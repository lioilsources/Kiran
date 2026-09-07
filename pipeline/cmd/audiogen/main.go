// Command audiogen generuje hudbu a SFX podle manifestu.
//
// Manifest (assets/audio/manifest.yaml) je zdroj pravdy: co má hra mít, jakým
// promptem to vzniklo a s jakým seedem. audiogen z něj čte, generuje chybějící
// nebo označené položky a zapisuje zpátky seed, model a hash.
//
//	audiogen -init                        # postaví/obnoví manifest ze skin definic
//	audiogen                              # dogeneruje chybějící
//	audiogen -only all -skin galaga       # přegeneruje celý skin
//	audiogen -regen sfx -ids fire_bullet  # přegeneruje jeden efekt všude
//	audiogen -only all -reseed -skin rtype # jiné provedení místo přesné kopie
//	audiogen -qa                          # jen kontrola hotových souborů
//
// Bez -reseed se použije seed z manifestu, takže regenerace dá tentýž soubor.
// To je záměr: assety musí jít zreprodukovat. Když se stopa nepovedla a chce
// se jiné provedení, je na to -reseed.
package main

import (
	"context"
	"flag"
	"fmt"
	"os"
	"os/signal"
	"path/filepath"
	"strings"
	"time"

	"tyrian-pipeline/internal/audio"
	"tyrian-pipeline/internal/skin"
)

const (
	musicTargetLUFS = -16.0
	sfxTargetLUFS   = -18.0
)

func main() {
	manifestPath := flag.String("manifest", "assets/audio/manifest.yaml", "cesta k manifestu")
	assetDir := flag.String("assets", "../tyrian_mobile/assets/skins", "kořen herních assetů")
	initManifest := flag.Bool("init", false, "postavit/obnovit manifest ze skin definic a skončit")
	only := flag.String("only", "missing", "co generovat: missing|all|flagged")
	regen := flag.String("regen", "all", "kategorie: all|music|sfx")
	skinID := flag.String("skin", "", "omezit na jeden skin")
	ids := flag.String("ids", "", "omezit na dané ID assetů (čárkou)")
	qaOnly := flag.Bool("qa", false, "jen zkontrolovat hotové soubory")
	reseed := flag.Bool("reseed", false, "zahodit uložený seed a vzít jiné provedení")
	dryRun := flag.Bool("dry-run", false, "vypsat, co by se generovalo, a nic nevolat")
	variations := flag.Int("variations", 1, "kolik variant SFX (jen pro -init)")
	flag.Parse()

	if err := run(*manifestPath, *assetDir, opts{
		initManifest: *initManifest,
		only:         *only,
		regen:        *regen,
		skinID:       *skinID,
		ids:          splitCSV(*ids),
		qaOnly:       *qaOnly,
		reseed:       *reseed,
		dryRun:       *dryRun,
		variations:   *variations,
	}); err != nil {
		fmt.Fprintln(os.Stderr, "Chyba:", err)
		os.Exit(1)
	}
}

type opts struct {
	initManifest bool
	only         string
	regen        string
	skinID       string
	ids          []string
	qaOnly       bool
	reseed       bool
	dryRun       bool
	variations   int
}

func run(manifestPath, assetDir string, o opts) error {
	existing, err := audio.Load(manifestPath)
	if err != nil && !os.IsNotExist(err) {
		return err
	}

	if o.initManifest {
		m, err := audio.Build(existing, skin.AllSkins(), audio.BuildOptions{
			AssetDir: assetDir, SFXVariations: o.variations,
		})
		if err != nil {
			return err
		}
		if err := m.Save(manifestPath); err != nil {
			return err
		}
		music, sfx := count(m)
		fmt.Printf("Manifest %s: %d skinů, %d stop, %d efektů\n", manifestPath, len(m.Skins), music, sfx)
		return nil
	}

	if existing == nil {
		return fmt.Errorf("manifest %s neexistuje — spusť nejdřív `audiogen -init`", manifestPath)
	}

	targets := selectTargets(existing, o)
	if len(targets) == 0 {
		fmt.Println("Není co dělat.")
		return nil
	}

	if o.qaOnly {
		return runQA(existing, targets, manifestPath)
	}

	if o.reseed {
		// Uložený seed jinak dá bit po bitu tentýž výsledek — což je při
		// reprodukci správně, ale ne když se stopa prostě nepovedla.
		for _, t := range targets {
			t.entry.Seed = 0
		}
	}

	provider, err := audio.NewProviderFromEnv()
	if err != nil {
		return err
	}
	fmt.Printf("Provider: %s | %d assetů ke generování\n", provider.Name(), len(targets))

	if o.dryRun {
		for _, t := range targets {
			fmt.Printf("  [dry] %s/%s/%s: %s\n", t.skin.ID, t.kind, t.entry.ID, t.entry.Prompt(provider.Name()))
		}
		return nil
	}

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	var generated, failed int
	start := time.Now()
	for i, t := range targets {
		if ctx.Err() != nil {
			fmt.Println("\nPřerušeno — manifest je uložený, běh se dá dokončit znovu.")
			break
		}
		fmt.Printf("  [%d/%d] %s/%s/%s ", i+1, len(targets), t.skin.ID, t.kind, t.entry.ID)
		if err := generateOne(ctx, provider, t); err != nil {
			fmt.Printf("SELHALO: %v\n", err)
			t.entry.QAFlags = []string{"generace selhala: " + err.Error()}
			failed++
		} else {
			fmt.Printf("OK seed=%d %.1fs %.1f LUFS\n", t.entry.Seed, t.entry.Measured, t.entry.LUFS)
			generated++
		}
		// Manifest se ukládá průběžně: patnáctiminutový běh přerušený na
		// dvanácté minutě jinak zahodí všechno, co už se vygenerovalo.
		if err := existing.Save(manifestPath); err != nil {
			return fmt.Errorf("uložení manifestu: %w", err)
		}
	}

	fmt.Printf("\nHotovo: %d vygenerováno, %d selhalo, %s\n",
		generated, failed, time.Since(start).Round(time.Second))
	if failed > 0 {
		return fmt.Errorf("%d assetů selhalo — detail v qa_flags manifestu", failed)
	}
	return nil
}

type target struct {
	skin  *audio.Skin
	kind  string
	entry *audio.Entry
}

func selectTargets(m *audio.Manifest, o opts) []target {
	idFilter := map[string]bool{}
	for _, id := range o.ids {
		idFilter[id] = true
	}

	var out []target
	for _, s := range m.Skins {
		if o.skinID != "" && s.ID != o.skinID {
			continue
		}
		for _, pair := range []struct {
			kind    string
			entries []*audio.Entry
		}{{"music", s.Music}, {"sfx", s.SFX}} {
			if o.regen != "all" && o.regen != pair.kind {
				continue
			}
			for _, e := range pair.entries {
				if len(idFilter) > 0 && !idFilter[e.ID] {
					continue
				}
				switch o.only {
				case "missing":
					if e.Generated() && fileExists(e.File) {
						continue
					}
				case "flagged":
					if len(e.QAFlags) == 0 {
						continue
					}
				case "all":
				default:
					continue
				}
				out = append(out, target{skin: s, kind: pair.kind, entry: e})
			}
		}
	}
	return out
}

func generateOne(ctx context.Context, p audio.Provider, t target) error {
	entry := t.entry
	prompt := entry.Prompt(p.Name())

	var assets []audio.Asset
	var err error
	if t.kind == "music" {
		var asset audio.Asset
		asset, err = p.GenerateMusic(ctx, audio.MusicRequest{
			Prompt:      prompt,
			DurationSec: int(entry.DurationS),
			BPM:         t.skin.BPM,
			Key:         t.skin.Key,
			Loop:        entry.Loop,
			Seed:        entry.Seed,
		})
		assets = []audio.Asset{asset}
	} else {
		assets, err = p.GenerateSFX(ctx, audio.SFXRequest{
			Prompt:      prompt,
			DurationSec: entry.DurationS,
			Variations:  max(entry.Variations, 1),
			Seed:        entry.Seed,
		})
	}
	if err != nil {
		return err
	}
	if len(assets) == 0 {
		return fmt.Errorf("provider nevrátil žádné audio")
	}

	if err := writeAssets(entry, assets); err != nil {
		return err
	}

	primary := assets[0]
	entry.Seed = primary.Seed
	entry.Model = primary.Model
	entry.Provider = p.Name()
	entry.SHA256 = primary.SHA256
	entry.LUFS = primary.LUFS
	entry.Measured = primary.Duration

	targetLUFS := musicTargetLUFS
	if t.kind == "sfx" {
		targetLUFS = sfxTargetLUFS
	}
	res, qaErr := audio.CheckAsset(entry.File, entry, targetLUFS)
	if qaErr != nil {
		entry.QAFlags = []string{"QA neproběhla: " + qaErr.Error()}
		return nil
	}
	entry.QAFlags = res.Flags
	entry.Measured = res.Duration
	entry.LUFS = res.LUFS
	return nil
}

// writeAssets zapíše první variantu pod jméno, které čte hra, a další
// s příponou _v2, _v3 — hra je zatím nepoužívá (SoundService načítá přesně
// `<id>.ogg`), ale při ručním výběru je fajn mít z čeho vybírat.
func writeAssets(entry *audio.Entry, assets []audio.Asset) error {
	if err := os.MkdirAll(filepath.Dir(entry.File), 0o755); err != nil {
		return err
	}
	for i, a := range assets {
		path := entry.File
		if i > 0 {
			ext := filepath.Ext(entry.File)
			path = strings.TrimSuffix(entry.File, ext) + fmt.Sprintf("_v%d", i+1) + ext
		}
		if err := os.WriteFile(path, a.Data, 0o644); err != nil {
			return err
		}
	}
	return nil
}

func runQA(m *audio.Manifest, targets []target, manifestPath string) error {
	var checked, flagged, missing int
	for _, t := range targets {
		if !fileExists(t.entry.File) {
			missing++
			continue
		}
		targetLUFS := musicTargetLUFS
		if t.kind == "sfx" {
			targetLUFS = sfxTargetLUFS
		}
		res, err := audio.CheckAsset(t.entry.File, t.entry, targetLUFS)
		if err != nil {
			t.entry.QAFlags = []string{"QA neproběhla: " + err.Error()}
			flagged++
			continue
		}
		checked++
		t.entry.QAFlags = res.Flags
		t.entry.Measured = res.Duration
		t.entry.LUFS = res.LUFS
		if !res.OK() {
			flagged++
			fmt.Printf("  %s/%s/%s: %s\n", t.skin.ID, t.kind, t.entry.ID, strings.Join(res.Flags, "; "))
		}
	}
	if err := m.Save(manifestPath); err != nil {
		return err
	}
	fmt.Printf("\nZkontrolováno %d, označeno %d, chybí %d souborů\n", checked, flagged, missing)
	return nil
}

func count(m *audio.Manifest) (music, sfx int) {
	for _, s := range m.Skins {
		music += len(s.Music)
		sfx += len(s.SFX)
	}
	return music, sfx
}

func fileExists(path string) bool {
	if path == "" {
		return false
	}
	info, err := os.Stat(path)
	return err == nil && !info.IsDir()
}

func splitCSV(s string) []string {
	if strings.TrimSpace(s) == "" {
		return nil
	}
	parts := strings.Split(s, ",")
	out := parts[:0]
	for _, p := range parts {
		if v := strings.TrimSpace(p); v != "" {
			out = append(out, v)
		}
	}
	return out
}

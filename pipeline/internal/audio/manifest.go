package audio

import (
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"time"

	"gopkg.in/yaml.v3"

	"tyrian-pipeline/internal/musicgen"
	"tyrian-pipeline/internal/sfxgen"
	"tyrian-pipeline/internal/skin"
)

// ManifestVersion se zvedne, až se formát rozbije. Loader starší verzi
// odmítne, místo aby ji tiše přečetl špatně.
const ManifestVersion = 1

// Manifest je zdroj pravdy o tom, jaké audio assety hra má.
//
// Pipeline z něj čte, co generovat, a zapisuje do něj, čím to vzniklo — seed,
// model, hash. Bez seedu v manifestu nejde asset zregenerovat; bez modelu
// nejde vyplnit THIRD_PARTY_LICENSES pro Steam.
type Manifest struct {
	Version     int     `yaml:"version"`
	GeneratedAt string  `yaml:"generated_at"`
	Skins       []*Skin `yaml:"skins"`
}

// Skin je jeden herní skin se svými stopami a efekty.
type Skin struct {
	ID    string   `yaml:"id"`
	Name  string   `yaml:"name"`
	BPM   int      `yaml:"bpm,omitempty"`
	Key   string   `yaml:"key,omitempty"`
	Music []*Entry `yaml:"music"`
	SFX   []*Entry `yaml:"sfx"`
}

// Entry je jeden asset — stopa nebo efekt.
type Entry struct {
	ID         string  `yaml:"id"`
	DurationS  float64 `yaml:"duration_s"`
	Loop       bool    `yaml:"loop,omitempty"`
	Variations int     `yaml:"variations,omitempty"`

	// Obě verze promptu vedle sebe: prompt_el je volný text pro ElevenLabs,
	// prompt_oss tagový vstup pro ACE-Step / MOSS. Obojí se při `audiogen -init`
	// přegeneruje ze šablony, aby se změna šablony propsala všude.
	PromptEL  string `yaml:"prompt_el"`
	PromptOSS string `yaml:"prompt_oss"`

	// Ruční přepis promptu. Když je vyplněný, vyhrává nad šablonou a `-init`
	// ho nikdy nepřepíše — proto je to samostatné pole a ne editace prompt_*:
	// jinak by nešlo poznat, co je šablona a co lidské rozhodnutí.
	PromptELOverride  string `yaml:"prompt_el_override,omitempty"`
	PromptOSSOverride string `yaml:"prompt_oss_override,omitempty"`

	// Vyplní se po generaci.
	Seed     int64    `yaml:"seed,omitempty"`
	Model    string   `yaml:"model,omitempty"`
	Provider string   `yaml:"provider,omitempty"`
	SHA256   string   `yaml:"sha256,omitempty"`
	File     string   `yaml:"file,omitempty"`
	LUFS     float64  `yaml:"lufs,omitempty"`
	Measured float64  `yaml:"measured_s,omitempty"`
	QAFlags  []string `yaml:"qa_flags,omitempty"`
}

// Generated říká, jestli asset už vznikl.
func (e *Entry) Generated() bool { return e.SHA256 != "" && e.File != "" }

// Prompt vrátí prompt pro daného providera — ruční přepis má přednost.
func (e *Entry) Prompt(provider string) string {
	if provider == "elevenlabs" {
		if e.PromptELOverride != "" {
			return e.PromptELOverride
		}
		return e.PromptEL
	}
	if e.PromptOSSOverride != "" {
		return e.PromptOSSOverride
	}
	return e.PromptOSS
}

// Load načte manifest z cesty.
func Load(path string) (*Manifest, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	var m Manifest
	if err := yaml.Unmarshal(data, &m); err != nil {
		return nil, fmt.Errorf("%s: %w", path, err)
	}
	if m.Version != ManifestVersion {
		return nil, fmt.Errorf("%s: verze manifestu %d, čekám %d", path, m.Version, ManifestVersion)
	}
	return &m, nil
}

// Save zapíše manifest atomicky (přes dočasný soubor a rename).
func (m *Manifest) Save(path string) error {
	m.Version = ManifestVersion
	m.GeneratedAt = time.Now().UTC().Format(time.RFC3339)

	data, err := yaml.Marshal(m)
	if err != nil {
		return err
	}
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		return err
	}
	tmp := path + ".tmp"
	if err := os.WriteFile(tmp, data, 0o644); err != nil {
		return err
	}
	return os.Rename(tmp, path)
}

// SkinByID najde skin v manifestu.
func (m *Manifest) SkinByID(id string) *Skin {
	for _, s := range m.Skins {
		if s.ID == id {
			return s
		}
	}
	return nil
}

// EntryByID najde asset dané kategorie.
func (s *Skin) EntryByID(kind, id string) *Entry {
	list := s.Music
	if kind == "sfx" {
		list = s.SFX
	}
	for _, e := range list {
		if e.ID == id {
			return e
		}
	}
	return nil
}

// BuildOptions řídí, co se do manifestu dostane.
type BuildOptions struct {
	// AssetDir je kořen herních assetů (typicky ../tyrian_mobile/assets/skins),
	// podle kterého se doplní pole File.
	AssetDir string
	// SFXVariations je výchozí počet variant efektu.
	SFXVariations int
}

// Build složí manifest ze skin definic a specifikací a slije ho s existujícím.
//
// Merge, ne přepis: ručně upravený prompt, seed a hash existujícího assetu
// zůstávají. Nové skiny a nové položky ve specifikaci se přidají, zmizelé
// se odeberou — manifest má odpovídat tomu, co pipeline umí vyrobit dnes.
func Build(existing *Manifest, skins []skin.SkinDef, opts BuildOptions) (*Manifest, error) {
	tierNames := make([]string, 0, len(musicgen.MusicSpecs))
	for _, spec := range musicgen.MusicSpecs {
		tierNames = append(tierNames, spec.Name)
	}
	sfxNames := make([]string, 0, len(sfxgen.SfxSpecs))
	for _, spec := range sfxgen.SfxSpecs {
		sfxNames = append(sfxNames, spec.Name)
	}
	skinIDs := make([]string, 0, len(skins))
	for _, s := range skins {
		if s.MusicStyle == "" && s.SfxStyle == "" {
			continue
		}
		skinIDs = append(skinIDs, s.ID)
	}
	if err := ValidateTagCoverage(skinIDs, tierNames, sfxNames); err != nil {
		return nil, err
	}

	variations := opts.SFXVariations
	if variations < 1 {
		variations = 1
	}

	out := &Manifest{Version: ManifestVersion}
	for _, s := range skins {
		if s.MusicStyle == "" && s.SfxStyle == "" {
			continue
		}
		tags, _ := TagsFor(s.ID)
		entry := &Skin{
			ID:   s.ID,
			Name: s.Name,
			BPM:  parseBPM(s.MusicTempo),
			Key:  s.MusicKey,
		}

		var prev *Skin
		if existing != nil {
			prev = existing.SkinByID(s.ID)
		}

		if s.MusicStyle != "" {
			for _, spec := range musicgen.MusicSpecs {
				e := &Entry{
					ID:        spec.Name,
					DurationS: float64(spec.DurationSec),
					Loop:      spec.Loop,
					PromptEL:  musicgen.BuildMusicPrompt(s.MusicStyle, s.MusicTempo, s.MusicKey, spec),
					PromptOSS: BuildMusicPromptOSS(tags, spec),
					File:      filepath.Join(opts.AssetDir, s.ID, "music", spec.Name+".ogg"),
				}
				mergeEntry(e, prev, "music")
				entry.Music = append(entry.Music, e)
			}
		}
		if s.SfxStyle != "" {
			for _, spec := range sfxgen.SfxSpecs {
				e := &Entry{
					ID:         spec.Name,
					DurationS:  spec.Duration,
					Variations: variations,
					PromptEL:   sfxgen.BuildSfxPrompt(s.SfxStyle, spec),
					PromptOSS:  BuildSFXPromptOSS(s.ID, spec),
					File:       filepath.Join(opts.AssetDir, s.ID, "sfx", spec.Name+".ogg"),
				}
				mergeEntry(e, prev, "sfx")
				entry.SFX = append(entry.SFX, e)
			}
		}
		out.Skins = append(out.Skins, entry)
	}
	sort.Slice(out.Skins, func(i, j int) bool { return out.Skins[i].ID < out.Skins[j].ID })
	return out, nil
}

// mergeEntry přenese ručně i strojově doplněné hodnoty ze starého manifestu.
func mergeEntry(e *Entry, prev *Skin, kind string) {
	if prev == nil {
		return
	}
	old := prev.EntryByID(kind, e.ID)
	if old == nil {
		return
	}
	e.PromptELOverride = old.PromptELOverride
	e.PromptOSSOverride = old.PromptOSSOverride
	e.Seed = old.Seed
	e.Model = old.Model
	e.Provider = old.Provider
	e.SHA256 = old.SHA256
	e.LUFS = old.LUFS
	e.Measured = old.Measured
	e.QAFlags = old.QAFlags
	if old.Variations > 0 {
		e.Variations = old.Variations
	}
}

func parseBPM(tempo string) int {
	var bpm int
	if _, err := fmt.Sscanf(tempo, "%d", &bpm); err != nil {
		return 0
	}
	return bpm
}

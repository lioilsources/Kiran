package audio

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"tyrian-pipeline/internal/skin"
)

func buildFresh(t *testing.T) *Manifest {
	t.Helper()
	m, err := Build(nil, skin.AllSkins(), BuildOptions{AssetDir: "assets/skins", SFXVariations: 1})
	if err != nil {
		t.Fatalf("Build: %v", err)
	}
	return m
}

func TestBuildCoversEverySkinAndTrack(t *testing.T) {
	m := buildFresh(t)
	if len(m.Skins) < 20 {
		t.Fatalf("skinů = %d, čekal aspoň 20", len(m.Skins))
	}
	galaga := m.SkinByID("galaga")
	if galaga == nil {
		t.Fatal("galaga chybí")
	}
	if len(galaga.Music) != 6 || len(galaga.SFX) != 10 {
		t.Errorf("galaga: %d stop, %d efektů; čekal 6 a 10", len(galaga.Music), len(galaga.SFX))
	}
	if galaga.BPM != 140 || galaga.Key != "C major" {
		t.Errorf("galaga: BPM=%d key=%q", galaga.BPM, galaga.Key)
	}

	intro := galaga.EntryByID("music", "intro")
	if intro == nil {
		t.Fatal("intro chybí")
	}
	if intro.PromptEL == "" || intro.PromptOSS == "" {
		t.Error("obě verze promptu musí být vyplněné")
	}
	if intro.PromptEL == intro.PromptOSS {
		t.Error("prompt_el a prompt_oss se mají lišit — jinak migrace neproběhla")
	}
	if intro.File != filepath.Join("assets/skins", "galaga", "music", "intro.ogg") {
		t.Errorf("cesta = %q", intro.File)
	}
}

func TestBuildIsDeterministic(t *testing.T) {
	a, b := buildFresh(t), buildFresh(t)
	if len(a.Skins) != len(b.Skins) {
		t.Fatal("dva běhy daly jiný počet skinů")
	}
	for i := range a.Skins {
		if a.Skins[i].ID != b.Skins[i].ID {
			t.Fatalf("pořadí skinů není stabilní: %s vs %s", a.Skins[i].ID, b.Skins[i].ID)
		}
	}
}

func TestBuildPreservesSeedsAndOverrides(t *testing.T) {
	first := buildFresh(t)
	galaga := first.SkinByID("galaga")
	intro := galaga.EntryByID("music", "intro")
	intro.Seed = 4242
	intro.SHA256 = "deadbeef"
	intro.Model = "acestep-v15-turbo"
	intro.PromptOSSOverride = "ručně vyladěný prompt"
	intro.QAFlags = []string{"ticho na začátku 120 ms"}

	second, err := Build(first, skin.AllSkins(), BuildOptions{AssetDir: "assets/skins", SFXVariations: 1})
	if err != nil {
		t.Fatalf("Build: %v", err)
	}
	got := second.SkinByID("galaga").EntryByID("music", "intro")
	if got.Seed != 4242 || got.SHA256 != "deadbeef" || got.Model != "acestep-v15-turbo" {
		t.Errorf("reprodukovatelnost se ztratila: %+v", got)
	}
	if got.PromptOSSOverride != "ručně vyladěný prompt" {
		t.Errorf("ruční přepis promptu se ztratil: %q", got.PromptOSSOverride)
	}
	if len(got.QAFlags) != 1 {
		t.Errorf("QA příznaky se ztratily: %v", got.QAFlags)
	}
	// Šablonový prompt se naopak musí přegenerovat, ne zamrznout.
	if got.PromptOSS == "" || got.PromptOSS == got.PromptOSSOverride {
		t.Errorf("šablonový prompt měl zůstat vedle přepisu: %q", got.PromptOSS)
	}
}

func TestPromptPrefersOverride(t *testing.T) {
	e := &Entry{PromptEL: "el", PromptOSS: "oss"}
	if e.Prompt("aistack") != "oss" || e.Prompt("elevenlabs") != "el" {
		t.Fatal("výchozí volba promptu podle providera nesedí")
	}
	e.PromptOSSOverride = "ruční"
	if e.Prompt("aistack") != "ruční" {
		t.Error("ruční přepis musí vyhrát")
	}
	if e.Prompt("elevenlabs") != "el" {
		t.Error("přepis pro OSS nesmí ovlivnit ElevenLabs prompt")
	}
}

func TestSaveLoadRoundTrip(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "manifest.yaml")
	m := buildFresh(t)
	m.SkinByID("galaga").EntryByID("sfx", "fire_bullet").Seed = 77

	if err := m.Save(path); err != nil {
		t.Fatalf("Save: %v", err)
	}
	loaded, err := Load(path)
	if err != nil {
		t.Fatalf("Load: %v", err)
	}
	if loaded.Version != ManifestVersion || loaded.GeneratedAt == "" {
		t.Errorf("hlavička: verze=%d čas=%q", loaded.Version, loaded.GeneratedAt)
	}
	if got := loaded.SkinByID("galaga").EntryByID("sfx", "fire_bullet").Seed; got != 77 {
		t.Errorf("seed po round-tripu = %d", got)
	}
}

func TestLoadRejectsWrongVersion(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, "manifest.yaml")
	if err := os.WriteFile(path, []byte("version: 99\nskins: []\n"), 0o644); err != nil {
		t.Fatal(err)
	}
	_, err := Load(path)
	if err == nil || !strings.Contains(err.Error(), "verze") {
		t.Fatalf("err = %v, čekal odmítnutí kvůli verzi", err)
	}
}

func TestGeneratedNeedsHashAndFile(t *testing.T) {
	cases := []struct {
		entry Entry
		want  bool
	}{
		{Entry{}, false},
		{Entry{SHA256: "abc"}, false},
		{Entry{File: "x.ogg"}, false},
		{Entry{SHA256: "abc", File: "x.ogg"}, true},
	}
	for _, c := range cases {
		if got := c.entry.Generated(); got != c.want {
			t.Errorf("%+v: Generated() = %v, want %v", c.entry, got, c.want)
		}
	}
}

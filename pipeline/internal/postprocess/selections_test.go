package postprocess

import (
	"path/filepath"
	"testing"
)

func TestSelectionsMissingFileIsNotAnError(t *testing.T) {
	// Every skin starts with no record; that must behave like "nothing chosen"
	// rather than failing the run.
	s, err := LoadSelections(filepath.Join(t.TempDir(), "nope.json"), "rtype")
	if err != nil {
		t.Fatalf("missing file should not error: %v", err)
	}
	if got := s.For("falcon1", 1); got != 1 {
		t.Errorf("unrecorded asset = %d, want the fallback 1", got)
	}
}

func TestSelectionsRoundTrip(t *testing.T) {
	path := filepath.Join(t.TempDir(), "gradius_v.json")
	s, _ := LoadSelections(path, "gradius_v")
	s.Set("falcon3", 3)
	s.Set("bouncer", 2)
	if err := s.Save(path); err != nil {
		t.Fatalf("save: %v", err)
	}

	back, err := LoadSelections(path, "gradius_v")
	if err != nil {
		t.Fatalf("reload: %v", err)
	}
	if got := back.For("falcon3", 1); got != 3 {
		t.Errorf("falcon3 = %d, want 3", got)
	}
	if got := back.For("bouncer", 1); got != 2 {
		t.Errorf("bouncer = %d, want 2", got)
	}
	// The whole point: an asset nobody re-picked still resolves to the default,
	// so recording one sprite never drags the rest of the skin along.
	if got := back.For("falcon1", 1); got != 1 {
		t.Errorf("untouched asset = %d, want 1", got)
	}
}

func TestConfigVariationForPrefersTheRecord(t *testing.T) {
	s := &Selections{Skin: "default", Assets: map[string]int{"starg": 2}}
	cfg := Config{Variation: 1, Sel: s}

	if got := cfg.variationFor("starg"); got != 2 {
		t.Errorf("recorded asset = %d, want 2", got)
	}
	if got := cfg.variationFor("bubble"); got != 1 {
		t.Errorf("unrecorded asset = %d, want the run default 1", got)
	}
}

func TestConfigVariationForWithoutRecord(t *testing.T) {
	// A nil record is valid and must not panic — it is how every run behaved
	// before selections existed.
	cfg := Config{Variation: 3}
	if got := cfg.variationFor("falcon1"); got != 3 {
		t.Errorf("nil record = %d, want the run default 3", got)
	}
}

func TestSelectionsIgnoresZeroAndNegative(t *testing.T) {
	// A hand-edited file with "falcon1": 0 must not send variationPath looking
	// for falcon1_v0.jpg.
	s := &Selections{Assets: map[string]int{"falcon1": 0, "falcon2": -1}}
	if got := s.For("falcon1", 1); got != 1 {
		t.Errorf("zero = %d, want fallback 1", got)
	}
	if got := s.For("falcon2", 1); got != 1 {
		t.Errorf("negative = %d, want fallback 1", got)
	}
}

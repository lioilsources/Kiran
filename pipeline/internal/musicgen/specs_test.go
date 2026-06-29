package musicgen

import (
	"strings"
	"testing"
)

func TestMusicSpecs_IntroPlusTiers(t *testing.T) {
	if len(MusicSpecs) < 2 {
		t.Fatalf("expected intro + tiers, got %d specs", len(MusicSpecs))
	}
	if MusicSpecs[0].Name != "intro" {
		t.Errorf("first spec should be intro, got %q", MusicSpecs[0].Name)
	}
	if MusicSpecs[0].Loop {
		t.Error("intro should be a one-shot, not a loop")
	}
	for i, spec := range MusicSpecs[1:] {
		wantName := "theme_" + string(rune('1'+i))
		if spec.Name != wantName {
			t.Errorf("tier %d: name = %q, want %q", i+1, spec.Name, wantName)
		}
		if !spec.Loop {
			t.Errorf("tier %q should loop", spec.Name)
		}
		// music_length_ms must land inside the Eleven Music 3s–600s range.
		ms := spec.DurationSec * 1000
		if ms < 3000 || ms > 600000 {
			t.Errorf("tier %q duration %dms outside [3000,600000]", spec.Name, ms)
		}
	}
}

func TestBuildMusicPrompt(t *testing.T) {
	loop := BuildMusicPrompt("synthwave neon, driving electronic", "128 BPM", "F minor", MusicSpecs[1])
	for _, want := range []string{"synthwave neon", "128 BPM", "F minor", "Seamless loop"} {
		if !strings.Contains(loop, want) {
			t.Errorf("loop prompt %q should contain %q", loop, want)
		}
	}

	intro := BuildMusicPrompt("8-bit chiptune", "130 BPM", "C minor", MusicSpecs[0])
	if strings.Contains(intro, "Seamless loop") {
		t.Errorf("intro prompt should not request a seamless loop: %q", intro)
	}

	// Empty tempo/key must be omitted cleanly (no dangling separators).
	bare := BuildMusicPrompt("ambient", "", "", MusicSpecs[1])
	if strings.Contains(bare, ", in .") || strings.Contains(bare, ", .") {
		t.Errorf("bare prompt has a dangling separator: %q", bare)
	}
}

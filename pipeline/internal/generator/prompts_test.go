package generator

import (
	"strings"
	"testing"

	"tyrian-pipeline/internal/skin"
)

func TestBuildPromptShip(t *testing.T) {
	s, _ := skin.GetSkin("space_invaders")
	prompt, err := BuildPrompt("ship", s, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !strings.Contains(prompt, "top-down") {
		t.Error("ship prompt should contain 'top-down'")
	}
	if !strings.Contains(prompt, "ONE ship only") {
		t.Error("ship prompt should ask for a single ship")
	}
	if !strings.Contains(prompt, "flat solid color") {
		t.Error("ship prompt should require a flat solid background")
	}
	if strings.Contains(prompt, "Sprite sheet") || strings.Contains(prompt, "frames") {
		t.Error("ship prompt must not ask for a multi-frame sprite sheet")
	}
	if !strings.Contains(prompt, "8-bit pixel art") {
		t.Error("ship prompt should contain style keywords")
	}
}

func TestBuildPromptExplosion(t *testing.T) {
	s, _ := skin.GetSkin("geometry_wars")
	prompt, err := BuildPrompt("explosion", s, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !strings.Contains(prompt, "neon") {
		t.Error("explosion prompt should contain skin-specific style")
	}
	if !strings.Contains(prompt, "32px") {
		t.Error("explosion prompt should contain sprite size")
	}
}

func TestBuildPromptBackground(t *testing.T) {
	s, _ := skin.GetSkin("space_invaders")
	extra := map[string]string{"LayerDesc": "distant stars, very sparse, tiny dots"}
	prompt, err := BuildPrompt("background", s, extra)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !strings.Contains(prompt, "distant stars") {
		t.Error("background prompt should contain layer description from extra")
	}
	if !strings.Contains(prompt, "tile seamlessly") {
		t.Error("background prompt should mention tiling")
	}
}

// The layers repeat vertically, so a tone that fades across the height shows
// as a hard step at every repeat. Every skin, in both prompt families, must
// ban the gradient, and no background text may ask for one.
func TestBackgroundPromptsKeepAnEvenTone(t *testing.T) {
	asks := []string{"gradient with", "dark gradient", "fading to", "fading into distance",
		"horizon bending", "curved planet horizon", "cinematic framing", "sky over", "sky above"}
	for _, s := range skin.AllSkins() {
		for _, wf := range []string{"", "pony"} {
			for _, a := range AssetsForSkin(s) {
				if a.AssetType != "background" {
					continue
				}
				p, err := BuildPromptForWorkflow("background", s, a.ExtraVars, wf)
				if err != nil {
					t.Fatalf("%s/%s: %v", s.ID, a.Name, err)
				}
				low := strings.ToLower(p)
				if !strings.Contains(low, "no vertical gradient") && !strings.Contains(low, "no gradient, no vertical fade") {
					t.Errorf("%s/%s (%q): background prompt does not ban the vertical gradient", s.ID, a.Name, wf)
				}
				for _, bad := range asks {
					if strings.Contains(low, bad) {
						t.Errorf("%s/%s (%q): background prompt asks for %q", s.ID, a.Name, wf, bad)
					}
				}
			}
		}
	}
}

func TestBuildPromptHUDIcon(t *testing.T) {
	s, _ := skin.GetSkin("ikaruga")
	extra := map[string]string{"IconType": "extra life heart"}
	prompt, err := BuildPrompt("hud_icon", s, extra)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !strings.Contains(prompt, "extra life heart") {
		t.Error("hud_icon prompt should contain icon type")
	}
	if !strings.Contains(prompt, "32x32") {
		t.Error("hud_icon prompt should specify 32x32")
	}
}

func TestBuildPromptPreview(t *testing.T) {
	s, _ := skin.GetSkin("galaga")
	prompt, err := BuildPrompt("preview", s, nil)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !strings.Contains(prompt, "selection screen") {
		t.Error("preview prompt should mention selection screen")
	}
}

func TestBuildPromptEnemy(t *testing.T) {
	s, _ := skin.GetSkin("geometry_wars")
	extra := map[string]string{"EnemyDirective": "standard fighter, medium size, angular wings"}
	prompt, err := BuildPrompt("enemy", s, extra)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !strings.Contains(prompt, "Enemy spacecraft") {
		t.Error("enemy prompt should contain 'Enemy spacecraft'")
	}
	if !strings.Contains(prompt, "standard fighter") {
		t.Error("enemy prompt should contain directive from ExtraVars")
	}
	if !strings.Contains(prompt, "BOTTOM edge") {
		t.Error("enemy prompt should specify nose toward the bottom edge")
	}
}

func TestBuildPromptStructure(t *testing.T) {
	s, _ := skin.GetSkin("space_invaders")
	extra := map[string]string{"StructureDirective": "large rocky asteroid, cratered surface, irregular shape"}
	prompt, err := BuildPrompt("structure", s, extra)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !strings.Contains(prompt, "obstacle") {
		t.Error("structure prompt should contain 'obstacle'")
	}
	if !strings.Contains(prompt, "rocky asteroid") {
		t.Error("structure prompt should contain directive from ExtraVars")
	}
	if !strings.Contains(prompt, "filling the frame") {
		t.Error("structure prompt should instruct the sprite to fill the frame")
	}
}

func TestBuildPromptUnknownType(t *testing.T) {
	s, _ := skin.GetSkin("space_invaders")
	_, err := BuildPrompt("nonexistent", s, nil)
	if err == nil {
		t.Error("expected error for unknown asset type")
	}
}

func TestBuildPromptHullAndPod(t *testing.T) {
	s, _ := skin.GetSkin("default")
	for _, a := range AssetsForSkin(s) {
		if a.AssetType != "hull" && a.AssetType != "pod" {
			continue
		}
		for _, wf := range []string{"flux", "pony"} {
			prompt, err := BuildPromptForWorkflow(a.Prompt(), s, a.ExtraVars, wf)
			if err != nil {
				t.Fatalf("%s/%s: %v", a.Name, wf, err)
			}
			want := a.ExtraVars["HullDirective"] + a.ExtraVars["PodDirective"]
			if !strings.Contains(prompt, want) {
				t.Errorf("%s/%s: prompt lacks its directive", a.Name, wf)
			}
			if strings.Contains(prompt, "<no value>") {
				t.Errorf("%s/%s: unfilled template field", a.Name, wf)
			}
		}
		if a.AssetType == "hull" {
			p, _ := BuildPrompt("hull", s, a.ExtraVars)
			if strings.Contains(p, "Roughly square overall proportions") {
				t.Errorf("%s: hull prompt keeps the ship's square rule", a.Name)
			}
		}
	}
}

func TestBuildPromptCreature(t *testing.T) {
	s, _ := skin.GetSkin("default")
	n := 0
	for _, a := range AssetsForSkin(s) {
		if a.AssetType != "creature" {
			continue
		}
		n++
		for _, wf := range []string{"flux", "pony"} {
			prompt, err := BuildPromptForWorkflow(a.Prompt(), s, a.ExtraVars, wf)
			if err != nil {
				t.Fatalf("%s/%s: %v", a.Name, wf, err)
			}
			if !strings.Contains(prompt, a.ExtraVars["CreatureDirective"]) {
				t.Errorf("%s/%s: prompt lacks its directive", a.Name, wf)
			}
			if strings.Contains(prompt, "<no value>") {
				t.Errorf("%s/%s: unfilled template field", a.Name, wf)
			}
		}
	}
	if n != len(creatureSpecs) {
		t.Errorf("got %d creature assets, want %d", n, len(creatureSpecs))
	}
}

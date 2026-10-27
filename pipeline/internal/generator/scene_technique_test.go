package generator

import (
	"strings"
	"testing"

	"tyrian-pipeline/internal/skin"
)

// comcenter_bg must carry the skin's medium, not a fixed cartoon look.
func TestComCenterBgSceneTechnique(t *testing.T) {
	cases := map[string]string{
		"galaga":     "pixel grid",
		"tyrian_dos": "pixel grid",
		"asteroids":  "vector lines",
		"tempest":    "vector lines",
		"star_fox":   "low-poly",
		"default":    "cel-shaded",
	}
	for id, want := range cases {
		s, ok := skin.GetSkin(id)
		if !ok {
			t.Fatalf("skin %q not found", id)
		}
		p, err := BuildPrompt("comcenter_bg", s, nil)
		if err != nil {
			t.Fatal(err)
		}
		if !strings.Contains(p, want) {
			t.Errorf("%s: prompt lacks %q", id, want)
		}
		if id != "default" && strings.Contains(p, "cel-shaded") {
			t.Errorf("%s: retro skin still asks for cel-shading", id)
		}
	}
}


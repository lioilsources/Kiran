package audio

import (
	"strings"
	"testing"

	"tyrian-pipeline/internal/musicgen"
	"tyrian-pipeline/internal/sfxgen"
	"tyrian-pipeline/internal/skin"
)

// Nový skin bez tagového přepisu by se projevil až tím, že by pro něj model
// dostal prázdný prompt a vyrobil generickou hudbu. Test to chytí dřív.
func TestEverySkinHasTagTranslation(t *testing.T) {
	var skinIDs []string
	for _, s := range skin.AllSkins() {
		if s.MusicStyle == "" && s.SfxStyle == "" {
			continue
		}
		skinIDs = append(skinIDs, s.ID)
	}
	var tiers []string
	for _, spec := range musicgen.MusicSpecs {
		tiers = append(tiers, spec.Name)
	}
	var sfxNames []string
	for _, spec := range sfxgen.SfxSpecs {
		sfxNames = append(sfxNames, spec.Name)
	}
	if err := ValidateTagCoverage(skinIDs, tiers, sfxNames); err != nil {
		t.Fatal(err)
	}
	if len(skinIDs) < 20 {
		t.Errorf("čekal jsem aspoň 20 skinů, mám %d — načetly se definice?", len(skinIDs))
	}
}

func TestMusicPromptIsTagged(t *testing.T) {
	tags, ok := TagsFor("galaga")
	if !ok {
		t.Fatal("galaga chybí v tabulce tagů")
	}
	spec := musicgen.MusicSpecs[3] // theme_3 — bojová vrstva
	got := BuildMusicPromptOSS(tags, spec)

	for _, want := range []string{"chiptune", "square wave", "combat", "[instrumental]", "seamless loop"} {
		if !strings.Contains(got, want) {
			t.Errorf("prompt neobsahuje %q:\n%s", want, got)
		}
	}
	// BPM a tónina jdou parametrem, ne textem — jinak soupeří s tagy.
	if strings.Contains(got, "BPM") || strings.Contains(got, "major") {
		t.Errorf("prompt nemá nést BPM ani tóninu:\n%s", got)
	}
}

func TestIntroPromptHasNoLoopHint(t *testing.T) {
	tags, _ := TagsFor("galaga")
	got := BuildMusicPromptOSS(tags, musicgen.MusicSpecs[0]) // intro, Loop=false
	if strings.Contains(got, "seamless loop") {
		t.Errorf("intro není smyčka:\n%s", got)
	}
	if !strings.Contains(got, "fanfare") {
		t.Errorf("intro má být fanfára:\n%s", got)
	}
}

func TestSFXPromptStaysShort(t *testing.T) {
	// Open modely na dlouhém promptu ztrácejí transient. ElevenLabs verze má
	// přes 300 znaků; tahle musí zůstat výrazně kratší.
	for _, spec := range sfxgen.SfxSpecs {
		got := BuildSFXPromptOSS("space_invaders", spec)
		if len(got) > 180 {
			t.Errorf("%s: prompt má %d znaků, moc dlouhý:\n%s", spec.Name, len(got), got)
		}
		if !strings.Contains(got, "dry, mono") {
			t.Errorf("%s: chybí steer na suchý mono zvuk:\n%s", spec.Name, got)
		}
	}
}

func TestSFXPromptCarriesSkinCharacter(t *testing.T) {
	invaders := BuildSFXPromptOSS("space_invaders", sfxgen.SfxSpecs[0])
	thunder := BuildSFXPromptOSS("lords_of_thunder", sfxgen.SfxSpecs[0])
	if invaders == thunder {
		t.Fatal("dva různé skiny dávají stejný prompt — zvukový svět se ztratil")
	}
	if !strings.Contains(invaders, "8-bit") {
		t.Errorf("space_invaders má být 8-bit:\n%s", invaders)
	}
}

func TestUnknownSkinFallsBackToEventDescription(t *testing.T) {
	got := BuildSFXPromptOSS("neexistuje", sfxgen.SfxSpecs[0])
	if got == "" {
		t.Fatal("prompt nesmí být prázdný ani pro neznámý skin")
	}
	if !strings.Contains(got, "laser") {
		t.Errorf("chybí popis události:\n%s", got)
	}
}

func TestJoinTagsDropsDuplicates(t *testing.T) {
	// galaga je „triumphant" a intro taky — zopakovaný tag model jen zbytečně
	// váží jedním směrem.
	tags, _ := TagsFor("galaga")
	got := BuildMusicPromptOSS(tags, musicgen.MusicSpecs[0])
	if strings.Count(got, "triumphant") != 1 {
		t.Errorf("tag „triumphant\" se má objevit jednou:\n%s", got)
	}
	if got := joinTags([]string{"a, b", "b, c", "", "  a "}); got != "a, b, c" {
		t.Errorf("joinTags = %q", got)
	}
}

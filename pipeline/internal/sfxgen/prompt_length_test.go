package sfxgen

import (
	"strings"
	"testing"

	"tyrian-pipeline/internal/skin"
)

// TestPromptsFitApiLimit guards the ElevenLabs 450-character cap across every
// skin × spec combination. The cap is enforced server-side with a 400, so
// without this the failure surfaces only after the request is in flight — and
// it hits the longest prompts first, which are the explosions carrying the most
// steering.
func TestPromptsFitApiLimit(t *testing.T) {
	var worst int
	var worstDesc string

	for _, s := range skin.Registry {
		if s.SfxStyle == "" {
			continue
		}
		for _, spec := range SfxSpecs {
			prompt := BuildSfxPrompt(s.SfxStyle, spec)
			n := len([]rune(prompt))
			if n > worst {
				worst, worstDesc = n, s.ID+"/"+spec.Name
			}
			if n > MaxPromptChars {
				t.Errorf("%s/%s: prompt is %d chars, limit is %d\n%s",
					s.ID, spec.Name, n, MaxPromptChars, prompt)
			}
		}
	}
	t.Logf("longest prompt: %d/%d chars (%s)", worst, MaxPromptChars, worstDesc)
}

// TestNoiseBurstsRejectPitch pins the steering that separates an explosion from
// a chime. Dropping it once produced a pitched arcade blip for explosion_small
// — spectral flatness fell from 0.34 to 0.12 — which is what a player hears as
// "that is a tinkle, I want an explosion".
func TestNoiseBurstsRejectPitch(t *testing.T) {
	style := "Classic 80s arcade, FM synthesis, bright tones"

	for _, spec := range SfxSpecs {
		prompt := BuildSfxPrompt(style, spec)
		switch {
		case spec.isNoiseBurst():
			for _, want := range []string{"atonal", "no pitch", "no chime"} {
				if !strings.Contains(prompt, want) {
					t.Errorf("%s: noise burst prompt lacks %q\n%s", spec.Name, want, prompt)
				}
			}
		case spec.isMelodic():
			if strings.Contains(prompt, "atonal") {
				t.Errorf("%s: melodic sting must not be steered atonal", spec.Name)
			}
		}
	}
}

// TestEveryPromptTargetsThePhoneSpeaker — the steer that stops the generator
// putting an explosion's weight below what the hardware can reproduce.
func TestEveryPromptTargetsThePhoneSpeaker(t *testing.T) {
	for _, spec := range SfxSpecs {
		prompt := BuildSfxPrompt("test style", spec)
		if !strings.Contains(prompt, "small phone speaker") {
			t.Errorf("%s: missing the playback steer\n%s", spec.Name, prompt)
		}
		// Words that previously produced sub-heavy, inaudible-on-mobile output.
		for _, banned := range []string{"deep boom", "sub rumble,", "heavy debris rumble"} {
			if strings.Contains(prompt, banned) {
				t.Errorf("%s: prompt asks for %q, which lands below a phone's range", spec.Name, banned)
			}
		}
	}
}

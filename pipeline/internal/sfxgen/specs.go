package sfxgen

import "fmt"

// SfxSpec defines a single sound effect to generate.
type SfxSpec struct {
	Name      string  // output filename (without extension)
	EventDesc string  // description of the sound event
	Duration  float64 // target duration in seconds
}

// SfxSpecs lists all sound effects to generate per skin.
//
// EventDesc leads with the sound's transient/texture rather than a generic
// label — ElevenLabs keys strongly off concrete onset words ("sharp", "tight",
// "punchy", "hard"), which keeps the frequent combat cues (fire/hit/explosion)
// crisp and cutting instead of soft and washy on rapid repeats.
//
// Weight is asked for in the low mids, never in sub-bass. The first pass was
// generated with words like "deep boom" and "heavy debris rumble", and got
// exactly that: explosion_large carried its loudest energy below 80Hz and rolled
// off above 4kHz. That is right for a subwoofer and inaudible on a phone, whose
// speaker gives up below roughly 500Hz — so on the target device the explosions
// had no weight at all while the shots, which live at 250Hz-8kHz, dominated
// everything. Measured on the shipped files, the shot sat 13dB above the big
// explosion in the band a phone can actually reproduce.
var SfxSpecs = []SfxSpec{
	{"fire_bullet", "single laser shot, tight fast zap with a short thump under it, sharp attack, quick decay, not piercing", 0.5},
	{"fire_beam", "sustained energy beam, steady continuous hum with body in the low mids, focused", 0.8},
	{"hit_shield", "energy shield deflection, electronic ping with body behind it, short zap, not shrill", 0.5},
	{"hit_hull", "metallic hull impact, clean hard hit, solid mid-range thud", 0.5},
	{"explosion_small", "small explosion, short clean noise burst, crisp, firm low-mid thump", 0.5},
	{"explosion_large", "big explosion, full clean noise burst, hard low-mid punch, scale from mid-range weight not sub rumble", 1.2},
	{"pickup", "item pickup, ascending chime, clean and short, warm rather than glassy", 0.5},
	{"weapon_unlock", "power-up unlock, triumphant rising fanfare with mid-range body", 1.5},
	{"sector_complete", "level complete, uplifting victory fanfare with mid-range body", 2.0},
	{"game_over", "defeat sting, descending somber tone with weight in the low mids", 2.5},
}

// isMelodic marks the musical stingers/fanfares where a "no music, dry" steer
// would fight the intent; everything else is a tight one-shot combat cue.
func (s SfxSpec) isMelodic() bool {
	switch s.Name {
	case "weapon_unlock", "sector_complete", "game_over":
		return true
	}
	return false
}

// isNoiseBurst marks the destructive cues, which must be broadband noise rather
// than anything pitched.
//
// This needs saying outright. Asking for a "tight burst" with a "quick pop" and
// weight in the low mids produced, against a skin style of "bright tones", a
// pitched arcade blip — measurably so: spectral flatness fell from 0.34 to 0.12,
// i.e. the sound moved *toward* a tone. An explosion is noise with a fast attack
// and a decaying tail; a chime is harmonic. The generator will pick the latter
// unless told not to.
func (s SfxSpec) isNoiseBurst() bool {
	switch s.Name {
	case "explosion_small", "explosion_large", "hit_hull":
		return true
	}
	return false
}

// playbackSteer states the target device outright. It is the part that matters
// most: without it the model happily puts the impact where a phone cannot
// reproduce it, and no post-processing gets it back — energy that was never
// rendered above 500Hz cannot be equalised into existence.
const playbackSteer = "Mixed for a small phone speaker: weight at 200Hz-2kHz, " +
	"no sub-bass, nothing piercing."

// MaxPromptChars is the ElevenLabs limit. Exceeding it fails the request
// outright, so it is worth a test rather than an API round trip: the first
// version of the noise steer pushed the three explosion prompts over and they
// were the only ones that mattered.
const MaxPromptChars = 450

// BuildSfxPrompt constructs the ElevenLabs prompt for a given skin style and SFX spec.
//
// Combat one-shots get a "dry, punchy, minimal reverb tail, mono" steer so they
// stay clean and layer well when many fire at once; the melodic stingers keep a
// touch of space and skip the "mono/dry" cue, and the destructive cues are
// forced to broadband noise (see [SfxSpec.isNoiseBurst]).
func BuildSfxPrompt(sfxStyle string, spec SfxSpec) string {
	steer := "Dry, punchy, tight transient, minimal reverb tail, mono."
	switch {
	case spec.isMelodic():
		steer = "Clean, musical, minimal reverb tail."
	case spec.isNoiseBurst():
		steer = "Dry mono. Clean synthetic noise burst, arcade noise channel " +
			"— atonal, no pitch, no chime. Sharp attack, short decay, no grit."
	}
	return sfxStyle + " " + spec.EventDesc + ". Game sound effect, " +
		formatDuration(spec.Duration) + " seconds. " + steer + " " + playbackSteer
}

func formatDuration(d float64) string {
	if d == float64(int(d)) {
		return fmt.Sprintf("%.1f", d)
	}
	return fmt.Sprintf("%.1f", d)
}

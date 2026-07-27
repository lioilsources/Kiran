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
var SfxSpecs = []SfxSpec{
	{"fire_bullet", "single laser shot, tight fast zap, sharp attack, quick decay", 0.5},
	{"fire_beam", "sustained energy beam, steady continuous hum, focused", 0.8},
	{"hit_shield", "energy shield deflection, bright electronic ping, short zap", 0.5},
	{"hit_hull", "metallic hull impact, hard crunch, sharp transient", 0.5},
	{"explosion_small", "small explosion, sharp punchy burst, quick pop", 0.5},
	{"explosion_large", "massive explosion, deep punchy boom, heavy debris rumble", 1.2},
	{"pickup", "item pickup, bright ascending chime, clean and short", 0.5},
	{"weapon_unlock", "power-up unlock, triumphant rising fanfare", 1.5},
	{"sector_complete", "level complete, uplifting victory fanfare", 2.0},
	{"game_over", "defeat sting, descending somber tone", 2.5},
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

// BuildSfxPrompt constructs the ElevenLabs prompt for a given skin style and SFX spec.
//
// Combat one-shots get a "dry, punchy, minimal reverb tail, mono" steer so they
// stay clean and layer well when many fire at once; the melodic stingers keep a
// touch of space and skip the "mono/dry" cue.
func BuildSfxPrompt(sfxStyle string, spec SfxSpec) string {
	steer := "Dry, punchy, tight transient, minimal reverb tail, mono."
	if spec.isMelodic() {
		steer = "Clean, musical, minimal reverb tail."
	}
	return sfxStyle + " " + spec.EventDesc + ". Game sound effect, " +
		formatDuration(spec.Duration) + " seconds. " + steer
}

func formatDuration(d float64) string {
	if d == float64(int(d)) {
		return fmt.Sprintf("%.1f", d)
	}
	return fmt.Sprintf("%.1f", d)
}

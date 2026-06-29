package musicgen

import "strings"

// MusicSpec defines a single music track to generate per skin.
type MusicSpec struct {
	Name        string // output filename (without extension): intro, theme_1..N
	Mood        string // scene / mood description
	Dynamics    string // dynamics + tempo feel (piano/slow … fortissimo/presto)
	DurationSec int    // target length in seconds
	Loop        bool   // true → seamless gameplay loop; false → one-shot (intro)
}

// MusicSpecs lists every track generated per skin: a heroic mission-start intro
// plus five intensity tiers. Tiers are ordered low→high so they map directly to
// the in-game intensity index that MusicService crossfades between.
var MusicSpecs = []MusicSpec{
	{"intro", "heroic mission-start fanfare, triumphant rising theme, the sense of launching into battle", "grand and bold, building to a peak", 12, false},
	{"theme_1", "calm exploration, drifting quietly through empty space, almost no threat", "piano dynamics, slow tempo, sparse and minimal", 40, true},
	{"theme_2", "a light skirmish, a few enemies approaching, mild rising tension", "mezzo-forte, adagio, steady understated groove", 40, true},
	{"theme_3", "active combat, dense enemy waves on screen, driving propulsive rhythm", "forte, allegro, full percussion and bass", 40, true},
	{"theme_4", "an intense firefight, overwhelmed and low on health, urgent and frantic", "fortissimo, presto, relentless and panicked", 40, true},
	{"theme_5", "an epic boss battle, the climactic showdown, maximum intensity", "fortissimo climax, presto, epic, heavy and heroic", 45, true},
}

// BuildMusicPrompt composes the Eleven Music prompt for a skin + track. The
// shared musicStyle/tempo/key keep every tier of a skin in the same sonic world
// so the runtime crossfades between intensity tiers stay coherent.
func BuildMusicPrompt(musicStyle, tempo, key string, spec MusicSpec) string {
	var b strings.Builder
	b.WriteString(musicStyle)
	b.WriteString(". ")
	b.WriteString(spec.Mood)
	b.WriteString(". ")
	b.WriteString(spec.Dynamics)
	b.WriteString(". Instrumental video game music")
	if tempo != "" {
		b.WriteString(", ")
		b.WriteString(tempo)
	}
	if key != "" {
		b.WriteString(", in ")
		b.WriteString(key)
	}
	b.WriteString(".")
	if spec.Loop {
		b.WriteString(" Seamless loop with a consistent groove, no fade in and no fade out.")
	}
	return b.String()
}

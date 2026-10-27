package audio

import (
	"fmt"
	"strings"

	"tyrian-pipeline/internal/musicgen"
	"tyrian-pipeline/internal/sfxgen"
)

// SkinTags je tagový přepis hudebního stylu skinu pro ACE-Step.
//
// ElevenLabs bral volný text a sám si z něj vytáhl žánr. ACE-Step čte tagy:
// žánr, nástroje, charakter, BPM, tónina. Prozaický `MusicStyle` mu jde přes
// LM plánovač, ale kratší tagový vstup dává mnohem stabilnější výsledky —
// hlavně u retro skinů, kde „primitive 1978 arcade audio" model svádí
// k moderní produkci, kdežto „chiptune, 8-bit, square wave" ne.
//
// Éra → styl podle plánu §4.3: 1979 arcade → chiptune 2-op, SNES → 16-bit
// FM/sample, 2010s → synthwave.
type SkinTags struct {
	Genre       string // žánr a éra
	Instruments string // konkrétní nástroje / zvukový čip
	Character   string // charakter, nálada
}

// musicTags mapuje ID skinu na tagy. Klíče musí odpovídat skin.Registry;
// [ValidateTagCoverage] to hlídá testem, ne až za běhu.
var musicTags = map[string]SkinTags{
	"default": {
		Genre:       "modern cinematic hybrid, orchestral electronic, AAA game score",
		Instruments: "analog synth arpeggios, orchestral strings, brass, sub bass, electronic drums",
		Character:   "heroic, propulsive, polished",
	},
	"space_invaders": {
		Genre:       "chiptune, 8-bit, 1978 arcade",
		Instruments: "monophonic square wave, descending four-note bass pulse",
		Character:   "cold, minimal, relentless, no melody",
	},
	"galaga": {
		Genre:       "chiptune, 8-bit, early 1980s arcade",
		Instruments: "three-channel square wave lead, PSG percussion",
		Character:   "bright, cheerful, melodic, triumphant",
	},
	"asteroids": {
		Genre:       "chiptune, vector arcade, 1979",
		Instruments: "analog bleeps, two-note bass thump, white noise hiss",
		Character:   "cold, sparse, tense, almost melody-free",
	},
	"geometry_wars": {
		Genre:       "synthwave, electro, retro-futurist",
		Instruments: "arpeggiated analog synth, four-on-the-floor drums, neon bass, glitch",
		Character:   "glowing, club energy, driving",
	},
	"ikaruga": {
		Genre:       "japanese bullet hell score, clean electronic",
		Instruments: "precise synths, orchestral hits, choir pads",
		Character:   "elegant, meditative, high contrast, building",
	},
	"nuclear_throne": {
		Genre:       "synth rock, post-apocalyptic, lo-fi",
		Instruments: "distorted fuzz bass, crunchy drums, overdriven chiptune lead",
		Character:   "dirty, raw, frantic",
	},
	"luftrausers": {
		Genre:       "surf rock, vintage, WW2 march",
		Instruments: "reverb twangy surf guitar, combo organ, rock drums",
		Character:   "sepia, swaggering, analog grit",
	},
	"nex_machina": {
		Genre:       "modern arcade electronica, dense synthwave",
		Instruments: "sequenced bass, neon synth leads, pounding electronic percussion",
		Character:   "relentless, high energy, bullet storm",
	},
	"tyrian_dos": {
		Genre:       "FM synthesis, OPL3 AdLib, 1995 DOS tracker module",
		Instruments: "FM lead, FM bass, tracker drums",
		Character:   "heroic, soaring, space rock",
	},
	"gradius_v": {
		Genre:       "japanese shmup score, arcade orchestral electronic",
		Instruments: "synth brass fanfare, fast arpeggiated lead, slap bass",
		Character:   "triumphant, propulsive, polished",
	},
	"rtype": {
		Genre:       "dark 1980s sci-fi score, biomechanical",
		Instruments: "FM synth drones, dissonant arpeggios, metallic textures, brooding bass",
		Character:   "ominous, oppressive, organic horror",
	},
	"river_raid": {
		Genre:       "chiptune, Atari 2600 TIA, 1982 home console",
		Instruments: "buzzy two-voice square wave, mono beeps, low engine drone",
		Character:   "sparse, stark, primitive",
	},
	"blazing_lazers": {
		Genre:       "FM chiptune, late 1980s 16-bit console, PC Engine",
		Instruments: "bright FM synth lead, driving bass, snappy percussion",
		Character:   "cheerful, energetic, fast",
	},
	"tempest": {
		Genre:       "minimal vector arcade, 1981",
		Instruments: "monophonic analog oscillator bleeps, pulsing bass tone, rising sweeps",
		Character:   "cold, hypnotic, melody-free",
	},
	"zaxxon": {
		Genre:       "chiptune, early 1980s arcade sound chip",
		Instruments: "two-voice square wave, marching bass, sparse noise percussion",
		Character:   "mechanical, tense, minimal melody",
	},
	"twinbee": {
		Genre:       "chiptune pop, mid 1980s arcade",
		Instruments: "bouncy square wave lead, bubbly bass, PSG drums",
		Character:   "cheerful, major key, kawaii, upbeat",
	},
	"fantasy_zone": {
		Genre:       "FM synth arcade, mid 1980s, latin tinged",
		Instruments: "bell-like FM lead, walking bass, light percussion",
		Character:   "whimsical, sunny, carefree",
	},
	"abadox": {
		Genre:       "chiptune horror, late 1980s 8-bit console",
		Instruments: "minor key square wave arpeggios, triangle bass, noise channel percussion",
		Character:   "ominous, industrial, claustrophobic",
	},
	"solar_striker": {
		Genre:       "handheld chiptune, 1990, four channel",
		Instruments: "two square wave voices, wave channel bass, noise drums",
		Character:   "tight, catchy, propulsive",
	},
	"axelay": {
		Genre:       "16-bit console orchestral, early 1990s sample based",
		Instruments: "sampled strings, brass stabs, timpani, rhythm section",
		Character:   "cinematic, heroic, driving",
	},
	"thunder_force": {
		Genre:       "FM synth console rock, early 1990s",
		Instruments: "distorted FM guitar lead, slap FM bass, sampled drums",
		Character:   "fast, melodic, triumphant",
	},
	"star_fox": {
		Genre:       "sample based console orchestra, early 1990s space opera",
		Instruments: "synthetic strings, brass, marching snare",
		Character:   "dramatic, bold, heroic, cinematic",
	},
	"lords_of_thunder": {
		Genre:       "CD audio console rock and metal, early 1990s",
		Instruments: "shredding electric guitar, double kick drums, driving bass, orchestral synth pads",
		Character:   "epic, fantasy battle anthem",
	},
}

// tierTags je tagový přepis nálady jednotlivých intenzitních vrstev.
// Klíče odpovídají musicgen.MusicSpecs; [ValidateTagCoverage] to hlídá.
var tierTags = map[string]string{
	"intro":   "fanfare, rising, triumphant, mission start, grand",
	"theme_1": "calm, sparse, minimal, low tension, drifting",
	"theme_2": "light tension, steady groove, mid energy",
	"theme_3": "combat, driving, full percussion, high energy",
	"theme_4": "urgent, frantic, relentless, very high energy",
	"theme_5": "boss battle, epic, climactic, maximum intensity",
}

// sfxTags je krátký fyzikální popis zvukového světa skinu pro SFX modely.
//
// Musí být krátký. SfxStyle ze skin definic je psaný pro ElevenLabs, který
// dlouhý popis unese; open modely na dlouhém promptu ztrácejí transient
// a vracejí rozmazaný zvuk.
var sfxTags = map[string]string{
	"default":          "modern sci-fi, clean digital",
	"space_invaders":   "8-bit chiptune, square wave, lo-fi arcade",
	"galaga":           "80s arcade FM synth, bright tones",
	"asteroids":        "minimal vector arcade, sine wave, white noise",
	"geometry_wars":    "synthwave, neon electronic, glitch",
	"ikaruga":          "japanese arcade, clean electronic, precise",
	"nuclear_throne":   "crunchy lo-fi, distorted chiptune",
	"luftrausers":      "WW2 vintage, radio static, muffled",
	"nex_machina":      "dense electronic, neon synth",
	"tyrian_dos":       "DOS AdLib FM synthesis, crunchy digital",
	"gradius_v":        "japanese arcade, clean digital laser",
	"rtype":            "dark sci-fi, metallic, biomechanical",
	"river_raid":       "Atari 2600 chip, square wave beep, mono lo-fi",
	"blazing_lazers":   "16-bit console FM synth, punchy",
	"tempest":          "pure sine and triangle oscillator, clean arcade bleep",
	"zaxxon":           "early 80s arcade chip, buzzy square wave, noise burst",
	"twinbee":          "80s arcade chip, bouncy square wave, bell tone",
	"fantasy_zone":     "FM synth arcade, bubbly, playful bell",
	"abadox":           "dark 8-bit chip, squelchy noise, buzzing square wave",
	"solar_striker":    "handheld 4-channel chip, sharp square blip, tiny speaker",
	"axelay":           "16-bit sampled console, metallic, filtered digital",
	"thunder_force":    "FM synthesis console chip, crunchy metallic",
	"star_fox":         "early 90s sampled console, filtered synth, compressed",
	"lords_of_thunder": "CD-quality console, sampled metal stab, cinematic impact",
}

// sfxEvent je stručný fyzikální popis události — kratší než EventDesc,
// který je psaný pro ElevenLabs.
var sfxEvent = map[string]string{
	"fire_bullet":     "single laser shot, tight zap, sharp attack, quick decay",
	"fire_beam":       "sustained energy beam, steady hum",
	"hit_shield":      "shield deflection, electronic ping, short",
	"hit_hull":        "metallic hull impact, hard knock",
	"explosion_small": "small explosion, sharp bang, short tail, broadband noise",
	"explosion_large": "big explosion, hard bang, punchy body, short tail, broadband noise",
	"pickup":          "item pickup, ascending chime, clean and short",
	"weapon_unlock":   "power-up unlock, rising fanfare",
	"sector_complete": "level complete, victory fanfare",
	"game_over":       "defeat sting, descending tone",
}

// BuildMusicPromptOSS složí tagový prompt pro ACE-Step.
//
// BPM a tónina jdou zvlášť jako parametry požadavku, ne do textu — model je
// bere jako strukturovaný vstup a v promptu by soupeřily s tagy.
func BuildMusicPromptOSS(tags SkinTags, spec musicgen.MusicSpec) string {
	parts := []string{tags.Genre, tags.Instruments}
	if mood := tierTags[spec.Name]; mood != "" {
		parts = append(parts, mood)
	}
	parts = append(parts, tags.Character, "video game music", "[instrumental]")
	if spec.Loop {
		parts = append(parts, "seamless loop, no fade in, no fade out")
	}
	return joinTags(parts)
}

// BuildSFXPromptOSS složí krátký prompt pro SFX model.
func BuildSFXPromptOSS(skinID string, spec sfxgen.SfxSpec) string {
	event := sfxEvent[spec.Name]
	if event == "" {
		event = spec.EventDesc
	}
	parts := []string{sfxTags[skinID], event, "game sound effect", "dry, mono, no reverb"}
	return joinTags(parts)
}

// TagsFor vrátí tagy skinu; druhá hodnota je false, když skin v tabulce není.
func TagsFor(skinID string) (SkinTags, bool) {
	tags, ok := musicTags[skinID]
	return tags, ok
}

// ValidateTagCoverage ohlásí skiny a vrstvy, které nemají tagový přepis.
// Volá se z testu i z audiogenu, aby nový skin nespadl až u desátého assetu.
func ValidateTagCoverage(skinIDs, tierNames, sfxNames []string) error {
	var missing []string
	for _, id := range skinIDs {
		if _, ok := musicTags[id]; !ok {
			missing = append(missing, "musicTags["+id+"]")
		}
		if _, ok := sfxTags[id]; !ok {
			missing = append(missing, "sfxTags["+id+"]")
		}
	}
	for _, name := range tierNames {
		if _, ok := tierTags[name]; !ok {
			missing = append(missing, "tierTags["+name+"]")
		}
	}
	for _, name := range sfxNames {
		if _, ok := sfxEvent[name]; !ok {
			missing = append(missing, "sfxEvent["+name+"]")
		}
	}
	if len(missing) > 0 {
		return fmt.Errorf("chybí tagový přepis: %s", strings.Join(missing, ", "))
	}
	return nil
}

// joinTags slije skupiny tagů do jednoho seznamu a vyhodí duplicity.
//
// Charakter skinu a nálada vrstvy se překrývají — galaga je „triumphant"
// a intro je taky „triumphant" — a zopakovaný tag model jen zbytečně váží
// jedním směrem. Pořadí se zachovává, protože ACE-Step bere první tagy jako
// dominantní.
func joinTags(groups []string) string {
	seen := make(map[string]bool)
	var out []string
	for _, group := range groups {
		for _, tag := range strings.Split(group, ",") {
			tag = strings.TrimSpace(tag)
			if tag == "" || seen[tag] {
				continue
			}
			seen[tag] = true
			out = append(out, tag)
		}
	}
	return strings.Join(out, ", ")
}

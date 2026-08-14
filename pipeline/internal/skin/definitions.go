package skin

// PostProcessEffect defines the shader effect applied to the game canvas.
type PostProcessEffect string

const (
	EffectNone        PostProcessEffect = "none"
	EffectScanlines   PostProcessEffect = "scanlines"
	EffectBloom       PostProcessEffect = "bloom"
	EffectVignette    PostProcessEffect = "vignette"
	EffectFilmGrain   PostProcessEffect = "film_grain"
	EffectGridDistort PostProcessEffect = "grid_distort"
)

// SkinDef defines all parameters needed to generate assets for a single skin.
type SkinDef struct {
	ID   string
	Name string

	// Prompt parameters
	ArtDirective       string
	StyleKeywords      string
	PaletteDescription string
	BackgroundMood     string
	// SceneNoun is the domain the background prompts are built on. Empty means
	// "deep space"; skins that are not set in space must override it, otherwise
	// the background template asserts a setting their BackgroundMood contradicts.
	SceneNoun       string
	ExplosionStyle  string
	BulletDirective string
	BossDirective   string // centered boss for the "preview" thumbnail

	// Technical
	SpriteSize int
	FrameCount int

	// Post-process shader
	PostProcess PostProcessEffect

	// Font
	GoogleFont string

	// Audio
	SfxStyle string // audio style keywords for SFX prompt construction

	// Music — adaptive soundtrack style (Eleven Music API). Shared across every
	// intensity tier of a skin so the runtime crossfades between tiers stay
	// coherent (same instrumentation / tempo / key). Empty MusicStyle = skip.
	MusicStyle string // overall instrumentation / genre
	MusicTempo string // shared tempo, e.g. "128 BPM"
	MusicKey   string // shared key, e.g. "A minor"

	// Pony SDXL overrides — empty means derive from base fields above.
	// Use these when base fields contain 3D/voxel/HEX references that confuse Pony's tag parser.
	PonyStyleKeywords      string
	PonyPaletteDescription string

	// Unlock
	UnlockedByDefault bool
	UnlockDesc        string
}

// Registry holds all known skin definitions keyed by ID.
var Registry = map[string]SkinDef{
	"default": {
		ID:                 "default",
		Name:               "Kiran (2026)",
		ArtDirective:       "Sleek modern 2D space shooter. Clean detailed sci-fi sprites with crisp edges and subtle cyan energy glow.",
		StyleKeywords:      "modern sci-fi, clean detailed sprites, cyan neon accents, sleek spacecraft, polished 2D shooter",
		PaletteDescription: "cyan #00FFEE, steel blue, white highlights on deep space black #050510",
		BackgroundMood:     "deep starfield, dark blue-black space with distant nebulae and drifting stars",
		ExplosionStyle:     "bright cyan-white energy burst expanding outward with sparks",
		BulletDirective:    "bright cyan energy bolt, elongated glowing pulse, 3x8 pixels",
		BossDirective:      "A massive modern capital-ship boss dominating the frame — sleek angular hull plating, multiple weapon turrets, pulsing cyan energy cores running along its spine",
		SpriteSize:         32,
		FrameCount:         6,
		PostProcess:        EffectNone,
		GoogleFont:         "Orbitron",
		SfxStyle:           "modern sci-fi, punchy digital lasers, weighty cinematic impacts, clean electronic",
		MusicStyle:         "Modern cinematic hybrid score for a 2020s AAA space shooter. Pulsing analog-synth arpeggios over sweeping orchestral strings and brass, deep sub-bass and punchy electronic percussion, heroic, propulsive and polished",
		MusicTempo:         "130 BPM",
		MusicKey:           "A minor",
		UnlockedByDefault:  true,
		UnlockDesc:         "Default skin",
	},
	"space_invaders": {
		ID:                 "space_invaders",
		Name:               "Space Invader",
		ArtDirective:       "Retro 1978 arcade game aesthetic. Chunky 8-bit pixel art with visible pixel grid.",
		StyleKeywords:      "8-bit pixel art, monochrome green phosphor CRT, chunky blocky pixels, retro arcade 1978",
		PaletteDescription: "monochrome green #00FF00 on pure black #000000, subtle green glow halos",
		BackgroundMood:     "deep black void with sparse green-tinted pixel stars, CRT phosphor glow",
		ExplosionStyle:     "blocky pixel explosion, green squares scatter outward, no smooth gradients",
		BulletDirective:    "small bright green pixel rectangle, 2x6 pixels, sharp edges, no glow",
		BossDirective:      "A giant blocky pixel-art mothership boss filling the frame — symmetrical alien-invader silhouette scaled up to monstrous size, chunky green pixel plating",
		SpriteSize:         16,
		FrameCount:         6,
		PostProcess:        EffectScanlines,
		GoogleFont:         "Press Start 2P",
		SfxStyle:           "8-bit chiptune, lo-fi square wave, classic arcade",
		MusicStyle:         "Primitive 1978 arcade audio. Monophonic square-wave bleeps over a relentless descending four-note bass pulse that drives the tension, lo-fi and minimal with no real melody, cold early-arcade atmosphere",
		MusicTempo:         "130 BPM",
		MusicKey:           "C minor",
		UnlockedByDefault:  true,
		UnlockDesc:         "Default skin",
	},
	"galaga": {
		ID:                 "galaga",
		Name:               "Galaga Ace",
		ArtDirective:       "Namco 1981 arcade pixel art. Colorful but limited palette, clean sprite work.",
		StyleKeywords:      "Namco 8-bit pixel art, primary colors, clean sprite edges, 1981 arcade",
		PaletteDescription: "bright red, white, yellow on black background, occasional blue accents",
		BackgroundMood:     "dark space with colorful distant stars, warm arcade cabinet glow",
		ExplosionStyle:     "colorful pixel burst, red-yellow-white concentric rings expanding outward",
		BulletDirective:    "small bright white pixel bolt with yellow trail, 3x8 pixels",
		BossDirective:      "A large ornate boss flagship centered in frame — classic arcade mothership silhouette with colorful geometric wing patterns and a glowing central eye",
		SpriteSize:         24,
		FrameCount:         6,
		PostProcess:        EffectScanlines,
		GoogleFont:         "VT323",
		SfxStyle:           "Classic 80s arcade, FM synthesis, bright tones",
		MusicStyle:         "Early-1980s arcade chiptune. Bright three-channel square-wave melodies and a catchy triumphant jingle, snappy PSG percussion, cheerful, melodic and victorious",
		MusicTempo:         "140 BPM",
		MusicKey:           "C major",
		UnlockedByDefault:  false,
		UnlockDesc:         "Score 10,000 points",
	},
	"asteroids": {
		ID:                 "asteroids",
		Name:               "Vector Pilot",
		ArtDirective:       "Atari 1979 vector graphics. Pure wireframe outlines, no filled shapes.",
		StyleKeywords:      "vector wireframe, white lines on black, Atari 1979, minimal geometric, oscilloscope aesthetic",
		PaletteDescription: "white wireframe lines with subtle blue-white glow on pure black",
		BackgroundMood:     "empty void with faint geometric grid lines fading into distance",
		ExplosionStyle:     "wireframe line segments flying outward from center, no fill, just edges",
		BulletDirective:    "single bright white dot with short trailing line, 2x4 pixels",
		BossDirective:      "A huge wireframe boss vessel built entirely from interlocking polygonal vector shapes, glowing outline edges, no fill, centered and dominating the frame",
		SpriteSize:         32,
		FrameCount:         6,
		PostProcess:        EffectVignette,
		GoogleFont:         "Share Tech Mono",
		SfxStyle:           "Minimal vector-style, sine waves, white noise bursts",
		MusicStyle:         "1979 vector-arcade audio. A slow two-note bass thump that accelerates with rising tension, sparse analog bleeps and white-noise thruster hiss, cold minimal oscilloscope tones, almost no melody",
		MusicTempo:         "110 BPM",
		MusicKey:           "A minor",
		UnlockedByDefault:  false,
		UnlockDesc:         "Survive 2 minutes without shooting",
	},
	"geometry_wars": {
		ID:                 "geometry_wars",
		Name:               "Neon Destroyer",
		ArtDirective:       "2003 Xbox Live neon geometry. Glowing vector outlines on black, synthwave palette.",
		StyleKeywords:      "neon glow, geometric shapes, synthwave, vivid outlines, HDR bloom, 2003 retro-futurism",
		PaletteDescription: "cyan #00FFFF, magenta #FF00FF, yellow #FFFF00 on pure black, intense glow",
		BackgroundMood:     "deep black with subtle dark blue grid lines that pulse and warp",
		ExplosionStyle:     "neon particle shower, cyan and magenta sparks radiating outward with bloom trails",
		BulletDirective:    "small glowing cyan diamond shape with bloom trail, 4x4 pixels",
		BossDirective:      "A massive rotating neon geometric boss entity centered in frame — interlocking glowing polygons orbiting a pulsing core, intense bloom trails",
		SpriteSize:         32,
		FrameCount:         6,
		PostProcess:        EffectBloom,
		GoogleFont:         "Orbitron",
		SfxStyle:           "Synthwave neon, punchy low-mid drive, electronic glitch",
		MusicStyle:         "Early-2000s retro-futurist synthwave and electro. Arpeggiated analog synths, four-on-the-floor electronic drums, deep neon bass and glitchy pulses, glowing club-energy intensity",
		MusicTempo:         "128 BPM",
		MusicKey:           "F minor",
		UnlockedByDefault:  false,
		UnlockDesc:         "Survive 3 minutes without power-ups",
	},
	"ikaruga": {
		ID:                 "ikaruga",
		Name:               "Polarity",
		ArtDirective:       "Minimalist Japanese bullet-hell 2001. Elegant, clean, high-contrast monochrome.",
		StyleKeywords:      "minimalist Japanese, bullet-hell elegance, high contrast, clean edges, zen aesthetic",
		PaletteDescription: "pure white #FFFFFF, near-black #0A0A0F, accent violet #8866FF",
		BackgroundMood:     "serene dark gradient with faint geometric mandalas, subtle violet accent light",
		ExplosionStyle:     "elegant white particle dissolve, circular wave expanding outward, minimal debris",
		BulletDirective:    "small white circle with violet core glow, 3x3 pixels, clean anti-aliased",
		BossDirective:      "A large elegant boss ship centered in frame, symmetrically split into light and dark halves with a glowing violet polarity core at its center",
		SpriteSize:         28,
		FrameCount:         6,
		PostProcess:        EffectVignette,
		GoogleFont:         "Rajdhani",
		SfxStyle:           "Japanese arcade, clean electronic, precise tonal",
		MusicStyle:         "Refined Japanese bullet-hell score. Clean precise electronic with orchestral hits and choir pads, elegant and meditative yet steadily building, high-contrast dynamics matching a light-and-dark polarity theme",
		MusicTempo:         "120 BPM",
		MusicKey:           "D minor",
		UnlockedByDefault:  false,
		UnlockDesc:         "Complete a level without taking damage",
	},
	"nuclear_throne": {
		ID:                 "nuclear_throne",
		Name:               "Wasteland Mutant",
		ArtDirective:       "Vlambeer-style chunky pixel art, 2015 post-apocalyptic mutant aesthetic. Thick outlines, exaggerated proportions, intentionally rough.",
		StyleKeywords:      "chunky pixel art, post-apocalyptic, Vlambeer screenshake aesthetic, rough hand-drawn pixels, low resolution, gritty indie",
		PaletteDescription: "warm desert browns #8B6914, toxic greens #4CAF50, rusty orange #D84315, dried blood red #8B0000 on dark earth #1A1A0E",
		BackgroundMood:     "scorched desert wasteland, irradiated dunes, dusty orange haze",
		ExplosionStyle:     "chunky pixel debris burst, brown-orange-green particles, thick smoke chunks",
		BulletDirective:    "chunky glowing bullet, thick bright green pixel pellet, 4x4 pixels",
		BossDirective:      "A hulking mutant boss creature-vehicle hybrid centered in frame, scavenged rusted armor plating fused with exposed toxic-green growths",
		SpriteSize:         24,
		FrameCount:         6,
		PostProcess:        EffectFilmGrain,
		GoogleFont:         "Silkscreen",
		SfxStyle:           "Crunchy lo-fi, heavy low-mid impact, distorted chiptune, Vlambeer screenshake audio",
		MusicStyle:         "Gritty post-apocalyptic synth-rock. Distorted fuzz-bass, crunchy lo-fi drums and aggressive overdriven chiptune leads, dirty analog edge, raw and frantic",
		MusicTempo:         "150 BPM",
		MusicKey:           "E minor",
		UnlockedByDefault:  false,
		UnlockDesc:         "Destroy 50 enemies in one run",
	},
	"luftrausers": {
		ID:                 "luftrausers",
		Name:               "Rauser Ace",
		ArtDirective:       "Vlambeer 2014 sepia monochrome WW2 aerial combat. Heavy ink outlines on parchment background, silhouette-focused.",
		StyleKeywords:      "sepia monochrome, WW2 propaganda poster, heavy ink outlines, cream and brown tones, vintage aviation, silhouette art",
		PaletteDescription: "warm sepia #704214, dark ink brown #2C1810, cream parchment #F5E6C8 on aged paper #E8D5B0",
		BackgroundMood:     "overcast sepia sky, thick cloud banks in cream and brown, vintage film grain",
		SceneNoun:          "open sky and ocean seen from above, wartime aerial theatre",
		ExplosionStyle:     "ink-splatter explosion, dark brown burst with sepia smoke rings",
		BulletDirective:    "dark brown ink dot projectile, small circular pellet with short sepia trail, 3x6 pixels",
		BossDirective:      "A colossal ink-lined WW2 zeppelin-boss silhouette centered in frame, bristling with gun turrets, heavy sepia ink outlines",
		SpriteSize:         28,
		FrameCount:         6,
		PostProcess:        EffectVignette,
		GoogleFont:         "Special Elite",
		SfxStyle:           "WW2 propeller engine, vintage radio static, muffled explosions, old film reel audio",
		MusicStyle:         "Adaptive vintage surf-rock. Reverb-drenched twangy surf guitar, vintage combo organ and driving rock drums with a WW2 propaganda-march swagger, sepia-toned analog grit",
		MusicTempo:         "120 BPM",
		MusicKey:           "A minor",
		UnlockedByDefault:  false,
		UnlockDesc:         "Complete 5 sectors without upgrades",
	},
	"nex_machina": {
		ID:                     "nex_machina",
		Name:                   "Voxel Storm",
		ArtDirective:           "Housemarque 2017 voxel-art twin-stick shooter. Dense neon particle effects, HDR bloom, dark backgrounds with vivid saturated colors.",
		StyleKeywords:          "voxel 3D rendered, intense neon particles, HDR bloom glow, Housemarque arcade, dense particle effects, vivid saturated neon",
		PaletteDescription:     "electric blue #0066FF, hot magenta #FF0066, neon green #00FF66, bright orange #FF6600 on deep black #050510",
		BackgroundMood:         "dark alien planet surface, voxel terrain with deep shadows, distant neon-lit structures",
		ExplosionStyle:         "dense voxel particle shower, bright neon cubes scattering, electric blue and magenta with bloom trails",
		BulletDirective:        "bright neon blue energy cube projectile, small glowing voxel with intense bloom trail, 3x5 pixels",
		BossDirective:          "A towering voxel-constructed boss entity centered in frame, radiating dense neon particle effects and intense bloom from every joint",
		SpriteSize:             32,
		FrameCount:             6,
		PostProcess:            EffectBloom,
		GoogleFont:             "Exo 2",
		SfxStyle:               "Dense electronic, thick low-mid impacts, neon synth, Housemarque arcade intensity",
		MusicStyle:             "Relentless modern arcade electronica. Dense driving synthwave, sequenced bass and bright neon leads over pounding electronic percussion, high-energy bullet-storm intensity",
		MusicTempo:             "140 BPM",
		MusicKey:               "G minor",
		PonyStyleKeywords:      "vivid saturated neon, HDR bloom glow, intense neon arcade, vibrant cel-shaded",
		PonyPaletteDescription: "electric blue, hot magenta, neon green, bright orange on deep black",
		UnlockedByDefault:      false,
		UnlockDesc:             "Score 500,000 points",
	},
	"tyrian_dos": {
		ID:                 "tyrian_dos",
		Name:               "DOS Reforged",
		ArtDirective:       "1995 DOS-era VGA pixel art space shooter. Richly detailed metallic sprites with dithering, 320x200 aesthetic upscaled.",
		StyleKeywords:      "DOS VGA 256-color, detailed metallic pixel art, dithered shading, 1995 Epic MegaGames, hand-pixeled sprites",
		PaletteDescription: "steel blue #4682B4, gunmetal gray #6C7A89, gold accents #FFD700, engine orange #FF8C00 on deep space blue #0A0A2E",
		BackgroundMood:     "classic DOS parallax starfield, deep blue-purple space, layered star planes",
		ExplosionStyle:     "detailed pixel explosion, orange-yellow-white fireball with dithered shading",
		BulletDirective:    "bright VGA-colored energy bolt, yellow-white elongated pulse with blue edge glow, 3x8 pixels",
		BossDirective:      "A heavily detailed metallic DOS-era boss dreadnought centered in frame, bristling with gun ports, dithered shading, gold accent trim",
		SpriteSize:         32,
		FrameCount:         6,
		PostProcess:        EffectScanlines,
		GoogleFont:         "IBM Plex Mono",
		SfxStyle:           "DOS AdLib/Sound Blaster, FM synthesis, 16-bit game audio, crunchy digital",
		MusicStyle:         "1995 DOS-era OPL3 AdLib and Sound Blaster FM synthesis. Tracker-module melodies, soaring 16-bit space-rock leads over driving FM bass, heroic MS-DOS adventure feel",
		MusicTempo:         "130 BPM",
		MusicKey:           "D minor",
		UnlockedByDefault:  false,
		UnlockDesc:         "Reach sector 5",
	},
	"gradius_v": {
		ID:                 "gradius_v",
		Name:               "Vic Viper",
		ArtDirective:       "Treasure/Konami 2004 Japanese shmup. Clean detailed 2D sprites with smooth shading, precise linework, professional arcade quality.",
		StyleKeywords:      "Japanese shmup, Konami arcade, clean detailed 2D, smooth gradient shading, precise mechanical design",
		PaletteDescription: "silver white #E0E0E0, deep navy #0D1B2A, bright red accents #FF1744, gold trim #FFD600, plasma blue #00B8D4",
		BackgroundMood:     "dark outer space with mechanical Moai structures, organic-mechanical landscape, dim purple nebula",
		ExplosionStyle:     "clean bright explosion, white-hot center expanding to orange-red ring, smooth gradient falloff",
		BulletDirective:    "bright plasma blue energy oval, smooth glowing projectile, 3x6 pixels",
		BossDirective:      "A massive organic-mechanical boss structure centered in frame, Moai-like carved features fused with precise mechanical plating, glowing red weak points",
		SpriteSize:         32,
		FrameCount:         6,
		PostProcess:        EffectNone,
		GoogleFont:         "Chakra Petch",
		SfxStyle:           "Japanese arcade, clean electronic, precise laser tones, Konami digital",
		MusicStyle:         "Heroic Japanese shmup score. Synth-brass fanfares, fast arpeggiated leads and slap-bass grooves, a polished arcade orchestral-electronic hybrid, triumphant and propulsive",
		MusicTempo:         "135 BPM",
		MusicKey:           "B minor",
		UnlockedByDefault:  false,
		UnlockDesc:         "Collect 100 power-ups",
	},
	"rtype": {
		ID:                 "rtype",
		Name:               "Bydo Slayer",
		ArtDirective:       "Irem 1987 biomechanical H.R. Giger aesthetic. Dark brooding alien organic forms merged with machinery, unsettling biological horror.",
		StyleKeywords:      "biomechanical, H.R. Giger inspired, dark organic alien, fleshy machinery, 1987 arcade, horror sci-fi",
		PaletteDescription: "dark flesh pink #8B4557, bone white #DDD5C0, alien red #CC0033, rusted metal #5C4033, sickly green #556B2F on near-black #080810",
		BackgroundMood:     "dark alien interior, biomechanical walls with ribbed organic textures, pulsing veins, dim red ambient",
		ExplosionStyle:     "organic burst, dark red-pink fleshy debris, bone-white fragments, sickly green fluid splatter",
		BulletDirective:    "bright orange-white energy beam segment, thin concentrated laser, 2x8 pixels",
		BossDirective:      "A colossal biomechanical boss organism centered in frame, fused flesh and rusted machinery, pulsing veins, layered bone-white armor segments",
		SpriteSize:         32,
		FrameCount:         6,
		PostProcess:        EffectVignette,
		GoogleFont:         "Teko",
		SfxStyle:           "Dark sci-fi horror, organic squelch, metallic resonance, biomechanical hum",
		MusicStyle:         "Dark biomechanical 1980s sci-fi score. Ominous FM-synth drones and dissonant arpeggios, cold metallic textures and brooding bass pulses, oppressive organic-horror atmosphere",
		MusicTempo:         "100 BPM",
		MusicKey:           "C minor",
		UnlockedByDefault:  false,
		UnlockDesc:         "Defeat 10 elite enemies",
	},
	"river_raid": {
		ID:                 "river_raid",
		Name:               "River Raid",
		ArtDirective:       "Atari 2600 1982 home console pixel art. Extremely limited palette, chunky rectangular sprites, top-down river shooter aesthetic.",
		StyleKeywords:      "Atari 2600, 4-color sprites, ultra-chunky pixels, early home console, Activision 1982, flat color fills, no gradients",
		PaletteDescription: "sky blue river #3CBCFC, tan riverbank #C8A064, bright red enemies #D82800, orange fuel depot #FC7460, white player jet #FCFCFC on blue water #3CBCFC",
		BackgroundMood:     "top-down river valley, flat tan-brown terrain on sides, wide blue river channel center, minimal detail",
		SceneNoun:          "aerial river valley seen from directly overhead, water and jungle banks",
		ExplosionStyle:     "simple chunky pixel burst, 4-5 large colored squares scattering, primary red-orange-white, no gradients",
		BulletDirective:    "tiny bright white vertical rectangle, 2x5 pixels, hard edges, no glow, pure Atari 2600 missile sprite",
		BossDirective:      "A giant chunky 4-color boss vehicle centered in frame, blocking the river channel wall-to-wall, flat primary-color fills, no gradients",
		SpriteSize:         16,
		FrameCount:         6,
		PostProcess:        EffectScanlines,
		GoogleFont:         "Press Start 2P",
		SfxStyle:           "Atari 2600 TIA chip, square wave beeps, mono lo-fi, early home console blips",
		MusicStyle:         "1982 Atari 2600 TIA-chip audio. Buzzy two-voice square-wave tones, primitive mono beeps and a low engine drone, the sparse stark soundscape of an early home console",
		MusicTempo:         "120 BPM",
		MusicKey:           "G major",
		UnlockedByDefault:  false,
		UnlockDesc:         "Refuel 10 times in one run",
	},
	"blazing_lazers": {
		ID:                 "blazing_lazers",
		Name:               "Gunhed",
		ArtDirective:       "Compile/Hudson 1989 TurboGrafx-16 colorful shooter. Vibrant 16-bit palette, clean detailed sprites, cheerful sci-fi action.",
		StyleKeywords:      "TurboGrafx-16 16-bit, vibrant primary colors, clean detailed sprites, 1989 Hudson Soft, cheerful sci-fi",
		PaletteDescription: "bright sky blue #4FC3F7, vivid red #F44336, sunshine yellow #FFEB3B, grass green #66BB6A, hot pink #EC407A on deep blue #0D0D30",
		BackgroundMood:     "colorful alien planet, bright blue sky fading to space, vivid terrain, cheerful cosmic backdrop",
		ExplosionStyle:     "colorful 16-bit explosion, bright red-yellow-white fireball with blue sparks",
		BulletDirective:    "bright yellow-white energy beam, wide vertical pulse with blue edge glow, 4x8 pixels",
		BossDirective:      "A large vibrant 16-bit boss mecha centered in frame, bristling with colorful weapon pods, clean bold sprite outlines",
		SpriteSize:         28,
		FrameCount:         6,
		PostProcess:        EffectScanlines,
		GoogleFont:         "Bungee",
		SfxStyle:           "Bright 16-bit console, cheerful FM synth, Hudson Soft PC Engine, punchy tones",
		MusicStyle:         "Late-1980s 16-bit console chiptune. Bright punchy FM-synth melodies, upbeat driving bass and snappy percussion, cheerful, energetic and fast-paced",
		MusicTempo:         "145 BPM",
		MusicKey:           "C major",
		UnlockedByDefault:  false,
		UnlockDesc:         "Win a co-op game",
	},
}

// AllSkins returns all registered skin definitions.
func AllSkins() []SkinDef {
	skins := make([]SkinDef, 0, len(Registry))
	for _, s := range Registry {
		skins = append(skins, s)
	}
	return skins
}

// GetSkin returns a skin definition by ID and whether it was found.
func GetSkin(id string) (SkinDef, bool) {
	s, ok := Registry[id]
	return s, ok
}

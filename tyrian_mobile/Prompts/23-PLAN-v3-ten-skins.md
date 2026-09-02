# Plan: v3.0 — 10 nových skinů

Přepracování původního draftu „Kirian — plán promptování ComfyUI pipeline"
podle reálného stavu repa (v2.9.1, 14 skinů). Jen plán — nic z toho zatím
není implementováno.

---

## 0. Co draft předpokládal a co v repu skutečně je

Draft byl psaný pro generickou pipeline. Skutečná pipeline (`pipeline/`,
Go + ComfyUI + ElevenLabs) je celá data-driven: **nový skin = jeden záznam
v `definitions.go` + registrace ve Flutteru + spuštění existujících příkazů.**
Většina věcí z draftu buď už existuje, nebo se dělá jinak:

| Draft | Realita v repu | Důsledek pro plán |
|---|---|---|
| Vessel 3–5 snímků: bank L / bank R / thruster | 1 obrázek `ship_frames` → postprocess syntetizuje **6 snímků glow modulací** (`glow.go`). Náklon lodi řeší engine (`Vessel.bank`, cosmetic), ne sprite. | Žádný img2img na animaci. Jeden obrázek na skin. |
| Nepřátelé 5–6 typů | **11 pevných spritů**: `falcon1–6`, `falconx`, `falconx2`, `falconx3`, `falconxb`, `falconxt` (mapované na `HostType`, normalizované na čtvercové reference). | Seznam je fixní v `assets.go/enemySpecs`, nemění se per skin. |
| Boss celek + odstřelitelné segmenty | Boss je **jeden sprite `rododendron`** (256×256 ref). `pack_atlas.dart` selže, když chybí. Segmenty engine neumí. | Segmenty = nová herní feature, **mimo v3**. |
| Projektily hráč + nepřátelé | 5 spritů zbraní hráče: `laser`, `bubble`, `vulcan`, `blaster`, `starg`. Nepřátelé používají stejné `imgName`. | Beze změny. |
| Power-upy | 5 HUD ikon `icon_life/bomb/shield/credit/gen` slouží zároveň jako collectables. | Beze změny. |
| Pozadí 1–3 vrstvy | **4 vrstvy paralaxu**, z toho `layer_0` a `layer_1` **per zóna ×7** (`layer_0_z0..z6`, `layer_1_z0..z6`) + sdílené `layer_2`, `layer_3` = **16 obrázků 1:2 @2k** na skin. | Nejdražší část generování. |
| Exploze | Kreslí se **procedurálně** (`entities/explosion.dart`), sprite se negeneruje. `ExplosionStyle` v SkinDef zůstal, ale nic ho nečte. | Vyplnit pro úplnost, nic neřešit. |
| UI | `preview` (Pony SDXL + hull LoRA), `comcenter_bg` 512×1024, `ui_card_bg` 192², `ui_button` 512×128. `ui_tab_active` je mrtvý (v `selections/` ano, v `AssetsForSkin` ne). | 4 UI obrázky na skin. |
| SFX: jsfxr/Bfxr, ~8 zvuků | **10 SFX přes ElevenLabs** (`-sfx`), prompt = `SfxStyle` + spec, limit 450 znaků, loudnorm → OGG. | jsfxr nezavádět, jen napsat `SfxStyle`. |
| Hudba: Suno/Udio, 1 track ~90 s | **6 tracků přes Eleven Music** (`-music`): `intro` 12 s one-shot + `theme_1..5` 40–45 s loop; sdílené `MusicStyle/Tempo/Key`. Moderace odmítá názvy her/skladatelů. | Přepsat směr hudby na hardware/žánr bez jmen. |
| STYLE / ASSET / TECH bloky | Přesně tak to je: STYLE = `ArtDirective + StyleKeywords + PaletteDescription` v SkinDef; ASSET + TECH = šablony per typ v `prompts.go` (top-down ortho, flat bg pro chroma key, „no text"). | Nové skiny **nepíší prompty**, jen vyplňují pole. Šablony měnit jen kvůli Zaxxonu (viz 2.2). |
| Vessel jako img2img style-reference | Workflow `flux_sprite.json` je **txt2img**. Konzistenci drží sdílené STYLE pole + `cmd/tune` (vision-LLM skórování, sidecar `tuned/<skin>/flux/<asset>.yaml`) + výběr variace v `selections/`. | Img2img referenční workflow = volitelná nová feature (viz 4.3). |
| Batchovat po skinech | Pipeline i `selections/` jsou per skin, `-force` resume-skipuje. | Sedí. |

**Závěr:** v3 je asset + registrace práce, ne engine práce. Jediné nutné
změny Go/Dart kódu jsou datové záznamy a jeden test navíc.

---

## 1. Seznam skinů

### 1.1 ID, názvy, pořadí

Zobrazované názvy v appce a ve storech jsou **generické popisy s rokem** (od
2.8 „Skins renamed to original descriptors to match the store entries"). Pro
adresáře a product ID navrhuji rovnou **neutrální ID** — product ID se nedají
nikdy přejmenovat ani znovu použít (App Store Connect i Play) a reviewer je
vidí. Stará ID (`rtype`, `gradius_v`…) zůstávají jak jsou.

Pořadí v `kSkins` je chronologické podle roku → nové skiny se **prokládají**
mezi stávající (selector nemá žádný index-fixed stav, ukládá `id`).

| # | Draft | `id` | Zobrazený název | Rok | `pixelArt` |
|---|---|---|---|---|---|
| 1 | Tempest | `neon_tube` | Neon Tube Vector (1981) | 1981 | true |
| 2 | Zaxxon | `iso_fortress` | Isometric Fortress (1982) | 1982 | true |
| 3 | TwinBee | `chibi_squadron` | Chibi Squadron (1985) | 1985 | false |
| 4 | Fantasy Zone | `candy_surreal` | Candy Surreal (1986) | 1986 | false |
| 5 | Abadox | `flesh_maze` | Organic Nightmare (1989) | 1989 | true |
| 6 | Solar Striker | `handheld_mono` | Handheld Monochrome (1990) | 1990 | true |
| 7 | Axelay | `mode7_steel` | Mode-7 Steel (1992) | 1992 | true |
| 8 | Thunder Force IV | `fm_thunder` | FM Thunder (1992) | 1992 | true |
| 9 | Star Fox | `flat_polygon` | Flat Polygon (1993) | 1993 | false |
| 10 | Lords of Thunder | `metal_knight` | Metal Knight (1993) | 1993 | false |

`pixelArt: true` = nearest-neighbour filtr při supersamplingu
(`asset_library.dart:139`); u AI-ilustrovaných stylů (chibi, pastel, low-poly,
manga) nechat false.

Výsledné pořadí `kSkins`: space_invaders 78 · asteroids 79 · galaga 81 ·
**neon_tube 81** · river_raid 82 · **iso_fortress 82** · **chibi_squadron 85** ·
**candy_surreal 86** · rtype 87 · blazing_lazers 89 · **flesh_maze 89** ·
**handheld_mono 90** · **mode7_steel 92** · **fm_thunder 92** ·
**flat_polygon 93** · **metal_knight 93** · tyrian_dos 95 · ikaruga 01 ·
geometry_wars 03 · gradius_v 04 · luftrausers 14 · nuclear_throne 15 ·
nex_machina 17 · default 26.

### 1.2 Překryvy se stávajícími skiny (nutná diferenciace)

| Nový | Koliduje s | Jak odlišit |
|---|---|---|
| `neon_tube` | `asteroids` (bílý wireframe na černé) | Vícebarevný neon (červená/žlutá/modrá/zelená), tlusté zářící hrany, tubusová mřížka v pozadí, ne bílá |
| `chibi_squadron` vs `candy_surreal` | navzájem | Chibi = sytá primární barva, kovový mecha lesk, tvrdé obrysy; Candy = pastel, žádné obrysy, měkké kulaté tvary, cukrová krajina |
| `flesh_maze` | `rtype` (biomech Giger) | rtype je kov+tělo, tmavý; Abadox je **pixel-art NES**, čisté maso/kost/sliz, sytá červená, žádný kov |
| `mode7_steel`, `fm_thunder` | `blazing_lazers` (16-bit) | BL = veselé primární barvy; Axelay = šedý kov, chladné stíny, planetární horizont; TF4 = modrá/ocelová sci-fi, mraky, gradienty MD |
| `handheld_mono` | `space_invaders` (mono zelená) | SI je 1 barva na černé; SS je **4 odstíny zelenošedé na světlém** pozadí, chunky, žádný glow |

### 1.3 Zaxxon a top-down engine

Šablony `ship`/`enemy` **vynucují 90° top-down** („zero isometric angle") a
hra je top-down. Skutečně izometrické sprity by v paralaxu vypadaly rozbitě.
Rozhodnutí: „isometric" použít jen v **shadingu** (tvrdé diagonální stíny
45°, dlaždicové terénní pozadí s diagonální mřížkou), silueta zůstává
top-down. Do `StyleKeywords` slovo *isometric* nedávat; do `BackgroundMood`
a `SceneNoun` ano.

---

## 2. Definice skinů (`pipeline/internal/skin/definitions.go`)

Společné pro všech 10: `FrameCount: 6`, `UnlockedByDefault: false`,
`Resolution` dané `AssetsForSkin`. `SpriteSize` je jen informativní údaj do
promptu `hud_icon`/manifestu. Hudební prompty **bez názvů her a autorů**
(Eleven Music moderace), hardwarové/žánrové popisy jsou v pořádku.

### 2.1 `neon_tube` — Neon Tube Vector (1981)
- ArtDirective: `1981 color vector arcade. Pure glowing wireframe outlines, no filled surfaces, drawn with thick luminous neon strokes on absolute black.`
- StyleKeywords: `color vector graphics, glowing neon wireframe, thick luminous lines, no fill, CRT phosphor bloom, 1981 arcade, geometric lattice`
- PaletteDescription: `neon red #FF2040, electric yellow #FFE500, cyan #40E0FF, lime #80FF40 wireframe on pure black #000000`
- BackgroundMood: `black void with a receding perspective tube lattice of glowing lines converging to a vanishing point, faint phosphor afterglow`
- SceneNoun: `` (deep space)
- BulletDirective: `short bright yellow vector line segment with white core, 2x8 pixels, no fill`
- BossDirective: `A colossal wireframe boss built from concentric neon polygons and radial spokes, thick glowing multicolor edges, no fill, centered and dominating the frame`
- SpriteSize 32 · PostProcess `bloom` · GoogleFont `Share Tech Mono`
- SfxStyle: `pure sine and triangle oscillator tones, clean analog arcade bleeps, no noise, short and precise`
- MusicStyle: `Minimal 1981 vector-arcade sound. Sparse monophonic analog oscillator bleeps and a slow pulsing bass tone, occasional rising sweeps, cold, hypnotic and almost melody-free`
- MusicTempo `118 BPM` · MusicKey `E minor`
- PonyStyleKeywords: `neon wireframe, line art, glowing outlines, black background, vector art`
- UnlockDesc: `Score 25,000 points`

### 2.2 `iso_fortress` — Isometric Fortress (1982)
- ArtDirective: `1982 arcade pixel art with a limited 16-color palette and hard 45-degree diagonal cast shadows. Clean blocky machinery, crisp pixel edges.`
- StyleKeywords: `1982 arcade pixel art, limited palette, hard diagonal shadows, blocky machinery, crisp pixel edges, brick and steel fortress`
- PaletteDescription: `fortress gray #8890A0, brick red #B03030, steel blue #4060A0, warning yellow #F0D040, deep shadow #101820`
- BackgroundMood: `fortified surface seen from straight above, walls and fuel tanks casting long diagonal shadows, diagonal tile grid, dusty gray-blue`
- SceneNoun: `armored fortress surface seen from directly overhead`
- BulletDirective: `small yellow pixel dart with dark diagonal shadow, 2x6 pixels, hard edges`
- BossDirective: `A giant blocky pixel-art robot fortress boss centered in frame, layered brick-and-steel armor, gun emplacements, hard diagonal shadows`
- SpriteSize 24 · PostProcess `scanlines` · GoogleFont `Press Start 2P`
- SfxStyle: `early-80s arcade discrete sound chip, buzzy square waves, short noise bursts, mono lo-fi`
- MusicStyle: `Early-1980s arcade sound-chip music. Two-voice square-wave motifs over a marching bass, sparse noise percussion, mechanical and tense, minimal melody`
- MusicTempo `126 BPM` · MusicKey `D minor`
- UnlockDesc: `Destroy 20 structures in one run`

### 2.3 `chibi_squadron` — Chibi Squadron (1985)
- ArtDirective: `Mid-80s cute anime shooter. Chibi mecha with round proportions, bright primary colors, bold clean outlines, glossy toy-like shading.`
- StyleKeywords: `chibi anime, cute mecha, super-deformed proportions, bright primary colors, bold outlines, glossy toy shading, cheerful 80s arcade`
- PaletteDescription: `cherry red #FF3040, sky blue #40A0FF, sunshine yellow #FFE040, white #FFFFFF, mint #60E0A0 on pale sky #C8E8FF`
- BackgroundMood: `bright daytime sky with fluffy white cumulus clouds, rolling green hills and toy towns far below, cheerful and sunny`
- SceneNoun: `bright daytime sky seen from above`
- BulletDirective: `round glossy pink-white energy pellet with soft highlight, 4x4 pixels`
- BossDirective: `A huge cute-but-menacing chibi mecha boss centered in frame, round armored body, oversized cannon arms, glossy primary-color plating`
- SpriteSize 28 · PostProcess `none` · GoogleFont `Bungee`
- SfxStyle: `bright cheerful 80s arcade chip, bouncy square-wave pops, playful bell tones, clean and snappy`
- MusicStyle: `Upbeat mid-80s chiptune pop. Bouncy square-wave leads, cheerful major-key melodies, bubbly bass and snappy PSG drums, kawaii arcade energy`
- MusicTempo `150 BPM` · MusicKey `F major`
- UnlockDesc: `Collect 50 power-ups`

### 2.4 `candy_surreal` — Candy Surreal (1986)
- ArtDirective: `Surreal pastel cartoon shooter. Soft round shapes, no hard outlines, candy-colored gradients, dreamlike playful design.`
- StyleKeywords: `pastel cartoon, surreal candy landscape, soft round shapes, no outlines, dreamy gradients, playful 80s arcade, cotton-candy palette`
- PaletteDescription: `bubblegum pink #FF9AD0, mint #A0F0D0, lemon #FFF0A0, lavender #C8B0FF, peach #FFC8A0 on cream #FFF4E8`
- BackgroundMood: `candy-colored floating islands, lollipop trees, striped mushrooms, soft pastel sky with round puffy clouds`
- SceneNoun: `pastel candy dreamscape seen from above`
- BulletDirective: `soft round pastel pink orb with white highlight, 4x4 pixels, no outline`
- BossDirective: `A giant surreal candy-creature boss centered in frame, round pastel body with smiling mouth and striped horns, dreamlike and slightly unsettling`
- SpriteSize 28 · PostProcess `none` · GoogleFont `Fredoka`
- SfxStyle: `bright FM-synth arcade, bubbly pops, cheerful bells and whistles, soft and playful`
- MusicStyle: `Cheerful mid-80s FM-synth arcade music. Bright bell-like FM leads, bouncy walking bass, light latin-tinged percussion, whimsical, sunny and carefree`
- MusicTempo `140 BPM` · MusicKey `G major`
- UnlockDesc: `Complete sector 3 without dying`

### 2.5 `flesh_maze` — Organic Nightmare (1989)
- ArtDirective: `Late-80s 8-bit console horror pixel art. Organic biological forms — flesh, bone, veins, teeth — rendered in chunky pixels with a dark red palette.`
- StyleKeywords: `8-bit console pixel art, biological horror, flesh and bone, veins and teeth, chunky pixels, dark red palette, organic alien anatomy`
- PaletteDescription: `raw flesh red #A02020, dried blood #501010, bone white #E8D8C0, bile green #80A030, black #080404`
- BackgroundMood: `inside a living alien body, ribbed fleshy tunnel walls, pulsing veins, dripping membranes, dim red glow`
- SceneNoun: `interior of a giant living organism`
- BulletDirective: `small bone-white spike with red tip, 2x7 pixels, hard pixel edges`
- BossDirective: `A gigantic pixel-art organic boss centered in frame, a mass of fanged mouths, eyes and pulsing tumors, bone plates and exposed muscle`
- SpriteSize 24 · PostProcess `scanlines` · GoogleFont `VT323`
- SfxStyle: `dark 8-bit console chip, wet squelchy noise bursts, low buzzing square waves, unsettling and gritty`
- MusicStyle: `Dark late-80s 8-bit console horror. Ominous minor-key square-wave arpeggios, throbbing triangle bass, harsh noise-channel percussion, industrial and claustrophobic`
- MusicTempo `132 BPM` · MusicKey `B minor`
- UnlockDesc: `Survive 90 seconds below 25% hull`

### 2.6 `handheld_mono` — Handheld Monochrome (1990)
- ArtDirective: `1990 monochrome handheld console pixel art. Exactly four shades of greenish gray, thick chunky pixels, no anti-aliasing, no glow.`
- StyleKeywords: `4-shade monochrome handheld pixel art, greenish gray palette, chunky pixels, hard edges, no glow, early portable console`
- PaletteDescription: `darkest #0F380F, dark #306230, light #8BAC0F, lightest #9BBC0F — only these four shades, no other colors`
- BackgroundMood: `sparse monochrome starfield and drifting dotted asteroids, four-shade greenish gray, flat and clean`
- SceneNoun: `` (deep space)
- BulletDirective: `tiny darkest-shade pixel dash, 1x4 pixels, no glow`
- BossDirective: `A large four-shade pixel-art warship boss centered in frame, chunky armored silhouette, symmetrical, readable at low resolution`
- SpriteSize 16 · PostProcess `scanlines` · GoogleFont `Press Start 2P`
- SfxStyle: `4-channel handheld chip, sharp square-wave blips, short noise bursts, tiny speaker lo-fi`
- MusicStyle: `Classic 1990 handheld four-channel chiptune. Two sharp square-wave voices, a wave-channel bass and noise-channel drums, tight, catchy and propulsive`
- MusicTempo `144 BPM` · MusicKey `A minor`
- PonyPaletteDescription: `dark green, olive, pale green, four shade monochrome`
- UnlockDesc: `Finish a sector using only the Vulcan`
- Pozn.: chroma key — sprity generovat na **nejsvětlejším odstínu** (`#9BBC0F`) jako flat bg; `bgremove` klíčuje barvu rohů, funguje. Pozadí `layer_0` v tomto skinu bude světlé, `layer_1+` musí být „bright on black" podle `isolatedOnBlack` — pro tento skin je otestovat jako první, hrozí, že vrstvy 1–3 budou vizuálně mimo paletu.

### 2.7 `mode7_steel` — Mode-7 Steel (1992)
- ArtDirective: `1992 16-bit console pixel art. Metallic sci-fi hulls with cool gray shading, fine dithering, a curved planet horizon and pseudo-3D ground plane.`
- StyleKeywords: `16-bit console pixel art, metallic sci-fi, cool gray steel, fine dithering, curved planet horizon, pseudo-3D rotating ground, 1992`
- PaletteDescription: `steel gray #9AA4B0, gunmetal #4A5560, cold blue #3060A0, warning orange #FF7020, white highlights on space black #06080C`
- BackgroundMood: `curved planet horizon bending across the frame, rotating pseudo-3D ground plane with scrolling grid texture, stars above, cold gray-blue`
- SceneNoun: `low orbit above a curved planet horizon`
- BulletDirective: `thin cold-blue laser needle with white core, 2x9 pixels`
- BossDirective: `A massive 16-bit metallic battle-station boss centered in frame, layered steel hull, rotating turret rings, orange warning lights`
- SpriteSize 32 · PostProcess `bloom` (0.5) · GoogleFont `Rajdhani`
- SfxStyle: `16-bit console sample-based sound chip, metallic impacts, filtered digital lasers, punchy compressed`
- MusicStyle: `Early-90s 16-bit console orchestral score. Sampled strings, brass stabs and timpani from a sample-based sound chip, cinematic and heroic with a driving rhythm section`
- MusicTempo `128 BPM` · MusicKey `C minor`
- UnlockDesc: `Reach sector 4`

### 2.8 `fm_thunder` — FM Thunder (1992)
- ArtDirective: `1992 16-bit home console shooter pixel art. Highly detailed blue-steel spacecraft, smooth multi-layer parallax clouds, saturated blue sci-fi palette.`
- StyleKeywords: `detailed 16-bit pixel art, blue sci-fi palette, layered parallax clouds, sleek angular fighters, 1992 home console, high detail`
- PaletteDescription: `cobalt blue #2050C0, ice blue #A0D0FF, chrome white #F0F4FF, hot orange #FF8000, magenta accents #E040A0 on deep navy #040A20`
- BackgroundMood: `layered blue cloud banks with sun-lit tops, distant planet limb, fast parallax, saturated blue sky-space`
- SceneNoun: `` (deep space)
- BulletDirective: `bright ice-blue energy shot with orange tail, 3x8 pixels`
- BossDirective: `A giant 16-bit blue-steel dreadnought boss centered in frame, layered angular armor, glowing orange reactor ports, rows of cannons`
- SpriteSize 32 · PostProcess `bloom` (0.7) · GoogleFont `Orbitron`
- SfxStyle: `FM-synthesis 16-bit console chip, crunchy digital lasers, metallic FM impacts, punchy and bright`
- MusicStyle: `Early-90s FM-synth console rock. Distorted FM guitar leads, slap-style FM bass, tight sampled drums, fast melodic and triumphant`
- MusicTempo `160 BPM` · MusicKey `E minor`
- UnlockDesc: `Score 100,000 points`

### 2.9 `flat_polygon` — Flat Polygon (1993)
- ArtDirective: `1993 flat-shaded low-poly 3D. Untextured polygons with single flat colors per face, visible faceting, no gradients, no anti-aliasing.`
- StyleKeywords: `flat-shaded low poly, untextured polygons, flat color faces, visible faceting, early 3D console, 1993, no gradients`
- PaletteDescription: `polygon gray #B0B8C0, flat blue #3050D0, flat red #D03030, flat yellow #E0C030, flat green #30A050 on flat black #000000`
- BackgroundMood: `flat-shaded low-poly space, a few large faceted asteroids and a polygon planet, hard-edged flat color, sparse`
- SceneNoun: `` (deep space)
- BulletDirective: `flat green polygon dart, two triangles, 3x8 pixels, no glow`
- BossDirective: `A giant flat-shaded low-poly boss battleship centered in frame, big faceted hull, single-color polygon faces, blocky turrets`
- SpriteSize 32 · PostProcess `none` · GoogleFont `Exo 2`
- SfxStyle: `early-90s sampled console chip, filtered synth lasers, compressed low-fi explosions, digital`
- MusicStyle: `Early-90s sample-based console orchestra. Dramatic synthetic strings and brass, marching snare, bold heroic themes with a cinematic space-opera feel`
- MusicTempo `120 BPM` · MusicKey `D minor`
- PonyStyleKeywords: `low poly, flat shading, faceted, geometric, 2d vector art`
- Pozn.: Pony šablony obsahují `no 3d render` — u tohoto skinu je Pony jen na `preview`, `PonyStyleKeywords` slovo *3D* neobsahuje.
- UnlockDesc: `Win a co-op game`

### 2.10 `metal_knight` — Metal Knight (1993)
- ArtDirective: `Early-90s heavy-metal fantasy anime. Armored flying knights and dragon-machines, fire and lightning, painted manga cover art with dramatic lighting.`
- StyleKeywords: `heavy metal fantasy anime, armored knight, fire and lightning, painted manga cover art, dramatic rim light, 1993, ornate gothic metal`
- PaletteDescription: `burnished gold #D8A030, blood red #B01020, lightning blue #60C0FF, flame orange #FF6010, black steel #1A1A22`
- BackgroundMood: `stormy sky over a burning fantasy kingdom, lightning-lit clouds, castle spires and lava below, painted and dramatic`
- SceneNoun: `stormy sky above a burning fantasy kingdom`
- BulletDirective: `blazing orange fire bolt with golden core, 3x9 pixels`
- BossDirective: `A colossal armored demon-knight boss centered in frame, gothic gold-and-black plate armor, wings of fire, crackling lightning`
- SpriteSize 32 · PostProcess `bloom` (0.8) · GoogleFont `Cinzel`
- SfxStyle: `CD-quality early-90s console, sampled metal guitar stabs, thunder and fire whooshes, heavy cinematic impacts`
- MusicStyle: `Early-90s CD-audio console rock and metal. Shredding electric guitar leads, double-kick drums, driving bass and orchestral synth pads, epic fantasy battle anthem`
- MusicTempo `165 BPM` · MusicKey `E minor`
- UnlockDesc: `Defeat 5 bosses`

---

## 3. Změny ve Flutteru (per skin, 5 souborů + storekit)

| Soubor | Změna |
|---|---|
| `lib/services/skin_registry.dart` | `SkinInfo('<id>', '<název> (rok)', pixelArt: …, productId: '$_iapPrefix.skin_<id>')` na správné chronologické místo |
| `lib/rendering/shader_config.dart` | `ShaderConfig` entry (tabulka níže) |
| `lib/ui/ui_theme.dart` | `UiTheme` entry — accent/surface barvy z palety, `cornerRadius` 0 pro pixel-art / 6 pro smooth, `applyFont` (google_fonts fetchuje za běhu, žádný bundling) |
| `pubspec.yaml` | 6 řádků: `ui/`, `sfx/`, `music/`, `backgrounds/`, `atlas.webp`, `atlas.json` — **ne** `sprites/` (`bundle_contents_test` to hlídá) |
| `ios/SkinStore.storekit` | NonConsumable entry, nové UUID, 0.99, `referenceName "<název> Skin"` |
| `marketing/googleplay-listing.md`, `appstore-listing.md` | řádky do IAP tabulek + What's New 3.0.0 |

### 3.1 Shader presety

| id | bloom | CRT | tint (R/G/B) | ostatní |
|---|---|---|---|---|
| neon_tube | 1.3 / thr 0.6 | — | 1.0/0.95/1.0 | vignette 0.85/0.2 |
| iso_fortress | — | scanlines 0.4, curve 0.01 | 0.95/0.95/1.0 | |
| chibi_squadron | 0.4 / 0.8 | — | neutral | vignette 0.95 |
| candy_surreal | — | — | 1.0/0.97/1.0 | saturation 1.1 |
| flesh_maze | — | scanlines 0.5, curve 0.015 | 1.0/0.85/0.85 | vignette 0.85/0.25 |
| handheld_mono | — | scanlines 0.6, curve 0.0 | 0.9/1.0/0.85 | saturation 0.9 |
| mode7_steel | 0.5 / 0.8 | — | 0.92/0.95/1.0 | |
| fm_thunder | 0.7 / 0.75 | — | 0.9/0.95/1.0 | |
| flat_polygon | — | — | neutral | vignette 0.95/0.1 |
| metal_knight | 0.8 / 0.7 | — | 1.0/0.92/0.85 | vignette 0.88/0.2 |

`saturation 1.1` vyžaduje ověřit, že tint/saturation pass clampuje >1 (dnes
se používá jen 0.85).

### 3.2 Testy
- `test/bundle_contents_test.dart` — automaticky pokryje nové skiny.
- `test/skin_switch_test.dart` — přidat do smyčky 2–3 nová id (`handheld_mono`,
  `flat_polygon`).
- **Nový** `test/skin_registry_consistency_test.dart`: každý `kSkins.id` má
  záznam v `ShaderConfig.defaults` **a** v `UiTheme._themes` (dnes to nikdo
  nehlídá — chybějící záznam tiše spadne na default) a `productId` je buď null,
  nebo `com.ol1n.kiran.skin_<id>`.
- `pipeline`: `go test ./...` (prompt-uniqueness testy) po přidání definic;
  `go run ./cmd/generate -skin <id> -dry-run` pro každý skin.

---

## 4. Změny v pipeline

### 4.1 Nutné
- `definitions.go`: 10 záznamů podle kap. 2.
- Nic v `assets.go`/`prompts.go` — šablony jsou univerzální.

### 4.2 Doporučené (malé)
- `cmd/tune` pro `ship_frames` každého skinu **před** hromadným generováním
  (sidecar `tuned/<id>/flux/ship_frames.yaml`, jako u `luftrausers`). Loď je
  stylová kotva i bez img2img — nejvíc se na ni kouká.
- Pro `handheld_mono` a `neon_tube` ověřit `-dry-run` prompt vrstev 1–3:
  `isolatedOnBlack` říká „bright on black", u 4-shade monochromu je to v pořádku
  jen když model drží paletu. Pokud ne, přidat do `SkinDef` nové pole
  `LayerOverride string` použitelné v `backgroundLayers` — jediná změna kódu
  pipeline, kterou v3 může potřebovat.

### 4.3 Volitelné (nová feature, jen po go/no-go)
Draft chtěl img2img/style-reference z lodi. Dnes: `flux_sprite.json` je
txt2img. Implementace by znamenala nový workflow
`flux_sprite_ref.json` (IPAdapter/Redux nebo img2img s denoise 0.6–0.75, ne
0.2–0.35 — to už by kopírovalo siluetu lodi do nepřátel) + flag
`-comfyui-ref-image <path>` v `cmd/generate`. Odhad ½–1 den. Rozhodnout **po
batch 1** (viz kap. 6): pokud sdílené STYLE pole + tune + výběr variací
udrží konzistenci jako u 14 stávajících skinů, nedělat.

---

## 5. Objem a náklady

Na jeden skin `AssetsForSkin` = 1 loď + 5 projektilů + 12 nepřátel/boss +
4 asteroidy + 16 pozadí + 5 ikon + 1 preview + 3 UI = **47 obrázků × 4 variace
= 188 generací** (pozadí 2k 1:2, zbytek 1k). Plus 10 SFX + 6 tracků hudby.

| | na skin | 10 skinů |
|---|---|---|
| ComfyUI obrázky | 188 | 1 880 |
| ElevenLabs SFX | 10 | 100 |
| Eleven Music (drahé, ~4,5 min audia) | 6 | 60 |
| `selections/<id>.json` | 1 | 10 |

### 5.1 Velikost bundlu — rozhodnout před releasem
Dnes `assets/skins` = **133 MB pro 14 skinů** (~9,5 MB/skin: hudba 40 MB,
atlasy 25 MB, UI 15 MB, pozadí 13 MB, SFX 2 MB). +10 skinů ≈ **+95 MB → ~230 MB**
assetů. To naráží na limit **200 MB** pro base modul AAB na Play i na hranici
cellular downloadu na App Store.

Možnosti (od nejlevnější):
1. `ui/comcenter_bg.png` (≈1 MB/skin) a `preview.png` (≈0,4 MB) → WebP
   v postprocessu, stejně jako pozadí a atlas. Ušetří ~1,2 MB/skin ≈ 30 MB na 24
   skinech. Změna v `processor.go` + `SkinInfo.previewPath` + ComCenter loader.
2. Hudba `theme_1..5` na 80k (dnes 96k) — ~5 MB.
3. Play Asset Delivery / iOS On-Demand Resources pro placené skiny —
   správné řešení, ale větší práce (AssetLibrary načítá přes `rootBundle`).
   Navrhuji **v3.1**, ne v3.0.

Pro v3.0 udělat 1 + 2 a přeměřit; pokud pořád > 200 MB, vyřadit z 3.0
dva skiny do 3.1.

---

## 6. Postup a dávkování

Batchovat **po skinech**, vždy stejnou sekvencí. První dávka schválně
obsahuje nejrizikovější styly, aby se pipeline ověřila dřív, než se pálí
1 880 generací.

| Batch | Skiny | Proč |
|---|---|---|
| 1 | `handheld_mono`, `neon_tube`, `flat_polygon` | 4-shade paleta vs. `isolatedOnBlack`; tmavá vektorová grafika vs. chroma key; low-poly vs. Pony `no 3d` |
| 2 | `iso_fortress`, `mode7_steel`, `fm_thunder` | tři pixel-art 16/8-bit, ověřit odlišení od `blazing_lazers` |
| 3 | `chibi_squadron`, `candy_surreal`, `flesh_maze`, `metal_knight` | ilustrativní styly, nejmenší riziko |

Po batchi 1: go/no-go na 4.3 a na `LayerOverride` (4.2).

### 6.1 Sekvence na jeden skin

```bash
cd pipeline
go run ./cmd/generate -skin <id> -dry-run                 # zkontrolovat prompty
go run ./cmd/tune -skin <id> -asset ship_frames -workflow flux -max-iters 4
go run ./cmd/generate -skin <id> -tuned-dir tuned -n 4     # všechny obrázky
go run ./cmd/generate -skin <id> -asset-type preview \
    -comfyui-workflow pony -comfyui-checkpoint "ponyDiffusionV6XL_v6StartWithThisOne.safetensors" \
    -comfyui-lora <hull-lora> -lora-trigger "st4rhu11s, spaceship, starship, "
go run ./cmd/generate -sfx -skin <id>
go run ./cmd/generate -music -skin <id>                    # až po vizuálním schválení
go run ./cmd/postprocess -skin <id>                        # zapíše selections/<id>.json
cd ../tyrian_mobile && dart run tool/pack_atlas.dart && dart run tool/verify_atlas.dart
flutter run -d macos    # projít 7 zón + ComCenter, přepnout tam a zpět
# re-pick vadných spritů:
cd ../pipeline && go run ./cmd/postprocess -skin <id> -only falcon3 -variation 2
```

Pak Flutter registrace (kap. 3), `flutter test`, `go test ./...`, commit
„Add <název> skin". Gallery obrázek `docs/gallery/<id>_enemies.png` (řada
falcon1–6, falconx…xt) — v repu na to není nástroj, vzniká ručně;
doporučuji přidat `tool/gallery_strip.dart` (~50 řádků nad `atlas.json`),
ať to není 10× ruční práce.

### 6.2 Uzavření v3.0
- `SKINS.md`: tabulka + 10 gallery sekcí, „14 visual themes" → 24.
- `README.md`, `AGENTS.md`: seznamy skin ID (AGENTS.md dnes uvádí 13 a chybí
  mu `default` — opravit při té příležitosti).
- `CHANGELOG.md`: záznam „10 nových skinů + velikostní opatření".
- App Store Connect: 10 IAP (review!), Play Console: 10 one-time products —
  ID z kap. 1.1, **nejdřív rozhodnout ID, pak založit**.
- `pubspec.yaml` `version: 3.0.0`, commit `Release 3.0.0`.

---

## 7. Rozhodnutí (schváleno 2026-09-02)

1. **ID skinů: herní názvy**, konzistentně se stávajícími (`rtype`, `gradius_v`).
   Product ID `com.ol1n.kiran.skin_<id>` jsou tím dané a **nepřejmenovatelné**:
   `tempest`, `zaxxon`, `twinbee`, `fantasy_zone`, `abadox`, `solar_striker`,
   `axelay`, `thunder_force`, `star_fox`, `lords_of_thunder`.
   Zobrazované názvy zůstávají generické popisy s rokem podle kap. 1.1.
2. **Zaxxon** = izometrie jen v shadingu a pozadí, silueta top-down. Slovo
   *isometric* není ve `StyleKeywords`, jen v `SceneNoun`/`BackgroundMood`.
3. **Všech 10 placených à $0.99**, free tier zůstává 3 skiny (24 celkem).
4. **Velikost: nejdřív generovat, pak měřit.** Přepočet na aktuální stav po
   v2.9 (plán výše počítal s předoptimalizačními čísly): bundlované assety jsou
   **93,8 MB / 14 skinů = 6,7 MB na skin**, takže +10 skinů = **+67 MB → 161 MB**
   (IPA odhadem ~180 MB), pod limitem 200 MB. Opatření z kap. 5.1 (WebP pro
   `comcenter_bg`/`preview`, hudba na 80k) se sáhne jen když reálné měření
   po vygenerování ukáže, že je to těsné.
5. Img2img referenční workflow (4.3): rozhodnout po batchi 1.
6. Boss segmenty a bank-frames lodi = engine features, mimo v3.

### 7.1 Mapování na původní draft

| Draft | `id` | `SkinDef.Name` | Zobrazený název |
|---|---|---|---|
| Tempest | `tempest` | Neon Tube | Neon Tube Vector (1981) |
| Zaxxon | `zaxxon` | Iso Fortress | Isometric Fortress (1982) |
| TwinBee | `twinbee` | Chibi Squadron | Chibi Squadron (1985) |
| Fantasy Zone | `fantasy_zone` | Candy Drift | Candy Surreal (1986) |
| Abadox | `abadox` | Flesh Maze | Organic Nightmare (1989) |
| Solar Striker | `solar_striker` | Pocket Mono | Handheld Monochrome (1990) |
| Axelay | `axelay` | Mode-7 Steel | Mode-7 Steel (1992) |
| Thunder Force IV | `thunder_force` | FM Thunder | FM Thunder (1992) |
| Star Fox | `star_fox` | Flat Polygon | Flat Polygon (1993) |
| Lords of Thunder | `lords_of_thunder` | Metal Knight | Metal Knight (1993) |

## 8. Stav implementace

- [x] `definitions.go` — 10 záznamů, `go build` + `-dry-run` ověřeno (47 specs × 4 variace na skin)
- [x] `test/skin_registry_consistency_test.dart` — hlídá, že každý skin v `kSkins`
      má shader preset i UI téma a že product ID odpovídá ID skinu
- [x] `river_raid` doplněn do `shader_config.dart` — chyběl a tiše padal na
      výchozí konfiguraci; zapsán explicitně tak, aby se vzhled nezměnil
- [ ] Batch 1 generování (`solar_striker`, `tempest`, `star_fox`)
- [ ] Flutter registrace — **až po vygenerování assetů**: řádky v `pubspec.yaml`
      ukazující na neexistující adresáře rozbijí build
- [ ] Batch 2, 3
- [ ] Měření velikosti, `SKINS.md`, storekit, IAP v ASC/Play, `version: 3.0.0`

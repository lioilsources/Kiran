# AGENTS.md

Operational reference for AI agents working on this repo. Read this before touching any code.

## Repo layout (quick reference)

```
tyrian_mobile/         Flutter/Flame game
  lib/entities/        Game objects (Vessel, Hostile, Projectile, …)
  lib/game/            TyrianGame (FlameGame), game_config.dart (all numeric constants)
  lib/rendering/       BatchRenderer, ParallaxBg, shader passes
  lib/services/        AssetLibrary, SaveService, SoundService, SkinRegistry
  lib/systems/         Device/Weapon, Fleet, Sector, PathSystem
  lib/ui/              Flutter overlays (OsdPanel, ComCenter, SkinSelector)
  assets/skins/        13 skins — sprites/, backgrounds/, sfx/, ui/, atlas.png, atlas.json
  shaders/             GLSL .frag files
  tool/pack_atlas.dart Texture atlas builder

pipeline/              Go asset generation pipeline
  cmd/generate/        Image + SFX generation (Grok / ol1n / ComfyUI backends)
  cmd/postprocess/     Resize, bg removal, copy to game assets
  internal/skin/       Skin definitions and manifest generation
```

## Hard constraints

- **No web target** — do not create `web/` or add web platform support.
- **VB6 parity** — all gameplay balance numbers (HP, damage, weapon stats) must match the original VB6 source in `tyrian_vba_64bit/`. Reference `game_config.dart` and `Prompts/00-GAMEPLAY-original.md`.
- **Audio** — `just_audio` only. `flame_audio` was removed; do not re-add it.
- **Sprite scale** — `spriteScale` in `game_config.dart` is the single source of truth for entity sizing. Never hardcode pixel sizes in entity files.
- **Flame components only inside the canvas** — no Flutter widgets inside the Flame component tree.

## Asset pipeline — full workflow for one skin

### 1. Generate images

```bash
cd pipeline

# ol1n (Flux) backend — all assets
go run ./cmd/generate -skin <id> -backend ol1n

# ComfyUI backend
go run ./cmd/generate -skin <id> -backend comfyui -comfyui-workflow flux

# Filter by asset type: ship | explosion | bullet | enemy | structure | background | hud_icon | preview
go run ./cmd/generate -skin <id> -backend ol1n -asset-type background

# Dry-run (print prompts only, no API calls)
go run ./cmd/generate -skin <id> -backend ol1n -dry-run
```

Key flags:
| Flag | Default | Meaning |
|------|---------|---------|
| `-n` | 4 | Variations per asset |
| `-workers` | 3 | Concurrent workers |
| `-resolution` | 1k | `1k` or `2k` |
| `-backend` | grok | `grok`, `ol1n`, `comfyui` |

Required env vars per backend:
- `ol1n`: `CF_ACCESS_CLIENT_ID`, `CF_ACCESS_CLIENT_SECRET`
- `comfyui`: `COMFYUI_API_URL` (+ CF vars optional)
- `grok`: `XAI_API_KEY`

### 2. Postprocess

```bash
go run ./cmd/postprocess -skin <id>
# Writes directly to ../tyrian_mobile/assets/skins/<id>/
```

Key flags:
| Flag | Default | Meaning |
|------|---------|---------|
| `-variation` | 1 | Which generated variation to use |
| `-size` | 128 | Max target dimension in px |
| `-threshold` | 30 | Background removal threshold |
| `-margin` | 15 | Background removal soft-edge margin |

### 3. Rebuild texture atlas

```bash
cd tyrian_mobile
dart run tool/pack_atlas.dart
```

### SFX generation (ElevenLabs)

```bash
cd pipeline
go run ./cmd/generate -skin <id> -sfx
# Requires: ELEVENLABS_API_KEY
```

### Available skin IDs

`space_invaders` · `galaga` · `asteroids` · `geometry_wars` · `ikaruga` · `nuclear_throne` · `luftrausers` · `nex_machina` · `tyrian_dos` · `gradius_v` · `rtype` · `river_raid` · `blazing_lazers`

## Running the game

```bash
cd tyrian_mobile
flutter run -d android
flutter run -d ios
flutter run -d macos
```

## Skin asset structure

Every skin must have:
```
assets/skins/<id>/
  atlas.png          packed sprite sheet
  atlas.json         sprite frame metadata
  sprites/           individual sprites (before atlas packing)
  backgrounds/       layer_0.png … layer_3.png (parallax layers)
  sfx/               .ogg or .mp3 sound effects
  ui/preview.png     thumbnail shown in SkinSelector
```

Missing files in `default/` skin fall through to a null/skip path in `AssetLibrary` — they do not crash the game. Other skins fall back to `default` for missing assets.

## Shader passes

Passes live in `lib/rendering/passes/`. Each pass has a `*Pass` class that sets uniforms per frame. Add new shaders by:
1. Adding a `.frag` file to `shaders/`
2. Declaring it in `pubspec.yaml` under `flutter > shaders`
3. Creating a `*Pass` class and wiring it into `TyrianGame.render()`

## Co-op multiplayer

UDP protocol in `lib/net/`. Two-player only. Uses device IP discovery — no relay server.

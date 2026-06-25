---
name: asset-pipeline
description: Complete asset generation pipeline — ComfyUI image generation, prompt tuning, postprocessing, SFX conversion, and atlas packing for Kiran game skins.
metadata:
  type: reference
---

# Kiran Asset Pipeline

All commands run from `pipeline/` unless noted. Copy `.env.example` → `.env` and fill in your values before running.

## Required env vars (`pipeline/.env`)

```
COMFYUI_API_URL=http://<host>:8188      # ComfyUI server
CF_ACCESS_CLIENT_ID=                    # Cloudflare Access (leave blank if no CF tunnel)
CF_ACCESS_CLIENT_SECRET=
ELEVENLABS_API_KEY=                     # For SFX generation
LLM_URL=http://<host>/v1                # Instruct LLM (prompt tuning)
LLM_MODEL=<model-id>
VL_MODEL=<vision-model-id>             # Vision LLM (image validation)
```

## Stage 1 — Generate images

```bash
cd pipeline

# All skins, 4 variations each, flux workflow
go run ./cmd/generate

# Single skin
go run ./cmd/generate -skin geometry_wars

# Filter by asset type
go run ./cmd/generate -skin geometry_wars -asset-type ship
# asset-type values: ship, explosion, bullet, enemy, structure, background,
#                    hud_icon, preview, comcenter_bg, ui_card_bg, ui_button, ui_tab_active

# Use pony workflow (SDXL)
go run ./cmd/generate -skin space_invaders -comfyui-workflow pony \
  -comfyui-checkpoint "ponyDiffusionV6XL_v6StartWithThisOne.safetensors"

# Use tuned prompts (from Stage 2)
go run ./cmd/generate -skin nex_machina -tuned-dir tuned

# Dry-run: print prompts without calling API
go run ./cmd/generate -skin rtype -dry-run

# Key flags
#   -skin <id>            one skin or empty = all
#   -out <dir>            output dir (default: output/assets/skins)
#   -workers <n>          concurrent ComfyUI jobs (default 3)
#   -n <n>                variations per asset (default 4)
#   -resolution 1k|2k     (default 1k = 1024px)
#   -comfyui-job-timeout  per-job timeout (default 15m)
```

Output: `output/assets/skins/<skin_id>/<subdir>/<asset>_v{1..N}.jpg` + `manifest.json`

## Stage 2 — Generate SFX

```bash
# All skins with SfxStyle defined
go run ./cmd/generate -sfx

# Single skin
go run ./cmd/generate -sfx -skin geometry_wars

# Dry-run: print prompts
go run ./cmd/generate -sfx -dry-run
```

Output: `output/assets/skins/<skin_id>/sfx/<name>.mp3`

SFX names (10 per skin): `fire_bullet`, `fire_beam`, `hit_shield`, `hit_hull`,
`explosion_small`, `explosion_large`, `pickup`, `weapon_unlock`, `sector_complete`, `game_over`

## Stage 3 — Tune prompts (optional)

Iterative loop: generate → vision-LLM score → instruct-LLM refine → repeat.
Saves winning prompt as YAML sidecar for use in Stage 1 via `-tuned-dir`.

```bash
go run ./cmd/tune \
  -skin nex_machina -asset asteroid \
  -workflow pony \
  -comfyui-checkpoint "ponyDiffusionV6XL_v6StartWithThisOne.safetensors" \
  -max-iters 4 -threshold 8.0

# Dry-run: print initial prompt and target
go run ./cmd/tune -skin geometry_wars -asset falcon -dry-run

# Key flags
#   -skin, -asset         which skin + asset to tune
#   -workflow pony|flux
#   -tuned-dir <dir>      where to save sidecar YAML (default: tuned/)
#   -out-dir <dir>        where to save final image for inspection (default: tuned_images/)
#   -max-iters <n>        iteration cap (default 4)
#   -threshold <f>        score 0–10 to accept (default 8.0)
```

Output: `tuned/<skin_id>/<workflow>/<asset>.yaml` + `tuned_images/<skin_id>/<workflow>/<asset>_tuned.jpg`

## Stage 4 — Postprocess

Converts raw JPEG variations → final game PNGs:
- **Sprites**: background removal (color-distance), trim transparent padding, fit to canonical reference canvas
- **ship_frames**: generates N animation frames via glow modulation (brightness oscillation)
- **explosion**: maps v1–v4 → `explosion1–4.png`
- **backgrounds**: exact resize to 512×1024; `layer_0` opaque, `layer_1+` bg-removed
- **UI sprites** (`comcenter_bg`, `ui_card_bg`, `ui_button`, `ui_tab_active`): opaque exact resize, no bg removal
- **SFX**: ffmpeg MP3 → OGG/Opus with `loudnorm` volume normalization

```bash
# Single skin, variation 1
go run ./cmd/postprocess -skin geometry_wars

# All skins found in input dir
go run ./cmd/postprocess

# Key flags
#   -skin <id>            one skin or empty = all
#   -input <dir>          pipeline output dir (default: output/assets/skins)
#   -output <dir>         game assets dir (default: ../tyrian_mobile/assets/skins)
#   -variation <n>        which _v{N} to use (default 1)
#   -size <px>            max dimension for sprites without reference size (default 128)
#   -threshold <n>        bg removal color-distance threshold (default 30)
#   -margin <n>           bg removal soft-edge ramp width px (default 15)
```

Output: `tyrian_mobile/assets/skins/<skin_id>/sprites/*.png`, `ui/*.png`, `backgrounds/*.png`, `sfx/*.ogg`

Reference sizes (canonical sprite dimensions from original Tyrian VB6, multiplied by `SupersampleFactor=4`):
vessel 114×84, falcon* 68×68, falconx* 102×102, falconxb 122×122, bouncer 128×142, asteroid 84×80, etc.
See `pipeline/internal/postprocess/reference_sizes.go` for complete list.

## Stage 5 — Pack atlas

Shelf-packs all skin sprites into a single `atlas.png` + `atlas.json` per skin.
Run from `tyrian_mobile/`.

```bash
cd tyrian_mobile
dart run tool/pack_atlas.dart
```

Output: `assets/skins/<skin_id>/atlas.png` + `assets/skins/<skin_id>/atlas.json`

Atlas limits: min 512px, max 4096px (power of 2, trimmed to used area).
Fragmentable sprites (enemies + asteroids) get Voronoi shard pre-computation baked in.

## Full pipeline — one skin end to end

```bash
cd pipeline

# 1. Generate images
go run ./cmd/generate -skin geometry_wars -n 4

# 2. Generate SFX
go run ./cmd/generate -sfx -skin geometry_wars

# 3. Postprocess (picks variation 1 by default)
go run ./cmd/postprocess -skin geometry_wars

# 4. Pack atlas
cd ../tyrian_mobile
dart run tool/pack_atlas.dart
```

## Asset types reference

| Type | Subdir | Postprocess |
|---|---|---|
| `ship` | sprites/ | bg remove → glow frames → `vessel_0..N-1.png` |
| `explosion` | sprites/ | bg remove → `explosion1-4.png` (cycles v1–v4) |
| `bullet` | sprites/ | bg remove → resize to reference |
| `enemy` | sprites/ | bg remove → fit to reference square |
| `structure` | sprites/ | bg remove → fit to reference |
| `background` | backgrounds/ | exact 512×1024; layer_0 opaque |
| `hud_icon` | ui/ | bg remove → resize |
| `preview` | ui/ | bg remove → resize |
| `comcenter_bg` | ui/ | exact resize, opaque |
| `ui_card_bg` | ui/ | exact resize, opaque |
| `ui_button` | ui/ | exact resize, opaque |
| `ui_tab_active` | ui/ | exact resize, opaque |
| `sfx` | sfx/ | ffmpeg MP3→OGG loudnorm |

## Skin definition

Skins live in `pipeline/internal/skin/definitions.go`. Each `SkinDef` has:
- `ArtDirective`, `StyleKeywords`, `PaletteDescription`, `BackgroundMood`, `ExplosionStyle`, `BulletDirective` — prompt fields
- `PonyStyleKeywords`, `PonyPaletteDescription` — SDXL/Pony overrides
- `SpriteSize`, `FrameCount` — generation params
- `PostProcess` — shader preset (`scanlines`, `bloom`, `vignette`, `film_grain`, `grid_distort`)
- `GoogleFont`, `SfxStyle` — UI font and audio style

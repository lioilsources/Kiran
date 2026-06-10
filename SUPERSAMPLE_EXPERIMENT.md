# Sprite supersampling experiment

## Problem

Skin sprites look tiny and lack detail on a mobile screen. The cause is **not**
the atlas size — it is the normalization step in the asset pipeline.

Every generated sprite is produced at **1024×1024**, then in
`pipeline/internal/postprocess/processor.go` it is:

```
Trim()                  // crop transparent padding
FitCanvas(refW, refH)   // shrink to the ORIGINAL VB6 size
```

The reference sizes (`reference_sizes.go`) are the original Tyrian pixel sizes —
`vessel` is **57×42**, `falcon` is **34×34**. So a 1024² illustration is crushed
to ~57×42 (≈0.3 % of the pixels survive). The game then sizes sprites as
`size = srcSize × spriteScale` and renders with `FilterQuality.none`
(nearest-neighbour), so the few remaining texels are blown up chunky on a
high-DPI display.

A bigger atlas alone does nothing: the packer (`tool/pack_atlas.dart`) just packs
the already-shrunk sprites, so the atlas stays 512².

## Idea: supersample the texture, keep the in-game size

Multiply every reference size by a factor **N** and divide `spriteScale` by the
same **N**. The on-screen footprint is unchanged (so **no gameplay, path,
formation, collision or layout changes are needed**), but each sprite now carries
N² more texels. The high-resolution atlas is then minified smoothly on screen
using `FilterQuality.medium` for non-pixel-art skins.

This is wired end-to-end behind a **single factor that defaults to 1.0**, which
reproduces today's behaviour exactly (and matches the atlases currently committed
to the repo). Nothing changes until you flip the factor and regenerate.

## The two knobs (must stay in sync)

| Where | Constant | Default |
|-------|----------|---------|
| `tyrian_mobile/lib/game/game_config.dart` | `spriteSupersample` | `1.0` |
| `pipeline/internal/postprocess/reference_sizes.go` | `SupersampleFactor` | `1` |

They **must hold the same value**. The game divides `spriteScale` by
`spriteSupersample`; the pipeline multiplies reference sizes by `SupersampleFactor`.

Supporting changes already in place:
- `tool/pack_atlas.dart` `kMaxSize` raised to **2048** so supersampled atlases fit
  (the atlas is still trimmed to the next pow-2 of used area, so factor-1 skins
  stay 512).
- Per-skin filtering: `SkinInfo.pixelArt` flag in `skin_registry.dart`. Detailed
  skins use `FilterQuality.medium` when supersampling is active; pixel-art /
  retro skins (and factor 1.0) keep `FilterQuality.none`. Selected in
  `AssetLibrary.loadAll` → `config.spriteFilterQuality`, consumed by
  `batch_renderer.dart` and the per-sprite paints.

## How to run the experiment

1. Set the factor in **both** files to the same value (try 3):
   - `game_config.dart`: `const double spriteSupersample = 3.0;`
   - `reference_sizes.go`: `const SupersampleFactor = 3`
2. Regenerate the sprites + atlases from the 1024² pipeline output:
   ```bash
   cd pipeline
   go run ./cmd/postprocess           # all skins, or: -skin gradius_v
   cd ../tyrian_mobile
   dart run tool/pack_atlas.dart
   ```
   > Requires the 1024² generated images under the pipeline output dir
   > (`output/assets/skins`, default of `cmd/postprocess -input`). The `default`
   > skin is genuine low-res Tyrian pixel art, so it will not gain detail —
   > test a detailed skin such as `gradius_v`, `nex_machina` or `ikaruga`.
3. `flutter run` and compare a detailed skin against `main`. In-game sizes should
   be identical; the sprites should be visibly sharper.

To revert: set both constants back to 1 / 1.0 and regenerate (or just check out
the committed atlases).

## What this does **not** do

It does not make ships physically larger on screen (more screen real estate).
That is a separate, much larger change requiring rework of path/formation
spacing, collision tuning, spawn density and OSD layout — see the discussion in
the PR. Supersampling is the cheap, reversible detail win; bigger ships is the
gameplay-affecting one.

## Complementary, prompt-side wins (not code)

- **Fill the frame**: bias generation so the subject occupies ~80–90 % of the
  1024² canvas. `Trim()` then keeps far more effective resolution.
- **Match aspect ratio** per sprite where possible (e.g. `vessel` ≈ 4:3 wide)
  so `FitInside` does not throw away one axis.

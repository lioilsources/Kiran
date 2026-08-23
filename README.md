# Kirian

A cross-platform 2D vertical-scrolling space shooter with a roguelike loop —
inspired by the classic vertical shooters of the 90s. Dying rewinds you to
Sector 1 with everything you earned; only your hull resets.

## Platforms

| Platform | Status |
|----------|--------|
| iOS | Live on the App Store |
| Android | Closed testing on Google Play |
| Windows | Supported (landscape, gamepad) |
| Linux | Supported (landscape, gamepad) |
| macOS | Supported (landscape, gamepad) |

## Features

- **Roguelike run** — death keeps weapons, credits and cumulative score; score permanently unlocks weapon tiers
- **18 hand-authored sectors** across six zones (~60 s each), then procedural sectors without a ceiling
- **12 enemy types** from basic fighters to end-game bosses
- **8 weapons** across 4 primary and 4 secondary slots, upgradeable through combat economy
- **Weapon-typed destruction** — enemies die by the weapon that killed them: water, ice, fire, lightning, plasma
- **14 visual skins** — each an original take on a different era of the genre (Monochrome Invader, Vector Wireframe, Arcade Formation, 8-Bit Canyon, Biomech Cruiser, 16-Bit Laser, Retro PC Pixel, Dual-Polarity, Neon Grid, Chrome Fleet, Sepia Dogfight, Wasteland Pixel, Neon Voxel, Kiran) with theme-specific sprites, sounds, per-zone parallax backgrounds, and post-process shaders
- **GPU shader pipeline** — vignette, bloom, CRT scanlines, chromatic aberration, dissolve, pixel explosion
- **Sprite destruction system** — Voronoi fragmentation with radial shard physics
- **ComCenter** — buy and upgrade weapons between sectors
- **Network co-op** — 2-player over local Wi-Fi, automatic discovery
- **Gamepad support** — PS4 / Xbox analog + buttons on desktop

## Tech Stack

- [Flutter](https://flutter.dev) + [Flame](https://flame-engine.org) ^1.35.1 game engine
- Custom GLSL fragment shaders via Flutter `FragmentProgram`
- Go asset pipeline (`pipeline/`) — sprite/background generation via ComfyUI (Flux), SFX/music via ElevenLabs

## Build

```bash
cd tyrian_mobile

# iOS
flutter run -d ios

# Android
flutter run -d android

# macOS
flutter run -d macos
```

## Asset Pipeline

Regenerate sprites, backgrounds, and SFX for a skin, then rebuild the texture
atlas. See `pipeline/SKILL.md` for the full reference.

### 1. Generate images (ComfyUI / Flux)

```bash
cd pipeline

# All assets for one skin
go run ./cmd/generate -skin asteroids

# Only backgrounds
go run ./cmd/generate -skin asteroids -asset-type background

# Dry-run (print prompts, no API calls)
go run ./cmd/generate -skin asteroids -dry-run
```

Key flags: `-n 4` (variations per asset), `-force` (regenerate existing)

Available skin IDs: `space_invaders`, `galaga`, `asteroids`, `geometry_wars`,
`ikaruga`, `nuclear_throne`, `luftrausers`, `nex_machina`, `tyrian_dos`,
`gradius_v`, `rtype`, `river_raid`, `blazing_lazers`, `default`
(directory ids are historical and do not match the display names above)

### 2. Postprocess (pick variation, resize, bg removal → game assets)

```bash
go run ./cmd/postprocess -skin asteroids
# output goes to ../tyrian_mobile/assets/skins/asteroids/

# Re-pick ONE asset without touching the rest of the skin
go run ./cmd/postprocess -skin asteroids -only falcon3 -variation 2

# Tune bg removal
go run ./cmd/postprocess -skin asteroids -threshold 30 -margin 15 -size 128
```

The chosen variation per asset is recorded in `pipeline/selections/<skin>.json`.

### 3. Rebuild texture atlas

```bash
cd ../tyrian_mobile
dart run tool/pack_atlas.dart
```

### SFX generation (ElevenLabs)

```bash
cd pipeline
go run ./cmd/generate -skin asteroids -sfx
```

## Documentation

- [CHANGELOG.md](CHANGELOG.md) — development history
- [GALLERY.md](GALLERY.md) — screenshots and videos
- [SKINS.md](SKINS.md) — visual themes reference

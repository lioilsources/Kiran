# Kiran

A cross-platform 2D vertical-scrolling space shooter — a mobile remake of the classic DOS game Tyrian, ported from the original TyrianVB (VB6/Win32).

## Platforms

| Platform | Status |
|----------|--------|
| iOS | Supported |
| Android | Supported |
| macOS | Partial (landscape + gamepad in progress) |
| Windows | Partial (landscape + gamepad in progress) |

## Features

- **7 sectors** (levels 1–6 scripted, 7+ procedurally random)
- **12 enemy types** from basic fighters to end-game bosses
- **8 weapons** across 4 primary and 4 secondary slots, upgradeable through combat economy
- **13 visual skins** — each with theme-specific sprites, sounds, parallax backgrounds, and post-process shaders (Nuclear Throne, Luftrausers, Nex Machina, Tyrian DOS, Gradius V, R-Type, Blazing Lazers, Galaga, Space Invaders, Geometry Wars, Ikaruga, Asteroids, Default)
- **GPU shader pipeline** — vignette, bloom, CRT scanlines, chromatic aberration, dissolve, pixel explosion
- **Sprite destruction system** — Voronoi fragmentation with radial shard physics
- **ComCenter shop** — buy and upgrade weapons between sectors
- **Network co-op** — 2-player online multiplayer
- **Gamepad support** — PS4 / Xbox analog + buttons on desktop

## Tech Stack

- [Flutter](https://flutter.dev) + [Flame](https://flame-engine.org) ^1.35.1 game engine
- Custom GLSL fragment shaders via Flutter `FragmentProgram`
- Go asset pipeline (`pipeline/`) — sprite generation, atlas packing, SFX via Grok Image API / ElevenLabs

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

Regenerate sprites, backgrounds, and SFX for a skin, then rebuild the texture atlas.

### 1. Generate images (Flux via ol1n / ComfyUI backend)

```bash
cd pipeline

# All assets for one skin
go run ./cmd/generate -skin asteroids -backend ol1n

# ComfyUI variant
go run ./cmd/generate -skin asteroids -backend comfyui -comfyui-workflow flux

# Only backgrounds
go run ./cmd/generate -skin asteroids -backend ol1n -asset-type background

# Dry-run (print prompts, no API calls)
go run ./cmd/generate -skin asteroids -backend ol1n -dry-run
```

Key flags: `-n 4` (variations per asset), `-workers 3`, `-resolution 1k|2k`

Available skin IDs: `space_invaders`, `galaga`, `asteroids`, `geometry_wars`, `ikaruga`, `nuclear_throne`, `luftrausers`, `nex_machina`, `tyrian_dos`, `gradius_v`, `rtype`, `river_raid`, `blazing_lazers`

### 2. Postprocess (pick variation, resize, bg removal → game assets)

```bash
go run ./cmd/postprocess -skin asteroids
# output goes to ../tyrian_mobile/assets/skins/asteroids/

# Pick a different variation
go run ./cmd/postprocess -skin asteroids -variation 2

# Tune bg removal
go run ./cmd/postprocess -skin asteroids -threshold 30 -margin 15 -size 128
```

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

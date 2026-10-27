# Skins

Kiran ships with 14 visual themes. Each skin provides its own sprites, parallax
backgrounds, SFX, adaptive music, and post-process shader preset.

Sprites are generated via the ComfyUI pipeline in `pipeline/` — **Flux** for the
in-game sprites (clean silhouettes that read at gameplay size and background-key
cleanly) and **Pony SDXL + a starship-hull LoRA** for the boss preview thumbnails
(hero art where the extra hull detail pays off). See `pipeline/SKILL.md`.

---

| Skin | Theme | Vessels | Bloom | CRT | Tint | Notes |
|------|-------|--------:|:-----:|:---:|------|-------|
| Monochrome Invader (1978) | Monochrome arcade | 4 | — | scanlines 0.4, curve 0.01 | neutral | Subtle CRT phosphor |
| Vector Wireframe (1979) | Vector wireframe | 4 | 0.6× | — | green tint (0.85 / 1.0 / 0.85) | Glow on geometry |
| Arcade Formation (1981) | Fixed-formation arcade | 4 | 0.5× | — | neutral | Soft bloom on projectiles |
| 8-Bit Canyon (1982) | 4-colour console era | 4 | — | — | neutral | Ultra-chunky flat sprites |
| Biomech Cruiser (1987) | Biomechanical sci-fi | 4 | 0.7× | — | neutral | Neutral bloom |
| 16-Bit Laser (1989) | 16-bit console shooter | 4 | 0.8× | — | warm (1.0 / 0.95 / 0.9) | Subtle warm glow |
| Retro PC Pixel (1995) | DOS-era pixel art | 4 | — | scanlines 0.7, curve 0.02 | warm (1.0 / 0.95 / 0.85) | Faithful retro feel |
| Dual-Polarity (2001) | Two-polarity shooter | 4 | 0.8× | — | cool blue (0.9 / 0.95 / 1.0) | Matches the polarity palette |
| Neon Grid (2003) | Neon vector grid | 4 | 1.5× | — | cyan tint (0.8 / 1.0 / 1.0) | Strongest bloom preset |
| Chrome Fleet (2004) | Chrome fleet shmup | 4 | 0.6× | — | cool blue (0.9 / 0.95 / 1.0) | Clean, high-contrast |
| Sepia Dogfight (2014) | Sepia dogfight | 4 | — | — | warm yellow (1.0 / 0.9 / 0.7) | No bloom — flat palette |
| Wasteland Pixel (2015) | Post-apocalyptic | 4 | — | — | desaturated warm | Saturation 0.85, orange tint |
| Neon Voxel (2017) | Dark neon voxel | 4 | 1.0× | — | neutral | High-contrast neon |
| Kiran (2026) | Kirian original | 1 | — | — | neutral | Hand-crafted baseline |

---

## Gallery

Each entry: the boss preview thumbnail (left) and the enemy roster — falcon,
falcon1–6, falconx/x2/x3/xb/xt, bouncer (right).

### Monochrome Invader (1978)
<p><img src="tyrian_mobile/assets/skins/space_invaders/ui/preview.png" width="190" align="top"> <img src="docs/gallery/space_invaders_enemies.png" width="560" align="top"></p>

### Vector Wireframe (1979)
<p><img src="tyrian_mobile/assets/skins/asteroids/ui/preview.png" width="190" align="top"> <img src="docs/gallery/asteroids_enemies.png" width="560" align="top"></p>

### Arcade Formation (1981)
<p><img src="tyrian_mobile/assets/skins/galaga/ui/preview.png" width="190" align="top"> <img src="docs/gallery/galaga_enemies.png" width="560" align="top"></p>

### 8-Bit Canyon (1982)
<p><img src="tyrian_mobile/assets/skins/river_raid/ui/preview.png" width="190" align="top"> <img src="docs/gallery/river_raid_enemies.png" width="560" align="top"></p>

### Biomech Cruiser (1987)
<p><img src="tyrian_mobile/assets/skins/rtype/ui/preview.png" width="190" align="top"> <img src="docs/gallery/rtype_enemies.png" width="560" align="top"></p>

### 16-Bit Laser (1989)
<p><img src="tyrian_mobile/assets/skins/blazing_lazers/ui/preview.png" width="190" align="top"> <img src="docs/gallery/blazing_lazers_enemies.png" width="560" align="top"></p>

### Retro PC Pixel (1995)
<p><img src="tyrian_mobile/assets/skins/tyrian_dos/ui/preview.png" width="190" align="top"> <img src="docs/gallery/tyrian_dos_enemies.png" width="560" align="top"></p>

### Dual-Polarity (2001)
<p><img src="tyrian_mobile/assets/skins/ikaruga/ui/preview.png" width="190" align="top"> <img src="docs/gallery/ikaruga_enemies.png" width="560" align="top"></p>

### Neon Grid (2003)
<p><img src="tyrian_mobile/assets/skins/geometry_wars/ui/preview.png" width="190" align="top"> <img src="docs/gallery/geometry_wars_enemies.png" width="560" align="top"></p>

### Chrome Fleet (2004)
<p><img src="tyrian_mobile/assets/skins/gradius_v/ui/preview.png" width="190" align="top"> <img src="docs/gallery/gradius_v_enemies.png" width="560" align="top"></p>

### Sepia Dogfight (2014)
<p><img src="tyrian_mobile/assets/skins/luftrausers/ui/preview.png" width="190" align="top"> <img src="docs/gallery/luftrausers_enemies.png" width="560" align="top"></p>

### Wasteland Pixel (2015)
<p><img src="tyrian_mobile/assets/skins/nuclear_throne/ui/preview.png" width="190" align="top"> <img src="docs/gallery/nuclear_throne_enemies.png" width="560" align="top"></p>

### Neon Voxel (2017)
<p><img src="tyrian_mobile/assets/skins/nex_machina/ui/preview.png" width="190" align="top"> <img src="docs/gallery/nex_machina_enemies.png" width="560" align="top"></p>

### Kiran (2026)
<p><img src="tyrian_mobile/assets/skins/default/ui/preview.png" width="190" align="top"> <img src="docs/gallery/default_enemies.png" width="560" align="top"></p>

---

## Shader Legend

- **Bloom** — 3-pass blur composited over bright pixels; strength `0.5–1.5×`, threshold `0.6–0.8`
- **CRT** — scanline overlay + barrel curvature; only on pixel-art retro skins (`tyrian_dos`, `space_invaders`)
- **Vignette** — applied to all skins (radius `0.85–0.95`, softness `0.15–0.2`)
- **Chromatic aberration** — triggered on damage hit, not part of the static skin preset

## Adding a New Skin

1. Create `assets/skins/<name>/` with `sprites/`, `ui/`, `sfx/`, `backgrounds/` subdirs
2. Add 4 vessel sprites: `vessel_0.png` – `vessel_3.png`
3. Run `dart run tool/pack_atlas.dart` to rebuild the texture atlas
4. Register a `ShaderConfig` entry in `lib/rendering/shader_config.dart`
5. Add the skin ID to `SkinRegistry` in `lib/services/skin_registry.dart`

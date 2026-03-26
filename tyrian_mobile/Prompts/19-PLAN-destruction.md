# Plan: Performance Optimization + Sprite Destruction System

## Context

Tyrian Mobile is a Flutter/Flame top-down space shooter with 50-155 entities on screen at peak load. Each entity is a `PositionComponent` with its own `render()` call, resulting in N individual draw calls. The game has 13 skins with ~30 individual PNGs each, no texture atlases, and no SpriteBatch usage. Projectiles have object pooling but explosions are create/destroy. The user's existing roadmap in `Prompts/18-PLAN-performance-optimization.md` defines 9 phases; this plan provides concrete implementation for all of them.

## Implementation Order

### Step 1: FPS Counter (baseline measurement)

**Files:** `lib/main.dart`, `lib/game/tyrian_game.dart`

- Add FPS overlay widget in `GameWidget.overlayBuilderMap` (outside game render pipeline, unaffected by shaders)
- Track entity counts in `TyrianGame`: expose `int get hostileCount`, `projectileCount`, `explosionCount` getters from active lists
- Display: `"60fps | H:24 P:48 E:8"` in top-left corner, togglable via debug flag
- Use `Stopwatch` based FPS (not `dt` based) for accuracy

---

### Step 2: Explosion Pool (quick GC win)

**Files:** `lib/entities/explosion.dart`, `lib/game/tyrian_game.dart`, `lib/systems/fleet.dart`

Convert Explosion to **pure data + centralized renderer** (not PositionComponent pool):

**New `ExplosionData` class** (plain Dart, no Component):
```dart
class ExplosionData {
  double x = 0, y = 0;
  int step = 0, maxSteps = 0, explosionSize = 0;
  bool active = false;

  void reset(double px, double py, int size) { ... }
}
```

**New `ExplosionRenderer extends Component`:**
- Pre-allocates `List<ExplosionData>` (30 entries)
- `acquire(x, y, size)` returns next inactive entry
- `update(dt)`: advances `step` on all active, deactivates when done
- `render(canvas)`: draws colored circles for all active entries in ONE render() call
- Reuse existing color cycle + core glow logic from current `Explosion.render()`

**Changes to `tyrian_game.dart`:**
- Replace `activeExplosions` list + `Explosion` component creation with `ExplosionRenderer` component
- `addExplosion(x, y, size)` calls `explosionRenderer.acquire(x, y, size)` instead of `world.add(Explosion(...))`
- Remove `removeExplosion()` method (lifecycle handled internally)

---

### Step 3: SpriteBatch Rendering (biggest FPS win)

**New file:** `lib/rendering/batch_renderer.dart`

**Architecture:** Keep entities as `PositionComponent` for update/collision logic, but make their `render()` no-ops. New `BatchRenderer` components read from the existing active entity lists and draw everything via `canvas.drawAtlas()`.

Uses raw `canvas.drawAtlas()` from dart:ui instead of Flame's `SpriteBatch` wrapper — avoids per-frame allocation overhead from SpriteBatch's handle system. Pre-allocated `RSTransform`, `Rect`, and `Color` lists are cleared and rebuilt each frame.

**`_AtlasBatch`** (internal helper):
- Groups sprites by source `ui.Image`
- `add(src, x, y, scaleX, scaleY, color)` — appends to transform/source/color lists
- `addRotated(src, centerX, centerY, scale, rotation, color)` — for shard fragments
- `render(canvas, paint)` — single `canvas.drawAtlas()` call

**`HostileBatchRenderer`:**
- Iterates `game.activeFleets[*].hostiles` + `game.clientHostiles.values`
- HP bars: second pass with `canvas.drawRect()` in world coordinates
- Hit flash: `color: Color(0xFFFF8888)` when `h.hit > 0`

**`ProjectileBatchRenderer`:**
- Iterates all vessels' device projectiles + `game.enemyProjectiles` + `game.clientPlayerProjectiles`

**`StructureBatchRenderer`:**
- Iterates `game.activeStructures` + `game.clientStructures.values`

**`ShardBatchRenderer`:**
- Renders active shards via `addRotated()` with per-shard rotation, scale, and alpha fade

**Entity modifications:**
- `hostile.dart`: add `Sprite? get sprite => _sprite;`, render() becomes no-op
- `projectile.dart`: add `Sprite? get sprite => _sprite;`, render() becomes no-op
- `structure.dart`: add sprite getter, render() becomes no-op

**Result:** ~100 draw calls → ~3 draw calls (with atlas, one per batch renderer type).

---

### Step 4: Texture Atlas Per Skin

**New file:** `tool/pack_atlas.dart` (build-time Dart script)

**Build-time packing:**
- Scans `assets/skins/$id/sprites/*.png` for each skin
- Uses `image` package to load all PNGs
- Shelf-packing algorithm, sorted by height (tallest first)
- 1px padding between sprites to prevent texture bleeding
- Power-of-2 dimensions, tries 512→1024
- Generates Voronoi fragments for fragmentable sprites (Step 9)
- Outputs: `assets/skins/$id/atlas.png` + `assets/skins/$id/atlas.json`
- Run via: `dart run tool/pack_atlas.dart`

**Atlas JSON format:**
```json
{
  "width": 1024, "height": 1024,
  "frames": {
    "falcon1": { "x": 0, "y": 0, "w": 40, "h": 40 },
    "falcon1_frag_0": { "x": 500, "y": 200, "w": 22, "h": 18 },
    ...
  },
  "fragments": {
    "falcon1": {
      "count": 6,
      "seeds": [[12.5, 8.3], [28.1, 15.0], ...],
      "pieces": [
        { "name": "falcon1_frag_0", "seedX": 12.5, "seedY": 8.3 },
        ...
      ]
    }
  }
}
```

**`asset_library.dart` changes:**
- `_tryLoadAtlas()`: loads atlas image + JSON, creates `Sprite` objects with `srcPosition`/`srcSize`
- Parses `"fragments"` section into `Map<String, List<FragmentInfo>>` for Voronoi shard lookup
- Falls back to individual PNGs seamlessly if atlas missing

**Impact on SpriteBatch:** With atlas, ALL sprites share one `ui.Image` → total scene = **3 draw calls**.

---

### Step 5: Sprite Shatter (quad-slice + Voronoi destruction)

**New file:** `lib/entities/shard.dart`

**`ShardData`** — plain Dart, no Component. Holds sourceRect, image, position, velocity, rotation, alpha, life.

**`ShardPool`** (80 slots):
- `spawn(sprite, deathX, deathY, hitX, hitY, spriteW, spriteH, spriteName)`:
  - Checks `AssetLibrary.fragments[spriteName]` for Voronoi data
  - If found: spawns 5-7 irregular Voronoi fragments
  - If not: falls back to 4-quadrant slice
- **Radial explosion physics**: shards fly outward from sprite center in all directions
- ±60° angular jitter + perpendicular random kick → each explosion is unique
- Random initial rotation, fast spin (±7 rad/s)
- Speed 120-320 px/s, life 0.5-1.0s, very light gravity (10 — space feel)

**Hit point tracking:** `lastHitX/Y` on `Hostile`, set in `Vessel._checkProjectileCollisions()`.

**Fleet integration:** On hostile death, spawn shards + boss-tier gets pixel explosion overlay.

---

### Step 6: Remove Flame Collision Infrastructure

**Files:** all entity files + `tyrian_game.dart`

- Remove `HasCollisionDetection` from `TyrianGame`
- Remove `RectangleHitbox` from all entities
- Remove `CollisionCallbacks` from `Vessel`, `Structure`, `Collectable`
- Move collectable pickup to manual AABB in `_checkCollectablePickup()`
- Existing manual AABB for hostiles/structures/projectiles unchanged

**Impact:** Removes Flame's internal broadphase overhead.

---

### Step 7: Dissolve/Burn Shader

**New files:**
- `shaders/dissolve.frag` — procedural FBM noise dissolve with glowing edge (no noise texture needed)
- `lib/rendering/dissolve_effect.dart` — per-entity shader wrapper

**Dissolve shader:** 4-octave FBM noise, configurable edge glow color (default orange), `uAmount` 0→1.

**`DissolveEffect` class:**
- `renderWith(canvas, width, height, drawContent)` — rasterizes entity to offscreen image, applies shader
- Can be animated (`begin(duration)`) or driven directly (`amount = value`)

**Vessel integration:** Below 30% HP, dissolve amount scales 0→0.6 (never fully dissolves — that's death). Loaded in `vessel.init()`.

---

### Step 8: Pixel Explosion Shader (boss deaths)

**New files:**
- `shaders/pixel_explosion.frag` — per-pixel scatter with gravity, random variation, heat glow
- `lib/rendering/pixel_explosion_overlay.dart` — standalone Component for boss death

**Pixel explosion shader:** Each pixel gets velocity from hit point, parabolic trajectory, per-pixel hash for organic variation, orange heat glow fading to transparent.

**`PixelExplosionOverlay`** — temporary PositionComponent:
- Captures boss sprite to offscreen image at death time
- Animates shader with `uTime` 0→1 over 1 second
- Self-destructs after animation

**Fleet integration:** Boss-tier hostiles (falconxb, falconxt, bouncer) spawn overlay alongside shard fragments.

---

### Step 9: Voronoi Fragmentation

**Build-time** (in `tool/pack_atlas.dart`):
- For each fragmentable sprite (falcon*, asteroid*, bouncer): generate 6 Voronoi seed points
- Pixel-based cell assignment (nearest seed)
- Extract tight-bounding-box fragment images, pack into atlas
- Store metadata (seed coordinates, fragment names) in atlas.json

**Runtime** (in `shard.dart` + `asset_library.dart`):
- `FragmentInfo` class stores fragment name + seed position
- `ShardPool._spawnVoronoi()` uses pre-baked fragments from atlas
- Falls back to quad-slice if fragments not available

**Result:** 17 sprites × 6 fragments = 102 Voronoi fragments per skin, all packed into the same atlas.

---

## Critical Files Summary

| File | Steps |
|------|-------|
| `lib/game/tyrian_game.dart` | 1, 2, 3, 5, 6 |
| `lib/rendering/batch_renderer.dart` (new) | 3, 5 |
| `lib/rendering/dissolve_effect.dart` (new) | 7 |
| `lib/rendering/pixel_explosion_overlay.dart` (new) | 8 |
| `lib/entities/hostile.dart` | 3, 5, 6 |
| `lib/entities/projectile.dart` | 3, 6 |
| `lib/entities/explosion.dart` → `ExplosionRenderer` | 2 |
| `lib/entities/shard.dart` (new) | 5, 9 |
| `lib/services/asset_library.dart` | 4, 9 |
| `lib/systems/fleet.dart` | 2, 5, 8 |
| `lib/entities/vessel.dart` | 5, 6, 7 |
| `lib/entities/structure.dart` | 3, 6 |
| `lib/entities/collectable.dart` | 6 |
| `tool/pack_atlas.dart` (new) | 4, 9 |
| `shaders/dissolve.frag` (new) | 7 |
| `shaders/pixel_explosion.frag` (new) | 8 |
| `lib/main.dart` | 1 |

## Verification

1. **FPS counter**: verify baseline before/after each step on Android mid-range device
2. **Flutter DevTools Performance tab**: raster thread < 8ms target
3. **Visual regression**: all 13 skins render correctly, HP bars visible, hit flash works
4. **Destruction**: hostiles visibly shatter on death with Voronoi fragments flying in all directions
5. **Boss deaths**: pixel explosion shader plays alongside shard fragments
6. **Vessel damage**: dissolve effect visible below 30% HP
7. **Gameplay**: collision detection works identically (manual AABB unchanged)
8. **Co-op**: client mode renders correctly with batch renderers
9. **Skin switch**: `refreshSprites()` correctly updates batch renderer image references
10. **Atlas fallback**: game works without atlas.png (individual PNG loading as fallback)

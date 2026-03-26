# Plan: Performance optimalizace — mobilní hra s 50+ sprites

## Context
Hra je top-down vesmírná střílečka ve Flutter/Flame. Při 50+ sprites na obrazovce (nepřátelé + střely + exploze + collectables) trpí výkon kvůli:
- N draw callů (každý entity = samostatný PositionComponent)
- Individuální PNG textury (N GPU uploadů)
- Flame broadphase kolize
- Audio player instance overhead
- Dart GC z new Explosion() každý frame

## Aktuální stav codebase

| Komponent | Implementace | Problém |
|-----------|-------------|---------|
| Hostile/Structure | `PositionComponent` + ruční `render()` | Samostatný draw call per enemy |
| Projectile | `PositionComponent` + **pool existuje** v Device | Pool OK, ale stále N draw callů |
| Explosion | `PositionComponent` + `removeFromParent()` | Žádný pool, nové objekty, N draw callů |
| Collectable | `PositionComponent` + `RectangleHitbox` | Flame collision broadphase |
| Textury | Individuální PNG per sprite | N GPU uploadů |
| Audio | just_audio, 30 AudioPlayer instancí | Těžký na paměť, async overhead |

## Prioritizovaný plán (od nejvyššího dopadu)

### Fáze 1: SpriteBatch rendering (OBROVSKÝ dopad)

**Cíl**: Všechny entity stejného typu v jednom draw callu.

**Nový systém**: `BatchRenderer` component — drží `SpriteBatch`, iteruje přes data list, renderuje jedním voláním.

```
Projectiles (50-100)  → 1 draw call
Hostiles (10-30)      → 1 draw call
Explosions (5-15)     → 1 draw call (Canvas circles, ne sprites)
Collectables (0-5)    → 1 draw call
```

**Implementace**:
- Entity data oddělená od rendering (struct/plain class místo Component)
- `BatchRenderer extends Component` drží `SpriteBatch` + iteruje list
- Zachovat stávající entity třídy pro logiku (update, collision), ale render delegovat na batch
- NEBO: převést entity na pure data + centralizovaný update v TyrianGame

**Doporučený přístup** (minimální refactor):
- Zachovat `Hostile`, `Projectile` atd. jako `PositionComponent` pro update/collision
- Override `render()` na prázdný (nic nekreslí)
- Nový `ProjectileBatchRenderer` a `HostileBatchRenderer` čtou pozice z active lists a renderují přes SpriteBatch

**Soubory**:
- Nový: `lib/rendering/batch_renderer.dart`
- Upravit: `lib/entities/projectile.dart` (prázdný render)
- Upravit: `lib/entities/hostile.dart` (prázdný render)
- Upravit: `lib/game/tyrian_game.dart` (přidat batch renderery)

### Fáze 2: Texture Atlas per skin (VELKÝ dopad)

**Cíl**: Jeden GPU upload per skin místo N.

**Implementace**:
- Generovat `atlas.webp` + `atlas.json` per skin (TexturePacker/build script)
- `AssetLibrary` načte atlas a parsuje JSON pro source rects
- `SpriteBatch` pak používá jeden atlas image pro všechny sprites

**Soubory**:
- Nový: `tools/pack_atlas.dart` (build-time script)
- Nový: per skin `atlas.webp` + `atlas.json`
- Upravit: `lib/services/asset_library.dart` (atlas loading)

### Fáze 3: Explosion pool (STŘEDNÍ dopad)

**Cíl**: Žádné `new Explosion()` za běhu.

**Implementace**:
- Pre-alokovat pool 20 Explosion instancí
- `acquire()` / `release()` místo `new` / `removeFromParent()`
- Exploze = Canvas circles (už jsou), ne sprites → žádný SpriteBatch potřeba

**Soubory**:
- Upravit: `lib/entities/explosion.dart` (pool pattern)
- Upravit: `lib/game/tyrian_game.dart` (pool management)
- Upravit: `lib/systems/fleet.dart` (použít pool)

### Fáze 4: Vlastní AABB kolize místo Flame hitboxů (STŘEDNÍ dopad)

**Cíl**: Odstranit overhead Flame collision systému.

**Aktuální stav**: `HasCollisionDetection` + `RectangleHitbox` per entity. Flame dělá broadphase + narrowphase interně.

**Implementace**:
- Projectile vs Hostile/Structure: ruční AABB check v game update loop
- Vessel vs Hostile/Collectable: ruční AABB check
- Odebrat `RectangleHitbox` z entity, odebrat `HasCollisionDetection` z TyrianGame
- Použít spatial grid pro O(n log n) místo O(n²)

Poznámka: Hostile už má ruční AABB v `_checkPlayerCollision()` (řádek 235). Tento pattern rozšířit na všechno.

**Soubory**:
- Nový: `lib/systems/collision_grid.dart`
- Upravit: `lib/game/tyrian_game.dart` (collision loop)
- Upravit: všechny entity (odebrat hitbox)

### Fáze 5: Audio — lehčí alternativa (MALÝ dopad)

**Problém**: 30 `AudioPlayer` instancí (just_audio) je těžké na paměť. Každý player má vlastní decoder pipeline.

**Lepší přístup**: `flutter_soloud` — nativní SoLoud engine, ultra-lehký, podporuje .ogg všude, zero-latency fire-and-forget, pool interně.

```dart
// flutter_soloud — 1 engine, fire-and-forget
final soloud = SoLoud.instance;
await soloud.init();
final source = await soloud.loadAsset('assets/sfx/fire.ogg');
soloud.play(source); // instant, no Future overhead
```

- Žádné AudioPlayer instance
- Nativní C++ dekódování (ne Dart)
- Podporuje .ogg na Windows/Android/iOS/macOS/Linux/Web
- Polyphony built-in (stejný zvuk vícekrát současně)

**Soubory**:
- `pubspec.yaml`: `just_audio` + `just_audio_windows` → `flutter_soloud`
- `lib/services/sound_service.dart`: přepsat na SoLoud API

### Fáze 6: 2D Destrukce — hybridní sprite shatter (VIZUÁLNÍ dopad)

**Cíl**: Při zničení nepřítele se sprite rozprskne — kombinace fyzikálních střepů + GPU pixel efektu.

**Hybridní 3-vrstvý systém** (optimální poměr výkon/vizuál na mobilu):

```
┌─────────────────────────────────────────────────┐
│  Výbuch nepřítele                               │
│                                                 │
│  1. Fyzikální střepy (4-8)  → SpriteBatch       │
│     = Předřezané quadranty, impulz+rotace+fade  │
│     CPU: nízké (plain data, pool)               │
│                                                 │
│  2. Stávající Explosion circles → Canvas        │
│     = Barevné kruhy, už implementováno          │
│     CPU: minimální                              │
│                                                 │
│  3. Pixel Explosion shader → GPU                │
│     = Pixely se rozlétnou od hitPointu          │
│     CPU: nulové, GPU: nízké                     │
│     Jen pro bossy/velké nepřátele               │
└─────────────────────────────────────────────────┘
```

**Vrstva 1: Fyzikální střepy (hlavní efekt)**

Pre-slice: sprite rozřezat na 4 quadranty (sourceRect výřezy z textury).
Při smrti: 4 ShardData dostanou impulz od hitPointu + rotaci + gravitaci.
Renderují se přes SpriteBatch (0 extra draw callů).

```dart
class ShardData {
  Rect sourceRect;    // výřez z atlas textury (1/4 sprite)
  Vector2 position;
  Vector2 velocity;   // impulz od hitPointu exploze
  double rotation;
  double angularVel;  // rotační rychlost
  double alpha;       // fade 1.0 → 0.0
  double life;        // countdown 0.5-0.8s
  bool active;
}
```

- Impulz: čím blíž hitPointu, tím větší rychlost
- Směr: centroid střepu → od hitPointu + random spread
- Gravitace: jemný pull dolů (vesmír → velmi slabý)
- Pool: pre-alokovat 40 shardů (10 explozí × 4 kusy)

**Vrstva 2: Stávající Explosion circles** — beze změn, zachovat

**Vrstva 3: Pixel Explosion shader (volitelně, pro bossy)**

```glsl
// shaders/pixel_explosion.frag
uniform float uTime;
uniform vec2  uHitPoint;

void main() {
    vec2  dir    = vTexCoord - uHitPoint;
    float speed  = 1.5 - length(dir);
    vec2  offset = dir * speed * uTime * uTime;
    offset.y    -= 0.5 * uTime * uTime; // gravitace

    vec2 sampleUV = vTexCoord - offset;
    if (sampleUV.x < 0.0 || sampleUV.x > 1.0 ||
        sampleUV.y < 0.0 || sampleUV.y > 1.0) discard;

    vec4 color = texture2D(uTexture, sampleUV);
    color.a   *= 1.0 - uTime;
    gl_FragColor = color;
}
```

Zero CPU overhead — vše na GPU v pixel shaderu.

**Implementace**:
- `ShardPool` + `ShardData` v `lib/entities/shard.dart` — plain data, žádný Component
- `ShardBatchRenderer` v `lib/rendering/batch_renderer.dart` — přes SpriteBatch
- Pre-slice v `AssetLibrary`: pro každý sprite spočítat 4 quadrant sourceRects
- Fleet: při smrti nepřítele → `shardPool.spawn(spriteRect, hitPoint, position)`
- Volitelně: `shaders/pixel_explosion.frag` jako post-process pass pro bossy

**Mobilní performance budget**:

| Technika | CPU | GPU | Mobil |
|----------|-----|-----|-------|
| 4 střepy přes SpriteBatch | ✅ nízké | ✅ nízké | ✅ výborné |
| Stávající Explosion circles | ✅ nízké | ✅ nízké | ✅ výborné |
| Pixel Explosion shader | ✅ nulové | ⚠️ střední | ✅ OK (jen bossy) |

**Soubory**:
- Nový: `lib/entities/shard.dart` (ShardData + ShardPool)
- Upravit: `lib/rendering/batch_renderer.dart` (ShardBatchRenderer)
- Upravit: `lib/services/asset_library.dart` (pre-slice quadrant rects)
- Upravit: `lib/systems/fleet.dart` (spawn shardů při smrti)
- Nový: `shaders/pixel_explosion.frag` (volitelně pro bossy)

## Doporučené pořadí implementace

| Pořadí | Fáze | Úkol | Effort | Dopad |
|--------|------|------|--------|-------|
| 1. | **5** | flutter_soloud (audio fix) | Malý | Vyřeší Windows + performance |
| 2. | **3** | Explosion pool | Malý | Méně GC |
| 3. | **1** | SpriteBatch rendering | Velký | Obrovský FPS boost |
| 4. | **6** | Sprite shatter destrukce | Střední | Vizuální wow efekt |
| 5. | **4** | Vlastní AABB kolize | Střední | Méně CPU |
| 6. | **2** | Texture atlas | Střední (tooling) | Méně GPU uploads |

Fáze 5 (audio) je nejrychlejší win. Fáze 6 (shatter) závisí na SpriteBatch z fáze 1 — shardy se renderují přes batch.

### Fáze 7: Voronoi fragmentace — pre-baked (VIZUÁLNÍ bonus)

**Cíl**: Alternativa k quad-slice z fáze 6. Realističtější rozbití na nepravidelné kusy.

**Přístup**: Pre-baked Voronoi — při načtení skinu se pro každý sprite typ vygeneruje N seed pointů a spočítají se Voronoi buňky. Runtime jen aktivuje předpočítané fragmenty.

**Implementace**:
- Build-time nebo load-time: Voronoi diagram přes Fortune's algorithm
- Pro každý sprite: 5-8 Voronoi cells → uložit sourceRects (bounding box per cell) + polygon mask
- Runtime: polygon masking přes Canvas.clipPath() na SpriteBatch segment
- Nebo jednodušeji: předem vyrendrovat fragmenty do offscreen bitmap při load

**Trade-off vs quad-slice**:

| | Quad-slice (Fáze 6) | Voronoi (Fáze 7) |
|---|---|---|
| Vizuál | Pravidelné 4 kusy | Nepravidelné střepy |
| Komplexita | Triviální (4 sourceRects) | Voronoi + clipping |
| Performance | Výborný | OK (clipPath overhead) |
| Memory | Minimální | Střední (pre-baked bitmaps) |

**Doporučení**: Začít s quad-slice (fáze 6), Voronoi jako budoucí upgrade.

### Fáze 8: Dissolve/Burn shader (VIZUÁLNÍ polish)

**Cíl**: Shader efekt pro postupné mizení zásahem — doplněk k fyzikálním střepům.

**Implementace**:
```glsl
// shaders/dissolve.frag
uniform sampler2D uTexture;
uniform sampler2D uNoise;     // Perlin/simplex noise texture
uniform float uAmount;        // 0.0 → 1.0 (dissolve progress)
uniform vec4 uEdgeColor;      // žhnoucí okraj (oranžová/červená)

void main() {
    vec4 color = texture2D(uTexture, vTexCoord);
    float noise = texture2D(uNoise, vTexCoord).r;

    if (noise < uAmount) discard;

    if (noise < uAmount + 0.05) {
        color = mix(color, uEdgeColor,
                    1.0 - (noise - uAmount) / 0.05);
    }
    gl_FragColor = color;
}
```

**Použití**: Na vessel při low HP (vizuální poškození) nebo na bossy při smrti.
Nízký GPU overhead — vhodné pro mobil.

**Soubory**:
- Nový: `shaders/dissolve.frag`
- Nový: `assets/textures/noise.png` (256x256 Perlin noise)
- Nový: `lib/rendering/passes/dissolve_pass.dart`

### Fáze 9: Diagnostika — FPS counter + DevTools profiling

**Cíl**: Měřit dopad každé fáze objektivně.

**Implementace**:
- FPS overlay: `FpsTextComponent` v GameWidget overlayBuilderMap
- Flame debugMode pro hitbox vizualizaci
- Flutter DevTools Performance tab metriky:
  - `build` > 8ms → Flutter widget overhead
  - `raster` > 8ms → draw calls / textury
  - `update` > 4ms → kolize / GC

**Soubory**:
- Upravit: `lib/main.dart` (přidat FPS overlay)

## Kompletní pořadí implementace

| Pořadí | Fáze | Úkol | Effort | Dopad |
|--------|------|------|--------|-------|
| 1. | **9** | FPS counter + profiling baseline | Malý | Měření |
| 2. | **5** | flutter_soloud (audio) | Malý | Windows fix + perf |
| 3. | **3** | Explosion pool | Malý | Méně GC |
| 4. | **1** | SpriteBatch rendering | Velký | Obrovský FPS boost |
| 5. | **2** | Texture atlas per skin | Střední | Méně GPU uploads |
| 6. | **6** | Sprite shatter (quad-slice) | Střední | Vizuální wow |
| 7. | **4** | Vlastní AABB + spatial grid | Střední | Méně CPU |
| 8. | **8** | Dissolve/burn shader | Malý | Vizuální polish |
| 9. | **7** | Voronoi fragmentace | Velký | Upgrade shatter efektu |

## Ověření

- FPS counter overlay během gameplay (měřit před/po každé fázi)
- Flutter DevTools → Performance tab → raster thread < 8ms
- Windows: zvuky hrají .ogg
- Android: žádná regrese, 60fps na mid-range zařízení
- Gameplay: vizuální vylepšení bez performance regrese
- Destrukce: nepřátelé se viditelně rozpadají při smrti

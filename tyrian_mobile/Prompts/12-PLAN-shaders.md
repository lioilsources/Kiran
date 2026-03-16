# Shader Effects Pipeline — Implementation Plan

## Context

TyrianVB mobile (Flutter/Flame 1.35.1) currently uses only Canvas-based rendering for all visual effects (damage flash via `saveLayer`+`srcATop`, beam glow via `MaskFilter.blur`, procedural explosions). This plan adds a GPU fragment shader post-processing pipeline leveraging Flame's **native `PostProcess` API** (`camera.postProcess`). The pipeline will apply 4 shader effects — Vignette+ColorGrade, Bloom, CRT/Scanlines, and Chromatic Aberration+DamageFlash — configurable per skin.

---

## Architecture

### Integration Point

```
camera.postProcess = PostProcessSequentialGroup([
  vignetteColorPass,    // always active
  bloomPass,            // per-skin (e.g. geometry_wars, ikaruga)
  crtPass,              // per-skin (e.g. tyrian_dos)
  chromaticAberrationPass, // event-driven (on damage)
]);
```

HUD (OsdPanel, ComCenter etc.) are Flutter overlay widgets on `GameWidget` — **not affected** by the shader pipeline. Only the game world (starfield, parallax, entities, beams) passes through shaders.

### Render Flow

```
World render → PostProcessSequentialGroup:
  1. VignetteColor: rasterize → vignette + color tint + saturation + damage flash
  2. Bloom: rasterize → threshold bright pixels → blur H → blur V → composite
  3. CRT: rasterize → barrel distortion + scanlines
  4. ChromaticAberration: rasterize → RGB channel split (event-driven, 0 = passthrough)
→ Final composited frame
```

Each pass that is disabled (intensity 0 or skin config off) calls `renderSubtree(canvas)` directly — zero overhead passthrough.

---

## Files to Create

### GLSL Fragment Shaders — `tyrian_mobile/shaders/`

#### 1. `vignette_color.frag`
```glsl
#include <flutter/runtime_effect.glsl>
uniform vec2 uSize;
uniform float uVignetteRadius;   // 0.3-0.9 — where darkening starts
uniform float uVignetteSoft;     // 0.1-0.5 — falloff softness
uniform float uTintR;            // per-skin RGB multiplier (1.0 = neutral)
uniform float uTintG;
uniform float uTintB;
uniform float uSaturation;       // 0.8-1.2
uniform float uDamageFlash;      // 0.0-1.0 — red flash on hit
uniform sampler2D uTexture;
```
Logic: Sample → desaturate/saturate → apply tint → vignette darken → mix red on damage.

#### 2. `bloom_threshold.frag`
```glsl
uniform vec2 uSize;
uniform float uThreshold;  // 0.5-0.9 — brightness cutoff
uniform sampler2D uTexture;
```
Logic: Extract pixels with luminance > threshold, output bright-only image.

#### 3. `bloom_blur.frag`
```glsl
uniform vec2 uSize;
uniform vec2 uDirection;  // (1,0) for H, (0,1) for V
uniform sampler2D uTexture;
```
Logic: 9-tap Gaussian blur in given direction. Runs twice (H then V) = separable Gaussian.

#### 4. `bloom_composite.frag`
```glsl
uniform vec2 uSize;
uniform float uStrength;  // 0.0-2.0 — bloom intensity
uniform sampler2D uScene;   // sampler 0: original scene
uniform sampler2D uBloom;   // sampler 1: blurred bright pixels
```
Logic: `output = scene + bloom * strength`. Additive blend.

#### 5. `crt.frag`
```glsl
uniform vec2 uSize;
uniform float uTime;
uniform float uScanlineIntensity;  // 0.0-1.0
uniform float uCurvature;          // 0.0-0.05 — barrel distortion
uniform sampler2D uTexture;
```
Logic: Barrel-distort UV → sample → modulate by `sin(uv.y * height)` for scanlines → optional subtle phosphor grain.

#### 6. `chromatic_aberration.frag`
```glsl
uniform vec2 uSize;
uniform float uIntensity;  // 0.0-1.0 — decays after damage
uniform sampler2D uTexture;
```
Logic: 3 samples at UV, UV+offset, UV-offset — compose R/G/B from different positions. Offset radiates from center. When intensity=0, single sample passthrough.

### Dart Classes — `tyrian_mobile/lib/rendering/`

#### 7. `shader_config.dart` — Per-skin effect parameters
```dart
class ShaderConfig {
  final double vignetteRadius;
  final double vignetteSoft;
  final double tintR, tintG, tintB;
  final double saturation;
  final bool bloomEnabled;
  final double bloomStrength;
  final double bloomThreshold;
  final bool crtEnabled;
  final double scanlineIntensity;
  final double crtCurvature;
  const ShaderConfig({...});

  // Default presets per skin
  static const defaults = <String, ShaderConfig>{
    'default':        ShaderConfig(vignetteRadius: 0.7, vignetteSoft: 0.3, ...),
    'geometry_wars':  ShaderConfig(bloomEnabled: true, bloomStrength: 1.5, ...),
    'tyrian_dos':     ShaderConfig(crtEnabled: true, scanlineIntensity: 0.7, ...),
    // ... all 13 skins
  };
}
```

#### 8. `shader_pipeline.dart` — Main pipeline orchestrator
Owns all passes. Created in `TyrianGame.onLoad()`.
```dart
class ShaderPipeline {
  final VignetteColorPass vignetteColor;
  final BloomPass bloom;
  final CrtPass crt;
  final ChromaticAberrationPass chromaticAberration;

  PostProcess build() => PostProcessSequentialGroup(postProcesses: [
    vignetteColor, bloom, crt, chromaticAberration,
  ]);

  void configure(ShaderConfig config) { ... }
  void setDamageFlash(double intensity) { ... }
  void triggerAberration() { ... }
}
```

#### 9. `passes/vignette_color_pass.dart`
Extends `PostProcess`. In `postProcess()`:
1. `rasterizeSubtree()` → get scene image
2. Set uniforms (size, vignette params, tint, saturation, damageFlash)
3. `shader.setImageSampler(0, image)`
4. `canvas.drawRect(fullscreen, Paint()..shader = shader)`
5. `image.dispose()`

#### 10. `passes/bloom_pass.dart`
Internally manages 4 sub-operations:
1. Threshold pass (full-res)
2. Horizontal blur pass (full-res)
3. Vertical blur pass (full-res)
4. Composite pass (full-res, 2 samplers: original scene + blurred bloom)

When `!enabled`, simply `renderSubtree(canvas)`.

#### 11. `passes/crt_pass.dart`
Single-pass. Rasterize → apply barrel distortion + scanlines.

#### 12. `passes/chromatic_aberration_pass.dart`
Single-pass. When `intensity == 0`, passthrough. On damage, intensity set to 1.0 and decays in `update(dt)` over 0.3s.

---

## Files to Modify

### 13. `pubspec.yaml` — Add shader declarations
```yaml
flutter:
  shaders:
    - shaders/vignette_color.frag
    - shaders/bloom_threshold.frag
    - shaders/bloom_blur.frag
    - shaders/bloom_composite.frag
    - shaders/crt.frag
    - shaders/chromatic_aberration.frag
```

### 14. `lib/services/skin_registry.dart` — Add ShaderConfig per skin
Extend `SkinInfo` with a `ShaderConfig shaderConfig` getter (uses the static defaults map keyed by skin id).

### 15. `lib/game/tyrian_game.dart` — Wire up pipeline
- **onLoad()** (after camera setup): Create `ShaderPipeline`, call `camera.postProcess = pipeline.build()`
- **update(dt)**: Compute `damageFlash` from vessel dmgTaken, feed to pipeline
- **refreshSprites()**: Reconfigure pipeline with new skin's `ShaderConfig`

### 16. `lib/entities/vessel.dart` — Remove saveLayer damage flash
Remove the `if (dmgTaken > 0) { saveLayer... }` block in `render()`. The fullscreen `vignette_color.frag` now handles damage flash via `uDamageFlash` uniform. Keep the per-entity P2 green tint and sprite rendering as-is. Add `game.shaderPipeline.triggerAberration()` in `takeDamage()`.

---

## Per-Skin Shader Configurations

| Skin | Vignette | Color Tint | Bloom | CRT | Notes |
|------|----------|-----------|-------|-----|-------|
| default | 0.7/0.3 | neutral (1,1,1) | off | off | Clean baseline |
| geometry_wars | 0.4/0.3 | cyan (0.8,1,1) | 1.5 str, 0.6 thresh | off | Heavy neon glow |
| tyrian_dos | 0.5/0.4 | warm (1,0.95,0.85) | off | 0.7 scanline, 0.02 curve | Retro CRT feel |
| space_invaders | 0.6/0.3 | neutral | off | 0.4 scanline, 0.01 curve | Subtle retro |
| ikaruga | 0.5/0.3 | cool (0.9,0.95,1) | 0.8 str, 0.75 thresh | off | Elegant glow |
| nuclear_throne | 0.3/0.4 | warm (1,0.9,0.75) | off | off | Heavy vignette, desaturated |
| galaga | 0.6/0.3 | neutral | 0.5 str, 0.8 thresh | off | Subtle bloom |
| asteroids | 0.5/0.3 | green (0.85,1,0.85) | 0.6 str, 0.7 thresh | off | Vector glow |
| luftrausers | 0.4/0.4 | sepia (1,0.9,0.7) | off | off | Film-like |
| nex_machina | 0.5/0.3 | neutral | 1.0 str, 0.65 thresh | off | Arcade glow |
| gradius_v | 0.6/0.3 | cool (0.9,0.95,1) | 0.6 str, 0.8 thresh | off | Clean sci-fi |
| rtype | 0.5/0.3 | neutral | 0.7 str, 0.75 thresh | off | Organic glow |
| blazing_lazers | 0.5/0.3 | warm (1,0.95,0.9) | 0.8 str, 0.7 thresh | off | Bright arcade |

---

## Implementation Order

### Step 1: Foundation + Vignette/ColorGrade/DamageFlash
1. Create `shaders/vignette_color.frag`
2. Create `lib/rendering/shader_config.dart`
3. Create `lib/rendering/passes/vignette_color_pass.dart`
4. Create `lib/rendering/shader_pipeline.dart`
5. Add `shaders:` section to `pubspec.yaml`
6. Modify `skin_registry.dart` — add `ShaderConfig`
7. Modify `tyrian_game.dart` — create pipeline in `onLoad()`, feed damageFlash in `update()`
8. Modify `vessel.dart` — remove saveLayer damage flash

### Step 2: Bloom
1. Create `shaders/bloom_threshold.frag`
2. Create `shaders/bloom_blur.frag`
3. Create `shaders/bloom_composite.frag`
4. Create `lib/rendering/passes/bloom_pass.dart`
5. Add bloom shaders to `pubspec.yaml`
6. Wire bloom into `ShaderPipeline`

### Step 3: CRT/Scanlines
1. Create `shaders/crt.frag`
2. Create `lib/rendering/passes/crt_pass.dart`
3. Add to `pubspec.yaml` and pipeline

### Step 4: Chromatic Aberration
1. Create `shaders/chromatic_aberration.frag`
2. Create `lib/rendering/passes/chromatic_aberration_pass.dart`
3. Add decay timer logic in `update(dt)` — 1.0 → 0.0 over 0.3s after damage
4. Wire damage events from `vessel.takeDamage()` to pipeline

---

## Key Technical Details

### Flame PostProcess API (built-in, no extra deps)
- `PostProcess.rasterizeSubtree()` → captures world render to `ui.Image`
- `PostProcess.renderSubtree(canvas)` → passthrough (no rasterize cost)
- `PostProcessSequentialGroup` chains passes — each pass's output is next pass's subtree
- `camera.postProcess = myPostProcess` — single assignment, wraps world render
- `PostProcess.update(dt)` called each frame — use for time/decay uniforms
- `PostProcess.onLoad()` — async, use for `FragmentProgram.fromAsset()`

### Fragment Shader Loading Pattern
```dart
class MyPass extends PostProcess {
  late FragmentShader _shader;

  @override
  Future<void> onLoad() async {
    final program = await FragmentProgram.fromAsset('shaders/my_effect.frag');
    _shader = program.fragmentShader();
  }

  @override
  void postProcess(Vector2 size, Canvas canvas) {
    final image = rasterizeSubtree();
    _shader.setFloatUniforms((s) {
      s.setSize(Size(size.x, size.y));
      // ... more uniforms
    });
    _shader.setImageSampler(0, image);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..shader = _shader,
    );
    image.dispose();
  }
}
```

### Bloom Multi-Pass Strategy
BloomPass is itself a `PostProcess` that internally manages sub-operations:
1. Calls `rasterizeSubtree()` to get the original scene image
2. Creates a threshold-only image using threshold shader
3. Blurs the threshold image H then V using blur shader
4. Composites original + blurred using composite shader

All intermediate images are created/disposed within a single `postProcess()` call using `PictureRecorder` + `Canvas` + `toImageSync`.

### Pixel Ratio
All passes use `pixelRatio: 1.0` — image pixel dimensions match logical viewport size (600 × dynamic height). This simplifies coordinate handling: `FlutterFragCoord()` maps 1:1 to image pixel coordinates. Normalized UV = `FlutterFragCoord() / uSize`. Quality is sufficient for a retro-styled game at 600px logical width.

### Viewport Sizing
The game uses **fixed width 600** with **dynamic height** based on device aspect ratio (`config.gameHeight = 600 * (size.y / size.x)`). All shaders receive the actual viewport dimensions via the `Vector2 size` parameter of `postProcess()` — no hardcoded sizes.

### Uniform Layout
Uniforms must be set in the **exact same order** as declared in GLSL. The `setFloatUniforms` helper auto-increments the index:
- `setSize(Size)` → 2 floats (vec2)
- `setFloat(double)` → 1 float
- `setImageSampler(index, image)` — separate from float uniforms

Avoid Flame's `setColor()` helper (broken with new Flutter Color API where `.r` returns normalized [0,1] instead of [0,255]). Use raw `setFloat()` for color components instead.

### Performance
- Viewport: 600 × dynamic (800-1300 logical pixels depending on device)
- All intermediate passes at full logical resolution (simple, sufficient for 600px viewport)
- Disabled passes = zero cost (passthrough via `renderSubtree`)
- Typical frame: 2-3 rasterize calls (vignette + bloom or CRT)
- Target: <3ms shader overhead per frame

---

## Verification

1. **Build**: `flutter build ios --debug` / `flutter run` — shaders compile at build time
2. **Visual**: Switch skins in selector — each skin should have distinct visual feel:
   - `default`: subtle vignette only
   - `geometry_wars`: strong neon bloom glow on projectiles/beams
   - `tyrian_dos`: CRT scanlines + barrel distortion
3. **Damage flash**: Take damage → smooth red fullscreen tint (replaces old per-entity flash)
4. **Chromatic aberration**: Take damage → brief RGB split, decays 0.3s
5. **Passthrough**: Disabled effects must have zero visual impact
6. **Co-op**: Both host and client should show shader effects identically
7. **Performance**: Stable 60fps on mid-range device with bloom enabled

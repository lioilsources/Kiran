import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;

import '../game/game_config.dart' as config;
import 'skin_registry.dart';

/// Voronoi fragment metadata for a single piece of a shattered sprite.
class FragmentInfo {
  final String name;
  final double seedX, seedY; // position within original sprite coords
  FragmentInfo(this.name, this.seedX, this.seedY);
}

/// Replaces Library.cls — loads and caches all game sprites.
/// BMP+mask system is eliminated; all assets are PNG with alpha channel.
class AssetLibrary {
  AssetLibrary._();
  static final AssetLibrary instance = AssetLibrary._();

  final Map<String, Sprite> _sprites = {};
  final Map<String, ui.Image> _images = {};
  final List<Sprite> _vesselFrames = [];
  final List<ui.Image> _bgLayers = [];
  List<ui.Image> get bgLayers => _bgLayers;

  /// Flame cache keys backing [_bgLayers], index-aligned. Needed so a zone swap
  /// evicts exactly the images it replaced — shared layers appear in both the
  /// old and the new key set and are therefore never disposed.
  final List<String> _bgKeys = [];

  /// Art zone currently resident. -1 = none; reset by [loadSkin].
  int _bgZone = -1;

  /// Art zone the game wants. Deliberately survives [loadSkin] so changing skin
  /// at sector 12 reloads zone 6, not zone 0.
  int _desiredZone = 0;

  /// Monotonic token so overlapping loads (ComCenter sector-jump spam) resolve
  /// last-wins instead of interleaving.
  int _bgLoadSeq = 0;

  int get bgZone => _bgZone;

  ui.Image? _atlasImage;
  final Map<String, Rect> _atlasRects = {};
  ui.Image? get atlasImage => _atlasImage;

  final Map<String, Sprite> _icons = {};

  /// Voronoi fragment metadata per sprite name.
  /// Key = sprite name (e.g. "falcon1"), Value = list of FragmentInfo.
  final Map<String, List<FragmentInfo>> _fragments = {};
  Map<String, List<FragmentInfo>> get fragments => _fragments;

  bool _loaded = false;
  String _skinId = 'default';
  AssetManifest? _manifest;

  String get skinId => _skinId;

  /// Switch to a different skin. Clears all caches and reloads.
  Future<void> loadSkin(String skinId) async {
    _sprites.clear();
    _images.clear();
    _bgLayers.clear();
    _bgKeys.clear();
    _bgZone = -1;
    // _desiredZone is deliberately NOT reset: a skin change mid-run must land on
    // the sector the player is actually in.
    _icons.clear();
    _atlasImage = null;
    _atlasRects.clear();
    _fragments.clear();
    _loaded = false;
    _placeholder = null;
    _manifest = null;
    // Clear Flame's image cache so it reloads from the new paths. This disposes
    // the atlas too, which every live Sprite references — correct for a skin
    // change (already a full stall), and exactly why a zone swap must never
    // reach it. loadZoneBackgrounds() evicts single keys instead.
    Flame.images.clearCache();
    _skinId = skinId;
    await loadAll();
  }

  /// Load preview images for all skins (for the skin selector screen).
  Future<Map<String, ui.Image>> loadPreviews() async {
    Flame.images.prefix = 'assets/';
    final previews = <String, ui.Image>{};
    for (final skin in kSkins) {
      try {
        final img = await Flame.images.load(skin.previewPath);
        previews[skin.id] = img;
      } catch (e) {
        print('Preview load failed for ${skin.id}: $e');
      }
    }
    return previews;
  }

  Future<void> loadAll() async {
    if (_loaded) return;

    // Pick texture filtering for this skin. Smooth (medium) filtering only helps
    // when sprites are supersampled (high-res atlas downsampled on screen) and
    // the skin isn't pixel-art; otherwise keep nearest-neighbour.
    final skin = kSkins.firstWhere(
      (s) => s.id == _skinId,
      orElse: () => const SkinInfo('default', 'default', pixelArt: true),
    );
    config.spriteFilterQuality =
        (!skin.pixelArt && config.spriteSupersample > 1.0)
            ? FilterQuality.medium
            : FilterQuality.none;

    // Flame expects images under assets/images/ by default.
    // We override the prefix so it loads from assets/ directly.
    Flame.images.prefix = 'assets/';

    // Try atlas-based loading first
    final atlasLoaded = await _tryLoadAtlas();
    if (atlasLoaded) {
      // Build vessel frames from atlas sprites
      _vesselFrames.clear();
      for (int i = 0; i < 6; i++) {
        final s = _sprites['vessel_$i'];
        if (s != null) _vesselFrames.add(s);
      }

      // Background layers are NOT in the atlas — load separately
      _bgZone = -1;
      await loadZoneBackgrounds(_desiredZone);

      await _loadIcons();
      _loaded = true;
      return;
    }

    // Fallback: individual PNG loading (existing code)
    String p(String name) => 'skins/$_skinId/sprites/$name.png';

    // Player — animated vessel frames (fall back to single vessel.png)
    _vesselFrames.clear();
    for (int i = 0; i < 6; i++) {
      final loaded = await _tryLoad('vessel_$i', p('vessel_$i'));
      if (loaded) _vesselFrames.add(_sprites['vessel_$i']!);
    }
    if (_vesselFrames.isEmpty) {
      await _load('vessel', p('vessel'));
    }

    // Enemies — falcon variants
    await _load('falcon', p('falcon'));
    for (int i = 1; i <= 6; i++) {
      await _load('falcon$i', p('falcon$i'));
    }
    await _load('falconx', p('falconx'));
    await _load('falconx2', p('falconx2'));
    await _load('falconx3', p('falconx3'));
    await _load('falconxb', p('falconxb'));
    await _load('falconxt', p('falconxt'));
    await _load('bouncer', p('bouncer'));
    // Boss sprite — optional per skin, Boss falls back to bouncer when absent
    await _tryLoad('rododendron', p('rododendron'));

    // Structures
    await _load('asteroid', p('asteroid'));
    await _load('asteroid1', p('asteroid1'));
    await _load('asteroid2', p('asteroid2'));
    await _load('asteroid3', p('asteroid3'));

    // Projectiles
    await _load('bubble', p('bubble'));
    await _load('vulcan', p('vulcan'));
    await _load('blaster', p('blaster'));
    await _load('laser', p('laser'));
    await _load('starg', p('starg'));

    // Explosions (4 variations)
    for (int i = 1; i <= 4; i++) {
      await _load('explosion$i', p('explosion$i'));
    }

    // Background layers (optional — only AI skins have them)
    _bgZone = -1;
    await loadZoneBackgrounds(_desiredZone);

    await _loadIcons();
    _loaded = true;
  }

  /// Swap the parallax layers to art [zone]. Callers resolve the zone from a
  /// sector index via `Sector.zoneForIndex` — index stopped being a proxy for
  /// zone once one level could span several sectors.
  ///
  /// layer_0/layer_1 ship per-zone variants; layer_2/layer_3 are shared and stay
  /// resident across the swap. Each of the four slots resolves independently
  /// through zone WebP → shared WebP → legacy PNG, so a skin without zone art
  /// still gets a complete four-layer set and this becomes a no-op for it after
  /// the first call.
  ///
  /// Safe to call from a synchronous path without awaiting: the live [bgLayers]
  /// list — which ParallaxBackground aliases — is only mutated once every new
  /// image has decoded, so a torn layer set is never observable.
  Future<void> loadZoneBackgrounds(int zone) async {
    _desiredZone = zone;
    if (zone == _bgZone && _bgLayers.isNotEmpty) return;
    final seq = ++_bgLoadSeq;

    final next = <ui.Image>[];
    final keys = <String>[];
    for (int i = 0; i < 4; i++) {
      for (final key in [
        'skins/$_skinId/backgrounds/layer_${i}_z$zone.webp',
        'skins/$_skinId/backgrounds/layer_$i.webp',
        'skins/$_skinId/backgrounds/layer_$i.png',
      ]) {
        final img = await _tryLoadImage(key);
        if (img != null) {
          next.add(img);
          keys.add(key);
          break;
        }
      }
    }

    if (seq != _bgLoadSeq) return; // superseded mid-flight

    // Order matters, and there must be no await between these steps:
    // Flame.images.clear() disposes the image it evicts, so the new set has to
    // be installed before the old keys are dropped. Dart schedules no frame
    // inside a synchronous block, so the swap is atomic from the renderer's
    // point of view. Breaking this yields an intermittent "Cannot use a
    // disposed Image" under sector-jump spam.
    final stale = [for (final k in _bgKeys) if (!keys.contains(k)) k];
    _bgLayers
      ..clear()
      ..addAll(next);
    _bgKeys
      ..clear()
      ..addAll(keys);
    _bgZone = zone;
    for (final k in stale) {
      Flame.images.clear(k);
    }
  }

  Future<void> _loadIcons() async {
    _icons.clear();
    for (final name in [
      'icon_life', 'icon_bomb', 'icon_shield', 'icon_credit', 'icon_gen',
      'comcenter_bg', 'ui_card_bg', 'ui_button', 'ui_tab_active',
    ]) {
      final path = 'skins/$_skinId/ui/$name.png';
      if (!await _assetExists(path)) continue;
      try {
        final image = await Flame.images.load(path);
        final sprite = Sprite(image);
        sprite.paint.filterQuality = config.spriteFilterQuality;
        _icons[name] = sprite;
      } catch (e) {
        print('Icon load failed [$name]: $e');
      }
    }
  }

  /// Try to load a pre-built texture atlas for the current skin.
  /// Returns true if the atlas was loaded successfully, false otherwise.
  Future<bool> _tryLoadAtlas() async {
    try {
      // Load atlas image
      final img = await _tryLoadImage('skins/$_skinId/atlas.png');
      if (img == null) return false;

      // Load atlas JSON
      final jsonStr =
          await rootBundle.loadString('assets/skins/$_skinId/atlas.json');
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final frames = json['frames'] as Map<String, dynamic>;

      _atlasImage = img;
      _atlasRects.clear();
      _images.clear();
      _sprites.clear();
      _fragments.clear();

      for (final entry in frames.entries) {
        final name = entry.key;
        final f = entry.value as Map<String, dynamic>;
        final rect = Rect.fromLTWH(
          (f['x'] as num).toDouble(),
          (f['y'] as num).toDouble(),
          (f['w'] as num).toDouble(),
          (f['h'] as num).toDouble(),
        );
        _atlasRects[name] = rect;
        _images[name] = img;
        final sprite = Sprite(
          img,
          srcPosition: Vector2(rect.left, rect.top),
          srcSize: Vector2(rect.width, rect.height),
        );
        sprite.paint.filterQuality = config.spriteFilterQuality;
        _sprites[name] = sprite;
      }

      // Parse Voronoi fragment metadata (optional section)
      if (json.containsKey('fragments')) {
        final frags = json['fragments'] as Map<String, dynamic>;
        for (final entry in frags.entries) {
          final name = entry.key;
          final data = entry.value as Map<String, dynamic>;
          final pieces = (data['pieces'] as List).cast<Map<String, dynamic>>();
          _fragments[name] = pieces
              .map((p) => FragmentInfo(
                    p['name'] as String,
                    (p['seedX'] as num).toDouble(),
                    (p['seedY'] as num).toDouble(),
                  ))
              .toList();
        }
      }

      return true;
    } catch (e) {
      print('Atlas load failed: $e');
      return false;
    }
  }

  Future<void> _load(String name, String path) async {
    try {
      final image = await Flame.images.load(path);
      _images[name] = image;
      final sprite = Sprite(image);
      sprite.paint.filterQuality = config.spriteFilterQuality;
      _sprites[name] = sprite;
    } catch (e) {
      print('Asset load failed [$name]: $e');
    }
  }

  /// Like _load but returns false on failure (no error log).
  Future<bool> _tryLoad(String name, String path) async {
    try {
      final image = await Flame.images.load(path);
      _images[name] = image;
      final sprite = Sprite(image);
      sprite.paint.filterQuality = config.spriteFilterQuality;
      _sprites[name] = sprite;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Returns true if the asset at [path] (relative to assets/) is in the bundle.
  /// Caches the manifest across calls within the same loadAll() invocation.
  Future<bool> _assetExists(String path) async {
    _manifest ??= await AssetManifest.loadFromAssetBundle(rootBundle);
    return _manifest!.getAssetVariants('assets/$path') != null;
  }

  /// Load a raw ui.Image, returning null if missing or on any error.
  /// Checks the AssetManifest first to avoid Flutter logging a platform error.
  Future<ui.Image?> _tryLoadImage(String path) async {
    if (!await _assetExists(path)) return null;
    try {
      return await Flame.images.load(path);
    } catch (_) {
      return null;
    }
  }

  Sprite? getSprite(String name) => _sprites[name];

  Sprite? getIcon(String name) => _icons[name];

  /// Animated vessel frames (empty if skin uses single vessel.png).
  List<Sprite> get vesselFrames => _vesselFrames;

  ui.Image? getImage(String name) => _images[name];

  /// Get sprite or a colored rectangle placeholder
  Sprite getOrPlaceholder(String name) {
    return _sprites[name] ?? _createPlaceholder();
  }

  static Sprite? _placeholder;
  Sprite _createPlaceholder() {
    if (_placeholder != null) return _placeholder!;
    // Use any loaded image as fallback; if none, this will be handled at render
    _placeholder = _sprites.values.isNotEmpty ? _sprites.values.first : null;
    return _placeholder ?? Sprite(Flame.images.fromCache('skins/$_skinId/sprites/vessel.png'));
  }
}

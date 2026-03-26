import 'dart:math';
import 'dart:ui' as ui;
import 'package:flame/components.dart';

import '../services/asset_library.dart';

/// Data for a single shard fragment (plain Dart, no Component).
class ShardData {
  ui.Rect sourceRect = ui.Rect.zero;
  ui.Image? image;
  double x = 0, y = 0;
  double vx = 0, vy = 0;
  double rotation = 0;
  double angularVel = 0;
  double alpha = 1.0;
  double life = 0;
  double totalLife = 0;
  double scale = 1.0;
  double baseScale = 1.0;
  bool active = false;
}

/// Pool of shard fragments for sprite destruction effects.
class ShardPool {
  static const int poolSize = 80; // ~11 kills * 7 fragments
  static final _rng = Random();

  final List<ShardData> shards = List.generate(poolSize, (_) => ShardData());

  /// Spawn shard fragments from a dying entity's sprite.
  /// Uses Voronoi fragments from the atlas when available, falling back to
  /// quad-slice.
  /// [sprite] -- the entity's Flame Sprite (has .image and .src)
  /// [deathX, deathY] -- center of the dying entity
  /// [hitX, hitY] -- where the killing projectile hit
  /// [spriteW, spriteH] -- rendered size of the sprite
  /// [spriteName] -- optional atlas sprite name for Voronoi fragment lookup
  void spawn(Sprite sprite, double deathX, double deathY,
      double hitX, double hitY, double spriteW, double spriteH,
      [String? spriteName]) {
    // Try Voronoi fragments first
    if (spriteName != null) {
      final fragInfos = AssetLibrary.instance.fragments[spriteName];
      if (fragInfos != null && fragInfos.isNotEmpty) {
        _spawnVoronoi(fragInfos, sprite, deathX, deathY, hitX, hitY,
            spriteW, spriteH);
        return;
      }
    }
    // Fallback: quad-slice
    _spawnQuadSlice(sprite, deathX, deathY, hitX, hitY, spriteW, spriteH);
  }

  /// Spawn shards using pre-baked Voronoi fragments from the atlas.
  void _spawnVoronoi(List<FragmentInfo> frags, Sprite originalSprite,
      double deathX, double deathY, double hitX, double hitY,
      double spriteW, double spriteH) {
    final lib = AssetLibrary.instance;
    final originalSrc = originalSprite.src;
    final scaleX = spriteW / originalSrc.width;
    final scaleY = spriteH / originalSrc.height;

    // Top-left of the sprite in world space
    final spriteLeft = deathX - spriteW / 2;
    final spriteTop = deathY - spriteH / 2;

    for (final frag in frags) {
      final fragSprite = lib.getSprite(frag.name);
      if (fragSprite == null) continue;

      final shard = _acquireInactive();
      if (shard == null) return; // pool exhausted

      // Fragment centroid in world space (seed position scaled to world)
      final cx = spriteLeft + frag.seedX * scaleX;
      final cy = spriteTop + frag.seedY * scaleY;

      _initShard(shard, fragSprite.src, fragSprite.image,
          cx, cy, deathX, deathY, scaleX);
    }
  }

  /// Fallback: spawn 4 quadrant shards by slicing the sprite into quarters.
  void _spawnQuadSlice(Sprite sprite, double deathX, double deathY,
      double hitX, double hitY, double spriteW, double spriteH) {
    final src = sprite.src;
    final image = sprite.image;
    final halfW = src.width / 2;
    final halfH = src.height / 2;
    final scaleX = spriteW / src.width;

    // 4 quadrants: TL, TR, BL, BR
    final quadrants = [
      ui.Rect.fromLTWH(src.left, src.top, halfW, halfH),
      ui.Rect.fromLTWH(src.left + halfW, src.top, halfW, halfH),
      ui.Rect.fromLTWH(src.left, src.top + halfH, halfW, halfH),
      ui.Rect.fromLTWH(src.left + halfW, src.top + halfH, halfW, halfH),
    ];

    final offsets = [
      [deathX - spriteW / 4, deathY - spriteH / 4],
      [deathX + spriteW / 4, deathY - spriteH / 4],
      [deathX - spriteW / 4, deathY + spriteH / 4],
      [deathX + spriteW / 4, deathY + spriteH / 4],
    ];

    for (int i = 0; i < 4; i++) {
      final shard = _acquireInactive();
      if (shard == null) return;

      _initShard(shard, quadrants[i], image,
          offsets[i][0], offsets[i][1], deathX, deathY, scaleX);
    }
  }

  /// Initialize a shard with radial explosion physics.
  /// Shards fly outward from [deathX/Y] in all directions with heavy random
  /// variation so each explosion looks unique.
  void _initShard(ShardData shard, ui.Rect sourceRect, ui.Image image,
      double cx, double cy, double deathX, double deathY, double scaleX) {
    // Base direction: from death center outward to fragment centroid
    var dx = cx - deathX;
    var dy = cy - deathY;
    final dist = sqrt(dx * dx + dy * dy);

    if (dist > 0.5) {
      dx /= dist;
      dy /= dist;
    } else {
      // Fragment at exact center — pick fully random direction
      final angle = _rng.nextDouble() * 2 * pi;
      dx = cos(angle);
      dy = sin(angle);
    }

    // Heavy random angular offset (±60°) so shards don't fly in neat lines
    final angleJitter = (_rng.nextDouble() - 0.5) * pi * 0.67;
    final cosJ = cos(angleJitter);
    final sinJ = sin(angleJitter);
    final jdx = dx * cosJ - dy * sinJ;
    final jdy = dx * sinJ + dy * cosJ;

    // Speed: wide range for variety (some fast, some slow)
    final speed = 120.0 + _rng.nextDouble() * 200.0;

    // Perpendicular random kick for extra scatter
    final perpSpeed = (_rng.nextDouble() - 0.5) * 160.0;

    final vx = jdx * speed + (-jdy) * perpSpeed;
    final vy = jdy * speed + jdx * perpSpeed;

    // Life: longer so shards travel further and are more visible
    final life = 0.5 + _rng.nextDouble() * 0.5;

    shard
      ..sourceRect = sourceRect
      ..image = image
      ..x = cx - sourceRect.width * scaleX / 2
      ..y = cy - sourceRect.height * scaleX / 2
      ..vx = vx
      ..vy = vy
      ..rotation = _rng.nextDouble() * 2 * pi // random initial rotation
      ..angularVel = (_rng.nextDouble() - 0.5) * 14 // faster spin
      ..alpha = 1.0
      ..life = life
      ..totalLife = life
      ..baseScale = scaleX
      ..scale = scaleX
      ..active = true;
  }

  ShardData? _acquireInactive() {
    for (final s in shards) {
      if (!s.active) return s;
    }
    return null;
  }

  void update(double dt) {
    for (final s in shards) {
      if (!s.active) continue;
      s.x += s.vx * dt;
      s.y += s.vy * dt;
      s.vy += 10 * dt; // very subtle gravity (space feel)
      s.rotation += s.angularVel * dt;
      s.life -= dt;
      final t = (s.life / s.totalLife).clamp(0.0, 1.0);
      s.alpha = t;
      s.scale = s.baseScale * (0.5 + 0.5 * t); // shrink as fading
      if (s.life <= 0) s.active = false;
    }
  }

  void clearAll() {
    for (final s in shards) {
      s.active = false;
    }
  }
}

import 'dart:math';
import 'dart:ui' as ui;
import 'package:flame/components.dart';

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
  static const int poolSize = 60; // 15 kills * 4 shards
  static final _rng = Random();

  final List<ShardData> shards = List.generate(poolSize, (_) => ShardData());

  /// Spawn 4 quadrant shards from a dying entity's sprite.
  /// [sprite] -- the entity's Flame Sprite (has .image and .src)
  /// [deathX, deathY] -- center of the dying entity
  /// [hitX, hitY] -- where the killing projectile hit
  /// [spriteW, spriteH] -- rendered size of the sprite
  void spawn(Sprite sprite, double deathX, double deathY,
      double hitX, double hitY, double spriteW, double spriteH) {
    final src = sprite.src;
    final image = sprite.image;
    final halfW = src.width / 2;
    final halfH = src.height / 2;
    final scaleX = spriteW / src.width;

    // 4 quadrants: TL, TR, BL, BR
    final quadrants = [
      ui.Rect.fromLTWH(src.left, src.top, halfW, halfH),                 // TL
      ui.Rect.fromLTWH(src.left + halfW, src.top, halfW, halfH),         // TR
      ui.Rect.fromLTWH(src.left, src.top + halfH, halfW, halfH),         // BL
      ui.Rect.fromLTWH(src.left + halfW, src.top + halfH, halfW, halfH), // BR
    ];

    // World-space offsets for each quadrant centroid
    final offsets = [
      [deathX - spriteW / 4, deathY - spriteH / 4], // TL
      [deathX + spriteW / 4, deathY - spriteH / 4], // TR
      [deathX - spriteW / 4, deathY + spriteH / 4], // BL
      [deathX + spriteW / 4, deathY + spriteH / 4], // BR
    ];

    for (int i = 0; i < 4; i++) {
      final shard = _acquireInactive();
      if (shard == null) return; // Pool exhausted

      final cx = offsets[i][0];
      final cy = offsets[i][1];

      // Direction: from hit point to quadrant centroid
      var dx = cx - hitX;
      var dy = cy - hitY;
      final dist = sqrt(dx * dx + dy * dy);
      if (dist > 0.01) {
        dx /= dist;
        dy /= dist;
      } else {
        // Hit exactly at centroid -- use quadrant direction
        dx = (i % 2 == 0) ? -1.0 : 1.0;
        dy = (i < 2) ? -1.0 : 1.0;
      }

      final speed = 80.0 + _rng.nextDouble() * 120.0;
      final life = 0.4 + _rng.nextDouble() * 0.3;

      shard
        ..sourceRect = quadrants[i]
        ..image = image
        ..x = cx - quadrants[i].width * scaleX / 2
        ..y = cy - quadrants[i].height * scaleX / 2
        ..vx = dx * speed + (_rng.nextDouble() - 0.5) * 40
        ..vy = dy * speed + (_rng.nextDouble() - 0.5) * 40
        ..rotation = 0
        ..angularVel = (_rng.nextDouble() - 0.5) * 8
        ..alpha = 1.0
        ..life = life
        ..totalLife = life
        ..baseScale = scaleX
        ..scale = scaleX
        ..active = true;
    }
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
      s.vy += 30 * dt; // light gravity
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

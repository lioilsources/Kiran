import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';

/// Data for a single explosion instance (plain data, no Component).
class ExplosionData {
  double x = 0;
  double y = 0;
  int step = 0;
  int maxSteps = config.explosionSteps;
  int explosionSize = 0;
  bool active = false;

  void reset(double px, double py, int size) {
    x = px;
    y = py;
    step = 0;
    explosionSize = size;
    maxSteps = config.explosionSteps;
    active = true;
  }
}

/// Centralized renderer for all explosions. Replaces N Explosion PositionComponents
/// with a single Component that manages a pre-allocated pool.
class ExplosionRenderer extends Component with HasGameReference<TyrianGame> {
  static const int poolSize = 30;

  static const _colors = [
    Color(0xFFFFFF00),
    Color(0xFFFF8800),
    Color(0xFFFF4400),
    Color(0xFFFF0000),
    Color(0xFFCC0000),
  ];

  final List<ExplosionData> _pool =
      List.generate(poolSize, (_) => ExplosionData());

  // Reusable Paint objects to avoid allocation
  final Paint _paint = Paint();
  final Paint _corePaint = Paint();

  int get activeCount {
    int c = 0;
    for (final e in _pool) {
      if (e.active) c++;
    }
    return c;
  }

  /// Acquire an explosion from the pool. Returns null if pool exhausted.
  ExplosionData? acquire(double x, double y, int size) {
    for (final e in _pool) {
      if (!e.active) {
        e.reset(x, y, size);
        return e;
      }
    }
    return null; // Pool exhausted — skip this explosion
  }

  @override
  void update(double dt) {
    for (final e in _pool) {
      if (!e.active) continue;
      e.step++;
      if (e.step >= e.maxSteps) {
        e.active = false;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    for (final e in _pool) {
      if (!e.active) continue;

      final progress = e.step / e.maxSteps;
      final radius = (e.explosionSize + 1) * 8.0 * progress;
      final alpha = ((1.0 - progress) * 255).round().clamp(0, 255);
      final colorIndex = (progress * (_colors.length - 1)).floor();

      _paint.color = _colors[colorIndex].withAlpha(alpha);
      canvas.drawCircle(Offset(e.x, e.y), radius, _paint);

      if (progress < 0.5) {
        _corePaint.color = Colors.white.withAlpha(alpha);
        canvas.drawCircle(Offset(e.x, e.y), radius * 0.3, _corePaint);
      }
    }
  }

  /// Deactivate all explosions (used on sector clear).
  void clearAll() {
    for (final e in _pool) {
      e.active = false;
    }
  }
}

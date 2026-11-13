import 'dart:math' as math;

import 'package:flame/components.dart';

/// A ship's own axes in game space (Prompts/30 §4).
///
/// Heading 0 is the nose to −y: today's flight, where ship space and game
/// space are the same thing. Positive headings turn clockwise. Everything a
/// ship does that has a "forward" — its guns, its sigils, its companions —
/// is computed in ship space and brought into the world through this frame.
///
/// At heading 0 every conversion here is the identity, bit for bit, which is
/// what keeps the flight, the mobile game and VB6 parity exactly as they
/// were: outside a duel the heading never leaves 0.
class ShipFrame {
  ShipFrame(this.heading)
      : fx = heading == 0 ? 0.0 : math.sin(heading),
        fy = heading == 0 ? -1.0 : -math.cos(heading),
        rx = heading == 0 ? 1.0 : math.cos(heading),
        ry = heading == 0 ? 0.0 : math.sin(heading);

  static final ShipFrame flight = ShipFrame(0);

  final double heading;

  /// Forward, unit, game space.
  final double fx, fy;

  /// Right, unit, game space.
  final double rx, ry;

  bool get isIdentity => heading == 0;

  /// A ship-space delta (x right, y back: today's game axes at heading 0)
  /// as a world delta.
  (double, double) toWorld(double x, double y) {
    if (heading == 0) return (x, y);
    return (rx * x - fx * y, ry * x - fy * y);
  }

  /// A world delta in ship space.
  (double, double) toShip(double wx, double wy) {
    if (heading == 0) return (wx, wy);
    return (wx * rx + wy * ry, -(wx * fx + wy * fy));
  }

  Vector2 toWorldV(double x, double y) {
    final (wx, wy) = toWorld(x, y);
    return Vector2(wx, wy);
  }

  /// A point laid out in ship space around ([cx], [cy]) — the way today's
  /// code places it at heading 0 — turned about that centre into the world.
  /// At heading 0 the point comes back untouched.
  (double, double) about(double cx, double cy, double px, double py) {
    if (heading == 0) return (px, py);
    final (wx, wy) = toWorld(px - cx, py - cy);
    return (cx + wx, cy + wy);
  }

  /// The heading whose forward is the world direction ([wx], [wy]).
  static double headingOf(double wx, double wy) => math.atan2(wx, -wy);

  /// [a] wrapped into (−π, π].
  static double wrap(double a) {
    var r = a % (2 * math.pi);
    if (r > math.pi) r -= 2 * math.pi;
    if (r <= -math.pi) r += 2 * math.pi;
    return r;
  }

  /// From [from] toward [to] by at most [step] radians, the short way round.
  static double turn(double from, double to, double step) {
    final d = wrap(to - from);
    if (d.abs() <= step) return to;
    return from + step * d.sign;
  }
}

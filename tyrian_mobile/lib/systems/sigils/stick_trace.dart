import 'dart:math' as math;

import 'sigil_grid.dart';

/// One right-stick sample: seconds since the trace began, ship space.
typedef StickSample = (double t, double x, double y);

/// Synthetic right-stick traces: the stick travelling
/// through the dots of a shape the way a thumb would — straight through the
/// centre, round the rim along the arc. The recogniser tests draw with it,
/// and so does the arena ghost that demonstrates a sigil (Prompts/29).
class StickTrace {
  static const double rate = 60;

  /// Seconds per 45° of rim and per centre↔rim stroke.
  final double arcStep, stroke;

  /// Uniform noise added to every sample.
  final double jitter;

  /// How far out the rim strokes reach.
  final double reach;
  final math.Random _rng;

  StickTrace({
    this.arcStep = 0.03,
    this.stroke = 0.05,
    this.jitter = 0,
    this.reach = 1.0,
    int seed = 7,
  }) : _rng = math.Random(seed);

  (double, double) _point(int dot) {
    if (dot == 4) return (0, 0);
    final a = SigilGrid.sectorAngle(SigilGrid.ring.indexOf(dot));
    return (math.sin(a) * reach, -math.cos(a) * reach);
  }

  /// The stick drawing [dots] from rest and coming home, then resting for
  /// [hold] seconds.
  List<StickSample> draw(List<int> dots, {double hold = 0.25, double lead = 0.1}) {
    final out = <StickSample>[];
    var t = 0.0;
    void emit(double x, double y) {
      final n = jitter == 0 ? 0.0 : jitter;
      out.add((
        t,
        x + (n == 0 ? 0 : (_rng.nextDouble() * 2 - 1) * n),
        y + (n == 0 ? 0 : (_rng.nextDouble() * 2 - 1) * n),
      ));
      t += 1 / rate;
    }

    void line((double, double) a, (double, double) b, double secs) {
      final n = math.max(1, (secs * rate).round());
      for (var i = 1; i <= n; i++) {
        final u = i / n;
        emit(a.$1 + (b.$1 - a.$1) * u, a.$2 + (b.$2 - a.$2) * u);
      }
    }

    void arc(int from, int to) {
      final ia = SigilGrid.ring.indexOf(from), ib = SigilGrid.ring.indexOf(to);
      var steps = (ib - ia + 8) % 8;
      if (steps > 4) steps -= 8;
      final a0 = SigilGrid.sectorAngle(ia);
      final a1 = a0 + steps * math.pi / 4;
      final n = math.max(1, (arcStep * steps.abs() * rate).round());
      for (var i = 1; i <= n; i++) {
        final a = a0 + (a1 - a0) * i / n;
        emit(math.sin(a) * reach, -math.cos(a) * reach);
      }
    }

    for (var i = 0; i < (lead * rate).round(); i++) {
      emit(0, 0);
    }
    var at = (0.0, 0.0);
    var prev = 4;
    for (final d in dots) {
      final p = _point(d);
      if (prev != 4 && d != 4 && SigilGrid.adjacentOnRing(prev, d)) {
        arc(prev, d);
      } else {
        line(at, p, stroke);
      }
      at = p;
      prev = d;
    }
    line(at, (0, 0), stroke);
    for (var i = 0; i < (hold * rate).round(); i++) {
      emit(0, 0);
    }
    return out;
  }
}

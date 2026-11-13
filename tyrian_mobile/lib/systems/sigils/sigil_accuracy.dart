import 'dart:math' as math;

import 'sigil_grid.dart';

/// How precisely a stroke followed its sigil's ideal line (Prompts/28 §11):
/// the HUD shows it after every cast, the arena drills on it.
///
/// The ideal line runs from the centre through the shape's dots and home —
/// straight through the centre, round the rim along the arc — scaled to how
/// far out this stick actually reached, so a thumb that never quite hits the
/// gate is judged on the shape it drew, not on the stick's travel.
abstract final class SigilAccuracy {
  /// Distance (in stick units, after scaling) at which a sample scores zero.
  static const double tolerance = 0.45;

  /// The ideal polyline of [dots] at rim radius [r], centre to centre.
  static List<(double, double)> idealLine(List<int> dots, {double r = 1}) {
    final pts = <(double, double)>[(0, 0)];
    var prev = 4;
    for (final d in dots) {
      if (prev != 4 && d != 4 && SigilGrid.adjacentOnRing(prev, d)) {
        final ia = SigilGrid.ring.indexOf(prev), ib = SigilGrid.ring.indexOf(d);
        final step = (ib - ia + 8) % 8 == 1 ? 1 : -1;
        final a0 = SigilGrid.sectorAngle(ia);
        for (var k = 1; k <= 6; k++) {
          final a = a0 + step * (math.pi / 4) * k / 6;
          pts.add((math.sin(a) * r, -math.cos(a) * r));
        }
      } else {
        pts.add(_point(d, r));
      }
      prev = d;
    }
    pts.add((0, 0));
    return pts;
  }

  static (double, double) _point(int dot, double r) {
    if (dot == 4) return (0, 0);
    final a = SigilGrid.sectorAngle(SigilGrid.ring.indexOf(dot));
    return (math.sin(a) * r, -math.cos(a) * r);
  }

  /// How far out the stick reached on the rim: the median magnitude of the
  /// samples past [rimFloor], or the furthest one when none got there.
  static double reach(List<(double, double)> trail, {double rimFloor = 0.7}) {
    final mags = [for (final (x, y) in trail) math.sqrt(x * x + y * y)];
    if (mags.isEmpty) return 1;
    final rim = mags.where((m) => m >= rimFloor).toList()..sort();
    if (rim.isEmpty) return mags.reduce(math.max).clamp(0.3, 1.0).toDouble();
    return rim[rim.length ~/ 2].clamp(0.3, 1.0).toDouble();
  }

  /// 0..1: how close [trail] stayed to the ideal line of [dots] (one minus
  /// the mean distance over [tolerance]) times how much of that line it
  /// covered. 1 is a stroke laid exactly on the whole line; stopping short
  /// costs as much as wandering off.
  static double score(List<(double, double)> trail, List<int> dots) {
    if (trail.isEmpty || dots.isEmpty) return 0;
    final line = idealLine(dots, r: reach(trail));
    var sum = 0.0;
    for (final (x, y) in trail) {
      final d = _distance(x, y, line);
      sum += (1 - d / tolerance).clamp(0.0, 1.0);
    }
    return sum / trail.length * coverage(trail, line);
  }

  /// Share of the ideal [line] the trail passed close to. The way home and
  /// the bit inside the centre zone are left out: a sigil that casts early
  /// never draws them, and the stroke only begins once the stick is out.
  static double coverage(List<(double, double)> trail, List<(double, double)> line,
      {double centre = 0.42}) {
    final probe = <(double, double)>[];
    for (var i = 1; i < line.length - 1; i++) {
      final a = line[i - 1], b = line[i];
      final len = math.sqrt(math.pow(b.$1 - a.$1, 2) + math.pow(b.$2 - a.$2, 2));
      final n = math.max(1, (len / 0.1).ceil());
      for (var k = 0; k <= n; k++) {
        final u = k / n;
        final p = (a.$1 + (b.$1 - a.$1) * u, a.$2 + (b.$2 - a.$2) * u);
        if (math.sqrt(p.$1 * p.$1 + p.$2 * p.$2) >= centre) probe.add(p);
      }
    }
    if (probe.isEmpty) return 1;
    final path = trail.length == 1 ? [trail.first, trail.first] : trail;
    var hit = 0;
    for (final (x, y) in probe) {
      if (_distance(x, y, path) <= tolerance * 0.6) hit++;
    }
    return hit / probe.length;
  }

  static double _distance(double x, double y, List<(double, double)> line) {
    var best = double.infinity;
    for (var i = 1; i < line.length; i++) {
      final d = _segment(x, y, line[i - 1], line[i]);
      if (d < best) best = d;
    }
    return best;
  }

  static double _segment(double px, double py, (double, double) a, (double, double) b) {
    final vx = b.$1 - a.$1, vy = b.$2 - a.$2;
    final l2 = vx * vx + vy * vy;
    var u = l2 == 0 ? 0.0 : ((px - a.$1) * vx + (py - a.$2) * vy) / l2;
    u = u.clamp(0.0, 1.0);
    final dx = px - (a.$1 + vx * u), dy = py - (a.$2 + vy * u);
    return math.sqrt(dx * dx + dy * dy);
  }
}

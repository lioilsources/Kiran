import 'dart:math' as math;

/// The 3×3 lock grid the right stick draws on (Prompts/28 §4.1).
///
/// Dots are numbered row by row, top to bottom, the same as OrbitronTactics:
///
///     0 1 2
///     3 4 5      4 is the stick at rest
///     6 7 8
///
/// The grid is ship-relative: dot 1 is "forward", wherever forward is on
/// screen. The caller rotates the stick into ship space before it gets here,
/// the same way movement is rotated in landscape.
abstract final class SigilGrid {
  static const int center = 4;

  /// The eight rim dots in clockwise order, starting at forward.
  static const List<int> ring = [1, 2, 5, 8, 7, 6, 3, 0];

  /// Grid column (0..2) and row (0..2) of [dot].
  static int col(int dot) => dot % 3;
  static int row(int dot) => dot ~/ 3;

  /// Unit offset of [dot] from the centre, y down (screen convention).
  static (double, double) offset(int dot) =>
      ((col(dot) - 1).toDouble(), (row(dot) - 1).toDouble());

  /// The rim dot whose 45° sector contains the direction (x, y), y down.
  static int rimDotFor(double x, double y) => ring[sectorFor(x, y)];

  /// Index into [ring] of the sector containing (x, y): 0 = forward, then
  /// clockwise.
  static int sectorFor(double x, double y) {
    // Angle clockwise from forward (0, -1), in [0, 2π).
    var a = math.atan2(x, -y);
    if (a < 0) a += 2 * math.pi;
    return ((a + math.pi / 8) / (math.pi / 4)).floor() % 8;
  }

  /// Angle clockwise from forward of the middle of [ring] sector [s].
  static double sectorAngle(int s) => s * math.pi / 4;

  /// Left↔right mirror of [dot] (columns swap, rows stay).
  static int mirror(int dot) => row(dot) * 3 + (2 - col(dot));

  static List<int> mirrorShape(List<int> shape) =>
      [for (final d in shape) mirror(d)];

  /// Whether two rim dots are neighbours on the ring.
  static bool adjacentOnRing(int a, int b) {
    final ia = ring.indexOf(a), ib = ring.indexOf(b);
    if (ia < 0 || ib < 0) return false;
    final d = (ia - ib).abs();
    return d == 1 || d == 7;
  }

  /// Rim dots strictly between [a] and [b] going the short way round, for a
  /// stick that jumped a sector between two samples. Empty when they are
  /// neighbours or opposite (opposite is ambiguous, so nothing is invented).
  static List<int> ringGap(int a, int b) {
    final ia = ring.indexOf(a), ib = ring.indexOf(b);
    if (ia < 0 || ib < 0) return const [];
    final cw = (ib - ia + 8) % 8;
    if (cw <= 1 || cw == 7 || cw == 4) return const [];
    final step = cw < 4 ? 1 : -1;
    final n = cw < 4 ? cw - 1 : 8 - cw - 1;
    return [for (var k = 1; k <= n; k++) ring[(ia + step * k + 8) % 8]];
  }

  /// True when [shape] is a full loop of the rim: 8 distinct rim dots, each
  /// next to the one before (a circle, any start, either direction).
  static bool isCircle(List<int> shape) {
    if (shape.length != 8 || shape.contains(center)) return false;
    if (shape.toSet().length != 8) return false;
    for (var i = 1; i < 8; i++) {
      if (!adjacentOnRing(shape[i - 1], shape[i])) return false;
    }
    return true;
  }

  /// Direction of a circle: +1 clockwise, -1 counter-clockwise, 0 not one.
  static int circleDirection(List<int> shape) {
    if (shape.length < 2) return 0;
    final a = ring.indexOf(shape[0]), b = ring.indexOf(shape[1]);
    if (a < 0 || b < 0) return 0;
    return (b - a + 8) % 8 == 1 ? 1 : -1;
  }

  /// Rotate a drawn circle (or double circle) to start at forward, so a loop
  /// begun anywhere on the rim matches the catalogue's one shape.
  static List<int> canonicalCircle(List<int> shape) {
    final dir = circleDirection(shape);
    final start = ring.indexOf(shape.first);
    if (dir == 0 || start < 0) return shape;
    return [
      for (var i = 0; i < shape.length; i++) ring[((i * dir) % 8 + 8) % 8],
    ];
  }
}

import 'dart:math' as math;

import 'sigil_grid.dart';
import 'sigil_spec.dart';

/// Where a running hull sigil has the ship, relative to where it began.
class SigilPose {
  final double dx;
  final double dy;
  final double scale;

  /// Turns of barrel roll, for drawing.
  final double roll;

  const SigilPose(this.dx, this.dy, {this.scale = 1, this.roll = 0});

  static const zero = SigilPose(0, 0);
}

/// One sigil in flight (Prompts/28 §5.4). Pure: the caster moves the ship to
/// [pose] and fires [dueCues]; this only keeps time and does the maths, so a
/// run is the same on every machine and in every replay.
class SigilRun {
  final SigilSpec spec;
  final bool mirrored;

  /// Unit direction of a flick, ship space (x right, y backward).
  final double dirX, dirY;

  double elapsed = 0;
  final Set<int> _fired = {};

  SigilRun(this.spec, {this.mirrored = false, int? flickDot})
      : dirX = _dir(flickDot).$1,
        dirY = _dir(flickDot).$2;

  static (double, double) _dir(int? dot) {
    if (dot == null) return (0, -1);
    final (x, y) = SigilGrid.offset(dot);
    final l = math.sqrt(x * x + y * y);
    return l == 0 ? (0, -1) : (x / l, y / l);
  }

  double get progress => spec.durationMs == 0
      ? 1
      : (elapsed / spec.duration).clamp(0.0, 1.0).toDouble();

  bool get done => elapsed >= spec.duration;

  /// Inside the sigil's untouchable window.
  bool get untouchable {
    final ph = spec.phase;
    if (ph == null) return false;
    final p = progress;
    return p >= ph.$1 && p <= ph.$2 && !done;
  }

  void advance(double dt) => elapsed += dt;

  /// Fire cues whose time has come, each once.
  List<FireCue> dueCues() {
    final out = <FireCue>[];
    final p = progress;
    for (var i = 0; i < spec.fire.length; i++) {
      final c = spec.fire[i];
      if (c.t <= p && _fired.add(i)) out.add(c);
    }
    return out;
  }

  SigilPose get pose => poseAt(progress);

  /// The path at progress [p]: eased between keys, mirrored, and for a flick
  /// turned from forward onto the flick direction.
  SigilPose poseAt(double p) {
    final keys = spec.path;
    if (keys.isEmpty) return SigilPose.zero;
    var a = keys.first, b = keys.last;
    for (var i = 1; i < keys.length; i++) {
      if (p <= keys[i].t) {
        a = keys[i - 1];
        b = keys[i];
        break;
      }
    }
    final span = b.t - a.t;
    final u = span <= 0 ? 1.0 : ((p - a.t) / span).clamp(0.0, 1.0);
    final e = u * u * (3 - 2 * u); // smoothstep
    var dx = a.dx + (b.dx - a.dx) * e;
    var dy = a.dy + (b.dy - a.dy) * e;
    final scale = a.scale + (b.scale - a.scale) * e;
    var roll = a.roll + (b.roll - a.roll) * e;
    if (mirrored) {
      dx = -dx;
      roll = -roll;
    }
    if (spec.isFlick) {
      // Forward (0, -1) onto (dirX, dirY): sinθ = dirX, cosθ = -dirY.
      final s = dirX, c = -dirY;
      final rx = dx * c - dy * s;
      final ry = dx * s + dy * c;
      dx = rx;
      dy = ry;
    }
    return SigilPose(dx, dy, scale: scale, roll: roll);
  }
}

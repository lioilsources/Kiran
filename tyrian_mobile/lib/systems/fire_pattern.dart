import 'dart:math';

import '../entities/hostile.dart';

/// How a fleet's shots leave its ships. Until this existed every enemy in the
/// game fired the same thing — one bubble straight down — and the twelve
/// hostile types differed only in HP. This is the roadmap's Tier 1 item 2:
/// variety in what comes *at* the player, which is where a shmup's feel
/// actually lives.
///
/// Patterns change the *shape* of fire only. Damage, cadence and projectile
/// size still come from `Fleet.addWeapon`, so the VB6 numbers and the
/// challenge multipliers apply unchanged.
enum FirePattern {
  /// One shot straight down. The VB6 behaviour and the only one until now.
  straight,

  /// One shot at the nearest vessel.
  aimed,

  /// Three shots in a fan: left, centre, right.
  spread,

  /// Three straight shots a few frames apart.
  burst,

  /// Every living ship in the fleet fires at once, at a slower cadence —
  /// a wall rather than a shot. Not a default for any type; authored only.
  volley;

  /// Frames between the shots of a [burst].
  static const int burstGap = 6;

  /// Cadence multiplier for [volley]: the whole fleet fires, so less often.
  static const double volleyCadence = 1.6;

  /// Horizontal speed of the outer [spread] shots (px/frame, like the boss).
  static const double spreadVx = 5.0;

  /// Default by hostile tier, so authored parts and random sectors both get
  /// variety without touching every `addWeapon` call: basic fighters still
  /// fire straight, the medium tier aims, heavies fan out, bosses burst.
  /// Deterministic on purpose — random sectors reproduce from a seed, and an
  /// extra RNG draw here would reshuffle every fleet after it.
  static FirePattern defaultFor(HostType type) {
    switch (type) {
      case HostType.falcon1:
      case HostType.falcon2:
      case HostType.falcon3:
        return straight;
      case HostType.falcon4:
      case HostType.falcon5:
      case HostType.falcon6:
        return aimed;
      case HostType.falconx:
      case HostType.bouncer:
        return spread;
      case HostType.falconx2:
      case HostType.falconx3:
      case HostType.falconxb:
      case HostType.falconxt:
        return burst;
    }
  }

  /// Velocity (vx, vy) of a shot of [speed] aimed from the shooter at the
  /// target, both in px/frame. The vertical component is kept at least
  /// [minDown] so a shot never stalls or crawls when the target sits level
  /// with the shooter — it still has to leave the screen.
  static (double, double) aim(double dx, double dy, double speed,
      {double minDown = 6.0}) {
    final len = sqrt(dx * dx + dy * dy);
    if (len < 1e-6) return (0, speed);
    var vx = speed * dx / len;
    var vy = speed * dy / len;
    if (vy < minDown) {
      vy = minDown;
      // Re-normalise so the shot keeps its speed rather than gaining it.
      final rest = sqrt(max(speed * speed - vy * vy, 0));
      vx = vx.sign * min(vx.abs(), rest);
    }
    return (vx, vy);
  }
}

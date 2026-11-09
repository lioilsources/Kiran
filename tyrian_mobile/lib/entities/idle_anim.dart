import 'dart:math';

/// The frames a creature boss flips between. [open] is the resting pose.
enum IdleFrame { open, blink, twitchL, twitchR }

/// Schedules a living boss's idle loop: long stretches of the resting pose,
/// broken at irregular intervals by a blink or a twitch to one side, each held
/// for a split second. A hit twitches it at once, so a shot reads as a flinch.
///
/// Pure timing, no assets: the caller maps the returned [IdleFrame] to a sprite.
class IdleAnimator {
  IdleAnimator({Random? rng}) : _rng = rng ?? Random();

  final Random _rng;
  double _until = 1.5; // seconds to the next beat
  double _hold = 0; // seconds left on the current non-resting frame

  IdleFrame frame = IdleFrame.open;

  static const blinkHold = 0.14;
  static const twitchHold = 0.11;

  IdleFrame step(double dt, {bool struck = false}) {
    if (_hold > 0) {
      _hold -= dt;
      if (_hold <= 0) {
        frame = IdleFrame.open;
        _until = 0.9 + _rng.nextDouble() * 2.6;
      }
      return frame;
    }
    _until -= dt;
    if (struck || _until <= 0) {
      final twitch = struck || _rng.nextBool();
      frame = twitch
          ? (_rng.nextBool() ? IdleFrame.twitchL : IdleFrame.twitchR)
          : IdleFrame.blink;
      _hold = twitch ? twitchHold : blinkHold;
    }
    return frame;
  }
}

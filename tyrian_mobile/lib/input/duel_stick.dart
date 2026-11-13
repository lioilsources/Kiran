import 'dart:math' as math;

import '../game/game_config.dart' as config;
import 'pad_scheme.dart';

/// What the right stick is doing in a duel (Prompts/30 §6.3).
enum StickRole {
  /// It turns the nose, and past the fire zone it fires.
  aim,

  /// A stance opened with the stick out: nothing until it passes the centre,
  /// so the nose does not jerk and no stroke starts mid-air.
  latch,

  /// It draws a sigil, in the frame frozen when the stance opened.
  draw,

  /// The stance closed with the stick out: nothing until it is back in the
  /// centre, then it aims again.
  settle,

  /// Both shoulders: MEGA BLAST is charging and the stick aims it.
  mega,
}

/// One frame of the right stick's role.
class DuelStickFrame {
  const DuelStickFrame({
    required this.role,
    this.aimX,
    this.aimY,
    this.aimFire = false,
    this.feed = false,
    this.stanceOpened = false,
    this.stance = false,
  });

  final StickRole role;

  /// Unit stick direction, screen space, when it points the nose this frame.
  final double? aimX, aimY;

  /// Aiming far enough to fire.
  final bool aimFire;

  /// Hand the stick to the sigil caster this frame; otherwise it gets the
  /// stick at rest, which also closes a stroke left open.
  final bool feed;

  /// A stance began this frame: freeze the frame strokes are read in.
  final bool stanceOpened;

  /// Something that opens a stance is held.
  final bool stance;

  bool get aiming => aimX != null;
}

/// The right stick's state machine in a duel. Pure, no Flame: one call per
/// frame with the raw pad, one [DuelStickFrame] back.
///
/// The rule for the player is one sentence: the stick aims; while something
/// is held, it draws. Every role change happens with the stick in the
/// centre, which is where a stroke starts anyway.
class DuelStick {
  DuelStick({this.binding = DuelBinding.rtStance, this.aimFires = true});

  DuelBinding binding;
  bool aimFires;

  StickRole role = StickRole.aim;
  bool _hull = false;

  void reset() {
    role = StickRole.aim;
    _hull = false;
  }

  /// [sx], [sy]: the right stick raw, screen space. [rt], [lt]: trigger
  /// depths 0..1. [arms], [wing]: the shoulders.
  DuelStickFrame step(double sx, double sy,
      {double rt = 0, double lt = 0, bool arms = false, bool wing = false}) {
    final t = binding == DuelBinding.rtStance ? rt : lt;
    _hull = _hull ? t > config.duelStanceOff : t >= config.duelStanceOn;
    final stance = _hull || arms || wing;
    final chord = arms && wing;
    final m = math.sqrt(sx * sx + sy * sy);
    final centred = m < config.sigilCenterEnter;

    var opened = false;
    switch (role) {
      case StickRole.aim:
        if (chord) {
          role = StickRole.mega;
        } else if (stance) {
          opened = true;
          role = centred ? StickRole.draw : StickRole.latch;
        }
      case StickRole.latch:
        if (chord) {
          role = StickRole.mega;
        } else if (!stance) {
          // A short squeeze while aiming changes nothing.
          role = StickRole.aim;
        } else if (centred) {
          role = StickRole.draw;
        }
      case StickRole.draw:
        if (chord) {
          role = StickRole.mega;
        } else if (!stance) {
          role = centred ? StickRole.aim : StickRole.settle;
        }
      case StickRole.settle:
        if (chord) {
          role = StickRole.mega;
        } else if (centred) {
          if (stance) {
            opened = true;
            role = StickRole.draw;
          } else {
            role = StickRole.aim;
          }
        }
      case StickRole.mega:
        if (!chord) {
          // The beam went where the stick pointed; the nose is already there.
          if (stance) {
            opened = true;
            role = centred ? StickRole.draw : StickRole.latch;
          } else {
            role = StickRole.aim;
          }
        }
    }

    final points = (role == StickRole.aim || role == StickRole.mega) &&
        m > config.duelAimDeadzone;
    return DuelStickFrame(
      role: role,
      aimX: points ? sx / m : null,
      aimY: points ? sy / m : null,
      aimFire: role == StickRole.aim && aimFires && m > config.duelAimFireZone,
      feed: role == StickRole.draw || role == StickRole.mega,
      stanceOpened: opened,
      stance: stance,
    );
  }
}

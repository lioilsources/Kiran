import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

import 'gamepad_input.dart';

/// Which button does what (Prompts/28 §3). Every binding of the pad lives in
/// this file: moving MEGA BLAST to the triggers or swapping the shoulders is
/// a change here, not a hunt through the game.
enum PadScheme {
  /// The pre-sigil pad, unchanged: B, RB or RT fire, nothing else is bound.
  classic,

  /// Left stick flies, right stick draws sigils, the shoulders pick the layer.
  sigil,
}

/// The player's pad settings, loaded once at startup.
abstract final class PadSettings {
  static PadScheme scheme = PadScheme.sigil;

  /// Left-handed: the sticks, the triggers and the shoulders swap sides.
  static bool southpaw = false;

  static const _keyScheme = 'pad_scheme';
  static const _keySouthpaw = 'pad_southpaw';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    scheme = PadScheme.values.firstWhere(
        (s) => s.name == prefs.getString(_keyScheme),
        orElse: () => PadScheme.sigil);
    southpaw = prefs.getBool(_keySouthpaw) ?? false;
  }

  static Future<void> setScheme(PadScheme s) async {
    scheme = s;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyScheme, s.name);
  }

  static Future<void> setSouthpaw(bool v) async {
    southpaw = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySouthpaw, v);
  }
}

/// One frame of pad intent, in screen space (x right, y down), after the
/// scheme and the southpaw swap. The game turns the sticks into ship space.
class PadFrame {
  /// Movement: left stick past its deadzone plus the d-pad, at most 1 long.
  final double moveX, moveY;

  /// The sigil stick, raw (the recogniser has its own zones).
  final double drawX, drawY;
  final bool fire;

  /// 0..1 cadence from the fire trigger; digital fire is 1.
  final double fireRate;

  /// OVERSTREAM pedal, 0..1.
  final double stream;

  /// Layer modifiers: ARMS and WING. Both held is MEGA BLAST.
  final bool arms, wing;
  final bool focus;
  final bool breakSigil;
  final bool swap;
  final bool grimoireSet;
  final bool grimoire;
  final bool pause;

  const PadFrame({
    this.moveX = 0,
    this.moveY = 0,
    this.drawX = 0,
    this.drawY = 0,
    this.fire = false,
    this.fireRate = 1,
    this.stream = 0,
    this.arms = false,
    this.wing = false,
    this.focus = false,
    this.breakSigil = false,
    this.swap = false,
    this.grimoireSet = false,
    this.grimoire = false,
    this.pause = false,
  });

  static const idle = PadFrame();

  /// Anything that should count as the pad being in use this frame.
  bool get active =>
      moveX != 0 ||
      moveY != 0 ||
      fire ||
      drawX * drawX + drawY * drawY > 0.09 ||
      arms ||
      wing ||
      stream > 0.05;

  /// Read [gp] through [scheme].
  factory PadFrame.read(GamepadState gp,
      {PadScheme scheme = PadScheme.sigil, bool southpaw = false}) {
    var mx = GamepadInput.deadzone(gp.leftStickX);
    var my = GamepadInput.deadzone(gp.leftStickY);
    var dx = gp.rightStickX, dy = gp.rightStickY;
    var fireT = gp.rightTrigger, streamT = gp.leftTrigger;
    var lb = gp.leftShoulder, rb = gp.rightShoulder;
    if (southpaw) {
      mx = GamepadInput.deadzone(gp.rightStickX);
      my = GamepadInput.deadzone(gp.rightStickY);
      dx = gp.leftStickX;
      dy = gp.leftStickY;
      (fireT, streamT) = (streamT, fireT);
      (lb, rb) = (rb, lb);
    }
    // The d-pad adds to the stick, for players who fly digitally.
    if (gp.dpadLeft) mx -= 1;
    if (gp.dpadRight) mx += 1;
    if (gp.dpadUp) my -= 1;
    if (gp.dpadDown) my += 1;
    final l2 = mx * mx + my * my;
    if (l2 > 1) {
      final l = math.sqrt(l2);
      mx /= l;
      my /= l;
    }

    if (scheme == PadScheme.classic) {
      return PadFrame(
        moveX: mx,
        moveY: my,
        fire: gp.fire,
        fireRate: gp.fireRate,
        pause: gp.pause,
      );
    }
    return PadFrame(
      moveX: mx,
      moveY: my,
      drawX: dx,
      drawY: dy,
      fire: fireT > 0.05,
      fireRate: fireT,
      stream: streamT,
      arms: lb,
      wing: rb,
      focus: gp.buttonA,
      breakSigil: gp.buttonB,
      swap: gp.buttonY,
      grimoireSet: gp.buttonX,
      grimoire: gp.back,
      pause: gp.pause,
    );
  }
}

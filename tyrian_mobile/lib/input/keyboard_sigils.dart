import 'package:flutter/services.dart';

import '../entities/ship_frame.dart';
import '../game/platform_config.dart' as platform;
import '../systems/sigils/sigil_grid.dart';
import '../systems/sigils/sigil_spec.dart';
import 'bindings.dart';
import 'keyboard_input.dart';
import 'pad_scheme.dart';

/// Sigils from the keyboard (Prompts/28 §12): the numpad is the circle as
/// seen on screen (8 is up, 5 the centre), and so is the U I O / J K L /
/// M , . block for keyboards without one. Dots are typed one after another;
/// the drawing ends a moment after the last key.
class KeyboardSigils {
  /// Seconds after the last dot that end the drawing.
  static const double settle = 0.3;

  static final Map<PhysicalKeyboardKey, (int, int)> _keys = {
    PhysicalKeyboardKey.numpad7: (-1, -1),
    PhysicalKeyboardKey.numpad8: (0, -1),
    PhysicalKeyboardKey.numpad9: (1, -1),
    PhysicalKeyboardKey.numpad4: (-1, 0),
    PhysicalKeyboardKey.numpad5: (0, 0),
    PhysicalKeyboardKey.numpad6: (1, 0),
    PhysicalKeyboardKey.numpad1: (-1, 1),
    PhysicalKeyboardKey.numpad2: (0, 1),
    PhysicalKeyboardKey.numpad3: (1, 1),
    PhysicalKeyboardKey.keyU: (-1, -1),
    PhysicalKeyboardKey.keyI: (0, -1),
    PhysicalKeyboardKey.keyO: (1, -1),
    PhysicalKeyboardKey.keyJ: (-1, 0),
    PhysicalKeyboardKey.keyK: (0, 0),
    PhysicalKeyboardKey.keyL: (1, 0),
    PhysicalKeyboardKey.keyM: (-1, 1),
    PhysicalKeyboardKey.comma: (0, 1),
    PhysicalKeyboardKey.period: (1, 1),
  };

  final List<int> _dots = [];
  SigilLayer _layer = SigilLayer.hull;
  double _idle = 0;
  double _time = 0;

  /// OVERSTREAM gear set with Q and E, 1..3.
  int gear = 1;

  /// The dot a key stands for, in ship space. [frame] is the pad's frame in
  /// a duel (Prompts/30 §6.6): the keys stay the circle as seen on screen,
  /// read the way the turned pad is.
  static int? dotFor(PhysicalKeyboardKey k, {bool? landscape, ShipFrame? frame}) {
    final d = _keys[k];
    if (d == null) return null;
    if (d.$1 == 0 && d.$2 == 0) return 4;
    var (gx, gy) =
        platform.screenToGame(d.$1.toDouble(), d.$2.toDouble(), landscape: landscape);
    if (frame != null) (gx, gy) = frame.toShip(gx, gy);
    return SigilGrid.rimDotFor(gx, gy);
  }

  /// This frame's keys. Returns a finished drawing once the keys settle.
  (List<int>, SigilLayer, double)? update(KeyboardInput kb, double dt,
      {ShipFrame? frame}) {
    for (final k in kb.takePresses()) {
      if (Bindings.keysFor(InputAction.streamDown).contains(k)) {
        gear = (gear - 1).clamp(1, 3);
      }
      if (Bindings.keysFor(InputAction.streamUp).contains(k)) {
        gear = (gear + 1).clamp(1, 3);
      }
      final dot = dotFor(k, frame: frame);
      if (dot == null) continue;
      if (_dots.isEmpty) {
        _layer = kb.action(InputAction.arms)
            ? SigilLayer.arms
            : (kb.action(InputAction.wing) ? SigilLayer.wing : SigilLayer.hull);
        _time = 0;
      }
      if (_dots.isEmpty || _dots.last != dot) _dots.add(dot);
      _idle = 0;
    }
    if (_dots.isEmpty) return null;
    _time += dt;
    _idle += dt;
    if (_idle < settle) return null;
    final dots = List.of(_dots);
    _dots.clear();
    while (dots.isNotEmpty && dots.first == 4) {
      dots.removeAt(0);
    }
    while (dots.isNotEmpty && dots.last == 4) {
      dots.removeLast();
    }
    if (dots.isEmpty) return null;
    return (dots, _layer, _time - _idle);
  }

  /// The rest of the keyboard as pad intent ([Bindings]): Shift = ARMS, Ctrl = WING (both
  /// = MEGA BLAST), Alt = FOCUS, F = BREAK, R = swap, Tab = grimoire.
  PadFrame frame(KeyboardInput kb) => PadFrame(
        arms: kb.action(InputAction.arms),
        wing: kb.action(InputAction.wing),
        focus: kb.action(InputAction.focus),
        breakSigil: kb.action(InputAction.breakSigil),
        swap: kb.action(InputAction.swap),
        grimoire: kb.action(InputAction.grimoire),
        stream: gear == 3 ? 1.0 : (gear == 2 ? 0.5 : 0.0),
      );
}

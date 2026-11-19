import 'package:flutter/services.dart';

import 'bindings.dart';

/// Tracks pressed keys for desktop keyboard input. Keys are tracked by
/// their physical place (Prompts/36 G5); [Bindings] says what each does.
class KeyboardInput {
  final Set<PhysicalKeyboardKey> _pressed = {};

  /// Fresh presses (no repeats) since the last [takePresses], in order —
  /// the keyboard's sigil dots are typed, not held.
  final List<PhysicalKeyboardKey> _presses = [];

  /// What each physical key last typed, for the hints (Prompts/36 §3.2).
  final Map<PhysicalKeyboardKey, LogicalKeyboardKey> _labels = {};

  /// Call from KeyboardHandler.onKeyEvent
  bool handleKeyEvent(KeyEvent event) {
    final k = event.physicalKey;
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      _pressed.add(k);
      _labels[k] = event.logicalKey;
      if (event is KeyDownEvent) _presses.add(k);
    } else if (event is KeyUpEvent) {
      _pressed.remove(k);
    }
    return false; // don't consume — let Flutter handle too
  }

  /// Forget every key, as when the window loses focus mid-press and the
  /// key-up never arrives.
  void clear() {
    _pressed.clear();
    _presses.clear();
  }

  bool isPressed(PhysicalKeyboardKey k) => _pressed.contains(k);

  /// Any key bound to [a] is down.
  bool action(InputAction a) => Bindings.keysFor(a).any(_pressed.contains);

  /// [a] was freshly pressed in [presses].
  static bool pressedIn(List<PhysicalKeyboardKey> presses, InputAction a) =>
      Bindings.keysFor(a).any(presses.contains);

  List<PhysicalKeyboardKey> takePresses() {
    final out = List.of(_presses);
    _presses.clear();
    return out;
  }

  /// The label [k] carries on this keyboard, once it has been pressed.
  LogicalKeyboardKey? labelOf(PhysicalKeyboardKey k) => _labels[k];

  double _axis(InputAction neg, InputAction pos) =>
      (action(pos) ? 1.0 : 0.0) - (action(neg) ? 1.0 : 0.0);

  /// WASD alone: in a duel the arrows aim instead (Prompts/30 §6.6).
  double get wasdX => _axis(InputAction.moveLeft, InputAction.moveRight);
  double get wasdY => _axis(InputAction.moveUp, InputAction.moveDown);

  /// The arrows alone, screen space.
  double get arrowX => _axis(InputAction.aimLeft, InputAction.aimRight);
  double get arrowY => _axis(InputAction.aimUp, InputAction.aimDown);

  /// Horizontal axis in flight, WASD or the arrows: -1 left to +1 right.
  double get dx => (wasdX + arrowX).clamp(-1.0, 1.0);

  /// Vertical axis in flight: -1 up to +1 down.
  double get dy => (wasdY + arrowY).clamp(-1.0, 1.0);

  /// Any key at all is down.
  bool get anyKey => _pressed.isNotEmpty;

  bool get fire => action(InputAction.fire);
  bool get pause => action(InputAction.pause);

  /// True if any movement or action key is pressed.
  bool get hasInput => dx != 0 || dy != 0 || fire;
}

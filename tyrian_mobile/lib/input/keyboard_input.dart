import 'package:flutter/services.dart';

/// Tracks pressed keys for desktop keyboard input.
class KeyboardInput {
  final Set<LogicalKeyboardKey> _pressed = {};

  /// Fresh presses (no repeats) since the last [takePresses], in order —
  /// the keyboard's sigil dots are typed, not held.
  final List<LogicalKeyboardKey> _presses = [];

  /// Call from KeyboardHandler.onKeyEvent
  bool handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      _pressed.add(event.logicalKey);
      if (event is KeyDownEvent) _presses.add(event.logicalKey);
    } else if (event is KeyUpEvent) {
      _pressed.remove(event.logicalKey);
    }
    return false; // don't consume — let Flutter handle too
  }

  bool isPressed(LogicalKeyboardKey k) => _pressed.contains(k);

  /// Any of [keys] is down.
  bool anyPressed(Iterable<LogicalKeyboardKey> keys) => keys.any(_pressed.contains);

  List<LogicalKeyboardKey> takePresses() {
    final out = List.of(_presses);
    _presses.clear();
    return out;
  }

  /// Horizontal axis: -1 (left/A) to +1 (right/D)
  double get dx {
    double v = 0;
    if (_pressed.contains(LogicalKeyboardKey.keyA) ||
        _pressed.contains(LogicalKeyboardKey.arrowLeft)) v -= 1;
    if (_pressed.contains(LogicalKeyboardKey.keyD) ||
        _pressed.contains(LogicalKeyboardKey.arrowRight)) v += 1;
    return v;
  }

  /// Vertical axis: -1 (up/W) to +1 (down/S)
  double get dy {
    double v = 0;
    if (_pressed.contains(LogicalKeyboardKey.keyW) ||
        _pressed.contains(LogicalKeyboardKey.arrowUp)) v -= 1;
    if (_pressed.contains(LogicalKeyboardKey.keyS) ||
        _pressed.contains(LogicalKeyboardKey.arrowDown)) v += 1;
    return v;
  }

  /// WASD alone: in a duel the arrows aim instead (Prompts/30 §6.6).
  double get wasdX =>
      (_pressed.contains(LogicalKeyboardKey.keyD) ? 1.0 : 0.0) -
      (_pressed.contains(LogicalKeyboardKey.keyA) ? 1.0 : 0.0);
  double get wasdY =>
      (_pressed.contains(LogicalKeyboardKey.keyS) ? 1.0 : 0.0) -
      (_pressed.contains(LogicalKeyboardKey.keyW) ? 1.0 : 0.0);

  /// The arrows alone, screen space.
  double get arrowX =>
      (_pressed.contains(LogicalKeyboardKey.arrowRight) ? 1.0 : 0.0) -
      (_pressed.contains(LogicalKeyboardKey.arrowLeft) ? 1.0 : 0.0);
  double get arrowY =>
      (_pressed.contains(LogicalKeyboardKey.arrowDown) ? 1.0 : 0.0) -
      (_pressed.contains(LogicalKeyboardKey.arrowUp) ? 1.0 : 0.0);

  /// Any key at all is down.
  bool get anyKey => _pressed.isNotEmpty;

  bool get fire => _pressed.contains(LogicalKeyboardKey.space);
  bool get pause => _pressed.contains(LogicalKeyboardKey.escape);

  /// True if any movement or action key is pressed.
  bool get hasInput => dx != 0 || dy != 0 || fire;
}

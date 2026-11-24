import 'package:flutter/gestures.dart'
    show kMiddleMouseButton, kPrimaryMouseButton, kSecondaryMouseButton;
import 'package:flutter/services.dart';

/// What a key or a mouse button does in flight (Prompts/36 §3.2). The menus
/// keep their own fixed keys; these are the game's.
enum InputAction {
  /// WASD: flies, in flight and in a duel.
  moveUp,
  moveDown,
  moveLeft,
  moveRight,

  /// The arrows: fly in flight, aim in a duel (Prompts/30 §6.6).
  aimUp,
  aimDown,
  aimLeft,
  aimRight,

  fire,

  /// The classic scheme's second weapon set, held (plan 34 for the keys).
  alternate,

  // The sigil scheme (Prompts/28 §12).
  arms,
  wing,
  focus,
  breakSigil,
  swap,
  streamDown,
  streamUp,
  grimoire,

  pause,
}

/// A mouse button, as [PointerEvent.buttons] has it.
enum MouseButton {
  left(kPrimaryMouseButton),
  right(kSecondaryMouseButton),
  middle(kMiddleMouseButton);

  const MouseButton(this.mask);
  final int mask;
}

/// Which keys and buttons fire which action. Keys are physical: the place
/// on the keyboard, not the letter printed on it, so WASD sits under the
/// left hand on AZERTY and QWERTZ too (Prompts/36 G5).
///
/// Fixed defaults for now; the controls screen (Prompts/36 phase 4) will
/// store the player's own.
abstract final class Bindings {
  static const Map<InputAction, List<PhysicalKeyboardKey>> defaultKeys = {
    InputAction.moveUp: [PhysicalKeyboardKey.keyW],
    InputAction.moveDown: [PhysicalKeyboardKey.keyS],
    InputAction.moveLeft: [PhysicalKeyboardKey.keyA],
    InputAction.moveRight: [PhysicalKeyboardKey.keyD],
    InputAction.aimUp: [PhysicalKeyboardKey.arrowUp],
    InputAction.aimDown: [PhysicalKeyboardKey.arrowDown],
    InputAction.aimLeft: [PhysicalKeyboardKey.arrowLeft],
    InputAction.aimRight: [PhysicalKeyboardKey.arrowRight],
    InputAction.fire: [PhysicalKeyboardKey.space],
    InputAction.alternate: [
      PhysicalKeyboardKey.shiftLeft,
      PhysicalKeyboardKey.shiftRight,
    ],
    InputAction.arms: [
      PhysicalKeyboardKey.shiftLeft,
      PhysicalKeyboardKey.shiftRight,
    ],
    InputAction.wing: [
      PhysicalKeyboardKey.controlLeft,
      PhysicalKeyboardKey.controlRight,
    ],
    InputAction.focus: [
      PhysicalKeyboardKey.altLeft,
      PhysicalKeyboardKey.altRight,
    ],
    InputAction.breakSigil: [PhysicalKeyboardKey.keyF],
    InputAction.swap: [PhysicalKeyboardKey.keyR],
    InputAction.streamDown: [PhysicalKeyboardKey.keyQ],
    InputAction.streamUp: [PhysicalKeyboardKey.keyE],
    InputAction.grimoire: [PhysicalKeyboardKey.tab],
    InputAction.pause: [PhysicalKeyboardKey.escape],
  };

  static const Map<InputAction, List<MouseButton>> defaultButtons = {
    InputAction.fire: [MouseButton.left],
    InputAction.alternate: [MouseButton.right],
  };

  static Map<InputAction, List<PhysicalKeyboardKey>> keys = defaultKeys;
  static Map<InputAction, List<MouseButton>> buttons = defaultButtons;

  static List<PhysicalKeyboardKey> keysFor(InputAction a) =>
      keys[a] ?? const [];
  static List<MouseButton> buttonsFor(InputAction a) => buttons[a] ?? const [];
}

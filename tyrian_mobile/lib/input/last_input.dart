import 'package:flutter/foundation.dart';

import '../game/platform_config.dart' as platform;

/// What the player holds in their hands (Prompts/36 §3.7).
enum InputDevice { touch, keyboardMouse, pad }

/// The device used last — not the one plugged in. A pad left on the desk
/// says nothing; a key, a mouse move, a stick or a finger does. The hints
/// read this, so they speak of what the player is actually using.
abstract final class LastInput {
  static final ValueNotifier<InputDevice> device = ValueNotifier(
      platform.isDesktop ? InputDevice.keyboardMouse : InputDevice.touch);

  static void use(InputDevice d) {
    if (device.value != d) device.value = d;
  }

  static bool get pad => device.value == InputDevice.pad;
  static bool get keyboardMouse => device.value == InputDevice.keyboardMouse;
}

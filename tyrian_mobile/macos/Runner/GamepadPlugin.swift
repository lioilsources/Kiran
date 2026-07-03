import Cocoa
import FlutterMacOS
import GameController

/// Native macOS gamepad bridge for the `com.tyrian/gamepad` MethodChannel.
///
/// Mirrors the Windows XInput plugin (`windows/runner/gamepad_plugin.cpp`):
/// the `poll` method returns a list of controller-state maps keyed exactly
/// the way Dart's `GamepadState.fromMap` expects. macOS reads controllers via
/// Apple's GameController framework (Xbox / DualShock / DualSense / MFi).
final class GamepadPlugin: NSObject {
  private let channel: FlutterMethodChannel

  init(messenger: FlutterBinaryMessenger) {
    channel = FlutterMethodChannel(
      name: "com.tyrian/gamepad", binaryMessenger: messenger)
    super.init()
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
    // Pick up controllers put into pairing mode after launch. Already-paired
    // Bluetooth / wired controllers show up in `controllers()` on their own.
    GCController.startWirelessControllerDiscovery(completionHandler: nil)
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "poll" else {
      result(FlutterMethodNotImplemented)
      return
    }

    var controllers: [[String: Any]] = []
    for controller in GCController.controllers() {
      guard let gp = controller.extendedGamepad else { continue }

      // GameController thumbstick Y is +up; the game wants +down (screen
      // space), matching the Windows plugin which negates Y as well.
      var pad: [String: Any] = [
        "lx": Double(gp.leftThumbstick.xAxis.value),
        "ly": Double(-gp.leftThumbstick.yAxis.value),
        "rx": Double(gp.rightThumbstick.xAxis.value),
        "ry": Double(-gp.rightThumbstick.yAxis.value),
        "a": gp.buttonA.isPressed,
        "b": gp.buttonB.isPressed,
        "x": gp.buttonX.isPressed,
        "y": gp.buttonY.isPressed,
        "lb": gp.leftShoulder.isPressed,
        "rb": gp.rightShoulder.isPressed,
        "lt": Double(gp.leftTrigger.value),
        "rt": Double(gp.rightTrigger.value),
        "du": gp.dpad.up.isPressed,
        "dd": gp.dpad.down.isPressed,
        "dl": gp.dpad.left.isPressed,
        "dr": gp.dpad.right.isPressed,
        "start": gp.buttonMenu.isPressed,
        "back": false,
      ]
      // `buttonOptions` (Share / View / Create) is optional on some pads.
      if let options = gp.buttonOptions {
        pad["back"] = options.isPressed
      }
      controllers.append(pad)
    }

    result(controllers)
  }
}

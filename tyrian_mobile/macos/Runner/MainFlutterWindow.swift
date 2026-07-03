import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  // Retained for the lifetime of the window so its MethodChannel stays alive.
  private var gamepadPlugin: GamepadPlugin?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let registrar = flutterViewController.registrar(forPlugin: "GamepadPlugin")
    gamepadPlugin = GamepadPlugin(messenger: registrar.messenger)

    super.awakeFromNib()
  }
}

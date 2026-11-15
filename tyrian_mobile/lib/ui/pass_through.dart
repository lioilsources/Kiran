import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// An overlay the finger flies through: a touch on it reaches whatever lies
/// below (the game), unless it lands on something that takes taps — a
/// [GestureDetector] or another [Listener] inside. The HUD uses it, so a
/// drag may start anywhere over the bars and still steer the ship.
class PassThrough extends SingleChildRenderObjectWidget {
  const PassThrough({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderPassThrough();
}

class RenderPassThrough extends RenderProxyBox {
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    // Probe first: text, bars and backdrops all report a hit, which would
    // stop the touch here. Only a hit on a pointer listener counts.
    final probe = BoxHitTestResult();
    if (!super.hitTest(probe, position: position)) return false;
    if (!probe.path.any((e) => e.target is RenderPointerListener)) {
      return false;
    }
    return super.hitTest(result, position: position);
  }
}

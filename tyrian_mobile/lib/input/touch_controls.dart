import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'touch_fingers.dart';

/// The touch flight controls (plan 32 Q3), as a mixin so a test can drive
/// them through Flame's real tap and drag dispatch. The game supplies what a
/// finger does to the ship; the mixin decides which finger does it.
mixin TouchControls on FlameGame, DragCallbacks, TapCallbacks {
  /// Primary finger vs. swap fingers. Only the primary moves the ship and
  /// holds the fire.
  final TouchFingers touchFingers = TouchFingers();

  // Delta-based, so finger and vessel move in sync.
  Vector2? _prevDragPos;

  /// The touch flies the ship now.
  bool get touchFlies;

  /// The weapon swap may run now.
  bool get touchSwaps;

  /// Move the ship by a finger's [canvasDelta], in canvas pixels.
  void touchSteer(Vector2 canvasDelta);

  /// The primary finger tapped: toggle the fire.
  void touchToggleFire();

  void touchSetFire(bool on);

  /// A second finger landed while the first is held.
  void touchSwap();

  /// Once a frame.
  void touchTick(double dt) => touchFingers.flush();

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final finger = touchFingers.down(event.pointerId);
    if (!touchFlies) return;
    if (!finger.primary) {
      if (finger.landed && touchSwaps) touchSwap();
      return;
    }
    _prevDragPos = event.canvasPosition.clone();
    touchSetFire(true);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!touchFlies || _prevDragPos == null) return;
    if (!touchFingers.isPrimary(event.pointerId)) return;
    final pos = event.canvasEndPosition;
    final delta = pos - _prevDragPos!;
    _prevDragPos = pos.clone();
    touchSteer(delta);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    final primary = touchFingers.isPrimary(event.pointerId);
    touchFingers.up(event.pointerId);
    // A swap finger lifting leaves the ship and its fire alone.
    if (!primary) return;
    if (!touchFlies) return;
    _prevDragPos = null;
    touchSetFire(false);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    final finger = touchFingers.down(event.pointerId);
    if (!touchFlies) return;
    if (!finger.primary) {
      if (finger.landed && touchSwaps) touchSwap();
      return;
    }
    touchToggleFire();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    touchFingers.up(event.pointerId);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    super.onTapCancel(event);
    touchFingers.tapCancelled(event.pointerId);
  }
}

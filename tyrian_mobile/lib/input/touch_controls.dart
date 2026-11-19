import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind;

import '../game/game_config.dart' as config;
import 'touch_fingers.dart';

/// The touch flight controls (plan 34), as a mixin so a test can drive them
/// through Flame's real tap and drag dispatch. The game supplies what a
/// finger does to the ship; the mixin decides which finger does it.
///
/// - One finger flies the ship and fires the first weapon set, as ever: a
///   lone tap toggles the fire, a drag holds it.
/// - Two or more fingers on the screen fire the second set at once.
/// - Back to a single finger for [config.touchAltRelease], the first set
///   returns. No finger at all changes nothing.
/// - Only the oldest moving finger steers, by its own moves. When it lifts,
///   the next one takes over from where it is, so the ship does not jump.
mixin TouchControls on FlameGame, DragCallbacks, TapCallbacks {
  final TouchFingers touchFingers = TouchFingers();

  /// How long a single finger has been on the screen with the second set
  /// still fitted.
  double _oneFinger = 0;

  /// The touch flies the ship now.
  bool get touchFlies;

  /// The second set may fly now (solo or host, playing, no duel).
  bool get touchSwaps;

  /// Move the ship by the steering finger's [canvasDelta], in canvas pixels.
  void touchSteer(Vector2 canvasDelta);

  /// A finger landed on an empty screen: toggle the fire.
  void touchToggleFire();

  void touchSetFire(bool on);

  /// Whether the second set is fitted.
  bool get touchAlternate;

  /// Fit the second set ([on]) or the first. [announce] says whether to
  /// show what flies now.
  void touchSetAlternate(bool on, {required bool announce});

  /// Once a frame, from the game's update: the one place the finger count
  /// is read.
  void touchTick(double dt) {
    if (!touchSwaps) {
      _oneFinger = 0;
      if (touchAlternate) touchSetAlternate(false, announce: false);
      return;
    }
    final n = touchFingers.count;
    if (n >= 2) {
      _oneFinger = 0;
      if (!touchAlternate) touchSetAlternate(true, announce: true);
      return;
    }
    if (n == 1 && touchAlternate) {
      _oneFinger += dt;
      if (_oneFinger >= config.touchAltRelease) {
        _oneFinger = 0;
        touchSetAlternate(false, announce: true);
      }
      return;
    }
    _oneFinger = 0;
  }

  /// Leave the mouse alone: on desktop it has its own controls
  /// (Prompts/36 §3.3) and only real touch is a finger here.
  bool get touchIgnoresMouse => false;

  // Pointers that turned out to be a mouse, by Flame's two id series (taps
  // and drags count apart, plan 34 §1): their later events are skipped too.
  final Set<int> _mouseTaps = {};
  final Set<int> _mouseDrags = {};

  /// A mouse button is down right now. Flame's drag start carries no
  /// device kind (its `FlameDragAdapter` builds the details without one, so
  /// it always reads `unknown`); a drag that begins under a held mouse
  /// button is the mouse's. Raw pointer events reach the game's mouse
  /// before the gesture arena starts the drag, so this is already true.
  bool get touchMouseHeld => false;

  bool _isMouse(PointerDeviceKind kind) =>
      touchIgnoresMouse &&
      (kind == PointerDeviceKind.mouse || touchMouseHeld);

  /// Forget every finger, at the start of a sector.
  void touchReset() {
    touchFingers.clear();
    _mouseTaps.clear();
    _mouseDrags.clear();
    _oneFinger = 0;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (_isMouse(event.deviceKind)) {
      _mouseTaps.add(event.pointerId);
      return;
    }
    final first = touchFingers.count == 0;
    touchFingers.tapDown(event.pointerId);
    // Only a finger landing on an empty screen toggles the fire: a second
    // finger's tap is the second set, not a trigger.
    if (first && touchFlies) touchToggleFire();
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (_mouseTaps.remove(event.pointerId)) return;
    touchFingers.tapUp(event.pointerId);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    super.onTapCancel(event);
    if (_mouseTaps.remove(event.pointerId)) return;
    touchFingers.tapUp(event.pointerId);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_isMouse(event.deviceKind)) {
      _mouseDrags.add(event.pointerId);
      return;
    }
    touchFingers.dragStart(event.pointerId);
    if (touchFlies) touchSetFire(true);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (_mouseDrags.contains(event.pointerId)) return;
    if (!touchFlies || touchFingers.steering != event.pointerId) return;
    // The update's own delta, so finger and vessel move in sync. (Not the
    // difference of end positions: Flame adds the delta to a position that
    // already includes it, so that difference runs a move ahead.)
    touchSteer(event.canvasDelta);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_mouseDrags.remove(event.pointerId)) return;
    touchFingers.dragEnd(event.pointerId);
    // The fire holds while any finger still moves.
    if (touchFlies && !touchFingers.dragging) touchSetFire(false);
  }
}

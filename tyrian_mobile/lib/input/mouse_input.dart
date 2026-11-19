import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'bindings.dart';

/// The desktop mouse (Prompts/36 §3.3), read once a frame like the keyboard.
///
/// Fed by [MouseFeed] from raw pointer events rather than Flame's gestures:
/// raw events have no gesture arena, so a press without a move is a press at
/// once, and the right button and the wheel arrive the same way. Only mouse
/// pointers land here; touch keeps going through [TouchControls].
class MouseInput {
  /// The cursor in game-widget pixels, once it has been over the window.
  Vector2? position;

  /// [PointerEvent.buttons] as of the last event.
  int buttons = 0;

  double _moved = 0;
  double _wheel = 0;

  bool held(MouseButton b) => buttons & b.mask != 0;

  /// Any button bound to [a] is down.
  bool action(InputAction a) => Bindings.buttonsFor(a).any(held);

  /// Pixels the cursor travelled since the last call.
  double takeMoved() {
    final m = _moved;
    _moved = 0;
    return m;
  }

  /// Wheel notches since the last call: + away from the player.
  double takeWheel() {
    final w = _wheel;
    _wheel = 0;
    return w;
  }

  /// One pointer event, its position already in game-widget pixels.
  void handle(PointerEvent e, Vector2 local) {
    if (e.kind != PointerDeviceKind.mouse) return;
    final p = position;
    if (p != null) _moved += p.distanceTo(local);
    position = local;
    if (e is PointerUpEvent || e is PointerCancelEvent) {
      buttons = e.buttons;
    } else if (e is PointerDownEvent || e is PointerMoveEvent) {
      buttons = e.buttons;
    } else if (e is PointerScrollEvent) {
      // Flutter's scroll delta is down-positive; one notch is ~100 px on
      // most systems, a trackpad sends small steps.
      _wheel -= e.scrollDelta.dy / 100;
    }
  }

  /// Forget the buttons, as when the window loses focus mid-press.
  void releaseAll() => buttons = 0;
}

/// Feeds a [MouseInput] from every mouse event inside [child]. Wraps the
/// whole screen, overlays included, so the cursor keeps steering over the
/// HUD; the game decides when it listens.
class MouseFeed extends StatelessWidget {
  const MouseFeed({
    super.key,
    required this.game,
    required this.mouse,
    required this.child,
  });

  final Game game;
  final MouseInput mouse;
  final Widget child;

  void _on(PointerEvent e) {
    if (e.kind != PointerDeviceKind.mouse || !game.isAttached) return;
    mouse.handle(
      e,
      game.convertGlobalToLocalCoordinate(
        Vector2(e.position.dx, e.position.dy),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.translucent,
    onPointerDown: _on,
    onPointerMove: _on,
    onPointerUp: _on,
    onPointerCancel: _on,
    onPointerHover: _on,
    onPointerSignal: _on,
    child: child,
  );
}

/// How a running sigil leaves the ship to the player (mirrors
/// `SigilControl`, kept apart so this file needs nothing from the game).
enum SteerFreedom { none, verticalOnly, full }

/// One frame of the ship flying after the cursor: from [pos] toward
/// [target], at most [maxStep] game units. Returns the new position.
(double, double) followStep(
  double px,
  double py,
  double tx,
  double ty,
  double maxStep,
  SteerFreedom freedom,
) {
  switch (freedom) {
    case SteerFreedom.none:
      return (px, py);
    case SteerFreedom.verticalOnly:
      final dy = ty - py;
      return (px, py + dy.clamp(-maxStep, maxStep));
    case SteerFreedom.full:
      final dx = tx - px, dy = ty - py;
      final d = math.sqrt(dx * dx + dy * dy);
      if (d <= maxStep || d == 0) return (tx, ty);
      final k = maxStep / d;
      return (px + dx * k, py + dy * k);
  }
}

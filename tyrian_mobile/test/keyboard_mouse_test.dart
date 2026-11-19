import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/game/platform_config.dart' as platform;
import 'package:tyrian_mobile/game/tyrian_game.dart';
import 'package:tyrian_mobile/input/bindings.dart';
import 'package:tyrian_mobile/input/keyboard_input.dart';
import 'package:tyrian_mobile/input/mouse_input.dart';
import 'package:tyrian_mobile/input/touch_controls.dart';

/// Prompts/36 phase 0 and 1, through real pointer and key events: a mounted
/// [GameWidget] inside the same [MouseFeed] the app wraps the screen in.
/// The test screen is 800 × 600 and the game fills it, so widget and game
/// pixels are the same.
class _Flight extends FlameGame
    with DragCallbacks, TapCallbacks, TouchControls {
  _Flight({this.ignoreMouse = true});

  final bool ignoreMouse;
  final mouse = MouseInput();
  final ship = Vector2.zero();
  bool fire = false;

  @override
  bool get touchIgnoresMouse => ignoreMouse;

  @override
  bool get touchMouseHeld => mouse.buttons != 0;

  @override
  bool get touchFlies => true;

  @override
  bool get touchSwaps => true;

  @override
  void touchSteer(Vector2 canvasDelta) => ship.add(canvasDelta);

  @override
  void touchToggleFire() => fire = !fire;

  @override
  void touchSetFire(bool on) => fire = on;

  @override
  bool get touchAlternate => false;

  @override
  void touchSetAlternate(bool on, {required bool announce}) {}

  @override
  void update(double dt) {
    super.update(dt);
    touchTick(dt);
  }
}

const _frame = Duration(milliseconds: 16);

Future<_Flight> _mount(WidgetTester tester, {bool ignoreMouse = true}) async {
  final g = _Flight(ignoreMouse: ignoreMouse);
  await tester.pumpWidget(MaterialApp(
      home: MouseFeed(game: g, mouse: g.mouse, child: GameWidget(game: g))));
  await tester.pump();
  await tester.pump(_frame);
  return g;
}

/// Lift the mouse and let the tap recognisers' timers run out.
Future<void> _done(WidgetTester tester, TestGesture m) async {
  await m.removePointer();
  await tester.pump(const Duration(seconds: 1));
}

Future<TestGesture> _mouse(WidgetTester tester, Offset at,
    {int buttons = kPrimaryMouseButton}) async {
  final m = await tester.createGesture(
      kind: PointerDeviceKind.mouse, buttons: buttons);
  await m.addPointer(location: at);
  await tester.pump(_frame);
  return m;
}

KeyEvent _down(PhysicalKeyboardKey p, LogicalKeyboardKey l) => KeyDownEvent(
    physicalKey: p, logicalKey: l, timeStamp: Duration.zero);
KeyEvent _up(PhysicalKeyboardKey p, LogicalKeyboardKey l) =>
    KeyUpEvent(physicalKey: p, logicalKey: l, timeStamp: Duration.zero);

void main() {
  group('the mouse feed (Prompts/36 §3.3)', () {
    testWidgets('a hover moves the cursor, no button needed', (tester) async {
      final g = await _mount(tester);
      final m = await _mouse(tester, const Offset(100, 100));
      await m.moveTo(const Offset(100, 100));
      await tester.pump(_frame);
      g.mouse.takeMoved();
      await m.moveTo(const Offset(300, 200));
      await tester.pump(_frame);
      expect(g.mouse.position, Vector2(300, 200));
      expect(g.mouse.buttons, 0);
      expect(g.mouse.takeMoved(), closeTo(223.6, 0.1));
      expect(g.mouse.takeMoved(), 0, reason: 'taken once');
      await _done(tester, m);
    });

    testWidgets('a press without a move fires at once', (tester) async {
      final g = await _mount(tester);
      final m = await _mouse(tester, const Offset(200, 200));
      await m.down(const Offset(200, 200));
      await tester.pump(_frame);
      expect(g.mouse.action(InputAction.fire), isTrue);
      expect(g.mouse.action(InputAction.alternate), isFalse);
      await m.up();
      await tester.pump(_frame);
      expect(g.mouse.action(InputAction.fire), isFalse);
      await _done(tester, m);
    });

    testWidgets('the right button holds the second set', (tester) async {
      final g = await _mount(tester);
      final m = await _mouse(tester, const Offset(200, 200),
          buttons: kSecondaryMouseButton);
      await m.down(const Offset(200, 200));
      await tester.pump(_frame);
      expect(g.mouse.action(InputAction.alternate), isTrue);
      expect(g.mouse.action(InputAction.fire), isFalse);
      await m.up();
      await tester.pump(_frame);
      expect(g.mouse.action(InputAction.alternate), isFalse);
      await _done(tester, m);
    });

    testWidgets('the wheel counts notches, away from the player is +',
        (tester) async {
      final g = await _mount(tester);
      final m = await _mouse(tester, const Offset(200, 200));
      await tester.sendEventToBinding(const PointerScrollEvent(
          position: Offset(200, 200),
          kind: PointerDeviceKind.mouse,
          scrollDelta: Offset(0, -200)));
      await tester.pump(_frame);
      expect(g.mouse.takeWheel(), 2);
      expect(g.mouse.takeWheel(), 0);
      await _done(tester, m);
    });

    testWidgets('a finger never reaches the mouse', (tester) async {
      final g = await _mount(tester);
      final f = await tester.startGesture(const Offset(150, 150));
      await f.moveBy(const Offset(0, -40));
      await tester.pump(_frame);
      expect(g.mouse.position, isNull);
      expect(g.mouse.buttons, 0);
      await f.up();
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('releaseAll drops a button the window never saw go up',
        (tester) async {
      final g = await _mount(tester);
      final m = await _mouse(tester, const Offset(200, 200));
      await m.down(const Offset(200, 200));
      await tester.pump(_frame);
      g.mouse.releaseAll();
      expect(g.mouse.action(InputAction.fire), isFalse);
      await m.up();
      await _done(tester, m);
    });
  });

  group('touch on desktop', () {
    testWidgets('a mouse drag is not a finger: no steer, no fire',
        (tester) async {
      final g = await _mount(tester);
      final m = await _mouse(tester, const Offset(300, 300));
      await m.down(const Offset(300, 300));
      for (var i = 0; i < 4; i++) {
        await m.moveBy(const Offset(0, -20));
        await tester.pump(_frame);
      }
      expect(g.ship, Vector2.zero());
      expect(g.touchFingers.count, 0);
      await m.up();
      await tester.pump(_frame);
      expect(g.fire, isFalse);
      await _done(tester, m);
    });

    testWidgets('a real finger still flies and fires, as plan 34',
        (tester) async {
      final g = await _mount(tester);
      final f = await tester.startGesture(const Offset(300, 300));
      for (var i = 0; i < 4; i++) {
        await f.moveBy(const Offset(0, -20));
        await tester.pump(_frame);
      }
      expect(g.ship.y, lessThan(-40));
      expect(g.fire, isTrue);
      await f.up();
      await tester.pump(_frame);
      expect(g.fire, isFalse);
    });

    testWidgets('phones keep the mouse as a finger', (tester) async {
      final g = await _mount(tester, ignoreMouse: false);
      final m = await _mouse(tester, const Offset(300, 300));
      await m.down(const Offset(300, 300));
      for (var i = 0; i < 4; i++) {
        await m.moveBy(const Offset(0, -20));
        await tester.pump(_frame);
      }
      expect(g.ship.y, lessThan(-40));
      await m.up();
      await tester.pump(_frame);
      await _done(tester, m);
    });
  });

  group('flying after the cursor', () {
    test('full: straight at the target, never past the step', () {
      expect(followStep(0, 0, 30, 40, 10, SteerFreedom.full), (6.0, 8.0));
      expect(followStep(0, 0, 3, 4, 10, SteerFreedom.full), (3.0, 4.0),
          reason: 'close enough: lands on it');
    });

    test('a sigil that flies the ship leaves it alone', () {
      expect(followStep(5, 5, 100, 100, 10, SteerFreedom.none), (5.0, 5.0));
    });

    test('vertical only: along y, capped', () {
      expect(followStep(5, 50, 100, 0, 10, SteerFreedom.verticalOnly),
          (5.0, 40.0));
    });
  });

  group('keys by place (Prompts/36 G5)', () {
    test('AZERTY: the key under W types Z and still flies up', () {
      final kb = KeyboardInput();
      kb.handleKeyEvent(
          _down(PhysicalKeyboardKey.keyW, LogicalKeyboardKey.keyZ));
      expect(kb.dy, -1);
      expect(kb.wasdY, -1);
      expect(kb.labelOf(PhysicalKeyboardKey.keyW), LogicalKeyboardKey.keyZ);
      kb.handleKeyEvent(
          _up(PhysicalKeyboardKey.keyW, LogicalKeyboardKey.keyZ));
      expect(kb.dy, 0);
    });

    test('WASD and the arrows together still fly at one speed', () {
      final kb = KeyboardInput()
        ..handleKeyEvent(
            _down(PhysicalKeyboardKey.keyA, LogicalKeyboardKey.keyQ))
        ..handleKeyEvent(_down(
            PhysicalKeyboardKey.arrowLeft, LogicalKeyboardKey.arrowLeft));
      expect(kb.dx, -1);
      expect(kb.wasdX, -1);
      expect(kb.arrowX, -1);
    });

    test('Shift is the second set and ARMS; the scheme picks which', () {
      final kb = KeyboardInput()
        ..handleKeyEvent(_down(
            PhysicalKeyboardKey.shiftLeft, LogicalKeyboardKey.shiftLeft));
      expect(kb.action(InputAction.alternate), isTrue);
      expect(kb.action(InputAction.arms), isTrue);
    });

    test('clear forgets keys held as the window lost focus', () {
      final kb = KeyboardInput()
        ..handleKeyEvent(
            _down(PhysicalKeyboardKey.space, LogicalKeyboardKey.space));
      expect(kb.fire, isTrue);
      kb.clear();
      expect(kb.fire, isFalse);
      expect(kb.takePresses(), isEmpty);
    });
  });

  group('the game', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('on desktop the mouse is no finger; elsewhere it stays one', () {
      expect(TyrianGame().touchIgnoresMouse, platform.isDesktop);
    });
  });
}

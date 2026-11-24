import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/game/tyrian_game.dart';
import 'package:tyrian_mobile/input/touch_controls.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/duel_director.dart';

/// Plan 34 through real gestures: Flame's own tap and drag dispatch on a
/// mounted [GameWidget], driving the same [TouchControls] the game mixes in.
/// The ship, its fire and its weapon set are stand-ins; what is under test is
/// which finger does what. The test screen is 800 × 600: every finger lands
/// inside it, or Flame never hears of it.
class _Flight extends FlameGame
    with DragCallbacks, TapCallbacks, TouchControls {
  bool playing = false;
  final ship = Vector2.zero();
  bool fire = false;
  bool alternate = false;
  int flips = 0;

  @override
  bool get touchFlies => playing;

  @override
  bool get touchSwaps => playing;

  final announced = <bool>[];

  @override
  void touchSteer(Vector2 canvasDelta) => ship.add(canvasDelta);

  @override
  void touchToggleFire() => fire = !fire;

  @override
  void touchSetFire(bool on) => fire = on;

  @override
  bool get touchAlternate => alternate;

  @override
  void touchSetAlternate(bool on, {required bool announce}) {
    if (on == alternate) return;
    alternate = on;
    flips++;
    announced.add(announce);
  }

  @override
  void update(double dt) {
    super.update(dt);
    touchTick(dt);
  }
}

const _frame = Duration(milliseconds: 16);

Future<_Flight> _fly(WidgetTester tester) async {
  final g = _Flight();
  await tester.pumpWidget(MaterialApp(home: GameWidget(game: g)));
  await tester.pump();
  await tester.pump(_frame);
  // A few taps in the menus first, so the tap ids (Flutter's pointer
  // numbers) and the drag ids (Flame's own counter) part ways, as they do
  // on a phone.
  for (var i = 0; i < 3; i++) {
    await tester.tapAt(const Offset(20, 20));
    await tester.pump(_frame);
  }
  g.playing = true;
  return g;
}

/// Move [fingers] together by [step], [times] times, one frame apiece.
Future<void> _move(
  WidgetTester tester,
  List<TestGesture> fingers,
  Offset step, {
  int times = 1,
}) async {
  for (var i = 0; i < times; i++) {
    for (final f in fingers) {
      await f.moveBy(step);
    }
    await tester.pump(_frame);
  }
}

Future<void> _frames(WidgetTester tester, int n) async {
  for (var i = 0; i < n; i++) {
    await tester.pump(_frame);
  }
}

const _up = Offset(0, -15);

void main() {
  testWidgets('1: one finger drags: the ship follows, fires, stops on lift',
      (tester) async {
    final g = await _fly(tester);
    final a = await tester.startGesture(const Offset(200, 400));
    await tester.pump(_frame);
    await _move(tester, [a], _up, times: 4);
    expect(g.ship.y, closeTo(-60, 0.01), reason: 'the ship follows the finger');
    expect(g.fire, isTrue, reason: 'a held finger fires');
    expect(g.alternate, isFalse, reason: 'one finger flies the first set');
    await a.up();
    await _frames(tester, 2);
    expect(g.fire, isFalse, reason: 'lifting the finger stops the fire');
    expect(g.alternate, isFalse);
  });

  testWidgets('2: a lone tap toggles the fire, a second finger\'s does not',
      (tester) async {
    final g = await _fly(tester);
    await tester.tapAt(const Offset(200, 400));
    await _frames(tester, 2);
    expect(g.fire, isTrue, reason: 'one tap: fire on');
    await tester.tapAt(const Offset(200, 400));
    await _frames(tester, 2);
    expect(g.fire, isFalse, reason: 'another: fire off');

    final a = await tester.startGesture(const Offset(200, 400));
    await tester.pump(_frame);
    await _move(tester, [a], _up, times: 3);
    expect(g.fire, isTrue);
    await tester.tapAt(const Offset(100, 500));
    await _frames(tester, 2);
    expect(g.fire, isTrue, reason: 'the second finger\'s tap leaves it on');
    await a.up();
    await _frames(tester, 2);
  });

  testWidgets('3: A flies, B rests: second set at once, A still steers',
      (tester) async {
    final g = await _fly(tester);
    final a = await tester.startGesture(const Offset(200, 400));
    await tester.pump(_frame);
    await _move(tester, [a], _up, times: 4);
    final before = g.ship.clone();

    final b = await tester.startGesture(const Offset(100, 500));
    await tester.pump(_frame);
    expect(g.alternate, isTrue, reason: 'two fingers: second set, at once');
    await _move(tester, [a], _up, times: 3);
    expect(g.ship.y - before.y, closeTo(-45, 0.01),
        reason: 'the ship keeps following A');
    expect(g.fire, isTrue, reason: 'the fire does not drop');

    await b.up();
    await _frames(tester, 3);
    expect(g.alternate, isTrue, reason: 'not before touchAltRelease');
    await _frames(tester, 12);
    expect(g.alternate, isFalse, reason: 'one finger again: first set');
    expect(g.fire, isTrue, reason: 'A still fires');
    await a.up();
    await _frames(tester, 2);
  });

  testWidgets('4: A and B both drag: second set, ship at one finger\'s speed',
      (tester) async {
    final g = await _fly(tester);
    final a = await tester.startGesture(const Offset(200, 400));
    await tester.pump(_frame);
    await _move(tester, [a], _up, times: 2);
    final b = await tester.startGesture(const Offset(100, 500));
    await tester.pump(_frame);
    final before = g.ship.clone();
    await _move(tester, [a, b], _up, times: 4);
    expect(g.touchFingers.count, 2);
    expect(g.touchFingers.dragging, isTrue);
    expect(g.alternate, isTrue);
    expect(g.ship.y - before.y, closeTo(-60, 0.01),
        reason: 'two fingers do not double the speed');
    await a.up();
    await b.up();
    await _frames(tester, 2);
  });

  testWidgets('5: the steering finger lifts, the other flies on, no jump',
      (tester) async {
    final g = await _fly(tester);
    final a = await tester.startGesture(const Offset(200, 400));
    await tester.pump(_frame);
    await _move(tester, [a], _up, times: 2);
    final c = await tester.startGesture(const Offset(100, 550));
    await tester.pump(_frame);
    await _move(tester, [a, c], _up, times: 3);
    await a.up();
    await tester.pump(_frame);
    final before = g.ship.clone();
    await _move(tester, [c], const Offset(10, 0), times: 3);
    expect(g.ship.x - before.x, closeTo(30, 0.01),
        reason: 'C steers now, by its own moves only');
    expect(g.ship.y - before.y, closeTo(0, 0.01), reason: 'and does not jump');
    expect(g.fire, isTrue);
    await _frames(tester, 12);
    expect(g.alternate, isFalse, reason: 'one finger again: first set');
    await c.up();
    await _frames(tester, 2);
    expect(g.fire, isFalse);
  });

  testWidgets('6: both lift within 50 ms: the set does not blink',
      (tester) async {
    final g = await _fly(tester);
    final a = await tester.startGesture(const Offset(200, 400));
    await tester.pump(_frame);
    await _move(tester, [a], _up, times: 2);
    final b = await tester.startGesture(const Offset(100, 500));
    await _move(tester, [a, b], _up, times: 2);
    expect(g.alternate, isTrue);
    expect(g.flips, 1);
    await b.up();
    await tester.pump(_frame);
    await tester.pump(_frame);
    await a.up();
    await _frames(tester, 20);
    expect(g.flips, 1, reason: 'no flip on the way out');
  });

  testWidgets('7: a cancelled finger leaves nothing behind', (tester) async {
    final g = await _fly(tester);
    final a = await tester.startGesture(const Offset(200, 400));
    await tester.pump(_frame);
    await _move(tester, [a], _up, times: 2);
    final b = await tester.startGesture(const Offset(100, 500));
    await tester.pump(_frame);
    await b.cancel();
    await tester.pump(_frame);
    expect(g.touchFingers.count, 1);
    await a.cancel();
    await tester.pump(_frame);
    expect(g.touchFingers.count, 0);
    expect(g.fire, isFalse);

    final before = g.ship.clone();
    final d = await tester.startGesture(const Offset(200, 400));
    await tester.pump(_frame);
    await _move(tester, [d], _up, times: 3);
    expect(g.ship.y - before.y, closeTo(-45, 0.01),
        reason: 'the next finger flies as the first did');
    await d.up();
    await _frames(tester, 2);
  });

  testWidgets('A rests, B drags: B steers', (tester) async {
    final g = await _fly(tester);
    final a = await tester.startGesture(const Offset(200, 400));
    await tester.pump(_frame);
    final b = await tester.startGesture(const Offset(100, 500));
    await tester.pump(_frame);
    await _move(tester, [b], _up, times: 3);
    expect(g.ship.y, closeTo(-45, 0.01), reason: 'the moving finger steers');
    expect(g.alternate, isTrue, reason: 'still two fingers');
    expect(g.fire, isTrue);
    await b.up();
    await a.up();
    await _frames(tester, 2);
  });

  testWidgets('8: leaving play puts the first set back, quietly',
      (tester) async {
    final g = await _fly(tester);
    final a = await tester.startGesture(const Offset(200, 400));
    final b = await tester.startGesture(const Offset(100, 500));
    await _move(tester, [a, b], _up, times: 2);
    expect(g.alternate, isTrue);
    g.playing = false; // sector over: the ComCenter
    await tester.pump(_frame);
    expect(g.alternate, isFalse, reason: 'at once, not after a delay');
    expect(g.announced, [true, false], reason: 'and without a message');
    await a.up();
    await b.up();
    await _frames(tester, 2);
  });

  group('the game', () {
    late TyrianGame game;
    late Vessel v;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      v = Vessel()
        ..fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun)
        ..fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
      game = TyrianGame()..vessel = v;
    });

    List<String> fitted(Map<String, dynamic> save) => [
          for (final w in save['weapons'] as List) (w as Map)['name'] as String,
        ];

    test('8: leaving play fits the first set before anything sees it', () {
      final first = fitted(v.toSaveMap());
      game.state = GameState.playing;
      expect(v.setAlternate(true), isTrue);
      expect(fitted(v.toSaveMap()), isNot(first));
      game.state = GameState.comCenter; // the save is written right after
      expect(v.alternateActive, isFalse);
      expect(fitted(v.toSaveMap()), first);

      for (final out in [GameState.paused, GameState.gameOver]) {
        game.state = GameState.playing;
        v.setAlternate(true);
        game.state = out;
        expect(v.alternateActive, isFalse, reason: '$out');
      }
    });

    test('9: solo and host fly the second set; a co-op client and a duel do '
        'not', () {
      game.state = GameState.playing;
      expect(game.touchFlies, isTrue);
      expect(game.touchSwaps, isTrue);
      game.coopRole = CoopRole.host;
      expect(game.touchSwaps, isTrue);
      game.coopRole = CoopRole.client;
      expect(game.touchFlies, isTrue, reason: 'a client still flies');
      expect(game.touchSwaps, isFalse, reason: 'but sends no second set');
      game.coopRole = CoopRole.none;
      game.duel.phase = DuelPhase.fight;
      expect(game.touchFlies, isFalse, reason: 'a duel\'s touch aims');
      expect(game.touchSwaps, isFalse);
      game.duel.phase = DuelPhase.none;
      game.state = GameState.comCenter;
      expect(game.touchFlies, isFalse);
      expect(game.touchSwaps, isFalse);
    });
  });
}

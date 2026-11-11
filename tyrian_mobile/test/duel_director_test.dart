import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/game/duel_space.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/game/tyrian_game.dart';
import 'package:tyrian_mobile/systems/duel_director.dart';
import 'package:tyrian_mobile/systems/fleet.dart';
import 'package:tyrian_mobile/systems/sector.dart';

/// The doors into a duel (Prompts/30 §8): their order, what each one lets
/// the ship do, and that the boss is held back until the field is ready.
void main() {
  late TyrianGame game;
  late Fleet boss;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    DuelDirector.seen.clear();
    DuelDirector.cutInMode = CutInMode.firstTime;
    game = TyrianGame();
    game.vessel = Vessel();
    final s = Sector(caption: 'T', level: 10);
    Sector.addBossWave(s, ordinal: 1, dps: 100, ttk: 20, hpFloor: 10000);
    boss = s.fleets.last;
  });

  void run(double seconds) {
    const step = 1 / 60;
    for (var t = 0.0; t < seconds; t += step) {
      game.duel.update(step);
    }
  }

  test('a boss fleet is held, a plain one is not', () {
    final d = game.duel;
    final plain = Fleet.create(
        id: 0,
        enterTime: 0,
        caption: 'x',
        hostType: boss.hostType,
        count: 1,
        durationSec: 1,
        srcX: 0,
        srcY: 0,
        dstX: 0,
        dstY: 0);
    expect(d.holds(plain), isFalse);
    expect(d.holds(boss), isTrue);
    expect(d.phase, DuelPhase.warning);
    expect(d.holds(boss), isTrue, reason: 'still held through the doors');
  });

  test('warning, close-up, turn, entrance — then the boss may start', () {
    final d = game.duel;
    d.holds(boss);
    expect(d.controls, isFalse);
    expect(d.geometry, isFalse, reason: 'the warning is still the flight');
    run(config.duelWarning + 0.02);
    expect(d.phase, DuelPhase.cutIn);
    expect(d.frozen, isTrue);
    expect(d.shelters, isTrue);
    expect(d.holds(boss), isTrue);
    run(config.duelCutIn + 0.02);
    expect(d.phase, DuelPhase.turn);
    expect(d.geometry, isTrue);
    expect(d.inputLocked, isTrue);
    run(config.duelTurn + 0.02);
    expect(d.phase, DuelPhase.entrance);
    expect(d.controls, isTrue);
    expect(d.holds(boss), isFalse, reason: 'released: the sector starts it');
    expect(game.vessel.heading, closeTo(uprightAngle, 1e-9));
    final start = duelToGame(0.5, config.duelShipStartV);
    expect(game.vessel.position.x, closeTo(start.x, 1e-3));
    expect(game.vessel.position.y, closeTo(start.y, 1e-3));
  });

  test('a boss seen once comes without its close-up', () {
    final d = game.duel;
    d.holds(boss);
    run(config.duelWarning + 0.02);
    expect(d.phase, DuelPhase.cutIn);
    d.reset();
    d.holds(boss);
    run(config.duelWarning + 0.02);
    expect(d.phase, DuelPhase.turn);
  });

  test('the close-up can be skipped once it has had a moment', () {
    final d = game.duel;
    d.holds(boss);
    run(config.duelWarning + 0.02);
    d.skip();
    expect(d.phase, DuelPhase.cutIn, reason: 'too early to skip');
    run(config.duelCutInSkippable);
    d.skip();
    expect(d.phase, DuelPhase.turn);
  });

  test('the background turns with the ship, and slows', () {
    final d = game.duel;
    expect(d.frameAngle, 0);
    expect(d.bgSpeed, 1);
    d.holds(boss);
    DuelDirector.cutInMode = CutInMode.never;
    run(config.duelWarning + 0.02);
    run(config.duelTurn / 2);
    expect(d.frameAngle, inExclusiveRange(0, uprightAngle));
    run(config.duelTurn);
    expect(d.frameAngle, uprightAngle);
    expect(d.bgSpeed, config.duelBgDrift);
  });

  test('the arena starts in the duel, the boss free to come at once', () {
    final d = game.duel;
    d.startArena();
    expect(d.phase, DuelPhase.entrance);
    expect(d.geometry, isTrue);
    expect(d.holds(boss), isFalse);
    expect(d.holdsCompletion, isFalse, reason: 'the arena runs its own rounds');
    d.reset();
    expect(d.active, isFalse);
    expect(game.vessel.heading, 0);
  });

  test('a duel holds the sector open until the turn back is done', () {
    final d = game.duel;
    d.holds(boss);
    expect(d.holdsCompletion, isTrue);
  });
}

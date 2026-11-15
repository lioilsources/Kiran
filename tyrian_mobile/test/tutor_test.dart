import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/entities/boss.dart';
import 'package:tyrian_mobile/entities/collectable.dart';
import 'package:tyrian_mobile/entities/hostile.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/game/tyrian_game.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/fleet.dart';
import 'package:tyrian_mobile/systems/sector.dart';
import 'package:tyrian_mobile/systems/tutor.dart';
import 'package:tyrian_mobile/systems/weapon_family.dart';

/// The tutor: lessons once per player, hints when needed, the round's goal
/// and summary, the death tip and the first round's three steps.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TyrianGame game;
  late Vessel v;
  late Tutor tutor;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await TutorMemory.instance.load();
    Tutor.touchOverride = false;
    v = Vessel()
      ..equipWeapon(DevType.generatorBasic, WeaponSlot.generator)
      ..fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    game = TyrianGame()..vessel = v;
    game.currentSector = Sector(caption: 'T', level: 1);
    tutor = game.tutor;
  });

  tearDown(() => Tutor.touchOverride = null);

  List<String> said() => game.recentMessages;

  void pick(CollType t) =>
      Collectable(caption: '', cType: t, value: 100).applyEffect(v, game);

  test('the first pickup of a kind explains the kind, once', () {
    pick(CollType.shieldUpgrade);
    expect(said(), contains(contains('takes hits before the hull')));
    final before = said().length;
    pick(CollType.shieldUpgrade);
    expect(said().length, before + 1, reason: 'the short note only');
    pick(CollType.leftWepUpgrade);
    pick(CollType.rightWepUpgrade);
    expect(said().where((m) => m.contains('raise a gun')).length, 1,
        reason: 'all weapon pickups are one kind');
  });

  test('lessons are remembered across runs', () async {
    pick(CollType.bonusCredit);
    await Future<void>.delayed(Duration.zero);
    await TutorMemory.instance.load();
    final again = TyrianGame()..vessel = v;
    Collectable(caption: '', cType: CollType.bonusCredit, value: 5)
        .applyEffect(v, again);
    expect(again.recentMessages.where((m) => m.contains('Credits buy')),
        isEmpty);
  });

  test('the round opens with its goal', () {
    tutor.roundStart();
    expect(said(), contains('Goal: survive the waves'));
    final s = Sector(caption: 'B', level: 10);
    s.fleets.add(Fleet.create(
        id: 0,
        enterTime: 0,
        caption: 'boss',
        hostType: HostType.falcon1,
        count: 1,
        durationSec: 1,
        srcX: 0,
        srcY: 0,
        dstX: 0,
        dstY: 0,
        bossSpec: const BossSpec(ordinal: 1, weapDamage: 1, rechargeFrames: 1)));
    game.currentSector = s;
    tutor.roundStart();
    expect(said(), contains('Goal: survive the waves and beat the boss'));
  });

  test('a low hull is pointed out once a round, a few times ever', () {
    var shown = 0;
    for (var round = 0; round < Tutor.hintLimit + 2; round++) {
      tutor.roundStart();
      v.hp = 5;
      for (var i = 0; i < 3; i++) {
        tutor.tick(0.1);
      }
      shown = said().where((m) => m.startsWith('Hull low')).length;
      game.recentMessages; // keep the list fresh
    }
    expect(TutorMemory.instance.times('lowHp'), Tutor.hintLimit);
    expect(shown, lessThanOrEqualTo(Tutor.hintLimit));
  });

  test('credits for an upgrade are pointed out', () {
    tutor.roundStart();
    v.credit = 1 << 30;
    tutor.tick(0.1);
    expect(said(), contains(startsWith('You can afford an upgrade')));
  });

  test('a starved generator is pointed out after a moment of firing', () {
    tutor.roundStart();
    v.fire = true;
    v.genValue = 0;
    tutor.tick(1.0);
    expect(said().where((m) => m.contains('generator gives')), isEmpty);
    tutor.tick(1.0);
    expect(said(), contains(contains('generator gives')));
  });

  test('the round ends with what it brought and the best weapon', () {
    tutor.roundStart();
    v.credit += 1500;
    Hostile kill(WeaponFamily f) => Hostile(
        caption: '', id: 1, hostType: HostType.falcon1, hp: 1, hpMax: 1)
      ..deathFamily = f;
    tutor.onKill(kill(WeaponFamily.vulcan));
    tutor.onKill(kill(WeaponFamily.vulcan));
    tutor.onKill(kill(WeaponFamily.bubble));
    tutor.roundEnd();
    expect(said(), contains(matches(RegExp(r'^\+1.500 credits · 3 kills$'))));
    expect(said(), contains('Best weapon: VULCAN'));
  });

  test('the death tip follows what the death looked like', () {
    v.shieldMax = 50;
    v.hpMax = 125;
    expect(tutor.deathTip(), startsWith('Upgrade the shield'));
    v.shieldMax = 500;
    expect(tutor.deathTip(), startsWith('Stronger guns'));
  });

  test('the first round on a touch screen: fly, collect, shop', () {
    Tutor.touchOverride = true;
    tutor.roundStart();
    tutor.tick(Tutor.afterTitle + 0.1);
    expect(said(), contains(startsWith('Drag to fly')));
    for (var i = 0; i < 10; i++) {
      v.position.x += 20;
      tutor.tick(0.016);
    }
    expect(said(), contains('Catch the icons that enemies drop'));
    pick(CollType.bonusCredit);
    tutor.roundEnd();
    expect(said(), contains('Between rounds, spend your credits in the ComCenter'));
    expect(TutorMemory.instance.times('intro'), 1);

    final before = said().where((m) => m.startsWith('Drag to fly')).length;
    tutor.roundStart();
    tutor.tick(Tutor.afterTitle + 0.1);
    expect(said().where((m) => m.startsWith('Drag to fly')).length, before,
        reason: 'the lesson does not repeat');
  });

  test('desktop gets no touch lessons', () {
    tutor.roundStart();
    tutor.tick(Tutor.afterTitle + 2);
    expect(said().where((m) => m.startsWith('Drag to fly')), isEmpty);
  });
}

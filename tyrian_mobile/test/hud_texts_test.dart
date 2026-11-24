import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/entities/collectable.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/game/tyrian_game.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/device.dart';
import 'package:tyrian_mobile/systems/tutor.dart';

/// The texts at the top of the screen: what each pickup did, and the
/// perimeter's name and level as a round begins.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TyrianGame game;
  late Vessel v;

  setUp(() async {
    // The tutor's first-time lessons are pinned in tutor_test.dart; here a
    // pilot who has seen them, so each pickup says its one note.
    SharedPreferences.setMockInitialValues({
      'tutor_seen': [
        for (final k in ['Weapon', 'Health', 'Shield', 'Generator', 'Credits'])
          'pickup$k:1',
      ],
    });
    await TutorMemory.instance.load();
    v = Vessel()
      ..equipWeapon(DevType.generatorBasic, WeaponSlot.generator)
      ..fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    game = TyrianGame()..vessel = v;
  });

  String pick(CollType t, {int value = 0}) {
    final before = game.recentMessages.length;
    Collectable(caption: '', cType: t, value: value).applyEffect(v, game);
    final shown = game.recentMessages;
    expect(shown.length, before + 1, reason: '$t says what it did');
    return shown.last;
  }

  test('every pickup explains itself', () {
    final front = v.getDevice(WeaponSlot.frontGun)!;
    expect(pick(CollType.frontWepUpgrade), 'FRONT Lv.${front.level}: stronger shots');
    expect(pick(CollType.leftWepUpgrade), startsWith('LEFT Lv.'),
        reason: 'an empty side slot gets its gun and says so');
    expect(pick(CollType.rightWepUpgrade), startsWith('RIGHT Lv.'));
    v.hp = 10;
    expect(pick(CollType.healthUpgrade), matches(RegExp(r'^\+\d+ HP: hull repaired$')));
    expect(pick(CollType.shieldUpgrade), endsWith('shield, recharges faster'));
    expect(pick(CollType.generatorUpgrade), 'Generator up: more power for your guns');
    expect(pick(CollType.bonusCredit, value: 1500),
        startsWith('+1'), reason: 'the credits it brought');
  });

  test('the repair note counts what was really repaired', () {
    v.hp = 40;
    final note = pick(CollType.healthUpgrade);
    expect(note, '+${v.hp - 40} HP: hull repaired');
  });

  test('a weapon at max level says nothing more: the sale says it', () {
    final front = v.getDevice(WeaponSlot.frontGun)!;
    while (front.level < Device.maxLevel) {
      front.upgrade();
    }
    // The sale pays through the mounted ship; the note is what is pinned.
    front.parentVessel = null;
    Collectable(caption: '', cType: CollType.frontWepUpgrade).applyEffect(v, game);
    expect(game.recentMessages.where((m) => m.contains('stronger shots')), isEmpty);
  });

  test('P2\'s pickups do not speak on the host\'s screen', () {
    final p2 = Vessel()..fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    Collectable(caption: '', cType: CollType.frontWepUpgrade).applyEffect(p2, game);
    expect(game.recentMessages, isEmpty);
  });

  test('messages close together stack instead of overlapping', () {
    game.showMessage('A');
    game.showMessage('B');
    game.showMessage('C');
    expect(game.recentMessages, ['A', 'B', 'C']);
  });
}

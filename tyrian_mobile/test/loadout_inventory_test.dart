import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/device.dart';

/// The ComCenter loadout lets a pilot own several weapons per slot and switch
/// between them for free. These pin the hangar rules the screen relies on.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('fitting into an empty slot uses no hangar', () {
    final v = Vessel();
    v.fitWeapon(DevType.smallBubble, WeaponSlot.leftGun);
    expect(v.getDevice(WeaponSlot.leftGun)!.name, DevType.smallBubble.name);
    expect(v.hangar, isEmpty);
  });

  test('switching keeps levels and returns the same instance', () {
    final v = Vessel();
    final bubble = v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    bubble.upgrade();
    expect(bubble.level, 1);

    v.fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun);
    expect(v.getDevice(WeaponSlot.frontGun)!.name, DevType.vulcanCannon.name);
    expect(v.hangar.single, same(bubble));
    expect(v.hangar.single.level, 1);

    final back = v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    expect(back, same(bubble));
    expect(back.level, 1);
    expect(v.hangar.single.name, DevType.vulcanCannon.name);
  });

  test('fitting the weapon already fitted is a no-op', () {
    final v = Vessel();
    final d = v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    expect(v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun), same(d));
    expect(v.hangar, isEmpty);
    expect(v.devices.where((x) => x.slot == WeaponSlot.frontGun).length, 1);
  });

  test('selling the fitted weapon refunds its price and leaves the slot empty',
      () {
    final v = Vessel();
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    final vulcan = v.fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun);
    v.credit = 0;
    final gained = v.sellFitted(WeaponSlot.frontGun);
    expect(gained, vulcan.price);
    expect(v.credit, vulcan.price);
    expect(v.getDevice(WeaponSlot.frontGun), isNull,
        reason: 'no auto-fit from the hangar');
    expect(v.hangar.single.name, DevType.bubbleGun.name);
  });

  test('selling from the hangar refunds the full current price', () {
    final v = Vessel();
    final bubble = v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    bubble.upgrade();
    v.fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun);
    v.credit = 0;
    expect(v.sellFromHangar(bubble), bubble.price);
    expect(v.credit, bubble.price);
    expect(v.hangar, isEmpty);
  });

  test('the generator cannot be sold', () {
    final v = Vessel();
    v.equipWeapon(DevType.generatorBasic, WeaponSlot.generator);
    expect(v.sellFitted(WeaponSlot.generator), 0);
    expect(v.getDevice(WeaponSlot.generator), isNotNull);
  });

  test('left and right own the same weapon independently', () {
    final v = Vessel();
    final left = v.fitWeapon(DevType.smallBubble, WeaponSlot.leftGun);
    left.upgrade();
    v.fitWeapon(DevType.smallBubble, WeaponSlot.rightGun);
    v.fitWeapon(DevType.smallVulcan, WeaponSlot.leftGun);
    expect(v.hangarEntry(DevType.smallBubble.name, WeaponSlot.leftGun),
        same(left));
    expect(v.hangarEntry(DevType.smallBubble.name, WeaponSlot.rightGun),
        isNull);
    expect(v.ownsWeapon(DevType.smallBubble.name, WeaponSlot.rightGun), isTrue);
    expect(v.getDevice(WeaponSlot.rightGun)!.level, 0);
  });

  test('hangar weapons do not draw power', () {
    final v = Vessel();
    v.equipWeapon(DevType.generatorBasic, WeaponSlot.generator);
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    final before = v.generatorLoad;
    v.fitWeapon(DevType.laser, WeaponSlot.frontGun);
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    expect(v.hangar.single.name, DevType.laser.name);
    expect(v.generatorLoad, closeTo(before, 1e-9));
  });

  test('the hangar survives a save round trip; old saves load empty', () {
    final v = Vessel();
    final bubble = v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    bubble.upgrade();
    v.fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun);
    final saved = v.toSaveMap();

    final restored = Vessel()..loadFromSave(saved);
    expect(restored.hangar.single.name, DevType.bubbleGun.name);
    expect(restored.hangar.single.level, 1);
    expect(restored.hangar.single.slot, WeaponSlot.frontGun);
    expect(restored.getDevice(WeaponSlot.frontGun)!.name,
        DevType.vulcanCannon.name);

    final legacy = Map<String, dynamic>.from(saved)..remove('hangar');
    final old = Vessel()..loadFromSave(legacy);
    expect(old.hangar, isEmpty);
  });

  test('a new game empties the hangar', () {
    final v = Vessel();
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    v.fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun);
    expect(v.hangar, isNotEmpty);
    v.newGame();
    expect(v.hangar, isEmpty);
  });
}

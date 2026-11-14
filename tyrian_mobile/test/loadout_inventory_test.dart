import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/systems/device.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/ui/com_center.dart' show swapHintVisible;

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

  // ── Touch swap (plan 32 Q3): the two strongest sets, per slot ──

  double dps(Vessel v, Device d) => d.dps;
  Device? front(Vessel v) => v.getDevice(WeaponSlot.frontGun);

  /// [types] owned for [slot], ranked strongest first at their levels.
  List<Device> own(Vessel v, WeaponSlot slot, List<DevType> types) {
    final devices = [for (final t in types) v.fitWeapon(t, slot)];
    return devices..sort((a, b) => dps(v, b).compareTo(dps(v, a)));
  }

  test('two weapons: the swap flips between them', () {
    final v = Vessel();
    final ranked = own(v, WeaponSlot.frontGun,
        [DevType.bubbleGun, DevType.vulcanCannon]);
    v.fitWeapon(DevType.byName(ranked[0].name)!, WeaponSlot.frontGun);
    expect(v.swapToAlternate(), isTrue);
    expect(front(v), same(ranked[1]), reason: 'strongest fitted → second');
    expect(v.swapToAlternate(), isTrue);
    expect(front(v), same(ranked[0]));
  });

  test('three weapons: a weaker one fitted goes to the strongest, then the '
      'swap flips between the top two', () {
    final v = Vessel();
    final ranked = own(v, WeaponSlot.frontGun,
        [DevType.bubbleGun, DevType.vulcanCannon, DevType.blaster]);
    expect(dps(v, ranked[0]), greaterThan(dps(v, ranked[2])));
    v.fitWeapon(DevType.byName(ranked[2].name)!, WeaponSlot.frontGun);
    v.swapToAlternate();
    expect(front(v), same(ranked[0]));
    v.swapToAlternate();
    expect(front(v), same(ranked[1]));
    v.swapToAlternate();
    expect(front(v), same(ranked[0]));
    expect(v.hangar.where((d) => d.slot == WeaponSlot.frontGun).length, 2);
  });

  test('ranking is by DPS at the current level', () {
    final v = Vessel();
    final bubble = v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    final vulcan = v.fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun);
    // Upgrade whichever is weaker until it is the stronger one.
    final weak = dps(v, bubble) < dps(v, vulcan) ? bubble : vulcan;
    final strong = identical(weak, bubble) ? vulcan : bubble;
    while (dps(v, weak) <= dps(v, strong) && weak.level < 4) {
      weak.upgrade();
    }
    if (dps(v, weak) <= dps(v, strong)) return; // cannot overtake: nothing to pin
    v.fitWeapon(DevType.byName(strong.name)!, WeaponSlot.frontGun);
    v.swapToAlternate();
    expect(front(v), same(weak), reason: 'the upgraded gun is now the strongest');
  });

  test('left and right swap independently; a single weapon stays', () {
    final v = Vessel();
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    final left = own(v, WeaponSlot.leftGun,
        [DevType.smallBubble, DevType.smallVulcan]);
    v.fitWeapon(DevType.byName(left[0].name)!, WeaponSlot.leftGun);
    final right = v.fitWeapon(DevType.smallBubble, WeaponSlot.rightGun);
    final frontGun = front(v);

    expect(v.swapToAlternate(), isTrue);
    expect(v.getDevice(WeaponSlot.leftGun), same(left[1]));
    expect(v.getDevice(WeaponSlot.rightGun), same(right),
        reason: 'one weapon in the slot: nothing to swap to');
    expect(front(v), same(frontGun));
    expect(v.hangarEntry(DevType.smallBubble.name, WeaponSlot.rightGun), isNull);
  });

  test('nothing to swap: the gesture does nothing', () {
    final v = Vessel();
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    v.fitWeapon(DevType.smallBubble, WeaponSlot.leftGun);
    expect(v.swapToAlternate(), isFalse);
    expect(v.hangar, isEmpty);
  });

  test('levels survive the swap; the new gun waits out the swap delay', () {
    final v = Vessel();
    final bubble = v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    bubble.upgrade();
    bubble.upgrade();
    final vulcan = v.fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun);
    vulcan.upgrade();
    v.swapToAlternate();
    v.swapToAlternate();
    v.swapToAlternate();
    expect(bubble.level, 2);
    expect(vulcan.level, 1);
    final fitted = front(v)!;
    expect(fitted.cd, closeTo(fitted.cooldown + config.swapDelay, 1e-9));
  });

  test('the hangar draws no power', () {
    final v = Vessel();
    v.equipWeapon(DevType.generatorBasic, WeaponSlot.generator);
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    final alone = v.generatorLoad;
    v.fitWeapon(DevType.laser, WeaponSlot.frontGun);
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun); // laser to hangar
    expect(v.generatorLoad, alone);
    v.swapToAlternate(); // laser fitted, bubble in the hangar
    expect(front(v)!.name, DevType.laser.name);
    final laserOnly = Vessel()
      ..equipWeapon(DevType.generatorBasic, WeaponSlot.generator)
      ..fitWeapon(DevType.laser, WeaponSlot.frontGun);
    expect(v.generatorLoad, laserOnly.generatorLoad);
  });

  test('the swap hint shows on touch only, once a slot has two weapons', () {
    final v = Vessel();
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    expect(swapHintVisible(v, touch: true), isFalse);
    v.fitWeapon(DevType.smallBubble, WeaponSlot.rightGun);
    v.fitWeapon(DevType.smallVulcan, WeaponSlot.rightGun);
    expect(swapHintVisible(v, touch: true), isTrue);
    expect(swapHintVisible(v, touch: false), isFalse);
  });
}

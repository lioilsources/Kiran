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

  // ── The touch's second set (plans 32 Q3 and 34), per slot ──

  double dps(Vessel v, Device d) => v.effectiveDps(d);
  Device? front(Vessel v) => v.getDevice(WeaponSlot.frontGun);
  Device? left(Vessel v) => v.getDevice(WeaponSlot.leftGun);

  /// [types] owned for [slot], ranked strongest first at their levels.
  List<Device> own(Vessel v, WeaponSlot slot, List<DevType> types) {
    final devices = [for (final t in types) v.fitWeapon(t, slot)];
    return devices..sort((a, b) => dps(v, b).compareTo(dps(v, a)));
  }

  void fit(Vessel v, Device d) => v.fitWeapon(DevType.byName(d.name)!, d.slot);

  test('two weapons: the second set fits the other, the first puts it back',
      () {
    final v = Vessel();
    final ranked = own(v, WeaponSlot.frontGun,
        [DevType.bubbleGun, DevType.vulcanCannon]);
    fit(v, ranked[0]);
    expect(v.setAlternate(true), isTrue);
    expect(v.alternateActive, isTrue);
    expect(front(v), same(ranked[1]), reason: 'strongest fitted → second');
    expect(v.setAlternate(true), isFalse, reason: 'idempotent');
    expect(front(v), same(ranked[1]), reason: 'holding is not flipping');
    expect(v.setAlternate(false), isTrue);
    expect(v.alternateActive, isFalse);
    expect(front(v), same(ranked[0]));
    expect(v.setAlternate(false), isFalse, reason: 'idempotent');
  });

  test('three weapons: a weaker one fitted goes to the strongest and comes '
      'back', () {
    final v = Vessel();
    final ranked = own(v, WeaponSlot.frontGun,
        [DevType.bubbleGun, DevType.vulcanCannon, DevType.blaster]);
    expect(dps(v, ranked[0]), greaterThan(dps(v, ranked[2])));
    fit(v, ranked[2]);
    v.setAlternate(true);
    expect(front(v), same(ranked[0]));
    v.setAlternate(false);
    expect(front(v), same(ranked[2]), reason: 'the first set, as fitted');
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
    fit(v, strong);
    v.setAlternate(true);
    expect(front(v), same(weak), reason: 'the upgraded gun is now the strongest');
  });

  test('left and right change independently; a single weapon stays', () {
    final v = Vessel();
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    final lefts = own(v, WeaponSlot.leftGun,
        [DevType.smallBubble, DevType.smallVulcan]);
    fit(v, lefts[0]);
    final right = v.fitWeapon(DevType.smallBubble, WeaponSlot.rightGun);
    final frontGun = front(v);

    expect(v.setAlternate(true), isTrue);
    expect(left(v), same(lefts[1]));
    expect(v.getDevice(WeaponSlot.rightGun), same(right),
        reason: 'one weapon in the slot: nothing to change to');
    expect(front(v), same(frontGun));
    expect(v.hangarEntry(DevType.smallBubble.name, WeaponSlot.rightGun), isNull);
    v.setAlternate(false);
    expect(left(v), same(lefts[0]));
    expect(v.getDevice(WeaponSlot.rightGun), same(right));
  });

  test('nothing to change: the second set does not start', () {
    final v = Vessel();
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    v.fitWeapon(DevType.smallBubble, WeaponSlot.leftGun);
    expect(v.setAlternate(true), isFalse);
    expect(v.alternateActive, isFalse);
    expect(v.hangar, isEmpty);
  });

  test('levels survive; both ways the gun waits out the swap delay', () {
    final v = Vessel();
    final bubble = v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    bubble.upgrade();
    bubble.upgrade();
    final vulcan = v.fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun);
    vulcan.upgrade();
    v.setAlternate(true);
    var fitted = front(v)!;
    expect(fitted.cd, closeTo(fitted.cooldown + config.swapDelay, 1e-9));
    fitted.cd = 0;
    v.setAlternate(false);
    fitted = front(v)!;
    expect(fitted, same(vulcan), reason: 'the first set, as fitted');
    expect(fitted.cd, closeTo(fitted.cooldown + config.swapDelay, 1e-9));
    v.setAlternate(true);
    expect(bubble.level, 2);
    expect(vulcan.level, 1);
  });

  test('a slot the second set filled is emptied again', () {
    final v = Vessel();
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    final lefts = own(v, WeaponSlot.leftGun,
        [DevType.smallBubble, DevType.smallVulcan, DevType.smallLaser]);
    v.sellFitted(WeaponSlot.leftGun); // empty, two in the hangar
    final stowed = v.hangar.where((d) => d.slot == WeaponSlot.leftGun).toList();
    expect(left(v), isNull);
    expect(stowed, hasLength(2));
    expect(v.setAlternate(true), isTrue);
    expect(left(v), same(lefts.firstWhere(stowed.contains)),
        reason: 'the strongest left gun still owned');
    v.setAlternate(false);
    expect(left(v), isNull, reason: 'the first set had no left gun');
    expect(v.hangar.where((d) => d.slot == WeaponSlot.leftGun).toSet(),
        stowed.toSet());
  });

  test('a slot swapped by hand in the second set keeps the pilot\'s choice',
      () {
    final v = Vessel();
    final fronts = own(v, WeaponSlot.frontGun,
        [DevType.bubbleGun, DevType.vulcanCannon, DevType.blaster]);
    fit(v, fronts[0]);
    final lefts = own(v, WeaponSlot.leftGun,
        [DevType.smallBubble, DevType.smallVulcan]);
    fit(v, lefts[0]);
    v.setAlternate(true);
    expect(front(v), same(fronts[1]));
    // What SigilCaster._fit does on Y.
    v.swapIn(DevType.byName(fronts[2].name)!, WeaponSlot.frontGun);
    v.keepHandFitted(WeaponSlot.frontGun);
    v.setAlternate(false);
    expect(front(v), same(fronts[2]), reason: 'the hand swap stands');
    expect(left(v), same(lefts[0]), reason: 'the rest of the first set returns');
  });

  test('the first set never refits a weapon the pilot no longer owns', () {
    final v = Vessel();
    final ranked = own(v, WeaponSlot.frontGun,
        [DevType.bubbleGun, DevType.vulcanCannon]);
    fit(v, ranked[0]);
    v.setAlternate(true);
    v.sellFromHangar(ranked[0]);
    v.setAlternate(false);
    expect(front(v), same(ranked[1]), reason: 'nothing to put back');
    expect(v.hangar, isEmpty, reason: 'and no free gun made up');
  });

  test('a new game or a loaded save forgets the second set', () {
    final v = Vessel();
    own(v, WeaponSlot.frontGun, [DevType.bubbleGun, DevType.vulcanCannon]);
    v.setAlternate(true);
    v.newGame();
    expect(v.alternateActive, isFalse);
    own(v, WeaponSlot.frontGun, [DevType.bubbleGun, DevType.vulcanCannon]);
    final saved = v.toSaveMap();
    v.setAlternate(true);
    v.loadFromSave(saved);
    expect(v.alternateActive, isFalse);
  });

  test('the hangar draws no power', () {
    final v = Vessel();
    v.equipWeapon(DevType.generatorBasic, WeaponSlot.generator);
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    final alone = v.generatorLoad;
    v.fitWeapon(DevType.laser, WeaponSlot.frontGun);
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun); // laser to hangar
    expect(v.generatorLoad, alone);
    v.setAlternate(true); // laser fitted, bubble in the hangar
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

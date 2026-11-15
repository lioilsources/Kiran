import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/dps_preview.dart';
import 'package:tyrian_mobile/systems/mods/mods_state.dart';

/// Plan 32 Q4: the delta under a chip is exactly what the STATS number moves
/// by when the player does what the chip offers.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ModsState.instance.reset();
  });

  Vessel ship() {
    final v = Vessel();
    v.equipWeapon(DevType.generatorBasic, WeaponSlot.generator);
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    return v;
  }

  int panel(Vessel v) => DpsPreview.powered(v).round();

  /// Predict, act, compare.
  void expectDelta(Vessel v, ChipDelta? predicted, void Function() act) {
    expect(predicted, isNotNull);
    final before = panel(v);
    act();
    expect(panel(v) - before, predicted!.value);
  }

  test('upgrade of the fitted gun', () {
    final v = ship();
    final gun = v.getDevice(WeaponSlot.frontGun)!;
    final d = DpsPreview(v)
        .chip(WeaponSlot.frontGun, DevType.bubbleGun, fitted: gun);
    expect(d!.value, greaterThanOrEqualTo(0));
    expectDelta(v, d, gun.upgrade);
  });

  test('switch to a hangar gun, at its own level', () {
    final v = ship();
    final vulcan = v.fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun);
    vulcan.upgrade();
    vulcan.upgrade();
    v.fitWeapon(DevType.bubbleGun, WeaponSlot.frontGun); // vulcan to hangar
    final d = DpsPreview(v)
        .chip(WeaponSlot.frontGun, DevType.vulcanCannon, hangar: vulcan);
    expectDelta(v,
        d, () => v.fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun));
    expect(v.getDevice(WeaponSlot.frontGun)!.level, 2);
  });

  test('buying a gun replaces the fitted one', () {
    final v = ship();
    final d = DpsPreview(v).chip(WeaponSlot.frontGun, DevType.vulcanCannon);
    expectDelta(v,
        d, () => v.fitWeapon(DevType.vulcanCannon, WeaponSlot.frontGun));
  });

  test('buying into an empty slot adds its whole DPS', () {
    final v = ship();
    final d = DpsPreview(v).chip(WeaponSlot.leftGun, DevType.smallBubble);
    expect(d!.value, greaterThan(0));
    expectDelta(v,
        d, () => v.fitWeapon(DevType.smallBubble, WeaponSlot.leftGun));
  });

  test('a gun the generator cannot power shows the truth, flagged', () {
    final v = ship();
    v.genMax = 1; // nothing but the stock gun's trickle fits
    final d = DpsPreview(v).chip(WeaponSlot.frontGun, DevType.laser);
    expect(d!.powered, isFalse);
    expect(d.value, lessThanOrEqualTo(0));
    expectDelta(v, d, () => v.fitWeapon(DevType.laser, WeaponSlot.frontGun));
  });

  test('max level shows no upgrade delta', () {
    final v = ship();
    final gun = v.getDevice(WeaponSlot.frontGun)!..level = 25;
    expect(
        DpsPreview(v).chip(WeaponSlot.frontGun, DevType.bubbleGun, fitted: gun),
        isNull);
  });

  test('previews leave the ship as it was', () {
    final v = ship();
    final gun = v.getDevice(WeaponSlot.frontGun)!;
    final before = gun.toJson();
    final p = DpsPreview(v);
    p.chip(WeaponSlot.frontGun, DevType.bubbleGun, fitted: gun);
    p.chip(WeaponSlot.frontGun, DevType.vulcanCannon);
    p.chip(WeaponSlot.leftGun, DevType.smallBubble);
    expect(gun.toJson(), before);
    expect(v.devices.length, 2);
    expect(v.hangar, isEmpty);
  });

  test('damage × rate is the gun\'s DPS', () {
    final v = ship();
    for (final t in [DevType.bubbleGun, DevType.vulcanCannon, DevType.laser]) {
      final gun = v.fitWeapon(t, WeaponSlot.frontGun)..upgrade();
      final b = DpsPreview(v).breakdown(gun);
      expect(b.damage * b.rate, closeTo(v.effectiveDps(gun), 1e-6),
          reason: t.name);
    }
  });

  test('STATS and HUD basis leave out guns that cannot fire', () {
    final v = ship();
    final full = DpsPreview.powered(v);
    v.fitWeapon(DevType.smallLaser, WeaponSlot.leftGun);
    v.genMax = 0.5;
    expect(DpsPreview.powered(v), lessThan(full + 1e-9));
    expect(v.totalDps, greaterThan(DpsPreview.powered(v)),
        reason: 'totalDps (VB6 scaling) still counts every gun');
  });
}

import '../entities/vessel.dart';
import 'campaign.dart';
import 'dev_type.dart';
import 'device.dart';

/// Plan 32 Q4: what a purchase, an upgrade or a switch would do to the
/// ship's DPS, worked out on copies — the ship is never touched.
///
/// The basis is [powered]: the DPS of the weapons the generator can power,
/// with mods ([Campaign.poweredDps]). STATS, the HUD and every delta use it,
/// so the numbers never contradict each other. `Vessel.totalDps` (which
/// feeds `lastMaxDps` and the VB6 enemy scaling) stays as it is.
class DpsPreview {
  final Vessel v;
  const DpsPreview(this.v);

  static double powered(Vessel v) => Campaign.poweredDps(v);

  /// [d]'s share of [powered] once fitted: nothing if it cannot be powered.
  double _gun(Device d) => v.canPower(d) ? v.effectiveDps(d) : 0;

  /// Powered DPS with [candidate] fitted in [slot] instead of what is there.
  double withDevice(WeaponSlot slot, Device candidate) {
    final fitted = v.getDevice(slot);
    var dps = powered(v) - (fitted == null ? 0 : _gun(fitted)) + _gun(candidate);
    // The drone mirrors the front gun at half strength.
    final drone = v.satellite;
    if (slot == WeaponSlot.frontGun && drone != null) {
      dps += v.effectiveDps(v.satelliteOf(candidate)) - v.effectiveDps(drone);
    }
    return dps;
  }

  /// [d] one level up, as a copy.
  static Device nextLevel(Device d) => Device.fromJson(d.toJson())..upgrade();

  /// The chip's delta, or null when it shows none (locked, or the fitted gun
  /// at max level). [fitted] / [hangar] are this chip's own devices, if any.
  ChipDelta? chip(WeaponSlot slot, DevType type,
      {Device? fitted, Device? hangar}) {
    final Device candidate;
    if (fitted != null) {
      if (fitted.level >= Device.maxLevel) return null;
      candidate = nextLevel(fitted);
    } else {
      candidate = hangar ?? Device.fromType(type, slot);
    }
    return ChipDelta(
      shown(powered(v), withDevice(slot, candidate)),
      powered: v.canPower(candidate),
    );
  }

  /// A delta as the screen shows it: the change of the rounded panel value,
  /// so the panel moves by exactly what the chip said.
  static int shown(double before, double after) =>
      after.round() - before.round();

  /// The `damage × rate` breakdown of [d] as fitted on this ship: damage per
  /// pull (beams already times their ticks) and pulls per second. Their
  /// product is the gun's DPS.
  ({double damage, double rate}) breakdown(Device d) {
    final plan = v.planFor(d);
    if (plan.cooldown <= 0) return (damage: 0, rate: 0);
    return (damage: plan.dpsFor(d) * plan.cooldown, rate: 1 / plan.cooldown);
  }
}

class ChipDelta {
  final int value;

  /// False when the generator could not power the gun: shown as a warning.
  final bool powered;

  const ChipDelta(this.value, {required this.powered});
}

import '../entities/vessel.dart';
import 'dev_type.dart';
import 'device.dart';

/// Plan 32 Q4: what a purchase, an upgrade or a switch would do to the
/// ship's DPS, worked out on copies — the ship is never touched.
///
/// The basis is [Vessel.poweredDps]: the DPS of the weapons the generator
/// can power. STATS, the HUD and every delta use it, so the numbers never
/// contradict each other. `Vessel.totalDps` (which feeds `lastMaxDps` and
/// the VB6 enemy scaling) stays as it is.
class DpsPreview {
  final Vessel v;
  const DpsPreview(this.v);

  bool _canPower(Device d) => d.pwrNeed <= v.genMax;

  /// [d]'s share of [Vessel.poweredDps] once fitted.
  double _gun(Device d) => _canPower(d) ? d.dps : 0;

  /// Powered DPS with [candidate] fitted in [slot] instead of what is there.
  double withDevice(WeaponSlot slot, Device candidate) {
    final fitted = v.getDevice(slot);
    return v.poweredDps - (fitted == null ? 0 : _gun(fitted)) + _gun(candidate);
  }

  /// [d] one level up, as a copy.
  static Device nextLevel(Device d) => Device.fromJson(d.toJson())..upgrade();

  /// The chip's delta, or null when it shows none (the fitted gun at max
  /// level). [fitted] / [hangar] are this chip's own devices, if any.
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
      shown(v.poweredDps, withDevice(slot, candidate)),
      powered: _canPower(candidate),
    );
  }

  /// A delta as the screen shows it: the change of the rounded panel value,
  /// so the panel moves by exactly what the chip said.
  static int shown(double before, double after) =>
      after.round() - before.round();

  /// The `damage × rate` breakdown of [d]: damage per shot (beams times
  /// their ticks, as in [Device.dps]) and shots per second. Their product is
  /// [Device.dps].
  static ({double damage, double rate}) breakdown(Device d) {
    if (d.cooldown <= 0) return (damage: 0, rate: 0);
    final damage = d.beam > 0 ? d.damage * d.seqs : d.damage;
    return (damage: damage.toDouble(), rate: 1 / d.cooldown);
  }
}

class ChipDelta {
  final int value;

  /// False when the generator could not power the gun: shown as a warning.
  final bool powered;

  const ChipDelta(this.value, {required this.powered});
}

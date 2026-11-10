import 'dart:math' as math;

import '../../game/game_config.dart' as config;
import '../dev_type.dart';
import '../device.dart';
import 'mod_spec.dart';

/// What one trigger pull of one gun produces, after mods. Built by the vessel
/// for each [Device.fire]; a gun with no mods gets a plan that reproduces the
/// pre-mod shot exactly (one stream, no fan, no salvo, the device's numbers).
class ShotPlan {
  final ModEffects fx;
  final int streams;
  final int fan;

  /// Angle of the outermost fan shot, radians, already scaled for the slot
  /// (side guns fan two thirds as wide).
  final double fanAngle;
  final int salvo;
  final int damage;
  final double speed;
  final double projScaleMul;
  final double drawScaleAdd;
  final double pwrNeed;
  final double cooldown;
  final int guide;

  const ShotPlan._({
    required this.fx,
    required this.streams,
    required this.fan,
    required this.fanAngle,
    required this.salvo,
    required this.damage,
    required this.speed,
    required this.projScaleMul,
    required this.drawScaleAdd,
    required this.pwrNeed,
    required this.cooldown,
    required this.guide,
  });

  /// Gap between salvo shots, seconds (6 frames at the VB6 40 fps, the same
  /// rhythm as the enemy burst pattern).
  static const salvoGap = 0.15;

  /// Narrowest spacing of parallel streams, px. The gun spaces them by the
  /// drawn width of its shot (Device._emit), so two bubbles never sit on top
  /// of each other and read as one.
  static const minStreamGap = 10.0;

  /// Most beams one laser draws.
  static const maxRays = 5;

  /// Cap on live player shots across the whole field. A gun that would go
  /// over it skips the pull, the same way it does when power runs short.
  static const maxLiveShots = 360;

  factory ShotPlan.of(Device d, ModEffects fx) {
    final side = d.slot == WeaponSlot.leftGun || d.slot == WeaponSlot.rightGun;
    return ShotPlan._(
      fx: fx,
      streams: fx.streams,
      fan: fx.fan,
      fanAngle: fx.fanAngle * math.pi / 180 * (side ? 2 / 3 : 1),
      salvo: fx.salvo,
      damage: (d.damage * fx.dmgMul).round(),
      speed: d.speed * fx.speedMul,
      projScaleMul: fx.projScaleMul,
      drawScaleAdd: fx.drawScaleAdd,
      pwrNeed: d.pwrNeed * fx.pwrMul,
      cooldown: d.cooldown / fx.cooldownDiv,
      guide: d.guide + fx.guideAdd,
    );
  }

  /// Most parallel streams any plan fires: four from mods, two more from
  /// OVERSTREAM (Prompts/28 §7).
  static const maxStreams = 6;

  /// This plan in a sigil's hands: OVERSTREAM [gear] adds streams and costs
  /// more per shot, FRENZY shortens the cooldown, STORM makes it free.
  ShotPlan shifted({int gear = 1, double cooldownMul = 1, double pwrMul = 1}) {
    final g = gear.clamp(1, config.overstreamCost.length);
    return ShotPlan._(
      fx: fx,
      streams: math.min(streams + g - 1, maxStreams),
      fan: fan,
      fanAngle: fanAngle,
      salvo: salvo,
      damage: damage,
      speed: speed,
      projScaleMul: projScaleMul,
      drawScaleAdd: drawScaleAdd,
      pwrNeed: pwrNeed * config.overstreamCost[g - 1] * pwrMul,
      cooldown: cooldown * cooldownMul,
      guide: guide,
    );
  }

  /// Shots of one pull of a projectile gun, salvo included.
  int get shotsPerPull => streams * fan * salvo;

  /// Beams one pull of a laser draws.
  int get rays => (streams * fan).clamp(1, maxRays);

  /// Angle from straight ahead of fan shot [j] of [fan], radians; negative
  /// leans left.
  double fanAngleAt(int j) {
    if (fan <= 1) return 0;
    final half = (fan - 1) / 2;
    return fanAngle * (j - half) / half;
  }

  /// Horizontal offset of stream [i] of [streams], [gap] apart.
  double streamOffset(int i, [double gap = minStreamGap]) =>
      (i - (streams - 1) / 2) * gap;

  /// Damage per second this plan sustains, before power limits. Beams count
  /// every ray and every animation step, like [Device.dps].
  double dpsFor(Device d) {
    if (cooldown <= 0) return 0;
    if (d.beam > 0) return damage * d.seqs * rays / cooldown;
    final crit = 1 + fx.critChance * (fx.critMul - 1);
    return damage * shotsPerPull * crit / cooldown;
  }
}

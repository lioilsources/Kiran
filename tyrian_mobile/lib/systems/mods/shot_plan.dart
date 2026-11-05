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

  /// Sideways speed of the outermost fan shot, px/frame, already scaled for
  /// the slot (side guns fan two thirds as wide).
  final double fanVx;
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
    required this.fanVx,
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

  /// Spacing of parallel streams, px.
  static const streamGap = 10.0;

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
      fanVx: fx.fanVx * (side ? 2 / 3 : 1),
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

  /// Shots of one pull of a projectile gun, salvo included.
  int get shotsPerPull => streams * fan * salvo;

  /// Beams one pull of a laser draws.
  int get rays => (streams * fan).clamp(1, maxRays);

  /// Sideways speed of fan shot [j] of [fan].
  double fanVxAt(int j) {
    if (fan <= 1) return 0;
    final half = (fan - 1) / 2;
    return fanVx * (j - half) / half;
  }

  /// Horizontal offset of stream [i] of [streams].
  double streamOffset(int i) => (i - (streams - 1) / 2) * streamGap;

  /// Damage per second this plan sustains, before power limits. Beams count
  /// every ray and every animation step, like [Device.dps].
  double dpsFor(Device d) {
    if (cooldown <= 0) return 0;
    if (d.beam > 0) return damage * d.seqs * rays / cooldown;
    final crit = 1 + fx.critChance * (fx.critMul - 1);
    return damage * shotsPerPull * crit / cooldown;
  }
}

import 'package:flutter/painting.dart';

import '../l10n/l10n.dart';
import '../systems/mods/hull_spec.dart';
import '../systems/mods/mod_spec.dart';
import '../systems/weapon_family.dart';

/// Player-facing text for mods and hulls. A mod's name is a proper noun and
/// never translated; what it does is assembled from its effect numbers, so a
/// retuned mod describes itself correctly without anyone editing a string.
abstract final class ModText {
  static String _x(double v) {
    final s = v.toStringAsFixed(2);
    return s.endsWith('0') ? v.toStringAsFixed(1) : s;
  }

  static int _pct(double v) => (v * 100).round();

  static List<String> effectLines(ModEffects e, AppLocalizations l) {
    const n = ModEffects.none;
    return [
      if (e.streams != n.streams) l.fxStreams(e.streams),
      if (e.fan != n.fan) l.fxFan(e.fan),
      if (e.salvo != n.salvo) l.fxSalvo(e.salvo),
      if (e.cooldownDiv != n.cooldownDiv) l.fxFireRate(_x(e.cooldownDiv)),
      if (e.dmgMul != n.dmgMul) l.fxDamage(_x(e.dmgMul)),
      if (e.speedMul != n.speedMul) l.fxShotSpeed(_x(e.speedMul)),
      if (e.projScaleMul != n.projScaleMul) l.fxShotSize(_x(e.projScaleMul)),
      if (e.guideAdd != n.guideAdd) l.fxHoming(e.guideAdd),
      if (e.pierce > 0) l.fxPierce(e.pierce),
      if (e.pierce < 0) l.fxPierceAll,
      if (e.critChance > 0) l.fxCrit(_pct(e.critChance), _x(e.critMul)),
      if (e.bossCritMul > 0) l.fxBossCrit(_x(e.bossCritMul)),
      if (e.forkCount > 0) l.fxFork(e.forkCount),
      if (e.forkDepth > 1) l.fxChain,
      if (e.split) l.fxSplit,
      if (e.frostSec > 0) l.fxFrost,
      if (e.crossfire) l.fxCrossfire,
      if (e.rearguard) l.fxRearguard,
      if (e.orbit) l.fxOrbit,
      if (e.bounces > 0) l.fxBounce(e.bounces),
      if (e.bounceTop) l.fxBounceTop,
      if (e.overdrive) l.fxOverdrive,
      if (e.reactor) l.fxReactor,
      if (e.genPowerMul != n.genPowerMul) l.fxGenPower(_x(e.genPowerMul)),
      if (e.genMaxMul != n.genMaxMul) l.fxGenMax(_x(e.genMaxMul)),
      if (e.surge) l.fxSurge,
      if (e.siphon > 0) l.fxSiphon(_pct(e.siphon)),
      if (e.hpMul != n.hpMul) l.fxHp(_x(e.hpMul)),
      if (e.shieldMul != n.shieldMul) l.fxShield(_x(e.shieldMul)),
      if (e.regenMul != n.regenMul) l.fxRegen(_x(e.regenMul)),
      if (e.leechHp > 0) l.fxLeech(e.leechHp),
      if (e.magnetRadius > 0 && e.magnetRadius < 1000) l.fxMagnet,
      if (e.magnetRadius >= 1000) l.fxMagnetAll,
      if (e.reflectChance > 0) l.fxReflect(_pct(e.reflectChance)),
      if (e.reflectGuided) l.fxReflectGuided,
      if (e.ghostSec > 0) l.fxGhost(_x(e.ghostSec)),
      if (e.nova) l.fxNova,
      if (e.agilityMul != n.agilityMul) l.fxAgility(_x(e.agilityMul)),
      if (e.hitboxMul != n.hitboxMul) l.fxHitbox(_x(e.hitboxMul)),
      if (e.creditMul != n.creditMul) l.fxCredits(_x(e.creditMul)),
      if (e.scoreMul != n.scoreMul) l.fxScore(_x(e.scoreMul)),
      if (e.satellite) l.fxSatellite,
      if (e.timewarp) l.fxTimewarp,
      if (e.gambler) l.fxGambler,
      // Power last: it is the price of everything above it.
      if (e.pwrMul != n.pwrMul) l.fxPower(_x(e.pwrMul)),
    ];
  }

  static String rarity(ModRarity r, AppLocalizations l) => switch (r) {
    ModRarity.common => l.rarityCommon,
    ModRarity.rare => l.rarityRare,
    ModRarity.mythic => l.rarityMythic,
  };

  static Color rarityColor(ModRarity r) => switch (r) {
    ModRarity.common => const Color(0xFFD8D8D8),
    ModRarity.rare => const Color(0xFF4FA8FF),
    ModRarity.mythic => const Color(0xFFFFC23A),
  };

  static const curseColor = Color(0xFFFF4D4D);

  static Color colorOf(ModSpec m) =>
      m.curse ? curseColor : rarityColor(m.rarity);

  static String families(Set<WeaponFamily> f) => f
      .map((e) => e == WeaponFamily.starg ? 'STAR' : e.name.toUpperCase())
      .join(', ');

  static String perk(HullPerk p, AppLocalizations l) => switch (p) {
    HullPerk.none => l.perkNone,
    HullPerk.afterimage => l.perkAfterimage,
    HullPerk.bulwark => l.perkBulwark,
    HullPerk.overclock => l.perkOverclock,
    HullPerk.battery => l.perkBattery,
  };

  /// How a locked hull is won.
  static String hullUnlock(String id, AppLocalizations l) => switch (id) {
    'dart' => l.hullUnlockBoss(1),
    'bastion' => l.hullUnlockBoss(2),
    'dynamo' => l.hullUnlockBoss(3),
    _ => l.hullUnlockFinish,
  };
}

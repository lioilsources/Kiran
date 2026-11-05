import 'dart:math';

import 'package:flame/components.dart';
import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../ui/format.dart';
import '../services/achievement_service.dart';
import '../services/sound_service.dart';
import 'dev_type.dart';
import '../entities/projectile.dart';
import '../entities/vessel.dart';
import '../entities/hostile.dart';
import '../l10n/l10n.dart';
import 'mods/mod_spec.dart';
import 'mods/shot_plan.dart';

/// Ported from Device.cls — a weapon instance equipped on a vessel or hostile.
class Device {
  String name;
  String displayName;
  String imgName;
  int price;
  double upgCost;
  int level = 0;
  WeaponSlot slot;
  int damage;
  int speed;
  int guide;
  double pwrNeed;
  double pwrGen;
  double cooldown; // seconds
  int beam;
  int beamActive = 0;
  int seqs;
  int xShift = 0;
  int xShiftMax;
  int xShiftDir = 1;
  bool scaleProjectile;
  double minProjScale;
  double maxProjScale;

  // Beam coordinates
  double sx = 0, sy = 0, dx = 0, dy = 0;

  /// Beams the current pull draws (WIDE, TRIPLE on a laser) and what each
  /// tick of them hits for. Ray 0 is [dx],[dy]; the others aim at
  /// [extraBeamTargets], filled by the vessel's beam pass.
  int beamRays = 1;
  int beamDamage = 0;
  ShotPlan? beamPlan;
  final List<Vector2> extraBeamTargets = [];

  // SALVO shots still to come from the last pull.
  int _salvoLeft = 0;
  double _salvoTimer = 0;
  ShotPlan? _salvoPlan;
  double _salvoDmg = 0;

  // Cooldown timer
  double cd = 0;

  // Active projectiles
  final List<Projectile> projectiles = [];

  // Object pool for projectile reuse
  final List<Projectile> _pool = [];

  // Parent references
  Vessel? parentVessel;
  Hostile? parentHostile;

  Device({
    required this.name,
    required this.displayName,
    required this.imgName,
    required this.slot,
    this.damage = 10,
    this.speed = 5,
    this.guide = 0,
    this.pwrNeed = 1.0,
    this.pwrGen = 0.0,
    this.cooldown = 0.25,
    this.beam = 0,
    this.seqs = 0,
    this.xShiftMax = 0,
    this.price = 100,
    this.upgCost = 0.1,
    this.scaleProjectile = false,
    this.minProjScale = 1.0,
    this.maxProjScale = 1.0,
  });

  /// Serialize mutable state for save persistence. Immutable traits (guide,
  /// beam, seqs, imgName, scaleProjectile, …) are recovered from the DevType
  /// looked up by [name] on restore.
  Map<String, dynamic> toJson() => {
        'name': name,
        'slot': slot.index,
        'level': level,
        'damage': damage,
        'pwrNeed': pwrNeed,
        'cooldown': cooldown,
        'price': price,
        'displayName': displayName,
        'pwrGen': pwrGen,
      };

  /// Restore a Device from saved JSON. Starts from the matching DevType
  /// template (immutable traits) and overwrites the upgraded/mutable fields.
  /// Does NOT replay upgrade() — generator genMax is persisted on the Vessel,
  /// so replaying would double-apply it.
  factory Device.fromJson(Map<String, dynamic> json) {
    final slot = WeaponSlot.values[json['slot'] as int];
    final type = DevType.byName(json['name'] as String) ?? DevType.bubbleGun;
    final device = Device.fromType(type, slot);
    device.level = json['level'] as int;
    device.damage = json['damage'] as int;
    device.pwrNeed = (json['pwrNeed'] as num).toDouble();
    device.cooldown = (json['cooldown'] as num).toDouble();
    device.price = json['price'] as int;
    device.displayName = json['displayName'] as String? ?? device.name;
    device.pwrGen = (json['pwrGen'] as num).toDouble();
    return device;
  }

  /// Create a Device from a DevType template
  factory Device.fromType(DevType type, WeaponSlot slot) {
    return Device(
      name: type.name,
      displayName: type.name,
      imgName: type.imgName,
      slot: slot,
      damage: type.damage,
      speed: type.speed,
      guide: type.guide,
      pwrNeed: type.pwrNeed,
      pwrGen: type.pwrGen,
      cooldown: type.cooldownSeconds,
      beam: type.beam,
      seqs: type.seqs,
      xShiftMax: type.xShiftMax,
      price: type.price,
      upgCost: type.upgCost,
      scaleProjectile: type.scaleProjectile,
      minProjScale: type.minProjScale,
      maxProjScale: type.maxProjScale,
    );
  }

  /// Port of Device.Create — fire weapon, create projectile or activate beam.
  ///
  /// [plan] is what the vessel's mods make of this pull; null fires the plain
  /// VB6 shot. [dmgBonus] stacks the pull-wide bonuses (SURGE, the DART's
  /// afterimage). [liveShots] is the field's current player-shot count, for
  /// the [ShotPlan.maxLiveShots] cap. Returns the shots spawned now.
  int fire(double vesselX, double vesselY, double vesselXm, double vesselWidth,
      Component world,
      {double fireRateMult = 1.0,
      ShotPlan? plan,
      double dmgBonus = 1.0,
      int liveShots = 0}) {
    // The generator is not a gun. It sits in the same devices list as the
    // weapons (Vessel.equipWeapon) and Vessel.update fires that list without
    // looking at slots, so without this it went off every ten seconds: a
    // fireBullet click, one unit of the power it had just generated spent,
    // and an invisible 10-damage projectile — invisible because its imgName
    // pointed at a 'generator' sprite no skin has ever contained, leaving
    // Projectile._loadSprite on its 6x12 fallback hitbox.
    if (slot == WeaponSlot.generator) return 0;

    if (cd > 0) return 0;

    final pl = plan ?? ShotPlan.of(this, ModEffects.none);
    if (beam == 0 && liveShots + pl.shotsPerPull > ShotPlan.maxLiveShots) {
      return 0;
    }

    // Power. A gun that needs more than the generator holds never fires,
    // unless REACTOR or the DYNAMO hull lets it fire off a full generator,
    // slowly; OVERDRIVE may run the generator a little into debt.
    var cdMul = 1.0;
    var cdFloor = 0.0;
    final v = parentVessel;
    if (v != null) {
      final cost = pl.pwrNeed;
      if (cost <= v.genValue) {
        v.genValue -= cost;
      } else if (cost > v.genMax && v.overreach(cost) != null) {
        if (v.genValue < v.genMax * 0.999) return 0;
        v.genValue = 0;
        final o = v.overreach(cost)!;
        cdMul = o.cooldownMul;
        cdFloor = o.cooldownFloor;
      } else if (pl.fx.overdrive &&
          v.genValue - cost >= -config.modOverdriveDebt * v.genMax) {
        v.genValue -= cost;
      } else {
        return 0;
      }
    }

    cd = pl.cooldown * cdMul / fireRateMult.clamp(0.1, 1.0);
    if (cd < cdFloor) cd = cdFloor;
    final dmg = pl.damage * dmgBonus;

    if (beam > 0) {
      beamActive = seqs;
      beamRays = pl.rays;
      beamDamage = dmg.round();
      beamPlan = pl;
      SoundService.instance.play(SfxEvent.fireBeam);
      return 0;
    }

    SoundService.instance.play(SfxEvent.fireBullet);
    var spawned = _emit(pl, dmg, vesselX, vesselY, vesselXm, vesselWidth, world);
    if (pl.salvo > 1) {
      _salvoLeft = pl.salvo - 1;
      _salvoTimer = ShotPlan.salvoGap;
      _salvoPlan = pl;
      _salvoDmg = dmg;
    }
    return spawned;
  }

  /// Fire the queued SALVO shots that are due, from where the ship is now.
  void updatePending(double dt, double vesselX, double vesselY,
      double vesselXm, double vesselWidth, Component world) {
    if (_salvoLeft <= 0) return;
    _salvoTimer -= dt;
    if (_salvoTimer > 0) return;
    _salvoLeft--;
    _salvoTimer = ShotPlan.salvoGap;
    _emit(_salvoPlan!, _salvoDmg, vesselX, vesselY, vesselXm, vesselWidth,
        world);
  }

  /// One volley of [pl]: every stream × every fan shot, plus REARGUARD.
  int _emit(ShotPlan pl, double dmg, double vesselX, double vesselY,
      double vesselXm, double vesselWidth, Component world) {
    _world = world;
    // Calculate spawn position based on slot
    double px, py;
    switch (slot) {
      case WeaponSlot.frontGun:
        px = vesselXm;
        py = vesselY - 5; // 5px gap above gun nozzle tip
      case WeaponSlot.leftGun:
        px = vesselX;
        py = vesselY + 18;
      case WeaponSlot.rightGun:
        px = vesselX + vesselWidth;
        py = vesselY + 18;
      default:
        px = vesselXm;
        py = vesselY;
    }

    // Apply xShift wave effect (VB6: step of 7 per shot)
    if (xShiftMax != 0) {
      px += xShift;
      xShift += xShiftDir * 14;
      if (xShift.abs() >= xShiftMax) xShiftDir = -xShiftDir;
    }

    // Scale based on level
    double scale = minProjScale;
    if (scaleProjectile && config.maxWeapLevel > 0) {
      scale = minProjScale +
          (maxProjScale - minProjScale) / config.maxWeapLevel * level;
    }
    scale *= pl.projScaleMul;

    final lean = !pl.fx.crossfire
        ? 0.0
        : switch (slot) {
            WeaponSlot.leftGun => config.modCrossfireVx,
            WeaponSlot.rightGun => -config.modCrossfireVx,
            _ => 0.0,
          };

    var n = 0;
    for (var i = 0; i < pl.streams; i++) {
      for (var j = 0; j < pl.fan; j++) {
        spawnShot(px + pl.streamOffset(i), py,
            vx: pl.fanVxAt(j) + lean,
            speed: -pl.speed,
            damage: dmg,
            scale: scale,
            plan: pl,
            world: world);
        n++;
      }
    }
    if (pl.fx.rearguard &&
        (slot == WeaponSlot.leftGun || slot == WeaponSlot.rightGun)) {
      spawnShot(px, py + 10,
          speed: pl.speed,
          damage: dmg * config.modRearguardDmg,
          scale: scale,
          plan: pl,
          world: world);
      n++;
    }
    return n;
  }

  static final Random _rng = Random();

  /// Where this gun's shots live; remembered for shots spawned off a hit.
  Component? _world;

  /// GAMBLER's draw: any projectile family, its damage between half and
  /// double. The beam is left out — a laser sprite fired as a bullet reads
  /// as a bug, not a gamble.
  static const _gamblerImgs = ['bubble', 'vulcan', 'blaster', 'starg'];

  /// One player shot from this device's pool. Used by the gun itself and by
  /// the hit path for FORK, SPLIT and reflected shots, which is why it takes
  /// its numbers as arguments rather than reading the device.
  Projectile spawnShot(double x, double y,
      {double vx = 0,
      required double speed,
      required double damage,
      required double scale,
      ShotPlan? plan,
      int depth = 0,
      String? img,
      Component? world}) {
    var sprite = img ?? imgName;
    var dmg = damage;
    if (plan != null && plan.fx.gambler && img == null) {
      sprite = _gamblerImgs[_rng.nextInt(_gamblerImgs.length)];
      dmg *= 0.5 + _rng.nextDouble() * 1.5;
    }
    Projectile proj;
    if (_pool.isNotEmpty) {
      proj = _pool.removeLast();
      proj.imgName = sprite;
      proj.activate(x, y, speed, dmg, scale);
    } else {
      proj = Projectile(
        imgName: sprite,
        position: Vector2(x, y),
        speed: speed,
        damage: dmg,
        scale: scale,
        parentDevice: this,
      );
      (world ?? _world ?? parentVessel?.parent)?.add(proj);
    }
    proj.vx = vx;
    proj.applyPlan(plan, depth: depth);
    projectiles.add(proj);
    return proj;
  }

  /// Update cooldown timer
  void updateCooldown(double dt) {
    if (cd > 0) {
      cd -= dt;
      if (cd < 0) cd = 0;
    }
    if (beamActive > 0) {
      beamActive--;
    }
  }

  /// Return projectile to pool
  void returnToPool(Projectile p) {
    projectiles.remove(p);
    p.deactivate();
    _pool.add(p);
  }

  static const maxLevel = 25;

  static const _roman = [
    '', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X',
    'XI', 'XII', 'XIII', 'XIV', 'XV', 'XVI', 'XVII', 'XVIII', 'XIX', 'XX',
    'XXI', 'XXII', 'XXIII', 'XXIV', 'XXV',
  ];

  /// Port of Device.Upgrade
  void upgrade() {
    if (level >= maxLevel) {
      // VB6: max level converts to credit/score bonus based on sector level
      if (parentVessel != null) {
        final sectorLevel = parentVessel!.lvlNum;
        int bonus;
        if (sectorLevel <= 1) {
          bonus = 25000;
        } else if (sectorLevel >= 40) {
          bonus = 5000000;
        } else {
          bonus = sectorLevel * 125000;
        }
        parentVessel!.addScore(bonus);
        parentVessel!.credit += bonus;
        (parentVessel! as HasGameReference<TyrianGame>)
            .game
            .showMessage(L10n.current.maxLevelSold(fmtNum(bonus)));
      }
      return;
    }
    damage = (damage * config.upgDamageMultiplier).round();
    pwrNeed *= config.upgPwrNeedMultiplier;
    cooldown /= config.upgCooldownDivisor;
    level++;
    price = (price * (1 + upgCost)).round();
    // VB6: update displayName with roman numeral
    displayName = '$name ${_roman[level]}';
    if (parentVessel != null) {
      AchievementService.instance.onWeaponLevel(name, level);
    }

    if (pwrGen > 0 && parentVessel != null) {
      pwrGen *= config.upgPwrGenMultiplier;
      // VB6 Device.Upgrade: vessel.genPower tracks the generator's new pwrGen so
      // both recharge rate (RechargeGenerator) and GeneratorLoad reflect the
      // upgrade. Without this, the shop upgrade only raised genMax and the load
      // of currently-assigned weapons never dropped.
      parentVessel!.genPower = pwrGen * parentVessel!.genPowerMul;
      parentVessel!.genMax *= config.upgGenMaxMultiplier;
    }
  }

  /// Calculate DPS (VB6: beam weapons multiply by seqs)
  double get dps {
    if (cooldown <= 0) return 0;
    if (beam > 0) return damage * seqs / cooldown;
    return damage / cooldown;
  }

  /// Cleanup all projectiles
  void clearProjectiles() {
    _salvoLeft = 0;
    for (final p in projectiles) {
      p.removeFromParent();
    }
    projectiles.clear();
    for (final p in _pool) {
      p.removeFromParent();
    }
    _pool.clear();
  }
}

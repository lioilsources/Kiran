import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../services/achievement_service.dart';
import '../services/sound_service.dart';
import '../services/pilot_name_generator.dart';
import '../systems/device.dart';
import '../systems/dev_type.dart';
import '../systems/weapon_family.dart';
import '../services/asset_library.dart';
import '../rendering/dissolve_effect.dart';
import '../systems/mods/hull_spec.dart';
import '../systems/mods/mod_rack.dart';
import '../systems/mods/mod_spec.dart';
import '../systems/mods/mods_state.dart';
import '../systems/mods/shot_plan.dart';
import 'boss.dart';
import 'hostile.dart';
import 'projectile.dart';
import '../ui/float_text.dart';
import '../l10n/l10n.dart';

/// Ported from Vessel.cls — the player's ship.
class Vessel extends PositionComponent
    with HasGameReference<TyrianGame> {
  String pilotName = 'Pilot';
  int playerIndex; // 0=P1, 1=P2

  // Stats (VB6 Vessel.cls ResetVessel defaults)
  int hp = 125;
  int hpMax = 125;
  double shield = 100;
  double shieldMax = 100;
  double shieldRegen = 0.1;
  double genValue = 100;
  double genMax = 100;
  double genPower = 4;
  int credit = 0;
  int score = 0;
  int lvlNum = 1;
  bool fire = false;
  double fireRateMult = 1.0; // 0.0–1.0; scales weapon cooldown (RT analog control)
  int dmgTaken = 0; // Damage flash counter

  // Asteroid ram combo — escalating collision punishment. Consecutive rams
  // within _asteroidComboWindow seconds ramp up: 1st drops shields, 2nd costs
  // half of max HP, 3rd is fatal. The window resets once it lapses.
  int _asteroidComboStage = 0;
  double _asteroidComboTimer = 0;
  static const double _asteroidComboWindow = 3.0; // seconds to chain rams

  // Weapons
  final List<Device> devices = [];

  /// Owned but not fitted. Each entry keeps its slot and level, so switching
  /// back to it in the ComCenter costs nothing and loses no upgrades. Hangar
  /// devices never fire and never count toward [generatorLoad] or [totalDps];
  /// co-op peers only ever see [devices].
  final List<Device> hangar = [];
  bool guidedWeapon = false;
  Hostile? closestEnemy;
  int nextWeaponLevel = 0;

  // ── Mods and hull (Prompts/27) ──
  HullSpec hull = HullSpec.falcon;
  final Map<RackKind, ModRack> racks = {
    for (final r in RackKind.values) r: ModRack(r, HullSpec.falcon.socketsFor(r)),
  };

  /// Ship-wide effects: the GEN and HULL racks stacked. Also folded into every
  /// gun's plan, which is how FLUX and GLASS reach the weapons.
  ModEffects mods = ModEffects.none;

  /// Plans' mod stacks per (rack, family), rebuilt by [refreshMods].
  final Map<String, ModEffects> _gunFx = {};

  /// Stat multipliers currently baked into hpMax, shieldMax, … . The fields
  /// keep their meaning everywhere (HUD, pickups, upgrades); [refreshMods]
  /// rescales them when the hull or racks change, and the save stores them
  /// divided back out.
  _StatMul _applied = const _StatMul();

  /// Gun drone (SATELLITE, the COLOSSUS hull). Kept out of [devices] so it
  /// never counts toward the generator, DPS, the shop or the co-op state.
  Device? satellite;
  double _satT = 0;
  final Random _rng = Random();

  double _stillTime = 0;
  double _prevX = double.nan, _prevY = double.nan;
  double _fullGenTime = 0;
  double _ghostTimer = 0;
  double _novaCd = 0;
  double _timewarpCd = 0;

  // VB6 Vessel.WepLevScores — score thresholds for weapon tier unlocks
  static const wepLevScores = [0, 400000, 4000000, 14000000];

  // DPS tracking for random sector scaling (VB6 rocket.lastMaxDps)
  double lastMaxDps = 0;

  // Dissolve shader effect (visual damage at low HP)
  final DissolveEffect dissolveEffect = DissolveEffect();

  // Sprite / animation
  Sprite? _sprite;
  List<Sprite> _frames = [];
  int _frameIndex = 0;
  int _frameDir = 1; // +1 forward, -1 backward (ping-pong)
  double _frameTimer = 0;
  static const _frameDuration = 0.12; // seconds per frame
  bool visible = true;

  /// Visual banking state (-1..1), driven by lateral movement. Purely
  /// cosmetic — read by TyrianGame for the opposite world shift.
  double bank = 0;
  double _prevBankX = double.nan;

  /// Visual-only depth pulse (Feature 2 experiment). Applied as a canvas scale
  /// about the sprite centre in render(); never touches [size], so collisions
  /// and beam/nozzle offsets stay exact.
  double visualScale = 1.0;
  double _depthTime = 0.0;

  /// Y offset from position.y to front gun nozzle tip (negative = above center).
  /// Computed from sprite alpha at load time to handle skins with transparent padding.
  double _gunNozzleOffsetY = 0.0;

  Vessel({this.playerIndex = 0}) : super(anchor: Anchor.center);

  Future<void> init() async {
    _loadFrames();
    await dissolveEffect.load();

    // Default weapon: Bubble Gun
    equipWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    equipWeapon(DevType.generatorBasic, WeaponSlot.generator);
  }

  void _loadFrames() {
    _frames = List.of(AssetLibrary.instance.vesselFramesFor(hull.id));
    if (_frames.isNotEmpty) {
      _sprite = _frames[0];
      _frameIndex = 0;
      _frameDir = 1;
    } else {
      _sprite = AssetLibrary.instance.getSprite('vessel');
    }
    if (_sprite != null) {
      size = _sprite!.srcSize * config.spriteScale;
    } else {
      size = Vector2(50, 40) * config.spriteScale;
    }
    _computeGunNozzleOffset();
  }

  /// Compute _gunNozzleOffsetY from sprite aspect ratio.
  ///
  /// Some skins (tyrian_dos, gradius_v, blazing_lazers) use a 32×128 canvas
  /// where the visible ship occupies only the middle ~27% (y=47–81 out of 128).
  /// Aspect ratio > 2:1 reliably identifies this format; for such sprites the
  /// gun nozzle sits at ~36.7% from the sprite top (= 0.133 × height above center).
  /// Normal sprites (aspect ratio ≤ 2:1) have the ship filling the canvas top-down,
  /// so the nozzle is at the sprite top (= −size.y/2 from center).
  void _computeGunNozzleOffset() {
    if (_sprite == null) {
      _gunNozzleOffsetY = 0;
      return;
    }
    final src = _sprite!.srcSize;
    final ar = src.y / src.x; // height:width aspect ratio
    if (ar > 2.0) {
      // Tall canvas with centered ship content (e.g. 32×128).
      // Ship visible from ~36.7% to ~63.3% of sprite height;
      // gun nozzle at 36.7% → offset from center = -(0.5 - 0.367) = -0.133
      _gunNozzleOffsetY = -size.y * 0.133;
    } else {
      // Normal canvas — gun nozzle at sprite top.
      _gunNozzleOffsetY = -size.y / 2;
    }
  }

  /// Re-fetch sprites from AssetLibrary after a skin change.
  void refreshSprite() {
    _loadFrames();
  }

  void resetPosition() {
    position.setValues(config.gameWidth / 2, config.gameHeight * 0.75);
  }

  void resetVessel() {
    hp = hpMax;
    shield = shieldMax;
    genValue = genMax;
    dmgTaken = 0;
    _asteroidComboStage = 0;
    _asteroidComboTimer = 0;
    fire = false;
    visible = true;
    bank = 0;
    _prevBankX = double.nan;
    for (final d in devices) {
      d.clearProjectiles();
    }
  }

  /// Full reset for new game — VB6 ResetVessel: all stats back to defaults
  ///
  /// [returnMods] sends what the racks hold back to the vault, which is right
  /// when this ship's save is about to be overwritten. Starting a campaign
  /// ship passes false: the mods on the endless ship stay in the endless
  /// save, which is where they are.
  void newGame({bool returnMods = true}) {
    AchievementService.instance.onRunStarted();
    score = 0;
    credit = 0;
    nextWeaponLevel = 0;
    lastMaxDps = 0;
    // Reset stat upgrades to VB6 defaults
    hpMax = 125;
    shieldMax = 100;
    shieldRegen = 0.1;
    genMax = 100;
    genPower = 4;
    lvlNum = 1;
    // Fresh run gets a new Ubuntu-style codename (player can rename in ComCenter)
    pilotName = PilotNameGenerator.randomCodename();
    for (final d in devices) {
      d.clearProjectiles();
    }
    devices.clear();
    hangar.clear();
    guidedWeapon = false;
    equipWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    equipWeapon(DevType.generatorBasic, WeaponSlot.generator);
    // A fresh run starts with empty racks; the mods go back to the vault,
    // which is the account's, not the run's. The hull is a choice, not
    // progress, and stays.
    if (returnMods) {
      returnModsToVault();
    } else {
      for (final r in racks.values) {
        r.fitted.clear();
      }
    }
    _applied = const _StatMul();
    refreshMods();
    resetVessel();
  }

  /// Serialize progress for save persistence (consumed by SaveService).
  Map<String, dynamic> toSaveMap() => {
        'pilotName': pilotName,
        'credit': credit,
        'score': score,
        'hp': hp,
        'hpMax': hpMax,
        'shield': shield,
        'shieldMax': shieldMax,
        'genMax': genMax,
        'genPower': genPower,
        'nextWeaponLevel': nextWeaponLevel,
        'weapons': devices.map((d) => d.toJson()).toList(),
        'hangar': hangar.map((d) => d.toJson()).toList(),
        'hull': hull.id,
        'racks': {for (final r in racks.values) r.kind.name: r.toJson()},
      }..addAll(_baseStats());

  /// The stat fields with the mod multipliers divided back out, so a save
  /// never bakes a mod into the ship.
  Map<String, dynamic> _baseStats() => {
        'hp': (hp / _applied.hp).round(),
        'hpMax': (hpMax / _applied.hp).round(),
        'shield': shield / _applied.shield,
        'shieldMax': shieldMax / _applied.shield,
        'shieldRegen': shieldRegen / _applied.regen,
        'genMax': genMax / _applied.genMax,
        'genPower': genPower / _applied.genPower,
      };

  /// Restore progress from a saved state map. Rebuilds the device list directly
  /// (no upgrade() replay — genMax is restored as-is to avoid double-applying).
  void loadFromSave(Map<String, dynamic> state) {
    pilotName = state['pilotName'] as String? ?? pilotName;
    credit = (state['credit'] as num?)?.toInt() ?? 0;
    score = (state['score'] as num?)?.toInt() ?? 0;
    hpMax = (state['hpMax'] as num?)?.toInt() ?? hpMax;
    hp = (state['hp'] as num?)?.toInt() ?? hpMax;
    shieldMax = (state['shieldMax'] as num?)?.toDouble() ?? shieldMax;
    shield = (state['shield'] as num?)?.toDouble() ?? shieldMax;
    genMax = (state['genMax'] as num?)?.toDouble() ?? genMax;
    genPower = (state['genPower'] as num?)?.toDouble() ?? genPower;
    // Weapon unlock tier: derive from score (VB6 WepLevScores), then take
    // whichever is higher — the persisted tier or the derivation. An unlock is
    // permanent, so a save written before the field existed still upgrades
    // correctly, and a cheat-granted tier is never silently revoked.
    nextWeaponLevel = 0;
    while (nextWeaponLevel < wepLevScores.length &&
        score > wepLevScores[nextWeaponLevel]) {
      nextWeaponLevel++;
    }
    final savedTier = (state['nextWeaponLevel'] as num?)?.toInt() ?? 0;
    if (savedTier > nextWeaponLevel) nextWeaponLevel = savedTier;

    for (final d in devices) {
      d.clearProjectiles();
    }
    devices.clear();
    final weapons = (state['weapons'] as List?) ?? const [];
    for (final w in weapons) {
      final device = Device.fromJson(Map<String, dynamic>.from(w as Map));
      device.parentVessel = this;
      devices.add(device);
    }
    // Saves written before the hangar existed simply have no key.
    hangar.clear();
    final stored = (state['hangar'] as List?) ?? const [];
    for (final w in stored) {
      final device = Device.fromJson(Map<String, dynamic>.from(w as Map));
      device.parentVessel = this;
      hangar.add(device);
    }
    // Always guarantee a front weapon and generator so the player can start.
    if (getDevice(WeaponSlot.frontGun) == null) {
      equipWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
    }
    if (getDevice(WeaponSlot.generator) == null) {
      equipWeapon(DevType.generatorBasic, WeaponSlot.generator);
    }
    shieldRegen = (state['shieldRegen'] as num?)?.toDouble() ?? shieldRegen;
    guidedWeapon = devices.any((d) => d.guide > 0);
    _loadMods(state);
    resetVessel();
  }

  void _loadMods(Map<String, dynamic> state) {
    hull = HullSpec.byId(state['hull'] as String?);
    final vault = ModsState.instance.vault;
    final stored = (state['racks'] as Map?) ?? const {};
    for (final r in racks.values) {
      r.fitted.clear();
      r.sockets = hull.socketsFor(r.kind);
      for (final e in (stored[r.kind.name] as List?) ?? const []) {
        final i = ModInstance.fromJson(Map<String, dynamic>.from(e as Map));
        if (i == null || r.fitted.length >= r.sockets) continue;
        r.fitted.add(i);
        // A crash between the vault save and this ship's save could leave a
        // mod in both places; the ship wins.
        vault.remove(i);
      }
    }
    _applied = const _StatMul();
    refreshMods();
  }

  // ── Mods ──

  Iterable<ModInstance> get fittedMods =>
      racks.values.expand((r) => r.fitted);

  /// Rack a gun slot's mods live in.
  static RackKind? rackFor(WeaponSlot slot) => switch (slot) {
        WeaponSlot.frontGun => RackKind.front,
        WeaponSlot.leftGun || WeaponSlot.rightGun => RackKind.side,
        WeaponSlot.satellite => RackKind.front,
        _ => null,
      };

  /// Fit [i] into rack [r]. The caller takes it out of the vault.
  FitRefusal? fitMod(ModInstance i, RackKind r) {
    final spec = i.spec;
    if (spec == null) return FitRefusal.wrongRack;
    final why = racks[r]!.refusal(spec);
    if (why != null) return why;
    racks[r]!.fitted.add(i);
    refreshMods();
    return null;
  }

  bool unfitMod(ModInstance i) {
    for (final r in racks.values) {
      if (r.fitted.remove(i)) {
        refreshMods();
        return true;
      }
    }
    return false;
  }

  /// Empty every rack into the vault.
  void returnModsToVault() {
    final vault = ModsState.instance.vault;
    for (final r in racks.values) {
      vault.addAll(r.fitted);
      r.fitted.clear();
    }
  }

  /// Switch hull. Mods past the new socket counts are returned (the caller
  /// puts them in the vault and says so).
  List<ModInstance> setHull(HullSpec h) {
    hull = h;
    final spill = <ModInstance>[];
    for (final r in racks.values) {
      r.sockets = h.socketsFor(r.kind);
      spill.addAll(r.trim());
    }
    refreshMods();
    _loadFrames();
    return spill;
  }

  /// Recompute everything that depends on the racks and the hull, and rescale
  /// the stat fields to the new multipliers.
  void refreshMods() {
    mods = ModEffects.combine([
      racks[RackKind.gen]!.combined(),
      racks[RackKind.hull]!.combined(),
    ]);
    _gunFx.clear();
    final target = _StatMul(
      hp: hull.hpMul * mods.hpMul,
      shield: hull.shieldMul * mods.shieldMul,
      regen: mods.regenMul,
      genPower: hull.genPowerMul * mods.genPowerMul,
      genMax: hull.genMaxMul * mods.genMaxMul,
    );
    if (target != _applied) {
      final r = target.over(_applied);
      hpMax = max(1, (hpMax * r.hp).round());
      hp = min(hpMax, (hp * r.hp).round());
      shieldMax *= r.shield;
      shield = min(shieldMax, shield * r.shield);
      shieldRegen *= r.regen;
      genPower *= r.genPower;
      genMax *= r.genMax;
      genValue = min(genMax, genValue * r.genMax);
      _applied = target;
    }
    _syncSatellite();
    guidedWeapon = devices.any((d) => effectiveGuide(d) > 0);
  }

  /// Multiplier the generator upgrade has to put back after it sets
  /// genPower absolutely (Device.upgrade).
  double get genPowerMul => _applied.genPower;

  ModEffects _fxFor(Device d) {
    final rack = rackFor(d.slot);
    if (rack == null) return mods;
    final family = weaponFamilyFromImgName(d.imgName);
    final key = '${rack.name}:${family?.name}';
    return _gunFx[key] ??=
        ModEffects.combine([racks[rack]!.combined(family), mods]);
  }

  ShotPlan planFor(Device d) => ShotPlan.of(d, _fxFor(d));

  int effectiveGuide(Device d) => d.guide + _fxFor(d).guideAdd;
  double effectivePwrNeed(Device d) => d.pwrNeed * _fxFor(d).pwrMul;
  double effectiveDps(Device d) => planFor(d).dpsFor(d);

  /// Whether a gun that needs [cost] — more than the generator holds — may
  /// still fire off a full generator, and how slowly. Null when it may not.
  ({double cooldownMul, double cooldownFloor})? overreach(double cost) {
    if (hull.perk == HullPerk.overclock &&
        cost <= genMax * HullSpec.overclockReach) {
      return (cooldownMul: config.modOverclockCooldown, cooldownFloor: 0.0);
    }
    if (mods.reactor) {
      return (cooldownMul: 1.0, cooldownFloor: config.modReactorCooldown);
    }
    return null;
  }

  /// Whether [d] can fire at all with this generator.
  bool canPower(Device d) {
    final cost = effectivePwrNeed(d);
    return cost <= genMax || overreach(cost) != null;
  }

  /// Keyboard/pad speed multiplier; touch stays 1:1.
  double get agility => hull.agility * mods.agilityMul;

  /// Size of the box enemy fire must hit, relative to the stock ship.
  double get hitboxScale => hull.hitbox * mods.hitboxMul;

  bool get _wantsSatellite => mods.satellite || hull.perk == HullPerk.battery;

  /// Keep the drone a half-strength copy of the front gun, free to fire.
  void _syncSatellite() {
    final front = getDevice(WeaponSlot.frontGun);
    if (!_wantsSatellite || front == null) {
      satellite?.clearProjectiles();
      satellite = null;
      return;
    }
    final s = satellite;
    if (s != null && s.name == front.name && s.level == front.level) return;
    s?.clearProjectiles();
    final type = DevType.byName(front.name) ?? DevType.bubbleGun;
    satellite = Device.fromType(type, WeaponSlot.satellite)
      ..level = front.level
      ..damage = max(1, (front.damage * config.modSatelliteDmg).round())
      ..cooldown = front.cooldown
      ..pwrNeed = 0
      ..parentVessel = this;
  }

  /// Every gun that puts shots on the field: the fitted devices and the drone.
  Iterable<Device> get guns =>
      satellite == null ? devices : [...devices, satellite!];

  /// Where the drone flies, in world coordinates.
  Vector2 get satellitePos => Vector2(
        position.x + cos(_satT * 1.6) * size.x * 0.9,
        position.y + size.y * 0.15,
      );

  /// After a kill landed by this ship: LEECH, SIPHON.
  void onKillFeedback(Hostile h) {
    if (mods.leechHp > 0) {
      final heal = h is BossPart || h is Boss
          ? (mods.leechHp * config.modLeechBossPart).round()
          : mods.leechHp;
      hp = min(hpMax, hp + heal);
    }
    if (mods.siphon > 0) {
      genValue = min(genMax, genValue + genMax * mods.siphon);
    }
  }

  /// REFLECT/MIRROR: an enemy shot meeting the shield may come back as ours.
  /// True when [p] was turned; the caller then drops it.
  bool tryReflect(Projectile p) {
    final chance = mods.reflectChance +
        (hull.perk == HullPerk.bulwark ? 0.1 : 0.0);
    if (chance <= 0 || shield <= 0 || _rng.nextDouble() >= chance) {
      return false;
    }
    final gun = getDevice(WeaponSlot.frontGun);
    if (gun == null) return false;
    final shot = gun.spawnShot(p.position.x + p.size.x / 2, p.position.y,
        speed: -config.modReflectSpeed,
        damage: p.damage * config.modReflectDmg,
        scale: 1.0,
        img: 'bubble');
    if (mods.reflectGuided) shot.guideOverride = config.modReflectGuide;
    return true;
  }

  /// Port of Vessel.AdjustPosition — move towards target
  void adjustPosition(double tx, double ty) {
    // Clamp to screen bounds
    final nx = tx.clamp(size.x / 2, config.gameWidth - size.x / 2);
    final ny = ty.clamp(size.y / 2, config.gameHeight - size.y / 2);
    position.setValues(nx, ny);

    // Update beam coordinates for beam weapons
    for (final d in devices) {
      if (d.beamActive > 0) {
        switch (d.slot) {
          case WeaponSlot.frontGun:
            d.sx = position.x;
            d.sy = position.y + _gunNozzleOffsetY - 5;
          case WeaponSlot.leftGun:
            d.sx = position.x - size.x / 2;
            d.sy = position.y + 18;
          case WeaponSlot.rightGun:
            d.sx = position.x + size.x / 2;
            d.sy = position.y + 18;
          default:
            d.sx = position.x;
            d.sy = position.y;
        }

        if (closestEnemy != null && !closestEnemy!.isDead) {
          d.dx = closestEnemy!.hostCenter.x;
          d.dy = closestEnemy!.hostCenter.y;
        } else {
          // Shoot straight up
          d.dx = d.sx;
          d.dy = 0;
        }
      }
    }
  }

  /// Port of Vessel.step — per-frame update
  @override
  void update(double dt) {
    if (!visible) return;

    // Animate sprite frames (runs on both host and client)
    if (_frames.length > 1) {
      _frameTimer += dt;
      if (_frameTimer >= _frameDuration) {
        _frameTimer -= _frameDuration;
        _frameIndex += _frameDir;
        if (_frameIndex >= _frames.length - 1) {
          _frameIndex = _frames.length - 1;
          _frameDir = -1;
        } else if (_frameIndex <= 0) {
          _frameIndex = 0;
          _frameDir = 1;
        }
        _sprite = _frames[_frameIndex];
      }
    }

    // Visual bank from lateral movement (runs on both host and client —
    // client positions come from snapshots and still produce deltas)
    if (dt > 0) {
      final dx = _prevBankX.isNaN ? 0.0 : position.x - _prevBankX;
      _prevBankX = position.x;
      double target = 0;
      if (dx.abs() < config.bankTeleportPx) {
        target = ((dx / dt) / config.bankFullSpeed).clamp(-1.0, 1.0);
      }
      bank = target + (bank - target) * exp(-config.bankResponse * dt);
      if (bank.abs() < 0.001) bank = 0;
    }

    // Visual-only depth breathing (runs on both host and client, like the frame
    // animation above). Leaves `size` untouched.
    if (config.depthPulseEnabled) {
      _depthTime += dt;
      final w = 2 * pi / config.vesselDepthPeriod;
      visualScale = 1.0 + config.vesselDepthAmplitude * sin(_depthTime * w);
    }

    // Client: positions set by snapshot, skip all game logic
    if (game.coopRole == CoopRole.client) return;

    final scaledDt = dt * config.originalFps;

    // Regenerate power
    if (genValue < genMax) {
      genValue += genPower * scaledDt;
      if (genValue > genMax) genValue = genMax;
    }

    // Regenerate shield
    if (shield < shieldMax && genValue > 0) {
      shield += shieldRegen * scaledDt;
      if (shield > shieldMax) shield = shieldMax;
    }

    _tickModTimers(dt);

    // Find closest enemy for guided weapons
    if (guidedWeapon) {
      _findClosestEnemy();
    }

    // Pull-wide bonuses: DART holding still, SURGE off a full generator.
    var bonus = 1.0;
    if (hull.perk == HullPerk.afterimage &&
        _stillTime >= HullSpec.afterimageDelay) {
      bonus *= HullSpec.afterimageDmg;
    }
    final surging = mods.surge && _fullGenTime >= config.modSurgeDelay;
    if (surging) bonus *= config.modSurgeDmg;
    var fired = false;
    var live = 0;
    for (final d in guns) {
      live += d.projectiles.length;
    }

    final gx = position.x - size.x / 2;
    final gy = position.y + _gunNozzleOffsetY; // gun nozzle Y (accounts for sprite padding)

    // Update weapons
    for (final d in guns) {
      d.updateCooldown(dt);
      final drone = identical(d, satellite);
      final sp = drone ? satellitePos : null;
      final x = sp?.x ?? gx, y = sp?.y ?? gy, xm = sp?.x ?? position.x;
      final w = drone ? 0.0 : size.x;

      // Fire if firing
      if (fire) {
        final before = d.cd;
        live += d.fire(x, y, xm, w, parent!,
            fireRateMult: fireRateMult,
            plan: planFor(d),
            dmgBonus: bonus,
            liveShots: live);
        if (d.cd > before) fired = true;
      }
      d.updatePending(dt, x, y, xm, w, parent!);

      // Update projectile positions and check collisions
      _updateProjectiles(d, dt);
    }
    if (surging && fired) _fullGenTime = 0;

    // Beam damage — outside projectile loop (beams have 0 projectiles)
    for (final d in guns) {
      if (d.beamActive > 0) {
        _processBeamCollision(d);
      }
    }

    // Damage flash decay
    if (dmgTaken > 0) dmgTaken--;
    // Asteroid ram-combo window decay — lapse resets the escalation
    if (_asteroidComboTimer > 0) _asteroidComboTimer -= dt;
  }

  /// VB6 TestDistance — finds closest enemy within guidance cone
  void _findClosestEnemy() {
    double minDist = 10000;
    closestEnemy = null;

    int maxGuide = 0;
    int maxSpeed = 0;
    for (final d in guns) {
      final g = effectiveGuide(d);
      if (g > maxGuide) maxGuide = g;
      if (d.speed > maxSpeed) maxSpeed = d.speed;
    }
    if (maxGuide == 0) return;

    // VB6: grat = maxGuide / maxSpeed — guidance angle ratio
    final grat = maxSpeed > 0 ? maxGuide / maxSpeed : 0.0;

    for (final fleet in game.activeFleets) {
      for (final hostile in fleet.hostiles) {
        if (hostile.isDead) continue;
        final dx = (position.x - hostile.hostCenter.x).abs();
        final dy = position.y - hostile.hostCenter.y; // positive = enemy above
        if (dy <= 0) continue; // enemy below or at same Y — unreachable
        if (grat < dx / dy) continue; // outside guidance cone
        final dist = sqrt(dx * dx + dy * dy);
        if (dist < minDist) {
          minDist = dist;
          closestEnemy = hostile;
        }
      }
    }
  }

  void _updateProjectiles(Device d, double dt) {
    final toRemove = <int>[];
    for (int i = 0; i < d.projectiles.length; i++) {
      final p = d.projectiles[i];
      if (!p.active) {
        toRemove.add(i);
        continue;
      }

      // Guided projectile homing. Shots flying downward (REARGUARD, a
      // PINBALL on its way back) home too: the cone test already picked the
      // target, this only nudges x.
      final guide = p.guideOverride ?? (p.plan?.guide ?? d.guide).toDouble();
      if (guide > 0 && closestEnemy != null && !closestEnemy!.isDead) {
        final dx = (p.position.x + p.size.x / 2) - closestEnemy!.hostCenter.x;
        final adjustment = dx.abs() > guide ? guide * dx.sign : dx;
        p.position.x -= adjustment * dt * config.originalFps;
      }

      // Check collision with enemies
      if (_checkProjectileCollisions(d, p)) {
        toRemove.add(i);
      }
    }

    // Remove hit projectiles (reverse order to preserve indices)
    for (int i = toRemove.length - 1; i >= 0; i--) {
      final idx = toRemove[i];
      if (idx < d.projectiles.length) {
        d.returnToPool(d.projectiles[idx]);
      }
    }
  }

  /// Damage of one hit of [p] on [h], with CRIT rolled. Returns the damage
  /// and whether it was a crit.
  (int, bool) _rollHit(Device d, Projectile p, Hostile h) {
    final base = p.plan == null ? d.damage : p.damage.round();
    final fx = p.plan?.fx;
    if (fx == null || fx.critChance <= 0 || _rng.nextDouble() >= fx.critChance) {
      return (base, false);
    }
    final boss = h is Boss || h is BossPart;
    final mul = boss && fx.bossCritMul > 0 ? fx.bossCritMul : fx.critMul;
    return ((base * mul).round(), true);
  }

  /// What a hit does past its damage: FROST, FORK on a kill, SPLIT on a
  /// survivor, and whether the shot flies on (PIERCE). True = consumed.
  bool _afterHit(Device d, Projectile p, Hostile h, bool killed) {
    final plan = p.plan;
    if (plan == null) return true;
    final fx = plan.fx;
    if (fx.frostSec > 0 && !killed) {
      final boss = h is Boss || h is BossPart;
      h.applyFrost(fx.frostSec * (boss ? config.modFrostBossShare : 1.0));
    }
    final cx = p.position.x + p.size.x / 2;
    final cy = p.position.y + p.size.y / 2;
    if (killed && fx.forkCount > 0 && p.forkDepth < fx.forkDepth) {
      final n = fx.forkCount;
      for (var i = 0; i < n; i++) {
        final a = n == 1
            ? 0.0
            : -config.modForkSpread + 2 * config.modForkSpread * i / (n - 1);
        final sp = p.speed.abs();
        final shot = d.spawnShot(cx, cy,
            vx: sp * sin(a),
            speed: -sp * cos(a),
            damage: p.damage * config.modForkDmg,
            scale: p.projScale,
            plan: plan,
            depth: p.forkDepth + 1,
            img: p.imgName);
        shot.pierced.add(h);
        shot.canSplit = false;
      }
    } else if (!killed && p.canSplit) {
      for (final dir in const [-1.0, 1.0]) {
        final shard = d.spawnShot(cx, cy,
            vx: dir * config.modSplitVx,
            speed: p.speed,
            damage: p.damage * config.modSplitDmg,
            scale: p.projScale * config.modSplitScale,
            plan: plan,
            depth: p.forkDepth + 1,
            img: p.imgName);
        shard.pierced.add(h);
        shard.canSplit = false;
        shard.hitsLeft = 0;
      }
      return true;
    }
    if (p.hitsLeft != 0) {
      if (p.hitsLeft > 0) p.hitsLeft--;
      p.pierced.add(h);
      if (fx.pierceFalloff > 0) {
        p.damage = max(p.damage * (1 - fx.pierceFalloff),
            plan.damage * config.modLanceFloor);
      }
      return false;
    }
    return true;
  }

  void _floatCrit(Hostile h) {
    game.world.add(FloatText(
      text: 'CRIT',
      color: const Color(0xFFFFE040),
      fontSize: 12,
      duration: 0.6,
      driftSpeed: 40,
      position: h.hostCenter.clone(),
    ));
  }

  /// Port of Vessel.ProcessEnemies — collision detection
  bool _checkProjectileCollisions(Device d, Projectile projectile) {
    final px1 = projectile.position.x;
    final py1 = projectile.position.y;
    final px2 = projectile.x2;
    final py2 = projectile.y2;

    // Check against all fleets
    for (final fleet in game.activeFleets) {
      // Broad phase: fleet AABB
      if (py2 < fleet.minY || py1 > fleet.maxY) continue;
      if (px2 < fleet.minX || px1 > fleet.maxX) continue;

      // Narrow phase: per hostile
      for (final h in fleet.hostiles) {
        if (h.isDead) continue;
        if (projectile.pierced.isNotEmpty && projectile.pierced.contains(h)) {
          continue;
        }
        if (_aabbOverlap(px1, py1, px2, py2,
            h.position.x, h.position.y, h.x2, h.y2)) {
          h.lastHitX = projectile.position.x + projectile.size.x / 2;
          h.lastHitY = projectile.position.y + projectile.size.y / 2;
          final (dmg, crit) = _rollHit(d, projectile, h);
          h.takeDamage(dmg, game, attacker: this, source: d);
          if (crit) _floatCrit(h);
          final killed = h.isDead;
          if (killed) {
            fleet.onHostileKilled(h, game, attacker: this);
          }
          return _afterHit(d, projectile, h, killed);
        }
      }
    }

    // Check against structures
    for (final s in game.activeStructures) {
      if (_aabbOverlap(px1, py1, px2, py2,
          s.position.x, s.position.y, s.x2, s.y2)) {
        final dmg = projectile.plan == null ? d.damage : projectile.damage.round();
        s.takeDamage(dmg, game);
        addScore(dmg);
        credit += dmg;
        return true;
      }
    }

    return false;
  }

  void _processBeamCollision(Device d) {
    // Beam hits closest enemy continuously; extra rays (WIDE, a fanned laser)
    // take the next nearest ones.
    d.extraBeamTargets.clear();
    final first = closestEnemy;
    if (first == null || first.isDead) return;
    final targets = <Hostile>[first];
    if (d.beamRays > 1) targets.addAll(_nearestOthers(first, d.beamRays - 1));
    final fx = d.beamPlan?.fx;
    final dmg = d.beamPlan == null ? d.damage : d.beamDamage;
    for (final h in targets) {
      final c = h.hostCenter;
      if (!identical(h, first)) d.extraBeamTargets.add(c.clone());
      h.lastHitX = c.x;
      h.lastHitY = c.y;
      var hit = dmg;
      if (fx != null && fx.critChance > 0 && _rng.nextDouble() < fx.critChance) {
        final boss = h is Boss || h is BossPart;
        hit = (hit * (boss && fx.bossCritMul > 0 ? fx.bossCritMul : fx.critMul))
            .round();
      }
      h.takeDamage(hit, game, attacker: this, source: d);
      if (h.isDead) {
        h.parentFleet?.onHostileKilled(h, game, attacker: this);
      }
    }
  }

  /// Up to [n] living hostiles above the ship, nearest first, besides [skip].
  List<Hostile> _nearestOthers(Hostile skip, int n) {
    final all = <(double, Hostile)>[];
    for (final f in game.activeFleets) {
      for (final h in f.hostiles) {
        if (h.isDead || identical(h, skip)) continue;
        final c = h.hostCenter;
        if (c.y >= position.y || c.y < 0) continue;
        final dx = c.x - position.x, dy = c.y - position.y;
        all.add((dx * dx + dy * dy, h));
      }
    }
    all.sort((a, b) => a.$1.compareTo(b.$1));
    return [for (final e in all.take(n)) e.$2];
  }

  void _tickModTimers(double dt) {
    _satT += dt;
    final moved = !_prevX.isNaN &&
        ((position.x - _prevX).abs() > 0.5 || (position.y - _prevY).abs() > 0.5);
    _stillTime = moved ? 0 : _stillTime + dt;
    _prevX = position.x;
    _prevY = position.y;
    _fullGenTime = genValue >= genMax * 0.999 ? _fullGenTime + dt : 0;
    if (_ghostTimer > 0) _ghostTimer -= dt;
    if (_novaCd > 0) _novaCd -= dt;
    if (_timewarpCd > 0) _timewarpCd -= dt;
    final front = getDevice(WeaponSlot.frontGun);
    if (_wantsSatellite &&
        (satellite == null ||
            front == null ||
            satellite!.name != front.name ||
            satellite!.level != front.level)) {
      _syncSatellite();
    }
  }

  /// NOVA: the shield just broke — hit everything on the field.
  void _nova() {
    _novaCd = config.modNovaCooldown;
    final dmg = genMax.round();
    for (final f in [...game.activeFleets]) {
      for (final h in [...f.hostiles]) {
        if (h.isDead || h.y2 < 0) continue;
        final boss = h is Boss || h is BossPart;
        h.takeDamage(boss ? (dmg * config.modNovaBossShare).round() : dmg, game,
            attacker: this);
        if (h.isDead) f.onHostileKilled(h, game, attacker: this);
      }
    }
    game.shaderPipeline.triggerAberration();
    game.showMessage('NOVA');
  }

  bool _aabbOverlap(
      double ax1, double ay1, double ax2, double ay2,
      double bx1, double by1, double bx2, double by2) {
    return ax1 < bx2 && ax2 > bx1 && ay1 < by2 && ay2 > by1;
  }

  /// Take damage (from hostile collision or projectile)
  void takeDamage(int amount) {
    // GHOST: a hull hit buys a moment untouchable.
    if (_ghostTimer > 0) return;
    final hadShield = shield > 0;
    // Shield absorbs first
    if (shield > 0) {
      final absorbed = min(shield, amount.toDouble());
      shield -= absorbed;
      amount -= absorbed.toInt();
      if (amount <= 0) {
        SoundService.instance.play(SfxEvent.hitShield);
      } else if (hull.perk == HullPerk.bulwark) {
        amount = max(1, (amount * config.modBulwarkHull).round());
      }
    }
    if (hadShield && shield <= 0 && mods.nova && _novaCd <= 0) _nova();
    if (amount > 0) {
      SoundService.instance.play(SfxEvent.hitHull);
      game.sectorHullDamage = true;
      if (mods.ghostSec > 0) _ghostTimer = mods.ghostSec;
      if (mods.timewarp && _timewarpCd <= 0) {
        _timewarpCd = config.modTimewarpCooldown;
        game.startTimewarp(config.modTimewarpScale, config.modTimewarpDuration);
      }
    }
    hp -= amount;
    dmgTaken = 4; // Flash frames
    game.shaderPipeline.triggerAberration();

    if (hp <= 0) {
      hp = 0;
      if (game.isCoop) {
        visible = false;
        fire = false;
        game.checkCoopGameOver();
      } else {
        game.triggerGameOver();
      }
    }
  }

  /// Asteroid ram — escalating, not a flat hit. Consecutive rams within
  /// [_asteroidComboWindow] seconds ramp up: 1st drops shields, 2nd costs half
  /// of max HP, 3rd is fatal. The combo resets once the window lapses.
  void hitByAsteroid() {
    if (_asteroidComboTimer <= 0) _asteroidComboStage = 0;
    _asteroidComboStage++;
    _asteroidComboTimer = _asteroidComboWindow;
    AchievementService.instance.onAsteroidRam();
    game.campaignTracker?.onAsteroidRam();

    switch (_asteroidComboStage) {
      case 1:
        // first ram: shields down (BASTION keeps half)
        shield = hull.perk == HullPerk.bulwark ? shield * 0.5 : 0;
        SoundService.instance.play(SfxEvent.hitShield);
      case 2:
        shield = 0;
        hp -= hpMax ~/ 2; // second ram in quick succession: half of max HP
        SoundService.instance.play(SfxEvent.hitHull);
        game.sectorHullDamage = true;
      default:
        shield = 0;
        hp = 0; // third+ ram: fatal
        SoundService.instance.play(SfxEvent.hitHull);
        game.sectorHullDamage = true;
    }

    dmgTaken = 4; // flash frames + brief invuln (mirrors takeDamage)
    game.shaderPipeline.triggerAberration();

    if (hp <= 0) {
      hp = 0;
      if (game.isCoop) {
        visible = false;
        fire = false;
        game.checkCoopGameOver();
      } else {
        game.triggerGameOver();
      }
    }
  }

  // Weapon management
  Device? getDevice(WeaponSlot slot) {
    for (final d in devices) {
      if (d.slot == slot) return d;
    }
    return null;
  }

  Device equipWeapon(DevType type, WeaponSlot slot) {
    // Remove existing weapon in slot
    devices.removeWhere((d) {
      if (d.slot == slot) {
        d.clearProjectiles();
        return true;
      }
      return false;
    });

    final device = Device.fromType(type, slot);
    device.parentVessel = this;
    devices.add(device);

    // Check if any weapon has guidance
    guidedWeapon = devices.any((d) => d.guide > 0);

    return device;
  }

  /// The hangar entry for weapon [name] bought for [slot], if any. Keyed by
  /// slot as well as name: LEFT and RIGHT can each own a Small Bubble at
  /// different levels.
  Device? hangarEntry(String name, WeaponSlot slot) {
    for (final d in hangar) {
      if (d.name == name && d.slot == slot) return d;
    }
    return null;
  }

  /// Whether [name] is owned for [slot], fitted or in the hangar.
  bool ownsWeapon(String name, WeaponSlot slot) =>
      getDevice(slot)?.name == name || hangarEntry(name, slot) != null;

  /// Fit [type] into [slot]. Whatever is fitted there now moves to the hangar
  /// with its level. A hangar entry for [type] in [slot] comes back as the
  /// same instance; otherwise a fresh level-0 device is created. Charging for
  /// a new device is the caller's job — switching to an owned one is free.
  Device fitWeapon(DevType type, WeaponSlot slot) {
    final current = getDevice(slot);
    if (current != null && current.name == type.name) return current;
    if (current != null) {
      current.clearProjectiles();
      devices.remove(current);
      hangar.add(current);
    }
    var device = hangarEntry(type.name, slot);
    if (device != null) {
      hangar.remove(device);
    } else {
      device = Device.fromType(type, slot);
      device.parentVessel = this;
    }
    devices.add(device);
    guidedWeapon = devices.any((d) => d.guide > 0);
    return device;
  }

  /// Sell the device fitted in [slot] for its current price. The slot stays
  /// empty even when the hangar holds something for it — the player picks.
  /// The generator is not sellable. Returns the credits gained.
  int sellFitted(WeaponSlot slot) {
    if (slot == WeaponSlot.generator) return 0;
    final device = getDevice(slot);
    if (device == null) return 0;
    final gained = device.price;
    credit += gained;
    removeWeapon(slot);
    return gained;
  }

  /// Sell a hangar entry for its current price. Returns the credits gained.
  int sellFromHangar(Device device) {
    if (!hangar.remove(device)) return 0;
    credit += device.price;
    return device.price;
  }

  void removeWeapon(WeaponSlot slot) {
    devices.removeWhere((d) {
      if (d.slot == slot) {
        d.clearProjectiles();
        return true;
      }
      return false;
    });
    guidedWeapon = devices.any((d) => d.guide > 0);
  }

  /// VB6 Vessel.AddScore — add score and check weapon unlock thresholds
  void addScore(int s) {
    score += s;
    if (nextWeaponLevel < wepLevScores.length &&
        score > wepLevScores[nextWeaponLevel]) {
      nextWeaponLevel++;
      const roman = ['', 'I', 'II', 'III', 'IV'];
      game.showMessage(L10n.current.weaponLevelUnlocked(roman[nextWeaponLevel]));
      SoundService.instance.play(SfxEvent.weaponUnlock);
    }
  }

  /// VB6 Vessel.GeneratorLoad — power consumption as % of generation
  double get generatorLoad {
    if (genPower <= 0) return 999;
    double pps = 0;
    for (final d in devices) {
      if (d.cooldown > 0 && d.pwrNeed > 0) {
        final p = planFor(d);
        pps += p.pwrNeed / p.cooldown;
      }
    }
    final genPerSec = genPower * config.originalFps;
    return genPerSec > 0 ? pps / genPerSec * 100 : 999;
  }

  /// VB6 Vessel.GenInfo — generator status string for ComCenter
  String get genInfo {
    final load = generatorLoad.round();
    var info = 'Cap ${genMax.toInt()} | Load $load%';
    for (final d in devices) {
      if (d.slot != WeaponSlot.generator && !canPower(d)) {
        info += ' | ${d.name} off';
      }
    }
    if (load > 100) info += ' | low';
    return info;
  }

  /// Total DPS across all weapons
  double get totalDps {
    double total = 0;
    for (final d in devices) {
      total += d.slot == WeaponSlot.generator ? d.dps : effectiveDps(d);
    }
    final s = satellite;
    if (s != null) total += effectiveDps(s);
    return total;
  }

  // P2 tint: modulate keeps alpha intact, tints RGB toward green
  static final _p2Paint = Paint()
    ..colorFilter = const ColorFilter.mode(Color(0xFF80FFA0), BlendMode.modulate);

  @override
  void render(Canvas canvas) {
    if (!visible) return;

    // Drive dissolve amount from HP ratio (kicks in below 30%)
    final hpRatio = hp / hpMax;
    if (hpRatio < 0.3) {
      // Map 0.3→0 HP to 0→0.6 dissolve (never fully dissolve — that's death)
      dissolveEffect.amount = (1.0 - hpRatio / 0.3) * 0.6;
    } else {
      dissolveEffect.amount = 0;
    }

    final paint = playerIndex == 1
        ? _p2Paint
        : (hull.id != HullSpec.falcon.id &&
                !AssetLibrary.instance.hasHullArt(hull.id)
            ? (Paint()
              ..colorFilter =
                  ColorFilter.mode(Color(hull.tint), BlendMode.modulate))
            : null);

    // Combine visual bank (roll + horizontal squash) and depth pulse (uniform
    // scale) into one centre-anchored transform. It must wrap the dissolve
    // branch too: renderWith rasterizes into a size.x × size.y offscreen
    // buffer, so transforming inside it would clip the corners. `size` is
    // never touched, so hitboxes/beams/nozzles stay exact.
    final banked = bank.abs() > 0.001;
    final pulse = config.depthPulseEnabled ? visualScale : 1.0;
    final scaled = (pulse - 1.0).abs() > 0.0001;
    final transformed = banked || scaled;
    if (transformed) {
      canvas.save();
      final cx = size.x / 2, cy = size.y / 2;
      canvas.translate(cx, cy);
      if (banked) {
        canvas.rotate(bank * config.bankMaxRoll);
        canvas.scale(1.0 - bank.abs() * config.bankSquashX, 1.0);
      }
      if (scaled) canvas.scale(pulse);
      canvas.translate(-cx, -cy);
    }

    if (dissolveEffect.amount > 0.001) {
      dissolveEffect.renderWith(canvas, size.x, size.y, (c) {
        _renderSprite(c, paint);
      });
    } else {
      _renderSprite(canvas, paint);
    }

    if (transformed) canvas.restore();
    if (satellite != null) _renderSatellite(canvas);
  }

  /// The drone, drawn from the ship's local frame. Its own art does not exist
  /// yet; the skin's boss turret, small, stands in.
  void _renderSatellite(Canvas canvas) {
    final sp = satellitePos;
    final local = Offset(sp.x - position.x + size.x / 2,
        sp.y - position.y + size.y / 2);
    final r = config.modSatelliteSize / 2;
    final art = AssetLibrary.instance.getSprite('drone') ??
        AssetLibrary.instance.getSprite('boss_turret');
    if (art != null) {
      art.render(canvas,
          position: Vector2(local.dx - r, local.dy - r),
          size: Vector2.all(r * 2));
    } else {
      canvas.drawCircle(local, r * 0.6, Paint()..color = const Color(0xFF80FFFF));
    }
  }

  void _renderSprite(Canvas canvas, Paint? paint) {
    if (_sprite != null) {
      _sprite!.render(canvas, size: size, overridePaint: paint);
    } else {
      final color = playerIndex == 1 ? const Color(0xFF00FF80) : const Color(0xFF00FFFF);
      final p = Paint()..color = color;
      final path = Path()
        ..moveTo(size.x / 2, 0)
        ..lineTo(0, size.y)
        ..lineTo(size.x, size.y)
        ..close();
      canvas.drawPath(path, p);
    }
  }

}

/// The mod/hull multipliers baked into a ship's stat fields.
class _StatMul {
  final double hp, shield, regen, genPower, genMax;

  const _StatMul({
    this.hp = 1,
    this.shield = 1,
    this.regen = 1,
    this.genPower = 1,
    this.genMax = 1,
  });

  _StatMul over(_StatMul o) => _StatMul(
        hp: hp / o.hp,
        shield: shield / o.shield,
        regen: regen / o.regen,
        genPower: genPower / o.genPower,
        genMax: genMax / o.genMax,
      );

  @override
  bool operator ==(Object other) =>
      other is _StatMul &&
      other.hp == hp &&
      other.shield == shield &&
      other.regen == regen &&
      other.genPower == genPower &&
      other.genMax == genMax;

  @override
  int get hashCode => Object.hash(hp, shield, regen, genPower, genMax);
}

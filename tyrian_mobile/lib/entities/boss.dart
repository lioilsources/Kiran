import 'dart:math';

import 'package:flame/components.dart';
import '../game/duel_space.dart';
import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../services/asset_library.dart';
import '../services/sound_service.dart';
import '../systems/device.dart';
import '../systems/duel_brain.dart';
import '../systems/path_system.dart';
import '../systems/training/duel_drill.dart';
import 'hostile.dart';
import 'idle_anim.dart';
import 'vessel.dart';
import '../l10n/l10n.dart';

/// A piece bolted onto a composite boss. Each campaign boss keeps the ones
/// before it and gains the next, so the silhouette grows across the campaign.
enum PartKind {
  /// Aimed pot shots from the flank.
  turret,

  /// While it lives the core takes no damage — the gate every later boss
  /// makes you solve first.
  shieldPod,

  /// Drives the core's strafe; destroying it leaves the boss sluggish.
  thruster,

  /// Spread volleys from the nose.
  cannon,
}

/// Parts in the order bosses acquire them: boss 1 flies with the turret,
/// boss 2 adds the shield pod, and so on.
const List<PartKind> kBossPartProgression = [
  PartKind.turret,
  PartKind.shieldPod,
  PartKind.thruster,
  PartKind.cannon,
];

List<PartKind> bossPartsForOrdinal(int ordinal) =>
    kBossPartProgression.take(ordinal.clamp(0, kBossPartProgression.length)).toList();

/// Stats for a phased boss wave (computed in Sector.addBossWave).
class BossSpec {
  final int ordinal; // 1 = level 10, 2 = level 15, ...
  final int weapDamage;
  final int rechargeFrames; // phase-1 fire cadence in update ticks

  /// Pieces to bolt on. Empty for the endless boss, which is a bare core.
  final List<PartKind> parts;

  const BossSpec({
    required this.ordinal,
    required this.weapDamage,
    required this.rechargeFrames,
    this.parts = const [],
  });
}

/// Phased boss appearing every 5th level from level 10 onward.
///
/// Unlike regular hostiles (whose fleet fires for them), the boss fires itself:
/// aimed shots in phase 1, spread volleys in phases 2-3, with movement swapped
/// to progressively faster strafes as HP drops through the phase thresholds.
/// Uses HostType.bouncer so boss music, magenta glow and the pixel-explosion
/// death effect all apply without special-casing.
class Boss extends Hostile {
  final BossSpec spec;

  /// The pieces attached to this core, alive or dead. Built once by
  /// [createParts] when the fleet spawns the boss.
  final List<BossPart> parts = [];
  /// Fire cooldowns in VB6 frame units (40fps), advanced by `dt * originalFps`
  /// rather than per rendered frame — otherwise the boss fires 1.5x more often
  /// at 60Hz and 3x at 120Hz while the player's cadence stays in seconds.
  double _fireCD = 0;

  /// Idle loop for skins whose boss is a creature (blink and twitch frames).
  final IdleAnimator _idle = IdleAnimator();
  int _lastHit = 0;
  int _volleys = 0;
  int _burstLeft = 0;
  double _burstCD = 0;
  int _phaseSeen = 1;

  // ── Duel (Prompts/30 §7) ──

  /// Spawned into a duel: the brain moves it, it stands upright and fires
  /// every way. Decided once, at spawn.
  bool duel = false;
  DuelBrain? brain;
  double _tell = 0;

  /// The skin's boss is a creature (head up, tentacles down) rather than a
  /// ship: it has the blink frame.
  bool get creature =>
      AssetLibrary.instance.getSprite('rododendron_blink') != null;

  Boss({
    required super.caption,
    required super.id,
    required this.spec,
    required super.hp,
    required super.hpMax,
    super.collisionDmg,
    super.trace,
    super.position,
  }) : super(hostType: HostType.bouncer);

  /// 1 above 66% HP, 2 above 33%, 3 below.
  int get phase => hp * 3 > hpMax * 2 ? 1 : (hp * 3 > hpMax ? 2 : 3);

  /// A duel boss comes in from above the field on no path of its own; the
  /// off-field net must leave it alone.
  @override
  bool get reapWhenStranded => !duel;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    if (game.duel.geometry) _enterDuel();
  }

  void _enterDuel() {
    duel = true;
    trace = null;
    final training = game.mode == GameMode.training;
    final low = training && game.arena.duelDrill == DuelDrillKind.turn;
    brain = DuelBrain(
      ordinal: max(1, spec.ordinal),
      width: duelWidth,
      height: duelHeight,
      keepOut: config.duelKeepOut,
      homeV: low ? 0.72 : config.duelBossHomeV,
      calm: training && game.arena.calmBoss,
      bandTop: low ? 0.55 : null,
      bandBottom: low ? 0.88 : null,
      seed: spec.ordinal * 7919 + spec.parts.length,
    );
    _placeFromBrain();
    drawAngle = creature ? uprightAngle : _facing();
  }

  /// The heading from the core to the nearest ship, as a draw angle.
  double _facing() {
    final v = _nearestVessel();
    final c = hostCenter;
    if (v == null) return uprightAngle + pi;
    return atan2(v.position.x - c.x, -(v.position.y - c.y));
  }

  void _placeFromBrain() {
    final b = brain!;
    final c = duelToGame(b.x / duelWidth, b.y / duelHeight);
    position.setValues(c.x - size.x / 2, c.y - size.y / 2);
  }

  /// One step of the duel's moves, before the hit tests of this frame.
  void _duelStep(double dt) {
    final b = brain!;
    final v = _nearestVessel();
    var sx = b.width / 2, sy = b.height;
    if (v != null) {
      final (u, w) = gameToDuel(v.position.x, v.position.y);
      sx = u * b.width;
      sy = w * b.height;
    }
    var step = dt * game.enemyTimeScale;
    if (frostTimer > 0) step *= 0.5;
    final phaseMul = switch (phase) { 1 => 1.0, 2 => 1.25, _ => 1.5 };
    b.step(step,
        phase: phase, shipX: sx, shipY: sy, speedMul: phaseMul / strafeStepsMult);
    _placeFromBrain();
    if (!creature) {
      final want = _facing();
      final d = atan2(sin(want - drawAngle), cos(want - drawAngle));
      final s = config.duelBossTurnRate * dt;
      drawAngle += d.abs() <= s ? d : s * d.sign;
    }
    // The dive's tell: it flashes before it comes.
    if (b.telling && hit == 0 && (b.move == DuelMove.dive)) hit = 1;
  }

  /// Build this boss's pieces. Called once by Fleet when the core spawns;
  /// the fleet owns them from then on, exactly like any other hostile.
  List<BossPart> createParts() {
    if (parts.isNotEmpty) return parts;
    for (var i = 0; i < spec.parts.length; i++) {
      final kind = spec.parts[i];
      parts.add(BossPart(
        core: this,
        kind: kind,
        // Ids sit well past the core's so the co-op snapshot key
        // (fleetId * 1000 + hostileId) cannot collide.
        id: 100 + i,
        armour: max((hpMax * 0.16).round(), 800),
        weapDamage: (spec.weapDamage * 0.6).round(),
        collisionDmg: max(collisionDmg ~/ 2, 5),
        bounty: max((creditValue ?? 2500) ~/ 5, 500),
      ));
    }
    return parts;
  }

  /// No damage reaches the core while a shield pod is up.
  bool get shielded =>
      parts.any((p) => p.kind == PartKind.shieldPod && !p.isDead);

  bool get _thrusterAlive =>
      parts.any((p) => p.kind == PartKind.thruster && !p.isDead);

  /// Strafe cycle length: a live thruster makes the core noticeably quicker,
  /// so shooting it off is a visible win even though it never shoots back.
  double get strafeStepsMult => _thrusterAlive ? 0.7 : 1.0;

  @override
  void takeDamage(int dmg, TyrianGame gameInstance,
      {Vessel? attacker, Device? source}) {
    if (shielded) {
      // The projectile is consumed either way (Vessel stops at the first
      // overlap), so flash the core to show the shot landed and did nothing.
      if (hit == 0) hit = 2;
      return;
    }
    super.takeDamage(dmg, gameInstance, attacker: attacker, source: source);
    if (isDead) {
      // The fleet only depletes once every hostile in it is gone, so a part
      // outliving its core would leave the sector unfinishable. These deaths
      // bypass onHostileKilled deliberately: they are not the player's kills,
      // which is what makes "destroy every part" a real objective.
      for (final p in parts) {
        if (!p.isDead) p.hp = 0;
      }
    }
  }

  /// Dedicated boss sprite where the skin provides one. Every skin now ships a
  /// rododendron atlas frame; bouncer stays as a defensive fallback for any
  /// skin whose atlas lacks it.
  @override
  String get spriteName =>
      AssetLibrary.instance.getSprite('rododendron') != null
          ? 'rododendron'
          : 'bouncer';

  /// Creature bosses ship `rododendron_blink` / `_twitch_l` / `_twitch_r` beside
  /// the resting frame; a skin without them keeps its single static sprite.
  void _animate(double dt) {
    final lib = AssetLibrary.instance;
    final open = lib.getSprite('rododendron');
    if (open == null || lib.getSprite('rododendron_blink') == null) return;
    // A dive's tell: the tentacles twitch, one side and the other.
    if (brain?.telling ?? false) {
      _tell += dt;
      final side = (_tell * 11).floor().isEven;
      setFrame(lib.getSprite(side ? 'rododendron_twitch_l' : 'rododendron_twitch_r') ?? open);
      return;
    }
    final struck = hit > 0 && _lastHit == 0;
    _lastHit = hit;
    final name = switch (_idle.step(dt, struck: struck)) {
      IdleFrame.open => 'rododendron',
      IdleFrame.blink => 'rododendron_blink',
      IdleFrame.twitchL => 'rododendron_twitch_l',
      IdleFrame.twitchR => 'rododendron_twitch_r',
    };
    setFrame(lib.getSprite(name) ?? open);
  }

  double get _weapScale => (spec.weapDamage / 75.0).clamp(0.3, 0.99);

  int get _cadence {
    final base = switch (phase) {
      1 => spec.rechargeFrames,
      2 => (spec.rechargeFrames * 0.75).round(),
      _ => (spec.rechargeFrames * 0.55).round(),
    };
    return (base * game.challenge.cadence).round();
  }

  @override
  void update(double dt) {
    if (duel && !isDead && game.coopRole != CoopRole.client) _duelStep(dt);
    super.update(dt);
    if (isDead) return;
    _animate(dt);
    // Client: entities driven by host snapshots
    if (game.coopRole == CoopRole.client) return;

    _checkPhaseTransition();

    // Hold fire until fully on screen
    if (!entered) return;

    _fireCD += dt * config.originalFps * game.enemyTimeScale;
    if (_fireCD >= _cadence) {
      _fireCD = 0;
      _fireVolley();
    }

    // Phase 3: aimed 3-shot burst trailing every third volley
    if (_burstLeft > 0) {
      _burstCD += dt * config.originalFps * game.enemyTimeScale;
      if (_burstCD >= 8) {
        _burstCD = 0;
        _burstLeft--;
        _fireAimed();
      }
    }
  }

  void _checkPhaseTransition() {
    final p = phase;
    if (p == _phaseSeen) return;
    _phaseSeen = p;
    if (duel) {
      // The brain reads the phase itself: a wider band, more moves.
      game.addExplosion(position.x + size.x / 2, position.y + size.y / 2, 2);
      SoundService.instance.play(SfxEvent.explosionSmall);
      return;
    }

    // Swap to a faster, wider strafe; steer toward the far half of the screen
    // so the cycle path never leads off the edge.
    final w = config.gameWidth;
    final dxMag = p == 2 ? w * 0.30 : w * 0.38;
    final dx = (trace?.current?.x ?? position.x) < w / 2 ? dxMag : -dxMag;
    final m = strafeStepsMult;
    if (p == 2) {
      cyclePath((280 * m).round(), dx.round(), 0, PathType.cosinus);
    } else {
      cyclePath((180 * m).round(), dx.round(), 40, PathType.sinCos);
    }

    game.addExplosion(position.x + size.x / 2, position.y + size.y / 2, 2);
    SoundService.instance.play(SfxEvent.explosionSmall);
  }

  void _fireVolley() {
    switch (phase) {
      case 1:
        _fireAimed();
      case 2:
        _fireSpread(const [-4.0, 0.0, 4.0]);
      default:
        _fireSpread(const [-6.0, -3.0, 0.0, 3.0, 6.0]);
        _volleys++;
        if (_volleys % 3 == 0) {
          _burstLeft = 3;
          _burstCD = 0;
        }
    }
  }

  /// Where a duel shot leaves the core: its rim, toward [to].
  Vector2 _duelMuzzle(Vector2 to) {
    final c = hostCenter;
    final d = to - c;
    final l = d.length;
    if (l < 1) return c;
    return c + d / l * (size.x * 0.4);
  }

  void _fireAimed() {
    if (duel) {
      // Any way at all: the ship may be beside it or beneath it.
      final target = _nearestVessel();
      if (target == null) return;
      final origin = _duelMuzzle(target.position);
      final dir = target.position - origin;
      final len = dir.length;
      if (len <= 1) return;
      _spawnShot(origin, 15.0 * dir.x / len, 15.0 * dir.y / len);
      return;
    }
    final origin = Vector2(position.x + size.x / 2, y2 + 10);
    final target = _nearestVessel();
    double vx = 0;
    double vy = 15.0;
    if (target != null) {
      final dir = target.position - origin;
      final len = dir.length;
      if (len > 1) {
        vx = 15.0 * dir.x / len;
        vy = 15.0 * dir.y / len;
        // Never shoot backwards/flat — keep shots travelling downward.
        if (vy < 6.0) {
          vy = 6.0;
          vx = vx.clamp(-13.0, 13.0);
        }
      }
    }
    _spawnShot(origin, vx, vy);
  }

  void _fireSpread(List<double> vxs) {
    if (duel) return _duelSpread(vxs);
    final origin = Vector2(position.x + size.x / 2, y2 + 10);
    for (final vx in vxs) {
      _spawnShot(origin, vx, 15.0);
    }
  }

  /// The flight's fan, its axis on the ship — or, at a perch or in an
  /// orbit, the same number of shots spread all round.
  void _duelSpread(List<double> vxs) {
    final target = _nearestVessel();
    final c = hostCenter;
    if (brain?.volley == DuelVolley.ring || target == null) {
      final n = vxs.length;
      final base = target == null
          ? 0.0
          : atan2(target.position.x - c.x, -(target.position.y - c.y));
      for (var i = 0; i < n; i++) {
        final a = base + 2 * pi * i / n;
        _spawnShot(c, 15.0 * sin(a), -15.0 * cos(a));
      }
      return;
    }
    final origin = _duelMuzzle(target.position);
    final aim = atan2(target.position.x - origin.x, -(target.position.y - origin.y));
    // The flight's fan points down (+y), angle π from up.
    for (final vx in vxs) {
      final a = aim + atan2(vx, 15.0) * -1;
      final sp = sqrt(vx * vx + 15.0 * 15.0);
      _spawnShot(origin, sp * sin(a), -sp * cos(a));
    }
  }

  void _spawnShot(Vector2 origin, double vx, double vy) {
    if (duel) {
      if (!Hostile.inPlayField(origin.x, origin.y, 0, 0)) return;
      game.spawnEnemyProjectile(origin.x, origin.y, spec.weapDamage, _weapScale,
          vx: vx, speed: vy);
      return;
    }
    if (origin.x < 0 || origin.x > config.gameWidth) return;
    game.spawnEnemyProjectile(origin.x, origin.y, spec.weapDamage, _weapScale,
        vx: vx, speed: vy);
  }

  Vessel? _nearestVessel() {
    Vessel? best;
    double bestDist = double.infinity;
    for (final v in game.allVessels) {
      if (!v.visible || v.hp <= 0) continue;
      final d = v.position.distanceToSquared(position);
      if (d < bestDist) {
        bestDist = d;
        best = v;
      }
    }
    return best;
  }
}

/// A piece riding on a composite boss.
///
/// Has no path of its own: every frame it is placed at a fixed offset from
/// the core's centre, so the whole assembly moves as one body while each
/// piece keeps its own HP, hitbox and payout. It lives in the boss's fleet
/// like any other hostile, which is what lets collision, the fleet bounds and
/// sector completion treat it without a special case.
class BossPart extends Hostile {
  final Boss core;
  final PartKind kind;
  final int weapDamage;

  double _fireCD = 0;

  BossPart({
    required this.core,
    required this.kind,
    required super.id,
    required int armour,
    required this.weapDamage,
    required int bounty,
    super.collisionDmg,
  }) : super(
          caption: _captionFor(kind),
          // Deliberately not a boss-tier type: that set drives the boss music
          // and the pixel-explosion death, and four of those going off at once
          // when the core takes its pieces with it is a frame-time spike for
          // no gain. The core alone carries the boss presentation.
          hostType: HostType.falconx3,
          hp: armour,
          hpMax: armour,
        ) {
    creditValue = bounty;
  }

  static String _captionFor(PartKind kind) {
    switch (kind) {
      case PartKind.turret:
        return L10n.current.bossPartTurret;
      case PartKind.shieldPod:
        return L10n.current.bossPartShieldPod;
      case PartKind.thruster:
        return L10n.current.bossPartThruster;
      case PartKind.cannon:
        return L10n.current.bossPartCannon;
    }
  }

  /// Where this piece sits, as a fraction of the core's own size.
  Vector2 get _offsetFraction {
    switch (kind) {
      case PartKind.turret:
        return Vector2(-0.42, -0.05);
      case PartKind.shieldPod:
        return Vector2(0.42, -0.05);
      case PartKind.thruster:
        return Vector2(0.0, 0.46);
      case PartKind.cannon:
        return Vector2(0.0, -0.5);
    }
  }

  /// Per-skin art lands one piece at a time, so every kind falls back to an
  /// elite fighter until its own sprite ships.
  @override
  String get spriteName {
    const names = {
      PartKind.turret: 'boss_turret',
      PartKind.shieldPod: 'boss_shield',
      PartKind.thruster: 'boss_thruster',
      PartKind.cannon: 'boss_cannon',
    };
    final name = names[kind]!;
    return AssetLibrary.instance.getSprite(name) != null ? name : 'falconx3';
  }

  @override
  bool get reapWhenStranded => false;

  int get _cadence {
    final base = switch (kind) {
      PartKind.turret => 110,
      PartKind.cannon => 150,
      PartKind.shieldPod || PartKind.thruster => 0, // unarmed
    };
    return (base * game.challenge.cadence).round();
  }

  @override
  void update(double dt) {
    if (isDead) return;
    if (game.coopRole == CoopRole.client) return;
    // Belt and braces for the cascade in Boss.takeDamage: a piece must never
    // outlive its core, or its fleet never depletes and the sector never ends.
    if (core.isDead) {
      hp = 0;
      return;
    }

    final c = core.hostCenter;
    final f = _offsetFraction;
    if (core.duel) {
      // The offsets are the art's, turned with the core (Prompts/30 §7.4):
      // the flight draws the core at π, which is where these come from.
      final a = core.drawAngle;
      final ox = -f.x * core.size.x, oy = -f.y * core.size.y;
      position.setValues(
        c.x + ox * cos(a) - oy * sin(a) - size.x / 2,
        c.y + ox * sin(a) + oy * cos(a) - size.y / 2,
      );
      drawAngle = a;
    } else {
      position.setValues(
        c.x + f.x * core.size.x - size.x / 2,
        c.y + f.y * core.size.y - size.y / 2,
      );
    }

    super.update(dt);

    if (_cadence == 0 || !entered) return;
    _fireCD += dt * config.originalFps * game.enemyTimeScale;
    if (_fireCD < _cadence) return;
    _fireCD = 0;
    _fire();
  }

  void _fire() {
    if (core.duel) return _duelFire();
    final origin = Vector2(position.x + size.x / 2, y2 + 6);
    final scale = (weapDamage / 75.0).clamp(0.3, 0.99);
    if (kind == PartKind.cannon) {
      for (final vx in const [-5.0, 0.0, 5.0]) {
        _shot(origin, vx, 14.0, scale);
      }
      return;
    }
    // Turret: aimed at whoever is closest.
    var vx = 0.0;
    var vy = 14.0;
    final target = _nearestVessel();
    if (target != null) {
      final dir = target.position - origin;
      final len = dir.length;
      if (len > 1) {
        vx = 14.0 * dir.x / len;
        vy = 14.0 * dir.y / len;
        if (vy < 6.0) {
          vy = 6.0;
          vx = vx.clamp(-12.0, 12.0);
        }
      }
    }
    _shot(origin, vx, vy, scale);
  }

  /// The turret aims any way; the cannon fans out along the art's "down",
  /// between the tentacles.
  void _duelFire() {
    final scale = (weapDamage / 75.0).clamp(0.3, 0.99).toDouble();
    final c = hostCenter;
    if (kind == PartKind.cannon) {
      final axis = drawAngle + pi;
      final origin =
          c + Vector2(sin(axis), -cos(axis)) * (max(size.x, size.y) / 2 + 6);
      for (final vx in const [-5.0, 0.0, 5.0]) {
        final a = axis - atan2(vx, 14.0);
        final sp = sqrt(vx * vx + 14.0 * 14.0);
        _shot(origin, sp * sin(a), -sp * cos(a), scale);
      }
      return;
    }
    final target = _nearestVessel();
    if (target == null) return;
    final dir = target.position - c;
    final len = dir.length;
    if (len <= 1) return;
    _shot(c, 14.0 * dir.x / len, 14.0 * dir.y / len, scale);
  }

  void _shot(Vector2 origin, double vx, double vy, double scale) {
    if (core.duel) {
      if (!Hostile.inPlayField(origin.x, origin.y, 0, 0)) return;
      game.spawnEnemyProjectile(origin.x, origin.y, weapDamage, scale,
          vx: vx, speed: vy);
      return;
    }
    if (origin.x < 0 || origin.x > config.gameWidth) return;
    game.spawnEnemyProjectile(origin.x, origin.y, weapDamage, scale,
        vx: vx, speed: vy);
  }

  Vessel? _nearestVessel() {
    Vessel? best;
    var bestDist = double.infinity;
    for (final v in game.allVessels) {
      if (!v.visible || v.hp <= 0) continue;
      final d = v.position.distanceToSquared(position);
      if (d < bestDist) {
        bestDist = d;
        best = v;
      }
    }
    return best;
  }
}

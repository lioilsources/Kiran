import 'dart:math';

import 'package:flame/components.dart';
import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../services/asset_library.dart';
import '../services/sound_service.dart';
import '../systems/device.dart';
import '../systems/path_system.dart';
import 'hostile.dart';
import 'vessel.dart';

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
  int _volleys = 0;
  int _burstLeft = 0;
  double _burstCD = 0;
  int _phaseSeen = 1;

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

  double get _weapScale => (spec.weapDamage / 75.0).clamp(0.3, 0.99);

  int get _cadence {
    switch (phase) {
      case 1:
        return spec.rechargeFrames;
      case 2:
        return (spec.rechargeFrames * 0.75).round();
      default:
        return (spec.rechargeFrames * 0.55).round();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;
    // Client: entities driven by host snapshots
    if (game.coopRole == CoopRole.client) return;

    _checkPhaseTransition();

    // Hold fire until fully on screen
    if (y2 <= 0) return;

    _fireCD += dt * config.originalFps;
    if (_fireCD >= _cadence) {
      _fireCD = 0;
      _fireVolley();
    }

    // Phase 3: aimed 3-shot burst trailing every third volley
    if (_burstLeft > 0) {
      _burstCD += dt * config.originalFps;
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

  void _fireAimed() {
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
    final origin = Vector2(position.x + size.x / 2, y2 + 10);
    for (final vx in vxs) {
      _spawnShot(origin, vx, 15.0);
    }
  }

  void _spawnShot(Vector2 origin, double vx, double vy) {
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
        return 'Turret';
      case PartKind.shieldPod:
        return 'Shield Pod';
      case PartKind.thruster:
        return 'Thruster';
      case PartKind.cannon:
        return 'Cannon';
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
    switch (kind) {
      case PartKind.turret:
        return 110;
      case PartKind.cannon:
        return 150;
      case PartKind.shieldPod:
      case PartKind.thruster:
        return 0; // unarmed
    }
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
    position.setValues(
      c.x + f.x * core.size.x - size.x / 2,
      c.y + f.y * core.size.y - size.y / 2,
    );

    super.update(dt);

    if (_cadence == 0 || y2 <= 0) return;
    _fireCD += dt * config.originalFps;
    if (_fireCD < _cadence) return;
    _fireCD = 0;
    _fire();
  }

  void _fire() {
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

  void _shot(Vector2 origin, double vx, double vy, double scale) {
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

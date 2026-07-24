import 'package:flame/components.dart';
import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../services/asset_library.dart';
import '../services/sound_service.dart';
import '../systems/path_system.dart';
import 'hostile.dart';
import 'vessel.dart';

/// Stats for a phased boss wave (computed in Sector._addBossWave).
class BossSpec {
  final int ordinal; // 1 = level 10, 2 = level 15, ...
  final int weapDamage;
  final int rechargeFrames; // phase-1 fire cadence in update ticks

  const BossSpec({
    required this.ordinal,
    required this.weapDamage,
    required this.rechargeFrames,
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
  int _fireCD = 0;
  int _volleys = 0;
  int _burstLeft = 0;
  int _burstCD = 0;
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

  /// Dedicated boss sprite where the skin provides one (only `default` ships
  /// with a rododendron atlas frame today); other skins fall back to bouncer.
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

    _fireCD++;
    if (_fireCD >= _cadence) {
      _fireCD = 0;
      _fireVolley();
    }

    // Phase 3: aimed 3-shot burst trailing every third volley
    if (_burstLeft > 0) {
      _burstCD++;
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
    if (p == 2) {
      cyclePath(280, dx.round(), 0, PathType.cosinus);
    } else {
      cyclePath(180, dx.round(), 40, PathType.sinCos);
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

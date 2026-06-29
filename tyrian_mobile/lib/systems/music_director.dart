import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../services/music_service.dart';

/// Drives [MusicService] from live gameplay. Each tick it computes a "threat"
/// score (enemy pressure relative to the player's power and survivability) and
/// maps it to an intensity tier, then asks MusicService to crossfade there.
///
/// Smoothing: the tier steps at most ±1 per evaluation and only after a minimum
/// dwell time, so the soundtrack rises and falls gradually instead of flapping.
/// An active boss overrides everything to the top tier.
class MusicDirector {
  final TyrianGame game;

  double _tick = 0;
  double _dwell = 0;
  int _tier = 1;

  MusicDirector(this.game);

  /// Reset to the calm tier — call at the start of each sector.
  void reset() {
    _tier = 1;
    _dwell = 0;
    _tick = 0;
  }

  void update(double dt) {
    _dwell += dt;
    _tick += dt;
    if (_tick < config.musicDirectorInterval) return;
    _tick = 0;

    final desired = game.bossActive
        ? config.musicTierCount
        : _bucket(_computeThreat());

    if (desired == _tier) return;

    // Boss transitions are immediate; otherwise respect the min dwell time and
    // step a single tier toward the target for a gradual ramp.
    if (!game.bossActive && _dwell < config.musicMinDwellSeconds) return;

    _tier += desired > _tier ? 1 : -1;
    _dwell = 0;
    MusicService.instance.setTier(_tier);
  }

  double _computeThreat() {
    final v = game.vessel;

    final hpFrac = v.hpMax > 0 ? v.hp / v.hpMax : 0.0;
    final shieldFrac = v.shieldMax > 0 ? v.shield / v.shieldMax : 0.0;
    final survivability = (0.5 * hpFrac + 0.5 * shieldFrac).clamp(0.0, 1.0);

    double offenseRaw = 0;
    for (final d in v.devices) {
      offenseRaw += d.damage * (1 + d.level);
    }
    final offense = (offenseRaw / config.musicRefOffense).clamp(0.0, 1.0);

    int hostiles = 0;
    int dmgSum = 0;
    for (final f in game.activeFleets) {
      for (final h in f.hostiles) {
        hostiles++;
        dmgSum += h.damage;
      }
    }
    final proj = game.enemyProjectiles.length;

    final raw = config.musicWCount * hostiles +
        config.musicWDmg * dmgSum +
        config.musicWProj * proj;

    // Strong weaponry lowers perceived threat; low health raises it (panic).
    var threat = raw / (1 + offense * config.musicKOff);
    threat *= (1 + (1 - survivability) * config.musicKSurv);
    return threat;
  }

  /// Map a threat score to a tier index (1..N) via the configured thresholds.
  int _bucket(double threat) {
    int tier = 1;
    for (final t in config.musicThresholds) {
      if (threat >= t) {
        tier++;
      } else {
        break;
      }
    }
    return tier.clamp(1, config.musicTierCount);
  }
}

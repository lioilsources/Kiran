import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../rendering/bg_zones.dart';
import '../entities/boss.dart';
import '../entities/hostile.dart';
import '../entities/structure.dart';
import '../entities/collectable.dart';
import 'fleet.dart';
import 'path_system.dart';

part 'sector_parts.dart';

/// One playable sector carved out of a hand-scripted VB6 level.
///
/// A level's script can be longer than is comfortable to play in one sitting,
/// so it may be split into several parts. Parts share their parent's [level],
/// which is what keeps VB6 balance — damage scaling, boss cadence, enemy HP —
/// identical no matter how the timeline is cut.
class _Part {
  /// VB6 difficulty level, shared by every part of one level — that is what
  /// keeps damage scaling, boss cadence and enemy HP on the VB6 curve no
  /// matter how the content is cut.
  final int level;

  /// Shown in the OSD ("System Perimeter I").
  final String caption;

  /// This part's share of the level's VB6 sectorBonus.
  final int bonus;

  /// Adds fleets/structures to an already-constructed [Sector]. Deliberately
  /// takes no TyrianGame: builders are pure content, which is what makes parts
  /// buildable in tests without a game instance.
  final void Function(Sector) build;

  const _Part(this.level, this.caption, this.bonus, this.build);
}

/// Ported from Sector.cls — a game level containing fleets and structures.
class Sector extends Component with HasGameReference<TyrianGame> {
  String caption;

  /// VB6 difficulty level, 1-based. Drives enemy damage scaling, boss cadence
  /// and the max-level weapon payout. Deliberately NOT the sector index: once
  /// a level is split into several shorter parts, several sectors share a level.
  int level;
  int sectorBonus;

  /// Which parallax art zone this sector wears. Defaults to the zone for its
  /// level, so every part of one level shares a backdrop.
  late final int zone;

  bool complete = false;
  double elapsed = 0;
  double completeTime = 0;

  final List<Fleet> fleets = [];
  final List<Structure> structures = [];

  int get activeFleetCount => fleets.where((f) => f.active).length;
  bool get isComplete => complete;

  Sector({
    required this.caption,
    required this.level,
    this.sectorBonus = 500,
    int? zone,
  }) {
    this.zone = zone ?? BgZones.forLevel(level);
  }

  @override
  void update(double dt) {
    elapsed += dt;

    // Activate fleets based on enter time
    for (final fleet in fleets) {
      if (!fleet.started && elapsed >= fleet.enterTime) {
        fleet.active = true;
        fleet.started = true;
        game.activeFleets.add(fleet);
        game.world.add(fleet);
      }
    }

    // Fleet acceleration: skip dead time (VB6: max 2-second buffer before next fleet)
    if (fleets.any((f) => f.started)) {
      final allStartedDead = fleets.where((f) => f.started).every((f) => !f.active);
      if (allStartedDead) {
        final nextUnstarted = fleets.where((f) => !f.started).toList();
        if (nextUnstarted.isNotEmpty) {
          final target = nextUnstarted.first.enterTime;
          if (target > elapsed + 2) {
            elapsed = target - 2; // VB6: snap to 2s before next fleet
          }
        }
      }
    }

    // Activate structures based on enter time
    for (final s in structures) {
      if (!s.activated && elapsed >= s.enterTime) {
        s.activated = true;
        if (s.trace?.current != null) {
          s.position.setValues(s.trace!.current!.x, s.trace!.current!.y);
        }
        game.activeStructures.add(s);
        game.world.add(s);
      }
    }

    // Check for sector completion (all fleets started and depleted)
    if (!complete && fleets.isNotEmpty && fleets.every((f) => f.started)) {
      if (fleets.every((f) => !f.active)) {
        completeTime += dt;
        if (completeTime >= config.delayOnComplete) {
          complete = true;
        }
      }
    }
  }

  /// Factory to create sector by index (hand-authored parts, then procedural)
  static Sector? create(int index, TyrianGame game) {
    final s = (index >= 0 && index < _parts.length)
        ? buildPart(index)
        : _createRandom(levelForIndex(index), game);
    // Every 5th level gets a phased boss as its final wave. Starts at level 10
    // so the hand-authored parts (levels 1-6) stay untouched.
    if (s.level % 5 == 0 && s.level >= 10) {
      _addBossWave(s, game);
    }
    return s;
  }

  /// Build a hand-authored part without a game instance. The boss wave and
  /// procedural paths are unreachable for these indices, which is what makes
  /// every part's content assertable in plain unit tests.
  @visibleForTesting
  static Sector buildPart(int index) {
    final p = _parts[index];
    final s = Sector(caption: p.caption, level: p.level, sectorBonus: p.bonus);
    p.build(s);
    return s;
  }

  /// Playable sectors, in order. Index into this list *is* the sector index.
  /// Three ~60-second parts per level; builders live in sector_parts.dart.
  /// Per-level bonus shares sum to the VB6 sectorBonus (5000/7500/10000/
  /// 15000/20000/25000) so the credit curve survives the split.
  static const List<_Part> _parts = [
    _Part(1, 'System Perimeter I', 1500, _l1p1),
    _Part(1, 'System Perimeter II', 1500, _l1p2),
    _Part(1, 'System Perimeter III', 2000, _l1p3),
    _Part(2, 'Inner Zone I', 2000, _l2p1),
    _Part(2, 'Inner Zone II', 2500, _l2p2),
    _Part(2, 'Inner Zone III', 3000, _l2p3),
    _Part(3, 'Planet Perimeter I', 3000, _l3p1),
    _Part(3, 'Planet Perimeter II', 3000, _l3p2),
    _Part(3, 'Planet Perimeter III', 4000, _l3p3),
    _Part(4, 'Planet Patrol I', 4000, _l4p1),
    _Part(4, 'Planet Patrol II', 5000, _l4p2),
    _Part(4, 'Planet Patrol III', 6000, _l4p3),
    _Part(5, 'Planet Orbit I', 6000, _l5p1),
    _Part(5, 'Planet Orbit II', 6000, _l5p2),
    _Part(5, 'Planet Orbit III', 8000, _l5p3),
    _Part(6, 'Industry Zone I', 7000, _l6p1),
    _Part(6, 'Industry Zone II', 8000, _l6p2),
    _Part(6, 'Industry Zone III', 10000, _l6p3),
  ];

  /// VB6 difficulty level for a sector index. Past the authored parts, each
  /// further sector is one level harder, continuing from where they left off.
  static int levelForIndex(int index) {
    if (index < 0) return 1;
    return index < _parts.length
        ? _parts[index].level
        : _parts.last.level + (index - _parts.length) + 1;
  }

  /// First sector index that plays the given level.
  static int firstIndexForLevel(int level) {
    final i = _parts.indexWhere((p) => p.level == level);
    return i >= 0 ? i : _parts.length + (level - _parts.last.level - 1);
  }

  /// Map a pre-v2.4 save's sector index onto the part table: the old index was
  /// one sector per level, so an old save resumes at the first part of the
  /// level it had reached. Procedural indices shift by the table growth and
  /// land on the same level (identical seed).
  static int migrateLegacyIndex(int old) => old <= 5
      ? firstIndexForLevel(old + 1)
      : _parts.length + (old - 6);

  /// Parallax art zone for a sector index.
  static int zoneForIndex(int index) => BgZones.forLevel(levelForIndex(index));

  /// VB6 damage growth coefficient (Sector.cls:493-519)
  static double _damageCoefficient(int level) {
    const dmgGrowLevel = 20;
    if (level < dmgGrowLevel) return 1.0;
    double dmgGrow = 0.25;
    if (level >= 35) {
      dmgGrow = 0.60;
    } else if (level >= 30) {
      dmgGrow = 0.45;
    } else if (level >= 25) {
      dmgGrow = 0.35;
    }
    return 1 + ((level - dmgGrowLevel + 1) * dmgGrow);
  }

  /// Append a phased boss as the sector's final wave (every 5th level >= 10).
  ///
  /// Stats scale without bound with the boss ordinal n (level 10 → 1, 15 → 2,
  /// ...): HP is rubber-banded to the player's peak DPS via a growing target
  /// time-to-kill, weapon damage follows the VB6 dcf curve with a boss premium,
  /// and cadence tightens toward a floor. Kill credit is a bounded bounty
  /// (creditOverride) so the DPS-scaled HP can't inflate the economy.
  static void _addBossWave(Sector s, TyrianGame game) {
    final n = s.level ~/ 5 - 1; // boss ordinal: level 10 → 1, 15 → 2, ...
    final w = config.gameWidth;
    final h = config.gameHeight;

    final dps = max(game.vessel.lastMaxDps, 100.0);
    final ttk = 20.0 + 3.0 * n; // target time-to-kill grows forever
    final bossHp = max((dps * ttk).round(), 10000 + 5000 * n);
    final dcf = _damageCoefficient(s.level);
    final bossDmg = (9 * 5.555 * dcf * 1.5).round().clamp(30, 9999);
    final recharge = (130 - 6 * n).clamp(40, 130);
    final collisionDmg = 20 + 2 * n;
    final bounty = 5000 + 5000 * n;

    // Enter once the last wave has fully spawned and flown its path (+3s).
    double lastEnd = 0;
    for (final f in s.fleets) {
      final pathDur = f.path.nodes.length * config.frameDelay / 1000.0;
      final end = f.enterTime + f.count * f.triggerInterval + pathDur;
      if (end > lastEnd) lastEnd = end;
    }

    final boss = Fleet.create(
      id: s.fleets.length,
      enterTime: lastEnd + 3.0,
      caption: 'Rododendron Mk.$n',
      hostType: HostType.bouncer,
      count: 1,
      durationSec: 6.0,
      srcX: w / 2,
      srcY: -160,
      dstX: w / 2,
      dstY: h * 0.22,
      pathType: PathType.cosinus,
      amplitude: 120,
      cycles: 2,
      bonus: CollType.shieldUpgrade,
      bonusMoney: bounty ~/ 2,
      defaultPathAction: PathAction.stay, // phase 1 hovers; Boss strafes later
      bossSpec: BossSpec(
        ordinal: n,
        weapDamage: bossDmg,
        rechargeFrames: recharge,
      ),
      hpOverride: bossHp,
      collisionDmgOverride: collisionDmg,
      creditOverride: bounty,
    );
    s.fleets.add(boss);
  }

  // ---- Random Sector Generation (VB6 Sector.SetupRandom) ----
  /// Keyed on difficulty [level], not on sector index — the two stopped being
  /// interchangeable once a level could span several sectors. Seeding on
  /// `level - 1` reproduces the previous `index * 42` seed exactly, so existing
  /// random sectors are unchanged.
  static Sector _createRandom(int level, TyrianGame game) {
    final rng = Random((level - 1) * 42);

    // VB6: fleetCount = Round(Rnd * 15 + 5) → 5-20 fleets
    final numFleets = (rng.nextDouble() * 15 + 5).round();

    final s = Sector(
      caption: 'Sector $level — Unknown Space',
      level: level,
      // VB6: sectorBonus = CLng(fleetCount) * CLng(2500) * level
      sectorBonus: numFleets * 2500 * level,
    );

    // Track max DPS (VB6 rocket.lastMaxDps)
    final dps = game.vessel.totalDps;
    if (dps > game.vessel.lastMaxDps) {
      game.vessel.lastMaxDps = dps;
    }
    final lastMaxDps = game.vessel.lastMaxDps;

    final dcf = _damageCoefficient(level);

    // VB6 maxHostLevel: scales with player DPS (Sector.cls:528-531)
    var maxHostLevel = (6 * (lastMaxDps / 500)).round();
    if (maxHostLevel > level + 2) maxHostLevel = level + 1;
    if (maxHostLevel > 10) maxHostLevel = 10;
    if (level >= 17 && dps > 10000) maxHostLevel = 11;
    maxHostLevel = maxHostLevel.clamp(0, HostType.values.length - 1);

    final hostTypes = HostType.values;
    double etime = 2.0;
    double simultan = 1.0;
    double prevDur = 0;

    for (int i = 0; i < numFleets; i++) {
      final typeIndex = rng.nextInt(maxHostLevel + 1).clamp(0, hostTypes.length - 1);
      final ht = hostTypes[typeIndex];
      final enemyHp = Hostile.getHpMax(ht).toDouble();

      // VB6 host count scaling (Sector.cls:536-551)
      var cnt = (rng.nextInt(4) + 1) * 5; // 5-25
      if (lastMaxDps > 0) {
        final hpRatio = enemyHp / lastMaxDps;
        if (hpRatio > 3) {
          if (cnt > 5) cnt = 5;
        } else if (hpRatio > 2) {
          if (cnt > 10) cnt = 10;
        } else if (hpRatio < 0.09) {
          cnt = cnt * 2;
        }
      }

      // VB6 duration scaling (Sector.cls:573-589)
      final pathTypes = PathType.values;
      final pt = pathTypes[rng.nextInt(pathTypes.length)];
      final amp = 60.0 + rng.nextDouble() * 200.0;
      final cyc = 1 + rng.nextInt(5);
      var durCoef = 1.6;
      if (pt.index > 1 && amp >= 100) durCoef += amp / 66;
      if (durCoef > 4.7) durCoef = 4.7;
      var dur = lastMaxDps > 0
          ? (enemyHp / lastMaxDps) * cnt * durCoef
          : 5.0 + rng.nextDouble() * 8.0;
      if (dur < 3.0) dur = 3.0;
      if (dur > 120.0) dur = 120.0;

      // VB6 simultaneous fleet logic: chance of sharing previous enter time
      double enter;
      if (i > 0 && rng.nextDouble() > 0.55 / simultan) {
        enter = etime; // simultaneous with previous fleet
        simultan++;
      } else {
        if (i > 0) {
          etime += prevDur + 2.0 + rng.nextDouble() * 3.0;
        }
        enter = etime;
        simultan = 1.0;
      }
      prevDur = dur;

      // VB6: 35% chance of horizontal attack paths
      double srcX, srcY, dstX, dstY;
      if (rng.nextDouble() < 0.35) {
        final fromLeft = rng.nextBool();
        srcX = fromLeft ? -50.0 : config.gameWidth + 50;
        dstX = fromLeft ? config.gameWidth + 50 : -50.0;
        srcY = config.gameHeight * 0.2 + rng.nextDouble() * config.gameHeight * 0.5;
        dstY = config.gameHeight * 0.2 + rng.nextDouble() * config.gameHeight * 0.5;
      } else {
        srcX = rng.nextDouble() * config.gameWidth;
        srcY = -40.0 - rng.nextDouble() * 60;
        dstX = rng.nextDouble() * config.gameWidth;
        dstY = config.gameHeight + 40.0 + rng.nextDouble() * 60;
      }

      final bonusTypes = CollType.values;
      final bon = bonusTypes[rng.nextInt(bonusTypes.length)];

      final fleet = Fleet.create(
        id: i,
        enterTime: enter,
        caption: '${cnt}x ${Hostile.hostCaption(ht)}',
        hostType: ht,
        count: cnt,
        triggerSteps: 15 + rng.nextInt(30),
        durationSec: dur,
        srcX: srcX,
        srcY: srcY,
        dstX: dstX,
        dstY: dstY,
        pathType: pt,
        amplitude: amp,
        cycles: cyc,
        bonus: bon,
        bonusMoney: 100 + rng.nextInt(500),
        showDamage: true,
      );
      final weapDmg = (typeIndex * 5.555 * dcf).round().clamp(5, 9999);
      final maxFL = (dps / 20).round().clamp(0, 385);
      final weapRecharge = ((400 - maxFL) * 2 + 2).clamp(4, 802);
      fleet.addWeapon(weapDmg, weapRecharge);
      s.fleets.add(fleet);
    }

    // VB6 asteroids: count = Rnd * (fleetCount/2), timed across the sector
    final asteroidCount = (rng.nextDouble() * numFleets / 2).round();
    if (asteroidCount > 0) {
      _addAsteroids(s, 0, asteroidCount, 50, config.gameWidth - 100);
      // Redistribute enter times evenly across sector duration
      final totalTime = etime + prevDur;
      for (int i = 0; i < s.structures.length; i++) {
        final slice = totalTime / s.structures.length;
        s.structures[i].enterTime = slice * i + rng.nextDouble() * slice;
      }
    }

    return s;
  }
}

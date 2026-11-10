import 'dart:math' as math;

import '../../entities/boss.dart';
import '../sector.dart';
import '../sigils/sigil_catalog.dart';
import '../sigils/sigil_recognizer.dart';
import '../sigils/sigil_spec.dart';
import 'kata.dart';

/// The training arena's dials (Prompts/29 §3): a boss that comes back the
/// moment it dies, with as many bolted-on parts as asked for, and the
/// player's own setup.
class ArenaSettings {
  /// Parts on the boss, 0 (bare core) to 4 (turret, shield pod, thruster,
  /// cannon) — the campaign's boss progression.
  int bossParts = 1;

  /// Companions the ship starts every round with.
  int companions = 0;

  /// CHARGE never runs out.
  bool infiniteCharge = false;

  /// World speed: 1, ½ or ¼.
  double speed = 1.0;

  /// The sigil being drilled, or null for free play.
  SigilKind? drill;

  /// The kata being run, or null. A kata replaces the drill.
  Kata? kata;

  void stepKata(int dir) {
    final sorted = [...kKatas]..sort((a, b) => a.band.compareTo(b.band));
    final all = <Kata?>[null, ...sorted];
    final i = all.indexOf(kata);
    kata = all[((i < 0 ? 0 : i) + dir) % all.length];
    if (kata != null) drill = null;
  }

  static const List<double> speeds = [1.0, 0.5, 0.25];
  static const int maxParts = 4;

  /// Every sigil there is, in teaching order: a sigil added to the catalogue
  /// is in the arena the same build.
  static List<SigilKind?> get drills => [
        null,
        for (final s in [...SigilCatalog.all]
          ..sort((a, b) => a.tier != b.tier
              ? a.tier.compareTo(b.tier)
              : a.layer.index.compareTo(b.layer.index)))
          s.kind,
      ];

  void stepParts(int dir) => bossParts = (bossParts + dir).clamp(0, maxParts);
  void stepCompanions(int dir) => companions = (companions + dir).clamp(0, 2);
  void stepSpeed(int dir) {
    final i = speeds.indexOf(speed);
    speed = speeds[((i < 0 ? 0 : i) + dir).clamp(0, speeds.length - 1)];
  }

  void stepDrill(int dir) {
    final all = drills;
    final i = all.indexOf(drill);
    drill = all[((i < 0 ? 0 : i) + dir) % all.length];
    if (drill != null) kata = null;
  }

  /// The VB6 level the arena boss is built at: deeper for more parts, so its
  /// guns match the campaign boss that carries the same pieces.
  int get level => bossParts <= 1 ? 10 : 10 + 5 * (bossParts - 1);

  /// Boss ordinal for its HP and cadence curve.
  int get ordinal => bossParts < 1 ? 1 : bossParts;

  /// One sector holding only the boss, with the parts the dial asks for,
  /// sized to a ship that deals [dps].
  Sector sector(double dps) {
    final s = Sector(caption: 'ARENA', level: level, sectorBonus: 0);
    Sector.addBossWave(s,
        ordinal: ordinal,
        dps: math.max(dps, 100.0),
        ttk: 18.0 + 4.0 * bossParts,
        hpFloor: 6000 + 4000 * bossParts,
        parts: bossPartsForOrdinal(bossParts));
    return s;
  }
}

/// How one sigil went in this arena session.
class SigilStat {
  int casts = 0;
  int misses = 0;
  double _accSum = 0;
  double bestAccuracy = 0;

  /// Fastest drawing that cast, seconds.
  double? bestTime;
  double lastAccuracy = 0;

  double get meanAccuracy => casts == 0 ? 0 : _accSum / casts;

  void cast(double accuracy, double time) {
    casts++;
    _accSum += accuracy;
    lastAccuracy = accuracy;
    if (accuracy > bestAccuracy) bestAccuracy = accuracy;
    if (bestTime == null || time < bestTime!) bestTime = time;
  }
}

/// The arena's scoreboard for the session.
class ArenaStats {
  int bosses = 0;

  /// Times the ship would have died; the arena puts it back together.
  int knockouts = 0;
  final Map<SigilKind, SigilStat> sigils = {};

  /// Misses whose nearest sigil is unknown.
  int stray = 0;
  double _bossClock = 0;
  double? bestBossTime;

  void reset() {
    bosses = 0;
    knockouts = 0;
    sigils.clear();
    stray = 0;
    _bossClock = 0;
    bestBossTime = null;
  }

  void tick(double dt) => _bossClock += dt;

  void bossDown() {
    bosses++;
    if (bestBossTime == null || _bossClock < bestBossTime!) {
      bestBossTime = _bossClock;
    }
    _bossClock = 0;
  }

  void onReading(SigilReading r) {
    final spec = r.spec;
    if (spec != null) {
      sigils.putIfAbsent(spec.kind, SigilStat.new).cast(r.accuracy, r.drawTime);
      return;
    }
    final near = r.miss?.nearest;
    if (near == null) {
      stray++;
    } else {
      sigils.putIfAbsent(near.kind, SigilStat.new).misses++;
    }
  }

  /// Casts and mean precision over every sigil.
  (int, double) get totals {
    var n = 0;
    var acc = 0.0;
    for (final s in sigils.values) {
      n += s.casts;
      acc += s.meanAccuracy * s.casts;
    }
    return (n, n == 0 ? 0 : acc / n);
  }
}

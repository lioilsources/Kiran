import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/hostile.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/systems/fleet.dart';
import 'package:tyrian_mobile/systems/path_system.dart';
import 'package:tyrian_mobile/systems/sector.dart';

/// Design-rule enforcement for the 18 hand-authored parts (v2.4.0).
///
/// These are the contracts the wave design was approved against: minute-long
/// scripts, enforced variety, a VB6-anchored economy, and the authoring
/// conventions the engine silently depends on (fleet ordering, bare-seconds
/// durations). A failure here means a part drifted from the design, not that
/// the engine broke.
void main() {
  const partCount = 18;

  /// VB6 per-level HP totals — kill credit equals HP, so this is the credit
  /// economy the shop prices were tuned against. Parts must land within ±20%.
  const vb6LevelHp = {1: 21020, 2: 31640, 3: 59000, 4: 61000, 5: 76200, 6: 97120};
  const levelBonus = {1: 5000, 2: 7500, 3: 10000, 4: 15000, 5: 20000, 6: 25000};

  const bossTier = {HostType.falconxb, HostType.falconxt, HostType.bouncer};

  double fleetDuration(Fleet f) =>
      (f.path.nodes.length + (f.extraPath?.nodes.length ?? 0)) / 40.0;

  double scriptEnd(Sector s) {
    var end = 0.0;
    for (final f in s.fleets) {
      final e = f.enterTime + f.count * f.triggerInterval + fleetDuration(f);
      if (e > end) end = e;
    }
    return end + config.delayOnComplete;
  }

  List<Sector> buildAll() =>
      [for (var i = 0; i < partCount; i++) Sector.buildPart(i)];

  test('every part is a minute session: script ends within 60 s', () {
    for (var i = 0; i < partCount; i++) {
      final s = Sector.buildPart(i);
      expect(scriptEnd(s), lessThanOrEqualTo(60.0),
          reason: '${s.caption} ends at ${scriptEnd(s).toStringAsFixed(1)} s');
    }
  });

  test('no single path outlives the part: longest flight <= 40 s', () {
    for (final s in buildAll()) {
      for (final f in s.fleets) {
        expect(fleetDuration(f), lessThanOrEqualTo(40.0),
            reason: '${s.caption} fleet ${f.id}');
      }
    }
  });

  test('variety: at least two enemy types and two path shapes per part', () {
    for (final s in buildAll()) {
      final types = s.fleets.map((f) => f.hostType).toSet();
      final shapes = s.fleets.map((f) => f.pathType).toSet();
      expect(types.length, greaterThanOrEqualTo(2), reason: s.caption);
      expect(shapes.length, greaterThanOrEqualTo(2), reason: s.caption);
    }
  });

  test('adjacent parts never share their dominant type or shape', () {
    HostType domType(Sector s) {
      final hp = <HostType, int>{};
      for (final f in s.fleets) {
        hp[f.hostType] =
            (hp[f.hostType] ?? 0) + f.count * Hostile.getHpMax(f.hostType);
      }
      return hp.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    }

    PathType domShape(Sector s) {
      final wgt = <PathType, double>{};
      for (final f in s.fleets) {
        wgt[f.pathType] = (wgt[f.pathType] ?? 0) + f.count * fleetDuration(f);
      }
      return wgt.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    }

    final all = buildAll();
    for (var i = 1; i < all.length; i++) {
      expect(domType(all[i]), isNot(domType(all[i - 1])),
          reason: '${all[i - 1].caption} → ${all[i].caption} share a type');
      expect(domShape(all[i]), isNot(domShape(all[i - 1])),
          reason: '${all[i - 1].caption} → ${all[i].caption} share a shape');
    }
  });

  test('fleets arrive in list order with ids 0..n-1', () {
    // The dead-time skip reads the FIRST unstarted fleet in list order, so an
    // out-of-order list silently mistargets the skip.
    for (final s in buildAll()) {
      for (var i = 0; i < s.fleets.length; i++) {
        expect(s.fleets[i].id, i, reason: '${s.caption} fleet order');
        if (i > 0) {
          expect(s.fleets[i].enterTime,
              greaterThanOrEqualTo(s.fleets[i - 1].enterTime),
              reason: '${s.caption} enterTime order');
        }
      }
    }
  });

  test('no boss-tier hostiles outside actual bosses', () {
    for (final s in buildAll()) {
      for (final f in s.fleets) {
        expect(bossTier.contains(f.hostType), isFalse,
            reason: '${s.caption} uses ${f.hostType} — boss music would fire');
      }
    }
  });

  test('per-level bonus shares sum exactly to the VB6 sectorBonus', () {
    final sums = <int, int>{};
    for (final s in buildAll()) {
      sums[s.level] = (sums[s.level] ?? 0) + s.sectorBonus;
    }
    expect(sums, levelBonus);
  });

  test('per-level HP economy stays within ±20% of VB6', () {
    final sums = <int, int>{};
    for (final s in buildAll()) {
      var hp = 0;
      for (final f in s.fleets) {
        hp += f.count * Hostile.getHpMax(f.hostType);
      }
      sums[s.level] = (sums[s.level] ?? 0) + hp;
    }
    for (final e in vb6LevelHp.entries) {
      final got = sums[e.key]!;
      expect(got, greaterThanOrEqualTo((e.value * 0.8).round()),
          reason: 'level ${e.key}: $got HP vs VB6 ${e.value}');
      expect(got, lessThanOrEqualTo((e.value * 1.2).round()),
          reason: 'level ${e.key}: $got HP vs VB6 ${e.value}');
    }
  });

  test('estimated peak concurrency stays under 32', () {
    for (final s in buildAll()) {
      var peak = 0.0;
      final end = scriptEnd(s);
      for (var t = 0.0; t <= end; t += 0.5) {
        var alive = 0.0;
        for (final f in s.fleets) {
          if (t < f.enterTime) continue;
          final spawned =
              ((t - f.enterTime) / f.triggerInterval + 1).clamp(0, f.count.toDouble());
          double exited = 0;
          if (f.defaultPathAction == PathAction.destroy) {
            final dur = fleetDuration(f);
            exited = ((t - f.enterTime - dur) / f.triggerInterval + 1)
                .clamp(0, f.count.toDouble());
          }
          alive += spawned - exited;
        }
        if (alive > peak) peak = alive;
      }
      expect(peak, lessThanOrEqualTo(32),
          reason: '${s.caption} peaks at ${peak.round()} concurrent');
    }
  });

  test('durations are bare seconds — session length is device-independent', () {
    // Build every part at two aspect ratios: path node counts must be
    // identical (steps = durationSec*40, no hs leak into durations) while the
    // geometry moves (hs IS applied to Y positions/amplitudes).
    final original = config.gameHeight;
    addTearDown(() => config.gameHeight = original);

    config.gameHeight = 832;
    final short = buildAll();
    config.gameHeight = 1300;
    final tall = buildAll();

    var geometryMoved = false;
    for (var i = 0; i < partCount; i++) {
      for (var j = 0; j < short[i].fleets.length; j++) {
        final a = short[i].fleets[j].path;
        final b = tall[i].fleets[j].path;
        expect(a.nodes.length, b.nodes.length,
            reason: '${short[i].caption} fleet $j: durationSec leaked hs');
        if (a.nodes.isNotEmpty &&
            (a.nodes.first.y - b.nodes.first.y).abs() > 0.001) {
          geometryMoved = true;
        }
      }
    }
    expect(geometryMoved, isTrue,
        reason: 'no fleet geometry tracks the field height — hs lost entirely');
  });
}

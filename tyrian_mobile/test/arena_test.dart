import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/boss.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_catalog.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_recognizer.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_spec.dart';
import 'package:tyrian_mobile/systems/training/arena.dart';

void main() {
  group('every combo is in the arena the same build (Prompts/29)', () {
    test('each sigil of the catalogue is a drill', () {
      final drills = ArenaSettings.drills.whereType<SigilKind>().toSet();
      expect(drills, SigilCatalog.all.map((s) => s.kind).toSet());
    });

    test('drills come in teaching order, free play first', () {
      final d = ArenaSettings.drills;
      expect(d.first, isNull);
      final tiers = [for (final k in d.skip(1)) SigilCatalog.of(k!).tier];
      expect(tiers, [...tiers]..sort());
    });

    test('stepping the drill visits every sigil and wraps', () {
      final a = ArenaSettings();
      final seen = <SigilKind?>{};
      for (var i = 0; i < ArenaSettings.drills.length; i++) {
        seen.add(a.drill);
        a.stepDrill(1);
      }
      expect(seen, ArenaSettings.drills.toSet());
      expect(a.drill, isNull, reason: 'back to free play');
    });
  });

  group('the arena boss', () {
    test('carries exactly the parts the dial asks for, 0 to 4', () {
      for (var parts = 0; parts <= ArenaSettings.maxParts; parts++) {
        final a = ArenaSettings()..bossParts = parts;
        final s = a.sector(500);
        expect(s.fleets, hasLength(1), reason: 'only the boss');
        final spec = s.fleets.single.bossSpec!;
        expect(spec.parts, bossPartsForOrdinal(parts), reason: 'parts $parts');
      }
    });

    test('the dial stops at the ends', () {
      final a = ArenaSettings()..bossParts = 0;
      a.stepParts(-1);
      expect(a.bossParts, 0);
      a.bossParts = 4;
      a.stepParts(1);
      expect(a.bossParts, 4);
    });

    test('more parts is a deeper boss', () {
      final levels = [
        for (var p = 0; p <= 4; p++) (ArenaSettings()..bossParts = p).level,
      ];
      expect(levels, [...levels]..sort());
      expect(levels.first, greaterThanOrEqualTo(10));
    });
  });

  group('speed and companions', () {
    test('world speed steps through 100, 50 and 25 %', () {
      final a = ArenaSettings();
      a.stepSpeed(1);
      expect(a.speed, 0.5);
      a.stepSpeed(1);
      expect(a.speed, 0.25);
      a.stepSpeed(1);
      expect(a.speed, 0.25);
      a.stepSpeed(-2);
      expect(a.speed, 1.0);
    });

    test('companions run 0 to 2', () {
      final a = ArenaSettings();
      a.stepCompanions(5);
      expect(a.companions, 2);
      a.stepCompanions(-5);
      expect(a.companions, 0);
    });
  });

  group('the scoreboard', () {
    SigilReading cast(SigilKind k, double acc, double t) => SigilReading(
          spec: SigilCatalog.of(k),
          drawn: const [],
          layer: SigilCatalog.of(k).layer,
          drawTime: t,
          accuracy: acc,
        );

    test('casts, precision and the fastest drawing per sigil', () {
      final st = ArenaStats();
      st.onReading(cast(SigilKind.loop, 0.8, 0.5));
      st.onReading(cast(SigilKind.loop, 1.0, 0.4));
      st.onReading(SigilReading(
        spec: null,
        drawn: const [],
        layer: SigilLayer.hull,
        drawTime: 0.3,
        miss: SigilDiagnosis(SigilMiss.skippedDot,
            nearest: SigilCatalog.of(SigilKind.loop)),
      ));
      final s = st.sigils[SigilKind.loop]!;
      expect(s.casts, 2);
      expect(s.misses, 1);
      expect(s.meanAccuracy, closeTo(0.9, 1e-9));
      expect(s.bestAccuracy, 1.0);
      expect(s.bestTime, 0.4);
      final (n, acc) = st.totals;
      expect(n, 2);
      expect(acc, closeTo(0.9, 1e-9));
    });

    test('boss times keep the best', () {
      final st = ArenaStats();
      st.tick(30);
      st.bossDown();
      st.tick(20);
      st.bossDown();
      st.tick(40);
      st.bossDown();
      expect(st.bosses, 3);
      expect(st.bestBossTime, 20);
    });
  });
}

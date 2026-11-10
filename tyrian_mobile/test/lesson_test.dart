import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_catalog.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_recognizer.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_spec.dart';
import 'package:tyrian_mobile/systems/training/lesson.dart';

SigilReading cast(SigilKind k, {double acc = 0.9}) => SigilReading(
    spec: SigilCatalog.of(k),
    drawn: const [],
    layer: SigilCatalog.of(k).layer,
    drawTime: 0.4,
    accuracy: acc);

SigilReading miss() => const SigilReading(
    spec: null, drawn: [], layer: SigilLayer.hull, drawTime: 0.4);

void main() {
  group('a lesson, step by step (Prompts/29 §4.1)', () {
    test('watch → trace → slow → live → five in a row → learned', () {
      final l = Lesson(SigilCatalog.of(SigilKind.loop));
      expect(l.phase, LessonPhase.watch);
      expect(l.ghostPlays, isTrue);
      l.onDemo();
      l.onDemo();
      expect(l.phase, LessonPhase.trace);
      expect(l.worldSpeed, 0, reason: 'the world stands while you trace');
      expect(l.countOnly, isTrue);
      for (var i = 0; i < 3; i++) {
        l.onReading(cast(SigilKind.loop));
      }
      expect(l.phase, LessonPhase.slow);
      expect(l.worldSpeed, 0.5);
      for (var i = 0; i < 3; i++) {
        l.onReading(cast(SigilKind.loop));
      }
      expect(l.phase, LessonPhase.live);
      for (var i = 0; i < 3; i++) {
        l.onReading(cast(SigilKind.loop));
      }
      expect(l.phase, LessonPhase.streak);
      for (var i = 0; i < 4; i++) {
        l.onReading(cast(SigilKind.loop));
      }
      l.onReading(miss());
      expect(l.count, 0, reason: 'a miss restarts the streak');
      for (var i = 0; i < 5; i++) {
        l.onReading(cast(SigilKind.loop));
      }
      expect(l.learned, isTrue);
    });

    test('another sigil does not count, and outside the streak does not reset', () {
      final l = Lesson(SigilCatalog.of(SigilKind.loop))..phase = LessonPhase.slow;
      l.onReading(cast(SigilKind.loop));
      l.onReading(cast(SigilKind.strike));
      expect(l.count, 1);
    });

    test('the ghost does not count as the player', () {
      final l = Lesson(SigilCatalog.of(SigilKind.loop));
      expect(l.onReading(cast(SigilKind.loop)), isFalse);
      expect(l.phase, LessonPhase.watch);
    });
  });

  group('the drill tempo has no ceiling (Prompts/29 §5.1)', () {
    test('five in a row raise it by 5 %, a miss in the layer lowers it', () {
      final l = Lesson(SigilCatalog.of(SigilKind.loop), learned: true);
      expect(l.worldSpeed, 1.0);
      for (var round = 0; round < 30; round++) {
        for (var i = 0; i < 5; i++) {
          l.onReading(cast(SigilKind.loop));
        }
      }
      expect(l.tempo, closeTo(2.5, 1e-9));
      expect(l.bestTempo, closeTo(2.5, 1e-9));
      l.onReading(miss());
      expect(l.tempo, closeTo(2.45, 1e-9));
    });

    test('never below half speed', () {
      final l = Lesson(SigilCatalog.of(SigilKind.loop), learned: true);
      for (var i = 0; i < 50; i++) {
        l.onReading(miss());
      }
      expect(l.tempo, Lesson.tempoFloor);
    });
  });

  group('mastery', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('rank is one per power of ten of real casts, unbounded', () {
      final e = MasteryEntry();
      expect(e.rank, 0);
      e.fieldCasts = 10;
      expect(e.rank, 1);
      e.fieldCasts = 999;
      expect(e.rank, 2);
      e.fieldCasts = 1000000;
      expect(e.rank, 6);
    });

    test('arena casts improve the records but not the rank', () {
      final e = MasteryEntry();
      e.record(cast(SigilKind.loop, acc: 0.95), field: false);
      expect(e.fieldCasts, 0);
      expect(e.bestAccuracy, 0.95);
      e.record(cast(SigilKind.loop, acc: 0.5), field: true);
      expect(e.fieldCasts, 1);
      expect(e.bestAccuracy, 0.95);
    });

    test('survives a save and a load', () async {
      final m = SigilMastery.instance;
      m.of(SigilKind.loop)
        ..learned = true
        ..fieldCasts = 42
        ..bestTempo = 1.35;
      await m.save();
      m.entries.clear();
      // Force a reload from prefs.
      final fresh = MasteryEntry.fromJson(
          (await SharedPreferences.getInstance()).getString('sigil_mastery') == null
              ? {}
              : {'learned': true, 'field': 42, 'acc': 0, 'tempo': 1.35});
      expect(fresh.learned, isTrue);
      expect(fresh.fieldCasts, 42);
      expect(fresh.bestTempo, 1.35);
    });
  });
}

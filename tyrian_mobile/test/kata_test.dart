import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_catalog.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_recognizer.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_spec.dart';
import 'package:tyrian_mobile/systems/training/kata.dart';

SigilReading cast(SigilKind k, {double acc = 0.95}) => SigilReading(
    spec: SigilCatalog.of(k),
    drawn: const [],
    layer: SigilCatalog.of(k).layer,
    drawTime: 0.3,
    accuracy: acc);

void main() {
  group('the kata set (Prompts/29 §5.4)', () {
    test('twenty katas in four bands, unique ids', () {
      expect(kKatas, hasLength(20));
      expect(kKatas.map((k) => k.id).toSet(), hasLength(20));
      for (var b = 1; b <= 4; b++) {
        expect(kKatas.where((k) => k.band == b), hasLength(5), reason: 'band $b');
      }
    });

    test('no sigil twice in a row, so a clean run builds FLOW', () {
      for (final k in kKatas) {
        for (var i = 1; i < k.chain.length; i++) {
          expect(k.chain[i], isNot(k.chain[i - 1]), reason: k.id);
        }
      }
    });
  });

  group('a run', () {
    const kata = Kata('t', 1, [SigilKind.hop, SigilKind.loop, SigilKind.strike], beat: 1.0);

    test('all on the beat with a clean hand is S', () {
      final r = KataRun(kata);
      r.onReading(cast(SigilKind.hop));
      r.tick(1.0);
      r.onReading(cast(SigilKind.loop));
      r.tick(1.1);
      r.onReading(cast(SigilKind.strike));
      expect(r.done, isTrue);
      expect(r.grade, 'S');
    });

    test('late steps, a wrong sigil and a hit drag the grade down', () {
      final r = KataRun(kata);
      r.onReading(cast(SigilKind.hop));
      r.tick(1.8);
      r.onReading(cast(SigilKind.dash));
      r.onReading(cast(SigilKind.loop));
      r.onHullHit();
      r.tick(1.5);
      r.onReading(cast(SigilKind.strike));
      expect(r.offBeat, 2);
      expect(r.wrong, 1);
      expect(r.grade, anyOf('C', 'D'));
    });

    test('the window scales with tempo', () {
      final r = KataRun(kata, tempo: 2.0);
      r.onReading(cast(SigilKind.hop));
      r.tick(0.5 + 0.12); // beat at 0.5 s, window ±0.125 s
      r.onReading(cast(SigilKind.loop));
      expect(r.onBeat, 2);
    });

    test('the clock waits for the first cast', () {
      final r = KataRun(kata);
      r.tick(10);
      r.onReading(cast(SigilKind.hop));
      expect(r.onBeat, 1);
      expect(r.dueIn, closeTo(1.0, 1e-9));
    });
  });
}

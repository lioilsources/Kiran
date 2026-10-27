import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/rendering/bg_zones.dart';

void main() {
  group('BgZones.forSector', () {
    test('maps the seven authored sectors 1:1', () {
      for (int i = 0; i < BgZones.count; i++) {
        expect(BgZones.forSector(i), i);
      }
    });

    test('clamps procedurally generated sectors to the last zone', () {
      for (final sector in [7, 8, 20, 999]) {
        expect(BgZones.forSector(sector), BgZones.count - 1);
      }
    });

    test('clamps negative indices to zone 0', () {
      expect(BgZones.forSector(-1), 0);
    });
  });

  group('BgZones.tintFor', () {
    test('is null through the authored zones, so their art speaks for itself',
        () {
      for (int level = 1; level <= BgZones.count; level++) {
        expect(BgZones.tintFor(level), isNull, reason: 'level $level');
      }
    });

    test('engages from the first procedural level', () {
      expect(BgZones.tintFor(BgZones.count + 1), isNotNull);
    });

    test('runs monotonically hotter and darker, never touching red', () {
      int? prevG, prevB;
      for (int level = BgZones.count + 1; level <= 40; level++) {
        final c = BgZones.tintFor(level)!;
        expect(c.a, 1.0, reason: 'filter alpha must not compound with the dim');
        expect((c.r * 255).round(), 255, reason: 'red is held at full');
        final g = (c.g * 255).round();
        final b = (c.b * 255).round();
        if (prevG != null) {
          expect(g, lessThanOrEqualTo(prevG));
          expect(b, lessThanOrEqualTo(prevB!));
        }
        expect(b, lessThan(g), reason: 'blue falls faster than green');
        prevG = g;
        prevB = b;
      }
    });

    test('saturates rather than fading to black', () {
      final saturated = BgZones.tintFor(19)!;
      expect(BgZones.tintFor(500), saturated);
      // Still bright enough to read as art rather than a black screen.
      expect((saturated.g * 255).round(), greaterThan(100));
      expect((saturated.b * 255).round(), greaterThan(60));
    });
  });
}

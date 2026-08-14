import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/rendering/bg_zones.dart';
import 'package:tyrian_mobile/systems/sector.dart';

/// Sector index and VB6 difficulty level used to be the same number. They are
/// being separated so a long level can be split into several shorter sectors.
/// While the part table is still one-window-per-level these must agree with the
/// old `index + 1`, which is what makes the refactor provably behaviour-neutral.
void main() {
  group('Sector.levelForIndex', () {
    test('reproduces index + 1 across the hand-scripted range', () {
      for (var i = 0; i < 6; i++) {
        expect(Sector.levelForIndex(i), i + 1, reason: 'index $i');
      }
    });

    test('the first procedural sector is level 7, as it was', () {
      expect(Sector.levelForIndex(6), 7);
    });

    test('procedural sectors keep climbing one level at a time', () {
      for (var i = 6; i < 40; i++) {
        expect(Sector.levelForIndex(i), i + 1, reason: 'index $i');
      }
    });

    test('is monotonic and never returns a level below 1', () {
      expect(Sector.levelForIndex(-1), 1);
      var prev = 0;
      for (var i = 0; i < 60; i++) {
        final lv = Sector.levelForIndex(i);
        expect(lv, greaterThanOrEqualTo(prev));
        prev = lv;
      }
    });

    test('no hand-scripted sector can trigger the every-5th-level boss', () {
      // _addBossWave fires on level % 5 == 0 && level >= 10. Splitting levels
      // into parts must never let a scripted sector drift into that window.
      for (var i = 0; i < 6; i++) {
        final lv = Sector.levelForIndex(i);
        expect(lv % 5 == 0 && lv >= 10, isFalse, reason: 'index $i → level $lv');
      }
    });
  });

  group('Sector.zoneForIndex', () {
    test('matches the old index-keyed mapping over the authored zones', () {
      for (var i = 0; i < BgZones.count; i++) {
        expect(Sector.zoneForIndex(i), BgZones.forSector(i), reason: 'index $i');
      }
    });

    test('clamps to the last authored zone beyond it', () {
      for (final i in [7, 8, 20, 200]) {
        expect(Sector.zoneForIndex(i), BgZones.count - 1);
      }
    });
  });

  group('BgZones.forLevel', () {
    test('is forSector shifted by one, so level 1 wears zone 0', () {
      expect(BgZones.forLevel(1), 0);
      expect(BgZones.forLevel(7), BgZones.count - 1);
      expect(BgZones.forLevel(99), BgZones.count - 1);
    });

    test('the escalation tint still starts only past the authored zones', () {
      // Tied to level, not index — a split level must not tint early.
      for (var lv = 1; lv <= BgZones.count; lv++) {
        expect(BgZones.tintFor(lv), isNull, reason: 'level $lv');
      }
      expect(BgZones.tintFor(BgZones.count + 1), isNotNull);
    });
  });
}

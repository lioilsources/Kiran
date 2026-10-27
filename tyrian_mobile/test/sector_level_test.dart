import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/rendering/bg_zones.dart';
import 'package:tyrian_mobile/systems/sector.dart';

/// Index → level/zone mapping for the 18-part table (three ~60s parts per
/// level, v2.4.0). The first procedural sector must still be level 7 with the
/// same RNG seed, or every "Unknown Space" silently changes content.
void main() {
  group('Sector.levelForIndex', () {
    test('three parts share each hand-authored level', () {
      for (var i = 0; i < 18; i++) {
        expect(Sector.levelForIndex(i), 1 + i ~/ 3, reason: 'index $i');
      }
    });

    test('the first procedural sector is level 7, as it always was', () {
      expect(Sector.levelForIndex(18), 7);
    });

    test('procedural sectors keep climbing one level at a time', () {
      for (var i = 18; i < 50; i++) {
        expect(Sector.levelForIndex(i), i - 11, reason: 'index $i');
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

    test('no hand-authored part can trigger the every-5th-level boss', () {
      for (var i = 0; i < 18; i++) {
        final lv = Sector.levelForIndex(i);
        expect(lv % 5 == 0 && lv >= 10, isFalse, reason: 'index $i → level $lv');
      }
    });
  });

  group('Sector.firstIndexForLevel and migrateLegacyIndex', () {
    test('first part of each level sits at 3*(level-1)', () {
      for (var lv = 1; lv <= 6; lv++) {
        expect(Sector.firstIndexForLevel(lv), 3 * (lv - 1));
      }
      expect(Sector.firstIndexForLevel(7), 18);
      expect(Sector.firstIndexForLevel(10), 21);
    });

    test('a pre-v2.4 save resumes at the first part of its level', () {
      // Old table: one sector per level, index == level - 1.
      expect(Sector.migrateLegacyIndex(0), 0);
      expect(Sector.migrateLegacyIndex(1), 3);
      expect(Sector.migrateLegacyIndex(3), 9);
      expect(Sector.migrateLegacyIndex(5), 15);
      // Old procedural indices keep their level (identical seed).
      expect(Sector.migrateLegacyIndex(6), 18);
      expect(Sector.migrateLegacyIndex(9), 21);
      expect(Sector.levelForIndex(Sector.migrateLegacyIndex(6)), 7);
      expect(Sector.levelForIndex(Sector.migrateLegacyIndex(9)), 10);
    });
  });

  group('achievement level mapping', () {
    // _onSectorComplete reports Sector.levelForIndex(completedIndex + 1) as
    // the reached level. Guards "Reach sector N" against firing three times
    // faster now that levels are split into three parts.
    test('only the last part of a level claims the next level', () {
      int reached(int completedIndex) =>
          Sector.levelForIndex(completedIndex + 1);
      expect(reached(0), 1); // System Perimeter I → still level 1
      expect(reached(1), 1);
      expect(reached(2), 2); // level 1 finished → reached level 2
      expect(reached(3), 2); // Inner Zone I must NOT claim level 3
      expect(reached(4), 2);
      expect(reached(5), 3);
      expect(reached(16), 6);
      expect(reached(17), 7); // last authored part → first procedural level
      expect(reached(18), 8);
    });
  });

  group('Sector.zoneForIndex', () {
    test('all three parts of a level share its art zone', () {
      for (var i = 0; i < 18; i++) {
        expect(Sector.zoneForIndex(i), i ~/ 3, reason: 'index $i');
      }
    });

    test('procedural sectors clamp to the last authored zone', () {
      for (final i in [18, 19, 30, 200]) {
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
      for (var lv = 1; lv <= BgZones.count; lv++) {
        expect(BgZones.tintFor(lv), isNull, reason: 'level $lv');
      }
      expect(BgZones.tintFor(BgZones.count + 1), isNotNull);
    });
  });
}

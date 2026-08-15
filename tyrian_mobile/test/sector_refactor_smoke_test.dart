import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/systems/sector.dart';

/// Pins the content of the six sectors across the _Part-table refactor.
/// These are the VB6 fleet/enemy counts as shipped; if this test fails, the
/// refactor stopped being behaviour-neutral.
///
/// This file is expected to be REPLACED when the 18 authored parts land —
/// the golden values below describe the VB6 content, not the new design.
void main() {
  const golden = [
    // (fleets, structures, total enemies)
    (10, 20, 147), // System Perimeter
    (9, 0, 173), // Inner Zone
    (7, 20, 196), // Planet Perimeter
    (18, 0, 167), // Planet Patrol
    (13, 7, 242), // Planet Orbit
    (7, 0, 136), // Industry Zone
  ];

  test('the refactored builders produce the exact VB6 content', () {
    for (var i = 0; i < golden.length; i++) {
      final s = Sector.buildPart(i);
      expect(s.fleets.length, golden[i].$1, reason: 'part $i fleets');
      expect(s.structures.length, golden[i].$2, reason: 'part $i structures');
      expect(s.fleets.fold(0, (a, f) => a + f.count), golden[i].$3,
          reason: 'part $i enemies');
      expect(s.level, i + 1);
    }
  });

  test('legacy index migration maps onto first parts', () {
    // With the 1:1 table this is the identity for 0..5 — the interesting
    // cases arrive with the 18-part table.
    for (var old = 0; old <= 5; old++) {
      expect(Sector.migrateLegacyIndex(old), Sector.firstIndexForLevel(old + 1));
    }
    // Procedural indices keep their level.
    expect(Sector.levelForIndex(Sector.migrateLegacyIndex(6)), 7);
    expect(Sector.levelForIndex(Sector.migrateLegacyIndex(9)), 10);
  });
}

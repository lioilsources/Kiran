import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/ui/loadout_cursor.dart';

/// Pad/keyboard navigation of the ComCenter loadout. Cell counts are per row:
/// FRONT, LEFT, RIGHT, GEN.
void main() {
  test('down walks the rows, then enters the bottom bar', () {
    final c = LoadoutCursor();
    final counts = [6, 5, 4, 1];
    c.moveRow(1, counts, 2);
    c.moveRow(1, counts, 2);
    c.moveRow(1, counts, 2);
    expect((c.region, c.row), (LoadoutRegion.loadout, 3));
    c.moveRow(1, counts, 2);
    expect(c.region, LoadoutRegion.bottomBar);
    c.moveRow(-1, counts, 2);
    expect((c.region, c.row), (LoadoutRegion.loadout, 3));
  });

  test('up from FRONT stays put', () {
    final c = LoadoutCursor();
    c.moveRow(-1, [6, 5, 4, 1], 1);
    expect((c.region, c.row), (LoadoutRegion.loadout, 0));
  });

  test('the column is kept as far as the next row allows', () {
    final c = LoadoutCursor()..cell = 5;
    c.moveRow(1, [6, 3, 4, 1], 1);
    expect(c.cell, 2);
    c.moveRow(1, [6, 3, 4, 1], 1);
    expect(c.cell, 2, reason: 'clamped, not restored');
    c.moveRow(1, [6, 3, 4, 1], 1);
    expect(c.cell, 0, reason: 'GEN has only UPG');
  });

  test('left/right stop at the row edges and report it', () {
    final c = LoadoutCursor();
    final counts = [3, 3, 3, 1];
    expect(c.moveCell(-1, counts, 1), isFalse);
    expect(c.moveCell(1, counts, 1), isTrue);
    expect(c.moveCell(1, counts, 1), isTrue);
    expect(c.moveCell(1, counts, 1), isFalse);
    expect(c.cell, 2);
  });

  test('the bottom bar moves between its buttons', () {
    final c = LoadoutCursor()
      ..region = LoadoutRegion.bottomBar
      ..bottomIndex = 0;
    expect(c.moveCell(1, [1, 1, 1, 1], 3), isTrue);
    expect(c.moveCell(1, [1, 1, 1, 1], 3), isTrue);
    expect(c.moveCell(1, [1, 1, 1, 1], 3), isFalse);
    expect(c.bottomIndex, 2);
  });

  test('tab cycles the whole screen in both directions', () {
    final c = LoadoutCursor();
    final counts = [4, 4, 4, 1];
    c.cycle(-1, counts, 1);
    expect(c.region, LoadoutRegion.bottomBar);
    c.cycle(1, counts, 1);
    expect((c.region, c.row), (LoadoutRegion.loadout, 0));
    for (var i = 0; i < 4; i++) {
      c.cycle(1, counts, 1);
    }
    expect(c.region, LoadoutRegion.bottomBar);
  });

  test('clamp follows a row that lost its SELL cell', () {
    final c = LoadoutCursor()..cell = 5;
    c.clamp(5);
    expect(c.cell, 4);
    c.clamp(0);
    expect(c.cell, 0);
  });
}

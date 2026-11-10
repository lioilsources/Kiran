import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/systems/training/arena.dart';
import 'package:tyrian_mobile/systems/training/gauntlet.dart';

void main() {
  test('every boss beaten adds a part, up to four, and toughness', () {
    final g = Gauntlet(startParts: 1);
    expect(g.parts, 1);
    for (var i = 0; i < 6; i++) {
      g.bossDown(0);
    }
    expect(g.parts, 4);
    expect(g.hpMul, closeTo(1.9, 1e-9));
  });

  test('the rating has no ceiling and pays for depth and FLOW', () {
    final a = Gauntlet(), b = Gauntlet();
    a.bossDown(0);
    a.bossDown(0);
    b.bossDown(9);
    b.bossDown(9);
    expect(b.rating, greaterThan(a.rating));
    for (var i = 0; i < 1000; i++) {
      a.bossDown(9);
    }
    expect(a.rating, greaterThan(1000000));
  });

  test('a gauntlet round builds the boss its round asks for', () {
    final arena = ArenaSettings()..bossParts = 0;
    final s = arena.sector(500, parts: 3, hpMul: 1.45);
    expect(s.fleets.single.bossSpec!.parts, hasLength(3));
  });
}

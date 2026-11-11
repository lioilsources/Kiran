import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/systems/duel_brain.dart';

/// The duel boss's moves (Prompts/30 §7.2): seeded, inside the arena, clear
/// of the ship, and growing with the boss's number and its wounds.
void main() {
  const w = 1067.0, h = 600.0;

  DuelBrain brain(int ordinal, {int seed = 1}) =>
      DuelBrain(ordinal: ordinal, width: w, height: h, seed: seed);

  test('it comes down from above to its home', () {
    final b = brain(1);
    expect(b.move, DuelMove.enter);
    expect(b.y, lessThan(0));
    for (var i = 0; i < 90; i++) {
      b.step(1 / 60, phase: 1, shipX: w / 2, shipY: h * 0.85);
    }
    expect(b.y, closeTo(h * 0.28, 8));
    expect(b.x, closeTo(w / 2, 8));
  });

  test('the same seed flies the same duel', () {
    final a = brain(4, seed: 7), b = brain(4, seed: 7);
    for (var i = 0; i < 60 * 40; i++) {
      final phase = i < 800 ? 1 : (i < 1600 ? 2 : 3);
      a.step(1 / 60, phase: phase, shipX: 300, shipY: 500);
      b.step(1 / 60, phase: phase, shipX: 300, shipY: 500);
      expect(a.x, b.x);
      expect(a.y, b.y);
    }
  });

  test('moves come with the boss number and the phase', () {
    expect(brain(1).movesFor(1), [DuelMove.hover, DuelMove.sweep]);
    expect(brain(1).movesFor(3), [DuelMove.hover, DuelMove.sweep, DuelMove.dive]);
    expect(brain(2).movesFor(2),
        [DuelMove.hover, DuelMove.sweep, DuelMove.dive, DuelMove.perch]);
    expect(brain(3).movesFor(3), isNot(contains(DuelMove.cross)));
    expect(brain(4).movesFor(3), contains(DuelMove.cross));
    expect(brain(4).movesFor(1), isNot(contains(DuelMove.orbit)));
  });

  test('a calm boss only hovers', () {
    final b = DuelBrain(ordinal: 4, width: w, height: h, calm: true);
    expect(b.movesFor(3), [DuelMove.hover]);
  });

  test('it keeps to the arena and, but for a dive, clear of the ship', () {
    for (var seed = 0; seed < 6; seed++) {
      final b = brain(4, seed: seed);
      final rng = Random(seed);
      var sx = w / 2, sy = h * 0.85;
      for (var i = 0; i < 60 * 60; i++) {
        final phase = i < 1200 ? 1 : (i < 2400 ? 2 : 3);
        if (i % 120 == 0) {
          sx = w * (0.1 + 0.8 * rng.nextDouble());
          sy = h * (0.5 + 0.45 * rng.nextDouble());
        }
        b.step(1 / 60, phase: phase, shipX: sx, shipY: sy);
        if (b.move == DuelMove.enter) continue;
        expect(b.x, inInclusiveRange(-w * 0.05, w * 1.05), reason: 'seed $seed');
        expect(b.y, inInclusiveRange(-h * 0.05, h * 1.0), reason: 'seed $seed');
      }
    }
  });

  test('phase 1 keeps to the top third', () {
    final b = brain(4, seed: 3);
    for (var i = 0; i < 60 * 30; i++) {
      b.step(1 / 60, phase: 1, shipX: w / 2, shipY: h * 0.85);
      if (b.move == DuelMove.enter) continue;
      // Hover bobs a little past its point.
      expect(b.y, lessThan(h / 3 + 20));
    }
  });

  test('a dive tells before it comes, and stops short of the ship', () {
    final b = brain(1, seed: 11);
    var sawTell = false, sawLunge = false;
    for (var i = 0; i < 60 * 90 && !(sawTell && sawLunge); i++) {
      b.step(1 / 60, phase: 2, shipX: w / 2, shipY: h * 0.85);
      if (b.telling) sawTell = true;
      if (b.lunging) {
        expect(sawTell, isTrue);
        sawLunge = true;
        final d = sqrt(pow(b.x - w / 2, 2) + pow(b.y - h * 0.85, 2));
        expect(d, greaterThan(30));
      }
    }
    expect(sawLunge, isTrue);
  });

  test('perch and orbit spread the fan all round', () {
    final b = brain(3, seed: 5);
    var ring = false;
    for (var i = 0; i < 60 * 120 && !ring; i++) {
      b.step(1 / 60, phase: 3, shipX: w / 2, shipY: h * 0.85);
      if (b.move == DuelMove.perch || b.move == DuelMove.orbit) {
        expect(b.volley, DuelVolley.ring);
        ring = true;
      }
    }
    expect(ring, isTrue);
  });
}

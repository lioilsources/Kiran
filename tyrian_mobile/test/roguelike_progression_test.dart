import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';

/// A minimal save payload; loadFromSave fills the rest from defaults.
Map<String, dynamic> save({
  int score = 0,
  int? nextWeaponLevel,
  int credit = 1234,
}) =>
    {
      'pilotName': 'test-pilot',
      'credit': credit,
      'score': score,
      if (nextWeaponLevel != null) 'nextWeaponLevel': nextWeaponLevel,
      'weapons': const [],
    };

void main() {
  group('weapon tier persistence', () {
    test('a saved tier survives even when score would not grant it', () {
      // The roguelike loop and the ComCenter cheat can both hand out a tier
      // that the score derivation would not reproduce.
      final v = Vessel()..loadFromSave(save(score: 0, nextWeaponLevel: 3));
      expect(v.nextWeaponLevel, 3);
    });

    test('a v2 save without the field still derives the tier from score', () {
      expect(Vessel().nextWeaponLevelAfter(save(score: 0)), 0);
      expect(Vessel().nextWeaponLevelAfter(save(score: 500000)), 2);
      expect(Vessel().nextWeaponLevelAfter(save(score: 5000000)), 3);
    });

    test('score derivation wins when it is higher than the saved tier', () {
      final v = Vessel()..loadFromSave(save(score: 5000000, nextWeaponLevel: 1));
      expect(v.nextWeaponLevel, 3);
    });

    test('the tier is round-tripped through toSaveMap', () {
      final v = Vessel()..loadFromSave(save(score: 0, nextWeaponLevel: 2));
      expect(v.toSaveMap()['nextWeaponLevel'], 2);
    });

    test('tier 2 is what makes the Blaster reachable in the shop', () {
      // ComCenter shows frontWeapons.sublist(0, nextWeaponLevel + 1).
      final v = Vessel()..loadFromSave(save(score: 0, nextWeaponLevel: 2));
      final shown = DevType.frontWeapons.sublist(0, v.nextWeaponLevel + 1);
      expect(shown.map((w) => w.name), contains('Blaster'));
    });
  });

  group('cumulative score', () {
    test('score is never cleared by a save round trip', () {
      final v = Vessel()..loadFromSave(save(score: 320240));
      expect(v.score, 320240);
      expect(v.toSaveMap()['score'], 320240);
    });

    test('newGame is the only thing that wipes progression', () {
      final v = Vessel()..loadFromSave(save(score: 320240, credit: 9999));
      v.newGame();
      expect(v.score, 0);
      expect(v.credit, 0);
      expect(v.nextWeaponLevel, 0);
    });

    test('resetVessel — the death path — keeps progression intact', () {
      final v = Vessel()
        ..loadFromSave(save(score: 320240, nextWeaponLevel: 2, credit: 9999));
      v.hp = 0;
      v.resetVessel();
      expect(v.hp, v.hpMax, reason: 'hull restored');
      expect(v.score, 320240);
      expect(v.credit, 9999);
      expect(v.nextWeaponLevel, 2);
    });
  });
}

extension on Vessel {
  int nextWeaponLevelAfter(Map<String, dynamic> state) {
    loadFromSave(state);
    return nextWeaponLevel;
  }
}

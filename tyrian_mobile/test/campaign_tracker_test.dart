import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/hostile.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/systems/campaign.dart';
import 'package:tyrian_mobile/systems/campaign_tracker.dart';
import 'package:tyrian_mobile/systems/weapon_family.dart';

/// Objective grading, fed with synthetic events. None of this needs a game:
/// the tracker counts what the hooks hand it and grades against the node's
/// own spec, which is what makes a node's difficulty assertable.
void main() {
  Hostile kill(WeaponFamily? by) => Hostile(
        caption: 'x',
        id: 0,
        hostType: HostType.falcon1,
        hp: 0,
        hpMax: 100,
      )..deathFamily = by;

  Vessel hullAt(int percent) {
    final v = Vessel();
    v.hpMax = 100;
    v.hp = percent;
    return v;
  }

  CampaignNode nodeWith(List<ObjectiveSpec> objectives) =>
      CampaignNode(0, 'Test', 1, objectives: objectives);

  group('counting', () {
    test('only killed hostiles count, and the killing weapon is recorded', () {
      final t = CampaignTracker()..beginNode(0);
      t.onKill(kill(WeaponFamily.bubble));
      t.onKill(kill(WeaponFamily.bubble));
      t.onKill(kill(WeaponFamily.vulcan));
      // A path-destroyed hostile never reaches onKill, and one killed by a
      // non-weapon death carries no family.
      t.onKill(kill(null));

      expect(t.kills, 4);
      expect(t.killsWith(WeaponFamily.bubble), 2);
      expect(t.killsWith(WeaponFamily.vulcan), 1);
      expect(t.killsWith(WeaponFamily.laser), 0);
    });

    test('a new node starts from zero — a retry is not cumulative', () {
      final t = CampaignTracker()..beginNode(0, credits: 100);
      t.onKill(kill(WeaponFamily.bubble));
      t.beginNode(0, credits: 250);

      expect(t.kills, 0);
      expect(t.killsWith(WeaponFamily.bubble), 0);
      expect(t.creditsAtStart, 250);
    });
  });

  group('grading', () {
    test('reaching the end clears the anchor task', () {
      final r = (CampaignTracker()..beginNode(0)).evaluate(
        node: nodeWith(const [ObjectiveSpec.clear]),
        vessel: hullAt(100),
        hullDamage: false,
      );
      expect(r.requiredMet, isTrue);
      expect(r.objectives.single.met, isTrue);
    });

    test('a kill count gates the node until it is reached', () {
      final t = CampaignTracker()..beginNode(0);
      final node = nodeWith(const [
        ObjectiveSpec.clear,
        ObjectiveSpec.kills(3, required: true),
      ]);

      for (var i = 0; i < 2; i++) {
        t.onKill(kill(WeaponFamily.bubble));
      }
      var r = t.evaluate(node: node, vessel: hullAt(100), hullDamage: false);
      expect(r.requiredMet, isFalse);
      expect(r.objectives.last.tally, '2 / 3');

      t.onKill(kill(WeaponFamily.bubble));
      r = t.evaluate(node: node, vessel: hullAt(100), hullDamage: false);
      expect(r.requiredMet, isTrue);
    });

    test('stars are optional and reported separately', () {
      final t = CampaignTracker()..beginNode(0);
      for (var i = 0; i < 5; i++) {
        t.onKill(kill(WeaponFamily.bubble));
      }
      final node = nodeWith(const [
        ObjectiveSpec.clear,
        ObjectiveSpec.untouched(),
        ObjectiveSpec.withWeapon(WeaponFamily.bubble, 5, 'Bubble Gun'),
        ObjectiveSpec.withWeapon(WeaponFamily.laser, 5, 'Laser'),
      ]);

      final r = t.evaluate(node: node, vessel: hullAt(100), hullDamage: false);
      expect(r.requiredMet, isTrue, reason: 'stars never gate');
      expect(r.starsEarned, {'untouched', 'weapon'});
      expect(r.starCount, 2);
      expect(r.starTotal, 3);
    });

    test('hull damage decides the untouched star', () {
      final t = CampaignTracker()..beginNode(0);
      final node = nodeWith(const [ObjectiveSpec.untouched()]);

      expect(
          t
              .evaluate(node: node, vessel: hullAt(40), hullDamage: true)
              .starsEarned,
          isEmpty);
      expect(
          t
              .evaluate(node: node, vessel: hullAt(40), hullDamage: false)
              .starsEarned,
          {'untouched'},
          reason: 'shield-only damage still counts as untouched');
    });

    test('the hull star reads the percentage left, not the raw HP', () {
      final t = CampaignTracker()..beginNode(0);
      final node = nodeWith(const [ObjectiveSpec.hull(60)]);

      expect(t.evaluate(node: node, vessel: hullAt(59), hullDamage: true).starCount, 0);
      expect(t.evaluate(node: node, vessel: hullAt(60), hullDamage: true).starCount, 1);

      final big = Vessel()
        ..hpMax = 500
        ..hp = 300; // 60%
      expect(t.evaluate(node: node, vessel: big, hullDamage: true).starCount, 1);
    });

    test('kinds that are not wired up yet never grade as met', () {
      // They are stars-only by construction (see the node table test), so a
      // false here costs a star and can never lock a pilot out.
      final t = CampaignTracker()..beginNode(0);
      const notYet = ObjectiveSpec('later', ObjectiveKind.collectPickups,
          'Collect 3 pickups', amount: 3);
      final r = t.evaluate(
          node: nodeWith(const [ObjectiveSpec.clear, notYet]),
          vessel: hullAt(100),
          hullDamage: false);

      expect(r.requiredMet, isTrue);
      expect(r.starsEarned, isEmpty);
    });
  });
}

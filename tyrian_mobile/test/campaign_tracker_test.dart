import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/boss.dart';
import 'package:tyrian_mobile/entities/hostile.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/systems/campaign.dart';
import 'package:tyrian_mobile/systems/campaign_tracker.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/weapon_family.dart';

/// Objective grading, fed with synthetic events. None of this needs a game:
/// the tracker counts what the hooks hand it and grades against the node's
/// own spec, which is what makes a node's difficulty assertable.
void main() {
  Hostile kill(WeaponFamily? by, {WeaponSlot? slot}) => Hostile(
        caption: 'x',
        id: 0,
        hostType: HostType.falcon1,
        hp: 0,
        hpMax: 100,
      )
        ..deathFamily = by
        ..deathSlot = slot;

  BossPart bossPart(PartKind kind) => BossPart(
        core: Boss(
          caption: 'core',
          id: 0,
          spec: const BossSpec(ordinal: 1, weapDamage: 10, rechargeFrames: 100),
          hp: 100,
          hpMax: 100,
        ),
        kind: kind,
        id: 100,
        armour: 100,
        weapDamage: 10,
        bounty: 100,
      )..hp = 0;

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

    test('the clock comes from the game, and under means at or below', () {
      final t = CampaignTracker()..beginNode(0);
      final node = nodeWith(const [ObjectiveSpec.under(48)]);

      expect(
          t.evaluate(
              node: node,
              vessel: hullAt(100),
              hullDamage: false,
              elapsed: 47.9).starCount,
          1);
      expect(
          t.evaluate(
              node: node,
              vessel: hullAt(100),
              hullDamage: false,
              elapsed: 48.9).starCount,
          1,
          reason: 'graded in whole seconds');
      expect(
          t.evaluate(
              node: node,
              vessel: hullAt(100),
              hullDamage: false,
              elapsed: 49.2).starCount,
          0);
    });
  });

  group('the shop half of the campaign', () {
    Vessel armed(List<(DevType, WeaponSlot)> loadout) {
      final v = Vessel();
      for (final (type, slot) in loadout) {
        v.equipWeapon(type, slot);
      }
      return v;
    }

    test('a loadout task reads the ship at launch, not at the end', () {
      // Pickups equip and upgrade guns mid-flight, so a ship that finished
      // with a side gun may never have shopped for one.
      final t = CampaignTracker()..beginNode(0);
      final bare = armed([(DevType.bubbleGun, WeaponSlot.frontGun)]);
      t.onLaunch(bare);

      // The pickup-equipped gun arrives after launch.
      bare.equipWeapon(DevType.smallBubble, WeaponSlot.leftGun);

      final r = t.evaluate(
          node: nodeWith(const [ObjectiveSpec.armSides(required: true)]),
          vessel: bare,
          hullDamage: false);
      expect(r.requiredMet, isFalse);

      t.onLaunch(bare); // next attempt, launched with it
      expect(
          t
              .evaluate(
                  node: nodeWith(const [ObjectiveSpec.armSides(required: true)]),
                  vessel: bare,
                  hullDamage: false)
              .requiredMet,
          isTrue);
    });

    test('a named gun is checked by name, in the slot asked for', () {
      final t = CampaignTracker()..beginNode(0);
      final v = armed([
        (DevType.bubbleGun, WeaponSlot.frontGun),
        (DevType.starGun, WeaponSlot.rightGun),
      ]);
      t.onLaunch(v);

      ObjectiveStatus grade(ObjectiveSpec spec) =>
          t.evaluate(node: nodeWith([spec]), vessel: v, hullDamage: false)
              .objectives
              .single;

      expect(grade(const ObjectiveSpec.flyWith('Vulcan Cannon')).met, isFalse);
      expect(grade(const ObjectiveSpec.flyWith('Bubble Gun')).met, isTrue);
      // A side task takes either mount — the shop never makes you choose.
      expect(
          grade(const ObjectiveSpec.flyWith('Star Gun',
                  inSlot: WeaponSlot.leftGun))
              .met,
          isTrue);
    });

    test('an upgrade task reads the level of the slot it names', () {
      final t = CampaignTracker()..beginNode(0);
      // A freshly bought device is level 0; one upgrade makes it level 1.
      final v = armed([(DevType.generatorBasic, WeaponSlot.generator)]);
      v.getDevice(WeaponSlot.generator)!.upgrade();

      t.onLaunch(v);
      ObjectiveStatus grade(int level) => t
          .evaluate(
              node: nodeWith([
                ObjectiveSpec.upgraded(WeaponSlot.generator, level, 'generator')
              ]),
              vessel: v,
              hullDamage: false)
          .objectives
          .single;

      expect(grade(1).met, isTrue);
      expect(grade(2).met, isFalse);
      expect(grade(2).tally, '1 / 2');
    });

    test('side-gun kills count from the slot that landed the blow', () {
      final t = CampaignTracker()..beginNode(0);
      t.onKill(kill(WeaponFamily.bubble, slot: WeaponSlot.frontGun));
      t.onKill(kill(WeaponFamily.bubble, slot: WeaponSlot.leftGun));
      t.onKill(kill(WeaponFamily.starg, slot: WeaponSlot.rightGun));
      t.onKill(kill(null)); // rammed, no weapon

      expect(t.sideGunKills, 2);
      expect(
          t
              .evaluate(
                  node: nodeWith(const [ObjectiveSpec.withSideGuns(2)]),
                  vessel: hullAt(100),
                  hullDamage: false)
              .starCount,
          1);
    });
  });

  group('field tasks', () {
    test('pickups, wiped formations and rams each count their own event', () {
      final t = CampaignTracker()..beginNode(0);
      t.onPickup();
      t.onPickup();
      t.onFleetCleared();
      t.onAsteroidRam();

      final r = t.evaluate(
          node: nodeWith(const [
            ObjectiveSpec.collect(2),
            ObjectiveSpec.wipeFleets(2),
            ObjectiveSpec.noRam(),
          ]),
          vessel: hullAt(100),
          hullDamage: false);

      expect(r.starsEarned, {'pickups'});
      expect(r.objectives[1].tally, '1 / 2');
      expect(r.objectives[2].met, isFalse, reason: 'one ram is one too many');
    });

    test('stripping a boss means shooting every part off yourself', () {
      final t = CampaignTracker()..beginNode(0);
      final node = CampaignNode(0, 'Boss', 2,
          bossOrdinal: 2, objectives: const [ObjectiveSpec.strip()]);

      NodeResult grade() =>
          t.evaluate(node: node, vessel: hullAt(100), hullDamage: false);

      expect(grade().starCount, 0);

      t.onKill(bossPart(PartKind.turret));
      expect(grade().objectives.single.tally, '1 / 2');
      expect(grade().starCount, 0, reason: 'the shield pod is still on');

      t.onKill(bossPart(PartKind.shieldPod));
      expect(grade().starCount, 1);
    });

    test('parts that die with the core do not count as stripped', () {
      // Boss.takeDamage zeroes the survivors directly, bypassing the kill
      // hook — which is exactly what makes this objective mean something.
      final t = CampaignTracker()..beginNode(0);
      final node = CampaignNode(0, 'Boss', 2,
          bossOrdinal: 1, objectives: const [ObjectiveSpec.strip()]);

      expect(t.evaluate(node: node, vessel: hullAt(100), hullDamage: false)
          .starCount, 0);
    });

    test('a node without a boss can never earn the strip star', () {
      final t = CampaignTracker()..beginNode(0);
      t.onKill(bossPart(PartKind.turret));
      expect(
          t
              .evaluate(
                  node: nodeWith(const [ObjectiveSpec.strip()]),
                  vessel: hullAt(100),
                  hullDamage: false)
              .starCount,
          0);
    });
  });
}

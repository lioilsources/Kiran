import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/collectable.dart';
import 'package:tyrian_mobile/entities/vessel.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/systems/campaign.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/sector.dart';

import 'support/part_rules.dart';

/// The campaign's twenty nodes: eighteen reused parts plus two level-7 parts,
/// bosses every fifth node. The reused parts are already covered by
/// sector_parts_test; the rules are re-applied here so the two campaign-only
/// parts and the 17→18→19 seams obey the same design.
void main() {
  List<Sector> buildAll() => [
        for (var i = 0; i < Campaign.nodeCount; i++)
          Campaign.buildNodeContent(i)
      ];

  test('twenty nodes, indexed in order', () {
    expect(Campaign.nodeCount, 20);
    for (var i = 0; i < kCampaignNodes.length; i++) {
      expect(kCampaignNodes[i].index, i);
    }
  });

  test('bosses 1..4 sit on every fifth node and nowhere else', () {
    final bosses = {
      for (final n in kCampaignNodes)
        if (n.bossOrdinal != null) n.index: n.bossOrdinal!
    };
    expect(bosses, {4: 1, 9: 2, 14: 3, 19: 4});
  });

  test('levels climb 1..7 and the nodes cover every art zone', () {
    var prev = 0;
    for (var i = 0; i < Campaign.nodeCount; i++) {
      final lv = Campaign.levelForNode(i);
      expect(lv, greaterThanOrEqualTo(prev), reason: 'node $i');
      expect(lv, lessThanOrEqualTo(7));
      prev = lv;
    }
    final zones = {for (var i = 0; i < Campaign.nodeCount; i++) Campaign.zoneForNode(i)};
    expect(zones, {0, 1, 2, 3, 4, 5, 6});
  });

  test('the first eighteen nodes are the endless parts, by name', () {
    for (var i = 0; i < Sector.partCount; i++) {
      expect(kCampaignNodes[i].caption, Sector.buildPart(i).caption,
          reason: 'node $i');
    }
    expect(Sector.campaignExtraCount, Campaign.nodeCount - Sector.partCount);
  });

  group('objectives can never lock a pilot out', () {
    /// Every kind the tracker grades — which is now all of them. A required
    /// task of an ungraded kind would be unmeetable and would gate the
    /// campaign forever.
    const graded = ObjectiveKind.values;

    /// What the node itself puts on the field.
    ({int enemies, int fleets, int drops}) supply(int i) {
      final s = Campaign.buildNodeContent(i);
      var enemies = 0;
      var drops = 0;
      for (final f in s.fleets) {
        enemies += f.count;
        if (f.bonus != CollType.none || f.bonusMoney > 0) drops++;
      }
      return (enemies: enemies, fleets: s.fleets.length, drops: drops);
    }

    test('every node asks to be cleared, and asks it as a requirement', () {
      for (final n in kCampaignNodes) {
        expect(n.objectives.first.kind, ObjectiveKind.completeNode,
            reason: n.caption);
        expect(n.requiredObjectives, isNotEmpty, reason: n.caption);
      }
    });

    test('required tasks only use kinds the tracker grades', () {
      for (final n in kCampaignNodes) {
        for (final o in n.requiredObjectives) {
          expect(graded, contains(o.kind),
              reason: '${n.caption}: required "${o.text}" cannot be met yet');
        }
      }
    });

    test('required kill counts stay well inside what the node sends', () {
      // Hostiles can also leave down the bottom of the field, so a required
      // count has to sit below the total with room to spare.
      for (var i = 0; i < Campaign.nodeCount; i++) {
        final node = kCampaignNodes[i];
        final available = supply(i).enemies;
        for (final o in node.requiredObjectives) {
          if (o.kind != ObjectiveKind.killsTotal) continue;
          expect(o.amount, lessThanOrEqualTo((available * 0.6).floor()),
              reason: '${node.caption}: needs ${o.amount} kills of $available');
        }
      }
    });

    test('kill counts of every flavour stay reachable at all', () {
      const killKinds = {
        ObjectiveKind.killsTotal,
        ObjectiveKind.killsWithFamily,
        ObjectiveKind.killsWithSlot,
      };
      for (var i = 0; i < Campaign.nodeCount; i++) {
        final node = kCampaignNodes[i];
        final available = supply(i).enemies;
        for (final o in node.objectives) {
          if (!killKinds.contains(o.kind)) continue;
          expect(o.amount, lessThanOrEqualTo(available),
              reason: '${node.caption}: "${o.text}" of $available');
        }
      }
    });

    test('formation and pickup counts fit what the node actually drops', () {
      // A formation only drops when wiped to the last ship, and a pickup only
      // exists because a formation dropped it.
      for (var i = 0; i < Campaign.nodeCount; i++) {
        final node = kCampaignNodes[i];
        final s = supply(i);
        for (final o in node.objectives) {
          if (o.kind == ObjectiveKind.fleetBonuses) {
            expect(o.amount, lessThanOrEqualTo(s.fleets),
                reason: '${node.caption}: "${o.text}" of ${s.fleets} formations');
          }
          if (o.kind == ObjectiveKind.collectPickups) {
            expect(o.amount, lessThanOrEqualTo(s.drops),
                reason: '${node.caption}: "${o.text}" of ${s.drops} drops');
          }
        }
      }
    });

    test('loadout tasks name weapons the shop actually stocks by then', () {
      // A task naming a gun the boss progression has not opened yet would be
      // unbuyable — and as a requirement, a dead end.
      var tier = 0;
      for (var i = 0; i < Campaign.nodeCount; i++) {
        final node = kCampaignNodes[i];
        for (final o in node.objectives) {
          if (o.kind != ObjectiveKind.equipInSlot) continue;
          final stocked = [
            ...DevType.frontWeapons.take(tier + 1),
            ...DevType.sideWeapons.take(tier + 1),
          ].map((d) => d.name);
          expect(stocked, contains(o.weaponName),
              reason: '${node.caption}: "${o.text}" but tier $tier is on sale');
        }
        // Clearing a boss opens the next tier for every node after it.
        if (node.isBoss) {
          tier = Campaign.tierForBossOrdinal(node.bossOrdinal!);
        }
      }
    });

    test('a timed star is quick but not impossible', () {
      // Below the last spawn there is physically nothing left to shoot yet;
      // above the script's own end it would come for free.
      for (var i = 0; i < Campaign.nodeCount; i++) {
        final node = kCampaignNodes[i];
        final s = Campaign.buildNodeContent(i);
        var spawnFloor = 0.0;
        for (final f in s.fleets) {
          final end = f.enterTime + (f.count - 1) * f.triggerInterval + 2.0;
          if (end > spawnFloor) spawnFloor = end;
        }
        for (final o in node.objectives) {
          if (o.kind != ObjectiveKind.underTime) continue;
          expect(o.amount, greaterThan(spawnFloor),
              reason: '${node.caption}: ${o.amount}s is before the last spawn '
                  'at ${spawnFloor.toStringAsFixed(1)}s');
          expect(o.amount, lessThan(scriptEnd(s)),
              reason: '${node.caption}: ${o.amount}s is past the script itself');
        }
      }
    });

    test('a required upgrade only ever asks for the generator', () {
      // Upgrade price is the weapon's own price compounding 25-42% a level,
      // so requiring a level on a gun the pilot chose could cost more than
      // the whole campaign earns. The generator is cheap and its lesson —
      // power is the real constraint — is the one worth forcing.
      for (final n in kCampaignNodes) {
        for (final o in n.requiredObjectives) {
          if (o.kind != ObjectiveKind.slotLevelAtLeast) continue;
          expect(o.slot, WeaponSlot.generator, reason: '${n.caption}: ${o.text}');
        }
      }
    });

    test('only boss nodes ask for boss parts', () {
      for (final n in kCampaignNodes) {
        for (final o in n.objectives) {
          if (o.kind != ObjectiveKind.allBossParts &&
              o.kind != ObjectiveKind.bossPartDestroyed) {
            continue;
          }
          expect(n.isBoss, isTrue,
              reason: '${n.caption} asks for boss parts but has no boss');
        }
      }
    });

    test('every node offers at least one star and a stable set of ids', () {
      for (final n in kCampaignNodes) {
        expect(n.starObjectives, isNotEmpty, reason: n.caption);
        final ids = n.objectives.map((o) => o.id).toList();
        expect(ids.toSet().length, ids.length,
            reason: '${n.caption} repeats an objective id');
      }
    });
  });

  test('every node carries its caption and level', () {
    for (var i = 0; i < Campaign.nodeCount; i++) {
      final s = Campaign.buildNodeContent(i);
      expect(s.caption, kCampaignNodes[i].caption);
      expect(s.level, kCampaignNodes[i].level);
      expect(s.isComplete, isFalse);
    }
  });

  test('every node is a minute session: script ends within 60 s', () {
    for (final s in buildAll()) {
      expect(scriptEnd(s), lessThanOrEqualTo(60.0),
          reason: '${s.caption} ends at ${scriptEnd(s).toStringAsFixed(1)} s');
    }
  });

  test('no single path outlives the node: longest flight <= 40 s', () {
    for (final s in buildAll()) {
      for (final f in s.fleets) {
        expect(fleetDuration(f), lessThanOrEqualTo(40.0),
            reason: '${s.caption} fleet ${f.id}');
      }
    }
  });

  test('variety: at least two enemy types and two path shapes per node', () {
    for (final s in buildAll()) {
      expect(s.fleets.map((f) => f.hostType).toSet().length,
          greaterThanOrEqualTo(2),
          reason: s.caption);
      expect(s.fleets.map((f) => f.pathType).toSet().length,
          greaterThanOrEqualTo(2),
          reason: s.caption);
    }
  });

  test('adjacent nodes never share their dominant type or shape', () {
    final all = buildAll();
    for (var i = 1; i < all.length; i++) {
      expect(domType(all[i]), isNot(domType(all[i - 1])),
          reason: '${all[i - 1].caption} → ${all[i].caption} share a type');
      expect(domShape(all[i]), isNot(domShape(all[i - 1])),
          reason: '${all[i - 1].caption} → ${all[i].caption} share a shape');
    }
  });

  test('fleets arrive in list order with ids 0..n-1', () {
    for (final s in buildAll()) {
      for (var i = 0; i < s.fleets.length; i++) {
        expect(s.fleets[i].id, i, reason: '${s.caption} fleet order');
        if (i > 0) {
          expect(s.fleets[i].enterTime,
              greaterThanOrEqualTo(s.fleets[i - 1].enterTime),
              reason: '${s.caption} enterTime order');
        }
      }
    }
  });

  test('no boss-tier hostiles in node content — bosses are added separately',
      () {
    for (final s in buildAll()) {
      for (final f in s.fleets) {
        expect(bossTier.contains(f.hostType), isFalse,
            reason: '${s.caption} uses ${f.hostType}');
      }
    }
  });

  test('estimated peak concurrency stays under 32', () {
    for (final s in buildAll()) {
      expect(peakConcurrency(s), lessThanOrEqualTo(32),
          reason: '${s.caption} peaks at ${peakConcurrency(s).round()}');
    }
  });

  test('durations are bare seconds — session length is device-independent',
      () {
    final original = config.gameHeight;
    addTearDown(() => config.gameHeight = original);

    config.gameHeight = 832;
    final short = buildAll();
    config.gameHeight = 1300;
    final tall = buildAll();

    for (var i = 0; i < Campaign.nodeCount; i++) {
      for (var j = 0; j < short[i].fleets.length; j++) {
        expect(short[i].fleets[j].path.nodes.length,
            tall[i].fleets[j].path.nodes.length,
            reason: '${short[i].caption} fleet $j: durationSec leaked hs');
      }
    }
  });

  group('weapon tiers come from bosses, not from score', () {
    // A campaign banks roughly 500k score over all twenty nodes against a
    // second score threshold of 4M, so without this a campaign pilot would
    // fly the whole way on the starting Bubble Gun.
    CampaignNode bossNode(int ordinal) =>
        kCampaignNodes.firstWhere((n) => n.bossOrdinal == ordinal);

    test('each boss opens the next tier, in order', () {
      final v = Vessel();
      expect(v.nextWeaponLevel, 0, reason: 'a fresh pilot starts on bubbles');

      expect(Campaign.applyBossUnlock(bossNode(1), v),
          '${DevType.frontWeapons[1].name} · ${DevType.sideWeapons[1].name}');
      expect(v.nextWeaponLevel, 1);

      expect(Campaign.applyBossUnlock(bossNode(2), v), isNotNull);
      expect(v.nextWeaponLevel, 2);

      expect(Campaign.applyBossUnlock(bossNode(3), v), isNotNull);
      expect(v.nextWeaponLevel, 3);
    });

    test('the last boss has no tier left to give', () {
      final v = Vessel()..nextWeaponLevel = 3;
      expect(Campaign.applyBossUnlock(bossNode(4), v), isNull);
      expect(v.nextWeaponLevel, 3);
      expect(Campaign.tierForBossOrdinal(4), DevType.frontWeapons.length - 1);
    });

    test('a plain node opens nothing', () {
      final v = Vessel();
      expect(Campaign.applyBossUnlock(kCampaignNodes[0], v), isNull);
      expect(v.nextWeaponLevel, 0);
    });

    test('replaying a boss neither re-announces nor revokes', () {
      final v = Vessel();
      Campaign.applyBossUnlock(bossNode(2), v); // jumped straight to tier 2
      expect(v.nextWeaponLevel, 2);

      expect(Campaign.applyBossUnlock(bossNode(2), v), isNull);
      expect(Campaign.applyBossUnlock(bossNode(1), v), isNull,
          reason: 'an earlier boss must not pull the tier back down');
      expect(v.nextWeaponLevel, 2);
    });

    test('every tier the bosses hand out is actually stocked by the shop', () {
      for (final n in kCampaignNodes.where((n) => n.isBoss)) {
        final tier = Campaign.tierForBossOrdinal(n.bossOrdinal!);
        expect(tier, lessThan(DevType.frontWeapons.length));
        expect(tier, lessThan(DevType.sideWeapons.length));
      }
    });
  });

  group('CampaignState', () {
    test('only node 0 is open at the start', () {
      final c = CampaignState();
      expect(c.isUnlocked(0), isTrue);
      expect(c.isUnlocked(1), isFalse);
      expect(c.isFinished, isFalse);
    });

    test('clearing a node opens the next one and keeps stars', () {
      final c = CampaignState();
      c.markCompleted(0, starsEarned: {'no_damage'});
      expect(c.isCompleted(0), isTrue);
      expect(c.isUnlocked(1), isTrue);
      expect(c.isUnlocked(2), isFalse);
      expect(c.starsFor(0), 1);

      c.markCompleted(0); // replay without stars must not lose the earned one
      expect(c.starsFor(0), 1);
      expect(c.currentNode, 1);
    });

    test('replaying an earlier node never moves the frontier back', () {
      final c = CampaignState()
        ..markCompleted(0)
        ..markCompleted(1)
        ..markCompleted(2);
      c.markCompleted(0);
      expect(c.currentNode, 3);
    });

    test('the last node is the end of the road', () {
      final c = CampaignState();
      for (var i = 0; i < Campaign.nodeCount; i++) {
        c.markCompleted(i);
      }
      expect(c.currentNode, Campaign.nodeCount - 1);
      expect(c.isFinished, isTrue);
    });

    test('survives a JSON round trip', () {
      final c = CampaignState(
        currentNode: 5,
        completed: {0, 1, 2, 3, 4},
        stars: {
          1: {'a', 'b'},
          4: {'boss_parts'}
        },
        vessel: {'credit': 1234, 'weapons': []},
      );
      final back = CampaignState.fromJson(c.toJson());
      expect(back.currentNode, 5);
      expect(back.completed, {0, 1, 2, 3, 4});
      expect(back.stars, {
        1: {'a', 'b'},
        4: {'boss_parts'}
      });
      expect(back.vessel['credit'], 1234);
    });

    test('an empty map is a fresh campaign', () {
      final c = CampaignState.fromJson(const {});
      expect(c.currentNode, 0);
      expect(c.completed, isEmpty);
      expect(c.stars, isEmpty);
    });
  });
}

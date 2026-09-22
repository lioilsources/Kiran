import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/systems/campaign.dart';
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

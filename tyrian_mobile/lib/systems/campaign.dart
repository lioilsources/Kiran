import 'dart:math';

import '../entities/vessel.dart';
import '../game/tyrian_game.dart';
import '../rendering/bg_zones.dart';
import 'sector.dart';

/// What an objective measures. Evaluation lives in campaign_tracker.dart;
/// this file only describes the campaign as data.
enum ObjectiveKind {
  completeNode,
  noHullDamage,
  killsWithFamily,
  killsWithSlot,
  killsTotal,
  equipInSlot,
  slotLevelAtLeast,
  ownsSideGun,
  collectPickups,
  fleetBonuses,
  noAsteroidRam,
  hpAbove,
  underTime,
  bossPartDestroyed,
  allBossParts,
}

/// One task on a campaign node. [required] tasks gate the next node; the rest
/// earn a star. [params] are kind-specific (weapon name, slot, count…).
class ObjectiveSpec {
  final String id;
  final ObjectiveKind kind;
  final Map<String, Object> params;
  final bool required;
  final String text;

  const ObjectiveSpec(this.id, this.kind, this.text,
      {this.params = const {}, this.required = false});

  static const completeNode = ObjectiveSpec(
      'complete', ObjectiveKind.completeNode, 'Clear the sector',
      required: true);
}

class CampaignNode {
  final int index;
  final String caption;

  /// VB6 difficulty level — what the part was authored for.
  final int level;

  /// 1..4 on the boss nodes, null elsewhere.
  final int? bossOrdinal;
  final List<ObjectiveSpec> objectives;

  const CampaignNode(this.index, this.caption, this.level,
      {this.bossOrdinal, this.objectives = const [ObjectiveSpec.completeNode]});

  bool get isBoss => bossOrdinal != null;
  int get zone => BgZones.forLevel(level);
}

/// The twenty nodes of the campaign, in play order. Nodes 0-17 are the
/// eighteen hand-authored parts (levels 1-6); 18-19 are campaign-only level-7
/// parts. Every fifth node ends with a boss.
const List<CampaignNode> kCampaignNodes = [
  CampaignNode(0, 'System Perimeter I', 1),
  CampaignNode(1, 'System Perimeter II', 1),
  CampaignNode(2, 'System Perimeter III', 1),
  CampaignNode(3, 'Inner Zone I', 2),
  CampaignNode(4, 'Inner Zone II', 2, bossOrdinal: 1),
  CampaignNode(5, 'Inner Zone III', 2),
  CampaignNode(6, 'Planet Perimeter I', 3),
  CampaignNode(7, 'Planet Perimeter II', 3),
  CampaignNode(8, 'Planet Perimeter III', 3),
  CampaignNode(9, 'Planet Patrol I', 4, bossOrdinal: 2),
  CampaignNode(10, 'Planet Patrol II', 4),
  CampaignNode(11, 'Planet Patrol III', 4),
  CampaignNode(12, 'Planet Orbit I', 5),
  CampaignNode(13, 'Planet Orbit II', 5),
  CampaignNode(14, 'Planet Orbit III', 5, bossOrdinal: 3),
  CampaignNode(15, 'Industry Zone I', 6),
  CampaignNode(16, 'Industry Zone II', 6),
  CampaignNode(17, 'Industry Zone III', 6),
  CampaignNode(18, 'Deep Core I', 7),
  CampaignNode(19, 'Deep Core II', 7, bossOrdinal: 4),
];

/// Persisted campaign progress plus the campaign vessel's save map. Kept
/// apart from the endless run's save so neither mode can touch the other.
class CampaignState {
  /// Highest node the player may launch.
  int currentNode;
  final Set<int> completed;

  /// Star objective ids earned per node.
  final Map<int, Set<String>> stars;
  Map<String, dynamic> vessel;

  CampaignState({
    this.currentNode = 0,
    Set<int>? completed,
    Map<int, Set<String>>? stars,
    Map<String, dynamic>? vessel,
  })  : completed = completed ?? {},
        stars = stars ?? {},
        vessel = vessel ?? {};

  bool isUnlocked(int node) => node >= 0 && node <= currentNode;
  bool isCompleted(int node) => completed.contains(node);
  int starsFor(int node) => stars[node]?.length ?? 0;
  bool get isFinished => completed.length >= kCampaignNodes.length;

  /// Record a cleared node and open the next one.
  void markCompleted(int node, {Set<String> starsEarned = const {}}) {
    completed.add(node);
    if (starsEarned.isNotEmpty) {
      (stars[node] ??= {}).addAll(starsEarned);
    }
    final next = min(node + 1, kCampaignNodes.length - 1);
    if (next > currentNode) currentNode = next;
  }

  Map<String, dynamic> toJson() => {
        'currentNode': currentNode,
        'completed': completed.toList()..sort(),
        'stars': {
          for (final e in stars.entries) '${e.key}': e.value.toList()..sort(),
        },
        'vessel': vessel,
      };

  factory CampaignState.fromJson(Map<String, dynamic> m) => CampaignState(
        currentNode: (m['currentNode'] as num?)?.toInt() ?? 0,
        completed: {
          for (final v in (m['completed'] as List?) ?? const [])
            (v as num).toInt(),
        },
        stars: {
          for (final e in ((m['stars'] as Map?) ?? const {}).entries)
            int.parse(e.key as String): {
              for (final s in (e.value as List)) s as String,
            },
        },
        vessel: Map<String, dynamic>.from((m['vessel'] as Map?) ?? const {}),
      );
}

abstract final class Campaign {
  static int get nodeCount => kCampaignNodes.length;

  static int levelForNode(int index) =>
      kCampaignNodes[index.clamp(0, kCampaignNodes.length - 1)].level;

  static int zoneForNode(int index) => BgZones.forLevel(levelForNode(index));

  /// The node's wave content, without its boss — buildable in tests.
  static Sector buildNodeContent(int index) {
    final node = kCampaignNodes[index];
    final s = index < Sector.partCount
        ? Sector.buildPart(index)
        : Sector.buildCampaignExtra(index - Sector.partCount);
    s.caption = node.caption;
    return s;
  }

  /// A playable node: content plus the boss wave on boss nodes.
  static Sector buildNode(int index, TyrianGame game) {
    final node = kCampaignNodes[index];
    final s = buildNodeContent(index);
    final n = node.bossOrdinal;
    if (n != null) {
      // Shorter target time-to-kill than the endless boss: a boss node should
      // still feel like a minute-long session, not a siege.
      Sector.addBossWave(s,
          ordinal: n,
          dps: max(poweredDps(game.vessel), 100.0),
          ttk: 15.0 + 4.0 * n,
          hpFloor: 6000 + 4000 * n);
    }
    return s;
  }

  /// DPS of the weapons the generator can actually sustain. `Vessel.totalDps`
  /// counts every device, including ones the ComCenter reports as "off".
  static double poweredDps(Vessel v) {
    double total = 0;
    for (final d in v.devices) {
      if (d.pwrNeed > v.genMax) continue;
      total += d.dps;
    }
    return total;
  }
}

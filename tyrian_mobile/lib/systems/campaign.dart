import 'dart:math';

import '../entities/boss.dart';
import '../entities/vessel.dart';
import '../game/tyrian_game.dart';
import '../rendering/bg_zones.dart';
import 'dev_type.dart';
import 'sector.dart';
import 'weapon_family.dart';

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
/// earn a star. [amount] carries the kind's number (kills, percent, seconds)
/// and [family] the weapon family for kill-by-weapon tasks.
class ObjectiveSpec {
  final String id;
  final ObjectiveKind kind;
  final String text;
  final bool required;
  final int amount;
  final WeaponFamily? family;

  const ObjectiveSpec(this.id, this.kind, this.text,
      {this.required = false, this.amount = 0, this.family});

  /// Clearing the sector at all — every node's first required task.
  static const clear = ObjectiveSpec(
      'clear', ObjectiveKind.completeNode, 'Clear the sector',
      required: true);

  /// Shoot down [n] of them, rather than letting them fly past.
  const ObjectiveSpec.kills(int n, {this.required = false})
      : id = 'kills',
        kind = ObjectiveKind.killsTotal,
        text = 'Shoot down $n hostiles',
        amount = n,
        family = null;

  /// Same, as a star — a higher bar than the required count.
  const ObjectiveSpec.sweep(int n)
      : id = 'sweep',
        kind = ObjectiveKind.killsTotal,
        text = 'Shoot down $n hostiles',
        required = false,
        amount = n,
        family = null;

  const ObjectiveSpec.untouched()
      : id = 'untouched',
        kind = ObjectiveKind.noHullDamage,
        text = 'Take no hull damage',
        required = false,
        amount = 0,
        family = null;

  const ObjectiveSpec.hull(int percent)
      : id = 'hull',
        kind = ObjectiveKind.hpAbove,
        text = 'Finish above $percent% hull',
        required = false,
        amount = percent,
        family = null;

  /// Kills whose final blow came from a given weapon family — the elemental
  /// death effect is the feedback, so this teaches what each gun does.
  const ObjectiveSpec.withWeapon(WeaponFamily f, int n, String weaponLabel,
      {this.required = false})
      : id = 'weapon',
        kind = ObjectiveKind.killsWithFamily,
        text = 'Kill $n with the $weaponLabel',
        amount = n,
        family = f;
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
      {this.bossOrdinal, this.objectives = const [ObjectiveSpec.clear]});

  bool get isBoss => bossOrdinal != null;
  int get zone => BgZones.forLevel(level);

  Iterable<ObjectiveSpec> get requiredObjectives =>
      objectives.where((o) => o.required);
  Iterable<ObjectiveSpec> get starObjectives =>
      objectives.where((o) => !o.required);
}

/// The twenty nodes of the campaign, in play order. Nodes 0-17 are the
/// eighteen hand-authored parts (levels 1-6); 18-19 are campaign-only level-7
/// parts. Every fifth node ends with a boss.
///
/// Required tasks stay inside what the node itself hands the player — clearing
/// it, and shooting down roughly half of what flies through — so no node can
/// lock a pilot out of the campaign. The stars are the reach: an untouched
/// run, a near-full hull, a full sweep. Loadout and shop tasks (buy a side
/// gun, upgrade the generator) need the launch snapshot and land next.
const List<CampaignNode> kCampaignNodes = [
  CampaignNode(0, 'System Perimeter I', 1, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(22, required: true),
    ObjectiveSpec.untouched(),
    ObjectiveSpec.withWeapon(WeaponFamily.bubble, 18, 'Bubble Gun'),
  ]),
  CampaignNode(1, 'System Perimeter II', 1, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(26, required: true),
    ObjectiveSpec.hull(75),
    ObjectiveSpec.sweep(46),
  ]),
  CampaignNode(2, 'System Perimeter III', 1, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(19, required: true),
    ObjectiveSpec.untouched(),
    ObjectiveSpec.withWeapon(WeaponFamily.bubble, 24, 'Bubble Gun'),
  ]),
  CampaignNode(3, 'Inner Zone I', 2, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(28, required: true),
    ObjectiveSpec.hull(60),
    ObjectiveSpec.sweep(50),
  ]),
  CampaignNode(4, 'Inner Zone II', 2, bossOrdinal: 1, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(22, required: true),
    ObjectiveSpec.untouched(),
    ObjectiveSpec.hull(50),
  ]),
  CampaignNode(5, 'Inner Zone III', 2, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(21, required: true),
    ObjectiveSpec.hull(75),
    ObjectiveSpec.sweep(37),
  ]),
  CampaignNode(6, 'Planet Perimeter I', 3, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(20, required: true),
    ObjectiveSpec.untouched(),
    ObjectiveSpec.withWeapon(WeaponFamily.bubble, 26, 'Bubble Gun'),
  ]),
  CampaignNode(7, 'Planet Perimeter II', 3, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(26, required: true),
    ObjectiveSpec.hull(60),
    ObjectiveSpec.sweep(46),
  ]),
  CampaignNode(8, 'Planet Perimeter III', 3, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(22, required: true),
    ObjectiveSpec.untouched(),
    ObjectiveSpec.sweep(40),
  ]),
  CampaignNode(9, 'Planet Patrol I', 4, bossOrdinal: 2, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(30, required: true),
    ObjectiveSpec.hull(50),
    ObjectiveSpec.sweep(55),
  ]),
  CampaignNode(10, 'Planet Patrol II', 4, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(18, required: true),
    ObjectiveSpec.untouched(),
    ObjectiveSpec.sweep(32),
  ]),
  CampaignNode(11, 'Planet Patrol III', 4, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(24, required: true),
    ObjectiveSpec.hull(60),
    ObjectiveSpec.sweep(43),
  ]),
  CampaignNode(12, 'Planet Orbit I', 5, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(26, required: true),
    ObjectiveSpec.untouched(),
    ObjectiveSpec.sweep(47),
  ]),
  CampaignNode(13, 'Planet Orbit II', 5, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(22, required: true),
    ObjectiveSpec.hull(75),
    ObjectiveSpec.sweep(40),
  ]),
  CampaignNode(14, 'Planet Orbit III', 5, bossOrdinal: 3, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(24, required: true),
    ObjectiveSpec.untouched(),
    ObjectiveSpec.hull(50),
  ]),
  CampaignNode(15, 'Industry Zone I', 6, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(24, required: true),
    ObjectiveSpec.hull(60),
    ObjectiveSpec.sweep(43),
  ]),
  CampaignNode(16, 'Industry Zone II', 6, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(28, required: true),
    ObjectiveSpec.untouched(),
    ObjectiveSpec.sweep(51),
  ]),
  CampaignNode(17, 'Industry Zone III', 6, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(16, required: true),
    ObjectiveSpec.hull(75),
    ObjectiveSpec.sweep(29),
  ]),
  CampaignNode(18, 'Deep Core I', 7, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(21, required: true),
    ObjectiveSpec.untouched(),
    ObjectiveSpec.sweep(38),
  ]),
  CampaignNode(19, 'Deep Core II', 7, bossOrdinal: 4, objectives: [
    ObjectiveSpec.clear,
    ObjectiveSpec.kills(16, required: true),
    ObjectiveSpec.untouched(),
    ObjectiveSpec.hull(50),
  ]),
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
      // still feel like a minute-long session, not a siege. The pieces carry
      // HP of their own on top of the core's, so the core's own target stays
      // deliberately modest.
      Sector.addBossWave(s,
          ordinal: n,
          dps: max(poweredDps(game.vessel), 100.0),
          ttk: 15.0 + 4.0 * n,
          hpFloor: 6000 + 4000 * n,
          parts: bossPartsForOrdinal(n));
    }
    return s;
  }

  /// Weapon tier a boss of this ordinal hands over. The last boss lands on
  /// the top tier the shop has, so it opens nothing new — by then the whole
  /// catalogue is on sale and the fight is the reward.
  static int tierForBossOrdinal(int ordinal) =>
      min(ordinal, DevType.frontWeapons.length - 1);

  /// Open the next weapon tier for beating a campaign boss, and say what
  /// opened. Null when nothing did.
  ///
  /// Endless earns tiers by cumulative score (`Vessel.wepLevScores`), a curve
  /// a campaign never approaches: a full twenty-node run banks around 500k
  /// against a second threshold of 4M, so a campaign pilot would fly the whole
  /// way on the starting Bubble Gun. Bosses carry that progression instead.
  /// The tier lives on the vessel and is only ever raised, so replaying a boss
  /// neither re-announces nor revokes anything.
  static String? applyBossUnlock(CampaignNode node, Vessel v) {
    final ordinal = node.bossOrdinal;
    if (ordinal == null) return null;
    final tier = tierForBossOrdinal(ordinal);
    if (tier <= v.nextWeaponLevel) return null;
    v.nextWeaponLevel = tier;
    return '${DevType.frontWeapons[tier].name} · ${DevType.sideWeapons[tier].name}';
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

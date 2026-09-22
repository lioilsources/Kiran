import '../entities/hostile.dart';
import '../entities/vessel.dart';
import 'campaign.dart';
import 'weapon_family.dart';

/// One objective's outcome at the end of a node.
class ObjectiveStatus {
  final ObjectiveSpec spec;
  final int progress;
  final int target;
  final bool met;

  const ObjectiveStatus(this.spec, this.progress, this.target, this.met);

  bool get required => spec.required;

  /// "18 / 22" for counted tasks, empty for the pass/fail ones.
  String get tally => target > 1 ? '$progress / $target' : '';
}

/// What a finished node earned: whether it counts as cleared, and which star
/// tasks came in.
class NodeResult {
  final int nodeIndex;
  final List<ObjectiveStatus> objectives;

  const NodeResult(this.nodeIndex, this.objectives);

  bool get requiredMet => objectives.where((o) => o.required).every((o) => o.met);

  Set<String> get starsEarned => {
        for (final o in objectives)
          if (!o.required && o.met) o.spec.id,
      };

  int get starCount => starsEarned.length;
  int get starTotal => objectives.where((o) => !o.required).length;
}

/// Counts what happens during one campaign node and grades it at the end.
///
/// Fed from the same call sites as [AchievementService] — the kill hook in
/// Fleet, the hull-damage flag on the game — and reset per node by
/// [beginNode]. Holds no references to the game, so the whole grading path is
/// testable without one.
class CampaignTracker {
  int nodeIndex = -1;
  int kills = 0;
  final Map<WeaponFamily, int> killsByFamily = {};

  /// Credits the pilot launched with, so the result card can show what the
  /// run itself brought in.
  int creditsAtStart = 0;

  /// Start counting for [index]; called from TyrianGame.loadSector, which is
  /// the only way a node begins — a retry included.
  void beginNode(int index, {int credits = 0}) {
    nodeIndex = index;
    kills = 0;
    killsByFamily.clear();
    creditsAtStart = credits;
  }

  /// A hostile the player shot down. Hostiles that fly off the field or are
  /// killed by a path action never reach this, which is what makes a kill
  /// count an actual measure of shooting.
  void onKill(Hostile h) {
    kills++;
    final f = h.deathFamily;
    if (f != null) killsByFamily[f] = (killsByFamily[f] ?? 0) + 1;
  }

  int killsWith(WeaponFamily f) => killsByFamily[f] ?? 0;

  /// Grade the node. [hullDamage] is the game's per-sector flag, [vessel] is
  /// read for its end-of-node hull.
  NodeResult evaluate({
    required CampaignNode node,
    required Vessel vessel,
    required bool hullDamage,
  }) {
    final out = <ObjectiveStatus>[];
    for (final spec in node.objectives) {
      out.add(_grade(spec, vessel, hullDamage));
    }
    return NodeResult(node.index, out);
  }

  ObjectiveStatus _grade(ObjectiveSpec spec, Vessel vessel, bool hullDamage) {
    switch (spec.kind) {
      case ObjectiveKind.completeNode:
        // Only reached once the sector is complete, so this is the anchor
        // every other task hangs off.
        return ObjectiveStatus(spec, 1, 1, true);

      case ObjectiveKind.killsTotal:
        return ObjectiveStatus(spec, kills, spec.amount, kills >= spec.amount);

      case ObjectiveKind.killsWithFamily:
        final n = spec.family == null ? 0 : killsWith(spec.family!);
        return ObjectiveStatus(spec, n, spec.amount, n >= spec.amount);

      case ObjectiveKind.noHullDamage:
        return ObjectiveStatus(spec, hullDamage ? 0 : 1, 1, !hullDamage);

      case ObjectiveKind.hpAbove:
        final pct = vessel.hpMax <= 0
            ? 0
            : (vessel.hp * 100 / vessel.hpMax).floor();
        return ObjectiveStatus(spec, pct, spec.amount, pct >= spec.amount);

      // Loadout, shop, pickup, timing and boss-part tasks land with the
      // launch snapshot and the composite boss; until then they never grade
      // as met, so none of them can gate a node.
      case ObjectiveKind.killsWithSlot:
      case ObjectiveKind.equipInSlot:
      case ObjectiveKind.slotLevelAtLeast:
      case ObjectiveKind.ownsSideGun:
      case ObjectiveKind.collectPickups:
      case ObjectiveKind.fleetBonuses:
      case ObjectiveKind.noAsteroidRam:
      case ObjectiveKind.underTime:
      case ObjectiveKind.bossPartDestroyed:
      case ObjectiveKind.allBossParts:
        return ObjectiveStatus(spec, 0, spec.amount, false);
    }
  }
}

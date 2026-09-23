import '../entities/boss.dart';
import '../entities/hostile.dart';
import '../entities/vessel.dart';
import 'campaign.dart';
import 'dev_type.dart';
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

/// What the ship looked like when the node launched. Loadout tasks read this
/// rather than the end state: pickups equip and upgrade guns mid-flight
/// (Collectable.applyEffect), so a ship that finished with a side gun may
/// never have shopped for one.
class LaunchLoadout {
  final Map<WeaponSlot, String> names;
  final Map<WeaponSlot, int> levels;

  const LaunchLoadout(this.names, this.levels);

  const LaunchLoadout.empty() : names = const {}, levels = const {};

  /// Whether [weapon] is mounted in [slot]. Asking for a side slot accepts
  /// either side: which of the two a gun went into is the player's business,
  /// and the shop does not make them choose.
  bool hasInSlot(WeaponSlot slot, String weapon) {
    if (slot == WeaponSlot.leftGun || slot == WeaponSlot.rightGun) {
      return names[WeaponSlot.leftGun] == weapon ||
          names[WeaponSlot.rightGun] == weapon;
    }
    return names[slot] == weapon;
  }

  int levelIn(WeaponSlot slot) => levels[slot] ?? 0;
  bool get hasSideGun =>
      names.containsKey(WeaponSlot.leftGun) ||
      names.containsKey(WeaponSlot.rightGun);
}

/// Counts what happens during one campaign node and grades it at the end.
///
/// Fed from the same call sites as [AchievementService] — the kill hook in
/// Fleet, the pickup sweep in the game loop, the hull-damage flag — and reset
/// per node by [beginNode]. Holds no references to the game, so the whole
/// grading path is testable without one.
class CampaignTracker {
  int nodeIndex = -1;
  int kills = 0;
  final Map<WeaponFamily, int> killsByFamily = {};
  final Map<WeaponSlot, int> killsBySlot = {};
  final Set<PartKind> bossPartsDowned = {};
  int pickups = 0;
  int fleetsWiped = 0;
  int asteroidRams = 0;

  /// Credits the pilot launched with, so the result card can show what the
  /// run itself brought in.
  int creditsAtStart = 0;

  LaunchLoadout launchLoadout = const LaunchLoadout.empty();

  /// Start counting for [index]; called from TyrianGame.loadSector, which is
  /// the only way a node begins — a retry included.
  void beginNode(int index, {int credits = 0}) {
    nodeIndex = index;
    kills = 0;
    killsByFamily.clear();
    killsBySlot.clear();
    bossPartsDowned.clear();
    pickups = 0;
    fleetsWiped = 0;
    asteroidRams = 0;
    creditsAtStart = credits;
    launchLoadout = const LaunchLoadout.empty();
  }

  /// Snapshot the ship as the mission starts, after the shop has closed.
  void onLaunch(Vessel v) {
    final names = <WeaponSlot, String>{};
    final levels = <WeaponSlot, int>{};
    for (final d in v.devices) {
      names[d.slot] = d.name;
      levels[d.slot] = d.level;
    }
    launchLoadout = LaunchLoadout(names, levels);
  }

  /// A hostile the player shot down. Hostiles that fly off the field or are
  /// killed by a path action never reach this, which is what makes a kill
  /// count an actual measure of shooting — and what makes stripping a boss a
  /// real objective, since pieces that die with the core never come through.
  void onKill(Hostile h) {
    kills++;
    final f = h.deathFamily;
    if (f != null) killsByFamily[f] = (killsByFamily[f] ?? 0) + 1;
    final s = h.deathSlot;
    if (s != null) killsBySlot[s] = (killsBySlot[s] ?? 0) + 1;
    if (h is BossPart) bossPartsDowned.add(h.kind);
  }

  void onPickup() => pickups++;

  /// A formation wiped to the last ship — the condition its bonus drop hangs
  /// off in Fleet.
  void onFleetCleared() => fleetsWiped++;

  void onAsteroidRam() => asteroidRams++;

  int killsWith(WeaponFamily f) => killsByFamily[f] ?? 0;

  /// Kills landed by the side guns, either slot.
  int get sideGunKills =>
      (killsBySlot[WeaponSlot.leftGun] ?? 0) +
      (killsBySlot[WeaponSlot.rightGun] ?? 0);

  /// Grade the node. [hullDamage] is the game's per-sector flag, [elapsed] the
  /// game's own clock (not Sector.elapsed, which the dead-time skip jumps
  /// forward), and [vessel] is read for its end-of-node hull.
  NodeResult evaluate({
    required CampaignNode node,
    required Vessel vessel,
    required bool hullDamage,
    double elapsed = 0,
  }) {
    final out = <ObjectiveStatus>[];
    for (final spec in node.objectives) {
      out.add(_grade(spec, node, vessel, hullDamage, elapsed));
    }
    return NodeResult(node.index, out);
  }

  ObjectiveStatus _grade(ObjectiveSpec spec, CampaignNode node, Vessel vessel,
      bool hullDamage, double elapsed) {
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

      case ObjectiveKind.killsWithSlot:
        return ObjectiveStatus(
            spec, sideGunKills, spec.amount, sideGunKills >= spec.amount);

      case ObjectiveKind.noHullDamage:
        return ObjectiveStatus(spec, hullDamage ? 0 : 1, 1, !hullDamage);

      case ObjectiveKind.hpAbove:
        final pct = vessel.hpMax <= 0
            ? 0
            : (vessel.hp * 100 / vessel.hpMax).floor();
        return ObjectiveStatus(spec, pct, spec.amount, pct >= spec.amount);

      case ObjectiveKind.equipInSlot:
        final ok = spec.slot != null &&
            spec.weaponName != null &&
            launchLoadout.hasInSlot(spec.slot!, spec.weaponName!);
        return ObjectiveStatus(spec, ok ? 1 : 0, 1, ok);

      case ObjectiveKind.ownsSideGun:
        final ok = launchLoadout.hasSideGun;
        return ObjectiveStatus(spec, ok ? 1 : 0, 1, ok);

      case ObjectiveKind.slotLevelAtLeast:
        final lvl =
            spec.slot == null ? 0 : launchLoadout.levelIn(spec.slot!);
        return ObjectiveStatus(spec, lvl, spec.amount, lvl >= spec.amount);

      case ObjectiveKind.collectPickups:
        return ObjectiveStatus(
            spec, pickups, spec.amount, pickups >= spec.amount);

      case ObjectiveKind.fleetBonuses:
        return ObjectiveStatus(
            spec, fleetsWiped, spec.amount, fleetsWiped >= spec.amount);

      case ObjectiveKind.noAsteroidRam:
        final ok = asteroidRams == 0;
        return ObjectiveStatus(spec, ok ? 1 : 0, 1, ok);

      case ObjectiveKind.underTime:
        final secs = elapsed.floor();
        return ObjectiveStatus(spec, secs, spec.amount, secs <= spec.amount);

      case ObjectiveKind.bossPartDestroyed:
        final ok = bossPartsDowned.isNotEmpty;
        return ObjectiveStatus(spec, ok ? 1 : 0, 1, ok);

      case ObjectiveKind.allBossParts:
        final wanted = node.bossOrdinal == null
            ? const <PartKind>[]
            : bossPartsForOrdinal(node.bossOrdinal!);
        final downed =
            wanted.where(bossPartsDowned.contains).length;
        return ObjectiveStatus(spec, downed, wanted.length,
            wanted.isNotEmpty && downed == wanted.length);
    }
  }
}

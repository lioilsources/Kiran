import '../campaign.dart';
import '../campaign_tracker.dart';
import 'mod_rack.dart';
import 'mod_spec.dart';
import 'mods_state.dart';

/// What a finished node or a downed boss handed over.
class ModReward {
  final List<ModInstance> mods;
  final List<String> hulls;

  const ModReward([this.mods = const [], this.hulls = const []]);

  bool get isEmpty => mods.isEmpty && hulls.isEmpty;
  static const nothing = ModReward();
}

/// Where mods come from (Prompts/27 §4). Campaign rewards are one-off and
/// keyed in [ModsState.claimed]; the endless boss drop repeats — endless is
/// the grind, the campaign is the challenge.
abstract final class ModRewards {
  /// Hull a campaign boss hands over the first time it falls.
  static const hullForBoss = {1: 'dart', 2: 'bastion', 3: 'dynamo'};

  /// The last hull: the campaign finished, or endless this deep.
  static const lastHull = 'colossus';
  static const lastHullDepth = 30;

  /// Endless depth milestones (sectors cleared in one run) and their rarity.
  static const depthMilestones = {
    10: ModRarity.rare,
    20: ModRarity.rare,
    30: ModRarity.mythic,
  };

  static ModReward campaignNode({
    required ModsState state,
    required CampaignNode node,
    required NodeResult result,
    required bool campaignFinished,
    String challengeId = 'normal',
    Iterable<ModInstance> fitted = const [],
  }) {
    if (!result.requiredMet) return ModReward.nothing;
    final mods = <ModInstance>[];
    final hulls = <String>[];
    final i = node.index;

    if (result.starTotal > 0 &&
        result.starCount == result.starTotal &&
        state.claim('stars:$i')) {
      mods.add(
        state.drop(
          DropTable.forNode(i).shiftedFor(challengeId),
          fitted: fitted,
        ),
      );
    }

    final ordinal = node.bossOrdinal;
    if (ordinal != null) {
      final stars = result.starsEarned;
      if (stars.contains('bossfast') && state.claim('boss:$ordinal')) {
        mods.add(
          ordinal >= 4
              ? state.dropRarity(ModRarity.mythic, fitted: fitted)
              : state.drop(
                  DropTable.bossTime.shiftedFor(challengeId),
                  fitted: fitted,
                ),
        );
      }
      if (stars.containsAll(const ['bossfast', 'strip', 'untouched']) &&
          state.claim('perfect:$i')) {
        mods.add(state.dropRarity(ModRarity.mythic, fitted: fitted));
      }
      final hull = hullForBoss[ordinal];
      if (hull != null && state.unlockedHulls.add(hull)) hulls.add(hull);
    }

    if (campaignFinished && state.claim('finish')) {
      mods.add(state.dropRarity(ModRarity.mythic, fitted: fitted));
      if (state.unlockedHulls.add(lastHull)) hulls.add(lastHull);
    }
    return ModReward(mods, hulls);
  }

  static ModReward endlessBoss({
    required ModsState state,
    String challengeId = 'normal',
    Iterable<ModInstance> fitted = const [],
  }) => ModReward([
    state.drop(DropTable.endlessBoss.shiftedFor(challengeId), fitted: fitted),
  ]);

  /// [cleared] sectors finished in this endless run.
  static ModReward endlessDepth({
    required ModsState state,
    required int cleared,
    Iterable<ModInstance> fitted = const [],
  }) {
    final rarity = depthMilestones[cleared];
    if (rarity == null || !state.claim('depth:$cleared')) {
      return ModReward.nothing;
    }
    final hulls = <String>[];
    if (cleared >= lastHullDepth && state.unlockedHulls.add(lastHull)) {
      hulls.add(lastHull);
    }
    return ModReward([state.dropRarity(rarity, fitted: fitted)], hulls);
  }
}

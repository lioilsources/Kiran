import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'hull_spec.dart';
import 'mod_rack.dart';
import 'mod_spec.dart';

/// Odds of each rarity in one drop, as weights.
class DropTable {
  final int common;
  final int rare;
  final int mythic;

  const DropTable(this.common, this.rare, this.mythic);

  static const early = DropTable(80, 20, 0);
  static const mid = DropTable(55, 38, 7);
  static const late = DropTable(35, 50, 15);
  static const bossTime = DropTable(0, 75, 25);
  static const mythicOnly = DropTable(0, 0, 1);
  static const endlessBoss = DropTable(70, 27, 3);

  /// Campaign tier by node index.
  static DropTable forNode(int node) =>
      node < 5 ? early : (node < 15 ? mid : late);

  /// Hard and Lord lean towards the rarer end; the other modes as they are.
  DropTable shiftedFor(String challengeId) => switch (challengeId) {
    'hard' => DropTable(max(0, common - 10), rare + 10, mythic),
    'lord' => DropTable(max(0, common - 10), rare + 10, mythic * 2),
    _ => this,
  };

  ModRarity roll(Random rng) {
    final total = common + rare + mythic;
    if (total <= 0) return ModRarity.common;
    final r = rng.nextInt(total);
    if (r < common) return ModRarity.common;
    if (r < common + rare) return ModRarity.rare;
    return ModRarity.mythic;
  }
}

/// Account-level mod progress: the vault of unfitted mods, unlocked hulls and
/// the one-off rewards already handed out. Shared by endless and campaign;
/// what is fitted lives on each ship's own save. Kept under its own key so
/// neither run save has to migrate when this changes.
class ModsState {
  ModsState._();
  static final ModsState instance = ModsState._();

  static const _key = 'mods_state';
  static const version = 1;

  final List<ModInstance> vault = [];
  final Set<String> unlockedHulls = {HullSpec.falcon.id};

  /// Keys of one-off rewards already paid ('stars:3', 'boss:2', …).
  final Set<String> claimed = {};

  /// Drops come from this seed and advance it, so a reload cannot reroll a
  /// drop and tests can replay one.
  int seed = 1;

  bool _loaded = false;

  void reset() {
    vault.clear();
    unlockedHulls
      ..clear()
      ..add(HullSpec.falcon.id);
    claimed.clear();
    seed = 1;
  }

  Map<String, dynamic> toJson() => {
    'version': version,
    'vault': [for (final i in vault) i.toJson()],
    'hulls': unlockedHulls.toList()..sort(),
    'claimed': claimed.toList()..sort(),
    'seed': seed,
  };

  void loadJson(Map<String, dynamic> m) {
    reset();
    for (final e in (m['vault'] as List?) ?? const []) {
      final i = ModInstance.fromJson(Map<String, dynamic>.from(e as Map));
      if (i != null) vault.add(i);
    }
    for (final h in (m['hulls'] as List?) ?? const []) {
      unlockedHulls.add(h as String);
    }
    for (final c in (m['claimed'] as List?) ?? const []) {
      claimed.add(c as String);
    }
    seed = (m['seed'] as num?)?.toInt() ?? 1;
  }

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_key);
    if (s == null) {
      seed = DateTime.now().microsecondsSinceEpoch & 0x7fffffff;
      return;
    }
    try {
      loadJson(jsonDecode(s) as Map<String, dynamic>);
    } catch (_) {
      reset();
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(toJson()));
  }

  /// The random source for the next draw; advances the stored seed.
  Random _nextRng() {
    final rng = Random(seed);
    seed = rng.nextInt(0x7fffffff) + 1;
    return rng;
  }

  String _newUid(Random rng) {
    final a = rng.nextInt(0x7fffffff).toRadixString(16).padLeft(8, '0');
    final b = rng.nextInt(0xffff).toRadixString(16).padLeft(4, '0');
    return '$a$b';
  }

  /// Draw one mod from [table] into the vault. Within a rarity the pick is
  /// even, except that mods the player already holds twice are skipped while
  /// anything else is left — duplicates are what the forge is for, not what
  /// a drop should hand out.
  ModInstance drop(DropTable table, {Iterable<ModInstance> fitted = const []}) {
    final rng = _nextRng();
    final rarity = table.roll(rng);
    return _add(_pick(rarity, rng, fitted), rng);
  }

  /// One mod of exactly [rarity], optionally never [exclude].
  ModInstance dropRarity(
    ModRarity rarity, {
    Iterable<ModInstance> fitted = const [],
    Set<String> exclude = const {},
  }) {
    final rng = _nextRng();
    return _add(_pick(rarity, rng, fitted, exclude: exclude), rng);
  }

  ModInstance _add(ModSpec spec, Random rng) {
    final i = ModInstance(_newUid(rng), spec.id);
    vault.add(i);
    return i;
  }

  ModSpec _pick(
    ModRarity rarity,
    Random rng,
    Iterable<ModInstance> fitted, {
    Set<String> exclude = const {},
  }) {
    final pool = [
      for (final m in ModSpec.ofRarity(rarity))
        if (!exclude.contains(m.id)) m,
    ];
    final all = pool.isEmpty ? ModSpec.ofRarity(rarity) : pool;
    final held = <String, int>{};
    for (final i in [...vault, ...fitted]) {
      held[i.modId] = (held[i.modId] ?? 0) + 1;
    }
    final fresh = [
      for (final m in all)
        if ((held[m.id] ?? 0) < 2) m,
    ];
    final from = fresh.isEmpty ? all : fresh;
    return from[rng.nextInt(from.length)];
  }

  /// Fuse three vault mods of one rarity into one of the next. Three mythics
  /// make a mythic that is none of the three. Null when the three are not
  /// all in the vault or not one rarity.
  ModInstance? forge(List<ModInstance> three) {
    if (three.length != 3 || three.toSet().length != 3) return null;
    if (!three.every(vault.contains)) return null;
    final rarities = {for (final i in three) i.spec?.rarity};
    if (rarities.length != 1 || rarities.first == null) return null;
    final r = rarities.first!;
    vault.removeWhere(three.contains);
    if (r == ModRarity.mythic) {
      return dropRarity(r, exclude: {for (final i in three) i.modId});
    }
    return dropRarity(ModRarity.values[r.index + 1]);
  }

  /// Pay a one-off reward once. Returns false if [key] was already paid.
  bool claim(String key) => claimed.add(key);
}

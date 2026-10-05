import 'package:shared_preferences/shared_preferences.dart';

/// Player-chosen difficulty: Easy / Normal / Hard, plus a hidden fourth.
///
/// Named [Challenge] rather than "difficulty" because this codebase already
/// uses *difficulty level* for the VB6 per-sector level number that drives
/// `Sector._damageCoefficient` and the art zones. The two are orthogonal: the
/// level says how far in you are, the challenge says how much the game is
/// allowed to hurt you for it.
///
/// [normal] is exactly 1.0 everywhere, so every VB6-parity number in the stat
/// tables stays untouched — the parity tests build at normal and must keep
/// passing. The others are multipliers applied at four choke points:
///
/// - HP at spawn (`Fleet._spawnHostile`) — boss parts derive from core HP, so
///   they follow for free. Kill *credit* is pinned to base HP there, otherwise
///   Hard would also be the richest economy and Easy the poorest.
/// - Damage at `TyrianGame.spawnEnemyProjectile`, which every enemy shot in
///   the game goes through: fleets, boss core, boss parts.
/// - Cadence on the three fire timers (fleet, boss core, boss part).
/// - Score at payout. This compounds with HP (score is paid per HP), which is
///   deliberate: weapon tiers unlock on cumulative score, so Hard reaches the
///   Laser sooner and Easy later. That is the trade the player is making.
enum Challenge {
  easy('easy', 'EASY', hp: 0.75, damage: 0.75, cadence: 1.25, score: 0.75),
  normal('normal', 'NORMAL', hp: 1.0, damage: 1.0, cadence: 1.0, score: 1.0),
  hard('hard', 'HARD', hp: 1.4, damage: 1.3, cadence: 0.8, score: 1.25),

  /// Not offered until unlocked (long-press on the selector, like the
  /// ComCenter cheat panel). Tyrian hid its top tiers behind key chords too.
  lord('lord', 'LORD', hp: 2.0, damage: 1.75, cadence: 0.6, score: 1.5);

  const Challenge(this.id, this.label,
      {required this.hp,
      required this.damage,
      required this.cadence,
      required this.score});

  /// Stable save key; never derive this from [name] or [index].
  final String id;
  final String label;

  /// Enemy HP multiplier.
  final double hp;

  /// Enemy projectile damage multiplier.
  final double damage;

  /// Multiplier on the frames between enemy shots — above 1 fires slower.
  final double cadence;

  /// Score multiplier on top of the (already HP-scaled) kill value.
  final double score;

  bool get isHidden => this == lord;

  static Challenge fromId(String? id) =>
      values.firstWhere((c) => c.id == id, orElse: () => normal);

  /// The menu's selection. Endless reads it live, so a change in the main
  /// menu applies from the next sector; a campaign copies it once when the
  /// campaign is created and keeps its own (see `CampaignState.challenge`).
  static Challenge selected = normal;
  static bool lordUnlocked = false;

  static const _keySelected = 'challenge';
  static const _keyLord = 'challenge_lord_unlocked';

  /// Load the menu selection once at startup; [selected] is then a plain
  /// static so the hot path never touches SharedPreferences.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    lordUnlocked = prefs.getBool(_keyLord) ?? false;
    final c = fromId(prefs.getString(_keySelected));
    selected = (c.isHidden && !lordUnlocked) ? normal : c;
  }

  static Future<void> select(Challenge c) async {
    selected = c;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySelected, c.id);
  }

  static Future<void> unlockLord() async {
    lordUnlocked = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLord, true);
  }

  /// What the selector cycles through: the hidden tier only once unlocked.
  static List<Challenge> get offered =>
      [for (final c in values) if (!c.isHidden || lordUnlocked) c];

  Challenge get next {
    final o = offered;
    return o[(o.indexOf(this) + 1) % o.length];
  }

  Challenge get previous {
    final o = offered;
    return o[(o.indexOf(this) - 1 + o.length) % o.length];
  }
}

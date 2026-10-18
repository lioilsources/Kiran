import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:games_services/games_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/hostile.dart';
import 'leaderboard_service.dart';

/// One achievement as configured in the developer portals.
///
/// [statKey] points into [AchievementService]'s local counter table; the
/// achievement unlocks when the counter reaches [target]. [incremental] marks
/// achievements that are defined as *incremental* in Play Console (with
/// [target] steps) — those are advanced with increment() deltas on Android;
/// everything else is a plain unlock. iOS always reports absolute
/// percentComplete, so the distinction only matters for Android.
class _AchDef {
  final String iosId;
  final String androidId;
  final String statKey;
  final int target;
  final bool incremental;

  const _AchDef(this.iosId, this.androidId, this.statKey, this.target,
      {this.incremental = false});
}

/// Tracks gameplay statistics locally and mirrors them into native
/// achievements (Apple Game Center / Google Play Games) via `games_services`.
///
/// Stats are the source of truth and live in shared_preferences, so progress
/// accumulates even when the player isn't signed in — the next successful
/// flush pushes everything that changed. Sign-in is owned by
/// [LeaderboardService]; this service just piggybacks on it.
///
/// Portal checklist (mirrors the leaderboard setup) — full copy-paste values
/// and image mapping live in docs/GAMECENTER_ACHIEVEMENTS.md:
///   iOS/macOS — App Store Connect → Achievements: create one entry per
///     [_defs] row using the `kiran_ach_*` ID. Milestone rows are plain
///     achievements; rows marked incremental read nicer as "progressive".
///   Android — Play Console → Play Games Services → Achievements: create the
///     entries (incremental rows with `target` steps), then replace the
///     REPLACE_WITH… placeholders below with the generated "CgkI…" IDs.
class AchievementService {
  AchievementService._();
  static final AchievementService instance = AchievementService._();

  static const _prefsKey = 'achievement_stats_v1';
  static const _flushIntervalSeconds = 60.0;

  static const _noAndroidId = 'REPLACE_WITH_PLAY_ACHIEVEMENT_ID';

  static const List<_AchDef> _defs = [
    // ── Progress — reached sector ─────────────────────────────
    _AchDef('kiran_ach_sector_5', 'CgkI9-rdyZoHEAIQAw', 'max_sector', 5),
    _AchDef('kiran_ach_sector_10', 'CgkI9-rdyZoHEAIQBg', 'max_sector', 10),
    _AchDef('kiran_ach_sector_20', 'CgkI9-rdyZoHEAIQEg', 'max_sector', 20),
    _AchDef('kiran_ach_sector_40', 'CgkI9-rdyZoHEAIQDg', 'max_sector', 40),
    // ── Combat — kills ────────────────────────────────────────
    _AchDef('kiran_ach_first_kill', 'CgkI9-rdyZoHEAIQBA', 'kills_total', 1),
    _AchDef('kiran_ach_kills_1000', 'CgkI9-rdyZoHEAIQFg', 'kills_total', 1000,
        incremental: true),
    _AchDef('kiran_ach_kills_10000', 'CgkI9-rdyZoHEAIQIA', 'kills_total', 10000,
        incremental: true),
    _AchDef('kiran_ach_falcon1_100', 'CgkI9-rdyZoHEAIQEw', 'kills_falcon1', 100,
        incremental: true),
    _AchDef('kiran_ach_falcon2_100', 'CgkI9-rdyZoHEAIQDA', 'kills_falcon2', 100,
        incremental: true),
    _AchDef('kiran_ach_falcon3_100', 'CgkI9-rdyZoHEAIQIg', 'kills_falcon3', 100,
        incremental: true),
    _AchDef('kiran_ach_falcon4_100', 'CgkI9-rdyZoHEAIQFw', 'kills_falcon4', 100,
        incremental: true),
    _AchDef('kiran_ach_falcon5_100', 'CgkI9-rdyZoHEAIQDQ', 'kills_falcon5', 100,
        incremental: true),
    _AchDef('kiran_ach_falcon6_100', 'CgkI9-rdyZoHEAIQCA', 'kills_falcon6', 100,
        incremental: true),
    _AchDef('kiran_ach_elite_100', 'CgkI9-rdyZoHEAIQHQ', 'kills_elite', 100,
        incremental: true),
    _AchDef('kiran_ach_boss_1', 'CgkI9-rdyZoHEAIQFA', 'kills_boss', 1),
    _AchDef('kiran_ach_boss_10', 'CgkI9-rdyZoHEAIQGQ', 'kills_boss', 10,
        incremental: true),
    // ── Asteroids ─────────────────────────────────────────────
    _AchDef('kiran_ach_asteroid_1', 'CgkI9-rdyZoHEAIQCg', 'asteroid_rams', 1),
    _AchDef('kiran_ach_asteroid_50', 'CgkI9-rdyZoHEAIQDw', 'asteroid_rams', 50,
        incremental: true),
    // ── Weapons at max level (XXV) ────────────────────────────
    _AchDef('kiran_ach_max_bubble_gun', 'CgkI9-rdyZoHEAIQEA', 'weapon_bubble_gun', 25),
    _AchDef(
        'kiran_ach_max_vulcan_cannon', 'CgkI9-rdyZoHEAIQEQ', 'weapon_vulcan_cannon', 25),
    _AchDef('kiran_ach_max_blaster', 'CgkI9-rdyZoHEAIQIw', 'weapon_blaster', 25),
    _AchDef('kiran_ach_max_laser', 'CgkI9-rdyZoHEAIQHg', 'weapon_laser', 25),
    _AchDef(
        'kiran_ach_max_small_bubble', 'CgkI9-rdyZoHEAIQFQ', 'weapon_small_bubble', 25),
    _AchDef(
        'kiran_ach_max_small_vulcan', 'CgkI9-rdyZoHEAIQCw', 'weapon_small_vulcan', 25),
    _AchDef('kiran_ach_max_star_gun', 'CgkI9-rdyZoHEAIQGA', 'weapon_star_gun', 25),
    _AchDef(
        'kiran_ach_max_small_laser', 'CgkI9-rdyZoHEAIQIQ', 'weapon_small_laser', 25),
    // ── Dedication ────────────────────────────────────────────
    _AchDef('kiran_ach_starts_10', 'CgkI9-rdyZoHEAIQCQ', 'runs_started', 10,
        incremental: true),
    _AchDef('kiran_ach_starts_100', 'CgkI9-rdyZoHEAIQGg', 'runs_started', 100,
        incremental: true),
    _AchDef('kiran_ach_time_1h', 'CgkI9-rdyZoHEAIQBw', 'play_minutes', 60,
        incremental: true),
    _AchDef('kiran_ach_time_10h', 'CgkI9-rdyZoHEAIQHw', 'play_minutes', 600,
        incremental: true),
    _AchDef('kiran_ach_deaths_25', 'CgkI9-rdyZoHEAIQGw', 'deaths', 25,
        incremental: true),
    _AchDef('kiran_ach_coop', 'CgkI9-rdyZoHEAIQBQ', 'coop_games', 1),
    _AchDef('kiran_ach_skins_5', 'CgkI9-rdyZoHEAIQJA', 'skins_played', 5),
    _AchDef('kiran_ach_untouchable', 'CgkI9-rdyZoHEAIQHA', 'untouchable_sectors', 1),
  ];

  final Map<String, int> _stats = {};
  final Set<String> _skinsPlayed = {};

  /// Non-incremental achievements already unlocked on the portal.
  final Set<String> _submittedUnlocks = {};

  /// Last submitted progress per achievement ID — percent on iOS/macOS,
  /// completed steps on Android.
  final Map<String, int> _submittedProgress = {};

  double _pendingPlaySeconds = 0;
  double _sinceFlush = 0;
  bool _dirty = false;
  bool _loaded = false;
  bool _flushing = false;

  /// Same sign-in session as the leaderboard — one Game Center / Play Games
  /// identity for the whole app.
  bool get available => LeaderboardService.instance.available;

  /// Load persisted stats. Call after [LeaderboardService.init] so the first
  /// flush can push progress accumulated while signed out.
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw != null) {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        (data['stats'] as Map<String, dynamic>? ?? {})
            .forEach((k, v) => _stats[k] = (v as num).toInt());
        _skinsPlayed
            .addAll((data['skins'] as List? ?? []).cast<String>());
        _submittedUnlocks
            .addAll((data['unlocks'] as List? ?? []).cast<String>());
        (data['progress'] as Map<String, dynamic>? ?? {})
            .forEach((k, v) => _submittedProgress[k] = (v as num).toInt());
      }
    } catch (_) {
      // Corrupt store — start over rather than crash; stats are best-effort.
    }
    _loaded = true;
    unawaited(_flush());
  }

  // ── Gameplay hooks (cheap, fire-and-forget) ─────────────────

  void onKill(HostType type, {bool isBoss = false}) {
    _bump('kills_total');
    if (isBoss) {
      _bump('kills_boss');
      return;
    }
    switch (type) {
      case HostType.falcon1:
        _bump('kills_falcon1');
      case HostType.falcon2:
        _bump('kills_falcon2');
      case HostType.falcon3:
        _bump('kills_falcon3');
      case HostType.falcon4:
        _bump('kills_falcon4');
      case HostType.falcon5:
        _bump('kills_falcon5');
      case HostType.falcon6:
        _bump('kills_falcon6');
      case HostType.falconx:
      case HostType.falconx2:
      case HostType.falconx3:
      case HostType.falconxb:
      case HostType.falconxt:
        _bump('kills_elite');
      case HostType.bouncer:
        break; // only ever a Boss in practice — handled above
    }
  }

  void onAsteroidRam() => _bump('asteroid_rams');

  /// Called on every shop upgrade with the weapon's new level.
  void onWeaponLevel(String weaponName, int level) {
    final key = 'weapon_${weaponName.toLowerCase().replaceAll(' ', '_')}';
    _raise(key, level);
  }

  /// A fresh run began (Vessel.newGame).
  void onRunStarted() => _bump('runs_started');

  /// A sector mission started — tracks distinct skins and co-op sessions.
  void onMissionStarted(String skinId, {bool isCoop = false}) {
    if (_skinsPlayed.add(skinId)) {
      _raise('skins_played', _skinsPlayed.length);
      _dirty = true;
    }
    if (isCoop) _bump('coop_games');
    unawaited(_flush());
  }

  /// [reachedLevel] is the LEVEL of the sector the player advanced to (parts
  /// of a level share it), not a raw sector index — see _onSectorComplete.
  /// Deepest sector level ever reached — the depth leaderboard's value.
  int get maxSectorLevel => _stats['max_sector'] ?? 0;

  void onSectorCompleted(int reachedLevel, {required bool tookHullDamage}) {
    _raise('max_sector', reachedLevel);
    if (!tookHullDamage) _bump('untouchable_sectors');
    unawaited(_flush());
  }

  void onGameOver() {
    _bump('deaths');
    unawaited(_flush());
  }

  /// Accumulate play time; whole minutes land in the stat and the service
  /// flushes itself roughly once a minute of active play.
  void addPlayTime(double dt) {
    _pendingPlaySeconds += dt;
    while (_pendingPlaySeconds >= 60) {
      _pendingPlaySeconds -= 60;
      _bump('play_minutes');
    }
    _sinceFlush += dt;
    if (_sinceFlush >= _flushIntervalSeconds) {
      _sinceFlush = 0;
      unawaited(_flush());
    }
  }

  /// Persist + submit now (app going to background, game over…).
  Future<void> flush() => _flush();

  /// Open the platform's native achievements overlay. No-op unless [available].
  Future<void> showAchievements() async {
    if (!available) return;
    try {
      await GamesServices.showAchievements();
    } catch (_) {}
  }

  // ── Internals ───────────────────────────────────────────────

  void _bump(String key) {
    _stats[key] = (_stats[key] ?? 0) + 1;
    _dirty = true;
  }

  /// Max-type stat — only ever raises (sector reached, weapon level…).
  void _raise(String key, int value) {
    if (value > (_stats[key] ?? 0)) {
      _stats[key] = value;
      _dirty = true;
    }
  }

  Future<void> _flush() async {
    if (!_loaded || _flushing) return;
    _flushing = true;
    try {
      if (available) await _submitAll();
      if (_dirty) {
        _dirty = false;
        await _persist();
      }
    } catch (_) {
      // Best-effort: a failed flush must never disturb gameplay.
    } finally {
      _flushing = false;
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      jsonEncode({
        'stats': _stats,
        'skins': _skinsPlayed.toList(),
        'unlocks': _submittedUnlocks.toList(),
        'progress': _submittedProgress,
      }),
    );
  }

  Future<void> _submitAll() async {
    final onApple = Platform.isIOS || Platform.isMacOS;
    for (final def in _defs) {
      final stat = _stats[def.statKey] ?? 0;
      if (stat <= 0) continue;
      try {
        if (onApple) {
          // Game Center wants absolute completion percent; it keeps the max
          // of everything reported and shows the banner at 100.
          final pct = (stat * 100 ~/ def.target).clamp(0, 100);
          if (pct > (_submittedProgress[def.iosId] ?? 0)) {
            await GamesServices.unlock(
              achievement: Achievement(
                iOSID: def.iosId,
                percentComplete: pct.toDouble(),
              ),
            );
            _submittedProgress[def.iosId] = pct;
            _dirty = true;
          }
        } else {
          if (def.androidId == _noAndroidId) continue; // portal not set up yet
          if (def.incremental) {
            final steps = stat.clamp(0, def.target);
            final delta = steps - (_submittedProgress[def.androidId] ?? 0);
            if (delta > 0) {
              await GamesServices.increment(
                achievement: Achievement(
                  androidID: def.androidId,
                  steps: delta,
                ),
              );
              _submittedProgress[def.androidId] = steps;
              _dirty = true;
            }
          } else if (stat >= def.target &&
              !_submittedUnlocks.contains(def.androidId)) {
            await GamesServices.unlock(
              achievement: Achievement(androidID: def.androidId),
            );
            _submittedUnlocks.add(def.androidId);
            _dirty = true;
          }
        }
      } catch (_) {
        // Unconfigured portal entry / transient network error — retried on
        // the next flush because the submitted markers only advance on
        // success.
      }
    }
  }
}

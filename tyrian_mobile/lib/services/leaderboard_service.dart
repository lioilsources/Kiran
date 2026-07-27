import 'dart:io' show Platform;

import 'package:games_services/games_services.dart';

/// The one place that talks to `games_services` (Apple Game Center on
/// iOS/macOS, Google Play Games on Android). There is no local fallback — the
/// old on-device high-score table was removed — so on platforms without a
/// native leaderboard (Windows/Linux) or before the player signs in, the
/// leaderboard simply isn't offered ([available] is false).
class LeaderboardService {
  LeaderboardService._();
  static final LeaderboardService instance = LeaderboardService._();

  // ── Portal IDs ──────────────────────────────────────────────
  // Filled in from the developer portals (see the portal checklist):
  //   iOS/macOS  — App Store Connect → Leaderboards → the reference name/ID
  //   Android    — Play Console → Play Games Services → Leaderboards → the ID
  //                (looks like "CgkI…"); the APP_ID goes in AndroidManifest.
  static const String _iosLeaderboardId = 'kiran_topscore';
  static const String _androidLeaderboardId = 'REPLACE_WITH_PLAY_LEADERBOARD_ID';

  bool _signedIn = false;

  /// Platforms that ship a native leaderboard SDK. Deliberately checks
  /// [Platform] directly rather than `platform_config.isDesktop`: that helper
  /// lumps macOS in with desktop, but macOS *has* Game Center.
  bool get supported =>
      Platform.isIOS || Platform.isMacOS || Platform.isAndroid;

  /// True only when a native leaderboard is actually usable — a supported
  /// platform with a signed-in player. UI keys its "Leaderboard" button off
  /// this, so it stays hidden on Windows/Linux and when sign-in failed.
  bool get available => supported && _signedIn;

  /// Silent sign-in at app start. Swallows failure (unconfigured portal, no
  /// network, user declined) — the leaderboard just stays unavailable.
  Future<void> init() async {
    if (!supported) return;
    try {
      await GamesServices.signIn();
      _signedIn = await GamesServices.isSignedIn;
    } catch (_) {
      _signedIn = false;
    }
  }

  /// Submit a run's score (the vessel's credit). No-op unless [available].
  Future<void> submit(int score) async {
    if (!available) return;
    try {
      await GamesServices.submitScore(
        score: Score(
          iOSLeaderboardID: _iosLeaderboardId,
          androidLeaderboardID: _androidLeaderboardId,
          value: score,
        ),
      );
    } catch (_) {
      // Non-fatal: a failed submit shouldn't disrupt the game-over flow.
    }
  }

  /// Open the platform's native leaderboard overlay. No-op unless [available].
  Future<void> showLeaderboard() async {
    if (!available) return;
    try {
      await GamesServices.showLeaderboards(
        iOSLeaderboardID: _iosLeaderboardId,
        androidLeaderboardID: _androidLeaderboardId,
      );
    } catch (_) {}
  }
}

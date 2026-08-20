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

  /// Second board: how deep the pilot has ever pushed. The run loops forever
  /// and a death only rewinds to sector 1, so depth is the other half of the
  /// ranking — score says how much you killed, this says how far you got.
  /// Must be created in App Store Connect / Play Console before it resolves;
  /// until then submits fail silently like any other unavailable board.
  static const String _iosDepthLeaderboardId = 'kiran_deepest';
  static const String _androidDepthLeaderboardId = 'REPLACE_WITH_PLAY_DEPTH_LEADERBOARD_ID';

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

  /// Submit the pilot's cumulative score. Deliberately not `credit`, which is
  /// a spendable balance — ranking on it meant buying a weapon dropped you
  /// down the board. No-op unless [available].
  Future<void> submitScore(int score) => _submit(
      _iosLeaderboardId, _androidLeaderboardId, score);

  /// Submit the deepest sector level ever reached.
  Future<void> submitDepth(int level) => _submit(
      _iosDepthLeaderboardId, _androidDepthLeaderboardId, level);

  Future<void> _submit(String iosId, String androidId, int value) async {
    if (!available) return;
    try {
      await GamesServices.submitScore(
        score: Score(
          iOSLeaderboardID: iosId,
          androidLeaderboardID: androidId,
          value: value,
        ),
      );
    } catch (_) {
      // Non-fatal: a failed submit shouldn't disrupt the death flow.
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

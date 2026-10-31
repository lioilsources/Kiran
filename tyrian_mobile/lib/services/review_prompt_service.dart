import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Asks for a store rating (SKStoreReviewController / Play In-App Review) at a
/// moment the player feels good about: right after clearing a whole level —
/// part III ends on its mini-boss — once the run is past the first level.
///
/// The OS decides whether the sheet actually shows (Apple caps it at three a
/// year); we keep our own cap on top so the request never lands twice in a
/// short stretch, even where the OS would allow it.
class ReviewPromptService {
  ReviewPromptService._();
  static final ReviewPromptService instance = ReviewPromptService._();

  static const _prefsKey = 'review_prompt_last_ms';

  /// First level whose clear may prompt — level 1 is still the tutorial run.
  static const int minLevel = 2;

  /// 365 / 3, so our own cap matches the three-a-year the App Store allows.
  static const Duration minGap = Duration(days: 122);

  /// Pure gate, see [maybeRequest].
  static bool shouldPrompt({
    required int clearedLevel,
    required int nextLevel,
    required DateTime now,
    DateTime? lastPrompt,
  }) {
    if (nextLevel <= clearedLevel) return false; // mid-level part
    if (clearedLevel < minLevel) return false;
    return lastPrompt == null || now.difference(lastPrompt) >= minGap;
  }

  /// Call when a sector is cleared, with the level of that sector and of the
  /// one the player advances to.
  Future<void> maybeRequest({
    required int clearedLevel,
    required int nextLevel,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastMs = prefs.getInt(_prefsKey);
      final now = DateTime.now();
      if (!shouldPrompt(
        clearedLevel: clearedLevel,
        nextLevel: nextLevel,
        now: now,
        lastPrompt:
            lastMs == null ? null : DateTime.fromMillisecondsSinceEpoch(lastMs),
      )) {
        return;
      }
      final review = InAppReview.instance;
      if (!await review.isAvailable()) return;
      await prefs.setInt(_prefsKey, now.millisecondsSinceEpoch);
      await review.requestReview();
    } catch (_) {
      // Never let a store hiccup reach the game loop.
    }
  }
}

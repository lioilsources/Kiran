import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Ported from state file persistence — saves the in-progress game state.
/// Uses shared_preferences for mobile storage (replaces VBA "state.d" file).
/// High scores are no longer stored on-device — they live in the native
/// leaderboards (Game Center / Play Games), see [LeaderboardService].
class SaveService {
  static const _keyGameState = 'game_state';

  /// Save game state (vessel stats, credit, level)
  static Future<void> saveGameState({
    required String pilotName,
    required int credit,
    required int score,
    required int hp,
    required int hpMax,
    required double shield,
    required double shieldMax,
    required double genMax,
    required double genPower,
    required int level,
    required List<Map<String, dynamic>> weapons,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final state = {
      'pilotName': pilotName,
      'credit': credit,
      'score': score,
      'hp': hp,
      'hpMax': hpMax,
      'shield': shield,
      'shieldMax': shieldMax,
      'genMax': genMax,
      'genPower': genPower,
      'level': level,
      'weapons': weapons,
    };
    await prefs.setString(_keyGameState, jsonEncode(state));
  }

  /// Load game state. Returns null if no saved state.
  static Future<Map<String, dynamic>?> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyGameState);
    if (jsonStr == null) return null;
    return jsonDecode(jsonStr) as Map<String, dynamic>;
  }

  /// Clear saved game state
  static Future<void> clearGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyGameState);
  }
}

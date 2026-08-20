import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Ported from state file persistence — saves the in-progress game state.
/// Uses shared_preferences for mobile storage (replaces VBA "state.d" file).
/// High scores are no longer stored on-device — they live in the native
/// leaderboards (Game Center / Play Games), see [LeaderboardService].
class SaveService {
  static const _keyGameState = 'game_state';

  /// Save format version. v1 saves (no marker) predate the 18-part sector
  /// table — their 'level' field holds one-sector-per-level indices and is
  /// migrated on load via [Sector.migrateLegacyIndex].
  static const int saveVersion = 2;

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
    required int nextWeaponLevel,
    required List<Map<String, dynamic>> weapons,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final state = {
      'saveVersion': saveVersion,
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
      // Weapon tier used to be derived from score on load. Now that a death
      // keeps the run going, an unlock has to be permanent even when the
      // derivation would come out lower (the ComCenter cheat, a future score
      // reset). Absent in v2 saves — load falls back to the score derivation.
      'nextWeaponLevel': nextWeaponLevel,
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

import 'package:shared_preferences/shared_preferences.dart';

/// Plan 32 Q1: a brand-new pilot's first tap on a skin goes straight into
/// sector 1. With no credits and a stock loadout there is nothing to do in
/// the ComCenter yet, so it is first shown after the first sector or death.
///
/// The flag lives in SharedPreferences, not in the save file, so the save
/// format (and saveVersion) stays as it is.
class ComCenterGate {
  ComCenterGate._();

  static const prefsKey = 'comcenter_seen';

  static bool? _seen;

  /// Read once at startup. A missing flag falls back to [hasSave]: a pilot
  /// with saved progress already knows the ComCenter and keeps seeing it.
  /// The fallback is written down so that the first save made by the
  /// skipped start does not turn it on for the next launch.
  static Future<void> load({required bool hasSave}) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getBool(prefsKey);
    // markSeen may already have run while this was awaiting.
    if (_seen == true) return;
    _seen = stored ?? hasSave;
    if (stored == null) await prefs.setBool(prefsKey, _seen!);
  }

  /// True when PLAY should skip the ComCenter and start the sector. False
  /// until [load] has run, so an unknown state shows the shop as before.
  static bool get skipComCenter => _seen == false;

  /// Called whenever the ComCenter is shown.
  static void markSeen() {
    if (_seen == true) return;
    _seen = true;
    SharedPreferences.getInstance().then((p) => p.setBool(prefsKey, true));
  }

  /// Tests only: forget the in-memory state.
  static void reset() => _seen = null;
}

import 'package:shared_preferences/shared_preferences.dart';

/// The three nudges real play gives a sigil player (Prompts/29 §5b), each
/// once in the life of a save: when CHARGE first fills, at the first wall
/// of enemy fire, and when the generator first keeps up with a held
/// trigger. Pure bookkeeping; the game decides when a moment has come.
enum SigilHint { hop, loop, stream }

class SigilHints {
  SigilHints._();
  static final SigilHints instance = SigilHints._();

  static const _key = 'sigil_hints_shown';
  final Set<SigilHint> shown = {};
  bool _loaded = false;

  /// The hint on screen now, and how long it stays.
  SigilHint? active;
  double left = 0;

  /// Seconds a hint stays, and the world speed while the first one shows.
  static const double duration = 3.0;
  static const double hopSlow = 0.3;

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final prefs = await SharedPreferences.getInstance();
    for (final n in prefs.getStringList(_key) ?? const <String>[]) {
      final h = SigilHint.values.where((v) => v.name == n).firstOrNull;
      if (h != null) shown.add(h);
    }
  }

  /// Show [h] if it never was. True when it starts now.
  bool offer(SigilHint h) {
    if (shown.contains(h) || active != null) return false;
    shown.add(h);
    active = h;
    left = duration;
    SharedPreferences.getInstance().then(
        (p) => p.setStringList(_key, [for (final s in shown) s.name]));
    return true;
  }

  /// The player did it: the hint has done its job.
  void dismiss() {
    active = null;
    left = 0;
  }

  /// Wall-clock seconds; returns the world speed factor for this frame.
  double tick(double realDt) {
    if (active == null) return 1;
    left -= realDt;
    if (left <= 0) {
      dismiss();
      return 1;
    }
    return active == SigilHint.hop ? hopSlow : 1;
  }
}

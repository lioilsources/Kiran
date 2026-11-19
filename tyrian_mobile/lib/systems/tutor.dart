import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/collectable.dart';
import '../entities/hostile.dart';
import '../game/platform_config.dart' as platform;
import '../game/tyrian_game.dart';
import '../input/last_input.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n.dart';
import '../ui/com_center.dart' show swapHintVisible;
import '../ui/format.dart';
import 'campaign.dart';
import 'device.dart';
import 'weapon_family.dart';

/// What the in-game tutor has told this player, kept across runs so its
/// lessons are not repeated: each hint id with how many times it was shown.
class TutorMemory {
  TutorMemory._();
  static final TutorMemory instance = TutorMemory._();

  static const _key = 'tutor_seen';
  final Map<String, int> _counts = {};

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _counts.clear();
    for (final e in prefs.getStringList(_key) ?? const <String>[]) {
      final i = e.lastIndexOf(':');
      if (i <= 0) continue;
      _counts[e.substring(0, i)] = int.tryParse(e.substring(i + 1)) ?? 1;
    }
  }

  int times(String id) => _counts[id] ?? 0;

  void note(String id) {
    _counts[id] = times(id) + 1;
    _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _key, [for (final e in _counts.entries) '${e.key}:${e.value}']);
  }

  @visibleForTesting
  void forget() => _counts.clear();
}

enum _Intro { off, fly, collect, shop }

/// The texts at the top of the screen that teach the game while it is
/// played: the first look at each pickup and at a boss, hints when they are
/// needed (low hull, a starved generator, credits for an upgrade), the round's
/// goal and its summary, a tip after a death, and a three-step first round
/// (fly, collect, shop). Lessons are shown once per player, hints a few
/// times at most and once per round.
class Tutor {
  Tutor(this.game);

  final TyrianGame game;

  TutorMemory get memory => TutorMemory.instance;

  /// A hint that comes back when needed, but at most this many times ever.
  static const hintLimit = 3;

  /// Below this share of max HP the hull counts as low.
  static const lowHull = 0.3;

  /// How long the generator must stay empty while firing before it counts
  /// as starved, in seconds.
  static const starvedFor = 1.5;

  /// Hints that would crowd the round's title wait this long, in seconds.
  static const afterTitle = 3.0;

  /// How far the ship must fly before the first lesson moves on.
  static const introDistance = 150.0;

  /// Touch-only lessons (flying by drag, two fingers). Tests set it.
  @visibleForTesting
  static bool? touchOverride;

  bool get _touch => touchOverride ?? !platform.isDesktop;

  // ── This round ──
  int _creditsAtStart = 0;
  int _kills = 0;
  final Map<WeaponFamily, int> _killsBy = {};
  final Set<String> _hintedThisRound = {};
  bool _bossWasActive = false;
  double _starved = 0;
  final List<(double, String)> _later = [];

  // ── The first round's lesson ──
  _Intro _intro = _Intro.off;
  double _flown = 0;
  double? _lastX, _lastY;

  void _say(String text) => game.showMessage(text, fontSize: 14);

  /// Show [text] once per player, under [id]. Returns whether it showed.
  bool _once(String id, String text, {double delay = 0}) {
    if (memory.times(id) > 0) return false;
    memory.note(id);
    delay > 0 ? _later.add((delay, text)) : _say(text);
    return true;
  }

  /// A hint: once per round, [hintLimit] times per player.
  void _hint(String id, String text) {
    if (_hintedThisRound.contains(id) || memory.times(id) >= hintLimit) return;
    _hintedThisRound.add(id);
    memory.note(id);
    _say(text);
  }

  /// A round begins: right after the perimeter's name and level.
  void roundStart() {
    final l = L10n.current;
    _creditsAtStart = game.vessel.credit;
    _kills = 0;
    _killsBy.clear();
    _hintedThisRound.clear();
    _bossWasActive = false;
    _starved = 0;
    _later.clear();
    _lastX = _lastY = null;

    final goal = goalText();
    if (goal != null) _say(goal);

    if (_touch && memory.times('intro') == 0) {
      _intro = _Intro.fly;
      _flown = 0;
      _later.add((afterTitle, l.tutFly));
      if (memory.times('fly') == 0) memory.note('fly');
    } else {
      _intro = _Intro.off;
      if (_touch) _once('fly', l.tutFly, delay: afterTitle);
    }
    // Desktop with the mouse in hand: the ship follows the cursor now
    // (Prompts/36 §3.3), which nothing on screen says.
    if (!_touch && LastInput.keyboardMouse) {
      _once('flyMouse', l.tutFlyMouse, delay: afterTitle);
    }
    // The second set is worth a word once there is one to fly.
    if (_touch && swapHintVisible(game.vessel, touch: true)) {
      _once('two', l.swapHint, delay: afterTitle + 1);
    }
  }

  /// The round's goal, under its title.
  String? goalText() {
    final l = L10n.current;
    final s = game.currentSector;
    if (s == null) return null;
    // A campaign node states its own objectives.
    if (game.mode == GameMode.campaign &&
        game.currentSectorIndex < kCampaignNodes.length) {
      final goals = kCampaignNodes[game.currentSectorIndex].objectives;
      if (goals.isNotEmpty) {
        return goals.map((o) => o.localizedText(l)).join(' · ');
      }
    }
    return s.fleets.any((f) => f.bossSpec != null) ? l.objBoss : l.objSurvive;
  }

  /// Once a frame while playing.
  void tick(double dt) {
    final l = L10n.current;
    for (var i = _later.length - 1; i >= 0; i--) {
      final (left, text) = _later[i];
      if (left - dt <= 0) {
        _later.removeAt(i);
        _say(text);
      } else {
        _later[i] = (left - dt, text);
      }
    }

    final v = game.vessel;
    if (!v.visible || v.hp <= 0) return;

    final boss = game.bossActive;
    if (boss && !_bossWasActive) _once('boss', l.tutBoss);
    _bossWasActive = boss;

    if (v.hp < v.hpMax * lowHull) _hint('lowHp', l.tutLowHp);

    _starved = v.fire && v.genValue < v.genMax * 0.05 ? _starved + dt : 0;
    if (_starved >= starvedFor) _hint('genStarved', l.tutGenStarved);

    final cheapest = _cheapestUpgrade();
    if (cheapest != null && v.credit >= cheapest) {
      _hint('canAfford', l.tutCanAfford);
    }

    if (_intro == _Intro.fly) {
      final x = v.position.x, y = v.position.y;
      if (_lastX != null) {
        _flown += (x - _lastX!).abs() + (y - _lastY!).abs();
      }
      _lastX = x;
      _lastY = y;
      if (_flown >= introDistance) {
        _intro = _Intro.collect;
        _say(l.introCollect);
      }
    }
  }

  int? _cheapestUpgrade() {
    int? best;
    for (final d in game.vessel.devices) {
      if (d.level >= Device.maxLevel) continue;
      if (best == null || d.price < best) best = d.price;
    }
    return best;
  }

  /// The longer word on a kind of pickup, the first time one is caught.
  String? pickupLesson(CollType t) {
    final l = L10n.current;
    if (_intro == _Intro.collect) _intro = _Intro.shop;
    final (id, text) = switch (t) {
      CollType.frontWepUpgrade ||
      CollType.leftWepUpgrade ||
      CollType.rightWepUpgrade =>
        ('pickupWeapon', l.tutPickupWeapon),
      CollType.healthUpgrade => ('pickupHealth', l.tutPickupHealth),
      CollType.shieldUpgrade => ('pickupShield', l.tutPickupShield),
      CollType.generatorUpgrade => ('pickupGenerator', l.tutPickupGenerator),
      CollType.bonusCredit => ('pickupCredits', l.tutPickupCredits),
      CollType.none => ('', ''),
    };
    if (id.isEmpty || memory.times(id) > 0) return null;
    memory.note(id);
    return text;
  }

  void onKill(Hostile h) {
    _kills++;
    final f = h.deathFamily;
    if (f != null) _killsBy[f] = (_killsBy[f] ?? 0) + 1;
  }

  /// The round is won: what it brought, and the first round's last lesson.
  void roundEnd() {
    final l = L10n.current;
    final gained = game.vessel.credit - _creditsAtStart;
    _say(l.roundSummary(fmtNum(gained < 0 ? 0 : gained), _kills));
    final best = bestWeapon;
    if (best != null) _say(l.roundBestWeapon(familyName(best, l)));
    if (_intro != _Intro.off) {
      _intro = _Intro.off;
      memory.note('intro');
      _say(l.introShop);
    }
  }

  /// The weapon family with the most kills this round.
  WeaponFamily? get bestWeapon {
    WeaponFamily? best;
    for (final e in _killsBy.entries) {
      if (best == null || e.value > _killsBy[best]!) best = e.key;
    }
    return best;
  }

  static String familyName(WeaponFamily f, AppLocalizations l) => switch (f) {
        WeaponFamily.bubble => l.familyBubble,
        WeaponFamily.vulcan => l.familyVulcan,
        WeaponFamily.blaster => l.familyBlaster,
        WeaponFamily.laser => l.familyLaser,
        WeaponFamily.starg => l.familyStar,
      };

  /// One tip for the game over screen, from what the death looked like.
  String deathTip() {
    final l = L10n.current;
    final v = game.vessel;
    if (game.bossActive) return l.deathBoss;
    if (v.shieldMax < v.hpMax) return l.deathShield;
    return l.deathGuns;
  }
}

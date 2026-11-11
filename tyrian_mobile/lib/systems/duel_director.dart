import 'package:flame/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/hostile.dart';
import '../game/duel_space.dart';
import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../services/asset_library.dart';
import 'fleet.dart';
import 'path_system.dart';

/// The doors into and out of a boss duel (Prompts/30 §8).
enum DuelPhase {
  none,

  /// WARNING: the field empties, the boss music starts. Full control.
  warning,

  /// The boss close-up. The world stands still; skippable.
  cutIn,

  /// The ship turns nose-up and the background turns with it.
  turn,

  /// The boss comes down from the top. Control is back.
  entrance,

  fight,

  /// The boss is down; pickups come to the ship.
  outro,

  /// Nose back to the left, into the flight's end of sector.
  turnBack,
}

/// How often the boss close-up plays.
enum CutInMode { firstTime, always, never }

/// Runs a boss duel's transition (Prompts/30 §8). The only gate is
/// [TyrianGame.duelEnabled]; everything that differs in a duel asks this
/// object which phase it is in.
class DuelDirector {
  DuelDirector(this.game);

  final TyrianGame game;

  DuelPhase phase = DuelPhase.none;

  /// Seconds into the phase, wall clock.
  double t = 0;

  /// The arena's duel: no doors in, no way back, a boss after a boss.
  bool arena = false;

  Fleet? _boss;
  bool _released = false;
  Vector2 _from = Vector2.zero();
  double _fromHeading = 0;

  /// The close-up's boss, for the overlay.
  int cutInOrdinal = 1;

  static CutInMode cutInMode = CutInMode.firstTime;

  /// Bosses whose close-up the player has seen: "skin:ordinal".
  static final Set<String> seen = {};
  static const _seenKey = 'duel_seen';
  static const _modeKey = 'duel_cut_in';

  /// Whether the duel's first-time hint card has been shown.
  static bool hintShown = false;
  static const _hintKey = 'duel_hint';

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    seen
      ..clear()
      ..addAll(prefs.getStringList(_seenKey) ?? const []);
    cutInMode = CutInMode.values.firstWhere(
        (m) => m.name == prefs.getString(_modeKey),
        orElse: () => CutInMode.firstTime);
    hintShown = prefs.getBool(_hintKey) ?? false;
  }

  static Future<void> setCutInMode(CutInMode m) async {
    cutInMode = m;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modeKey, m.name);
  }

  static Future<void> markHintShown() async {
    hintShown = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hintKey, true);
  }

  // ── What the rest of the game asks ──

  bool get active => phase != DuelPhase.none;

  /// The field is the arena: nose free, background turned. From the turn
  /// in until the turn back is done.
  bool get geometry => phase.index >= DuelPhase.turn.index;

  /// The duel's controls are live.
  bool get controls =>
      phase == DuelPhase.entrance ||
      phase == DuelPhase.fight ||
      phase == DuelPhase.outro;

  /// Nothing can hurt the ship.
  bool get shelters =>
      phase == DuelPhase.cutIn ||
      phase == DuelPhase.turn ||
      phase == DuelPhase.turnBack;

  /// The world stands still.
  bool get frozen => phase == DuelPhase.cutIn;

  /// No flight input at all.
  bool get inputLocked =>
      phase == DuelPhase.cutIn ||
      phase == DuelPhase.turn ||
      phase == DuelPhase.turnBack;

  /// Pickups fly to the ship.
  bool get magnet =>
      phase == DuelPhase.turn ||
      phase == DuelPhase.outro ||
      phase == DuelPhase.turnBack ||
      (geometry && arena);

  double get _turnK => _ease((t / config.duelTurn).clamp(0.0, 1.0).toDouble());
  double get _backK =>
      _ease((t / config.duelTurnBack).clamp(0.0, 1.0).toDouble());

  /// The angle the background is drawn at: the ship's heading through the
  /// turn, so the stars stream against the nose the whole way round.
  double get frameAngle => switch (phase) {
        DuelPhase.turn => uprightAngle * _turnK,
        DuelPhase.turnBack => uprightAngle * (1 - _backK),
        _ when geometry => uprightAngle,
        _ => 0,
      };

  /// Background speed against the flight's.
  double get bgSpeed => switch (phase) {
        DuelPhase.turn => 1 + (config.duelBgDrift - 1) * _turnK,
        DuelPhase.turnBack => config.duelBgDrift + (1 - config.duelBgDrift) * _backK,
        DuelPhase.cutIn => 0,
        _ when geometry => config.duelBgDrift,
        _ => 1,
      };

  /// WARNING is on screen.
  bool get warning => phase == DuelPhase.warning;

  /// Sector asks before it starts a fleet: a boss fleet waits for the doors.
  bool holds(Fleet f) {
    if (f.bossSpec == null) return false;
    if (_released && identical(f, _boss)) return false;
    if (arena) return false;
    if (phase == DuelPhase.none) {
      if (!game.duelEnabled) return false;
      _begin(f);
      return true;
    }
    return identical(f, _boss);
  }

  /// A fleet that is not the boss stays quiet while a duel is under way.
  bool silences(Fleet f) => active && !identical(f, _boss);

  /// The field may finish its sector: not while a duel is on.
  bool get holdsCompletion => active && !arena;

  // ── Lifecycle ──

  /// Back to the flight, now. A new sector, the end of a run.
  void reset() {
    phase = DuelPhase.none;
    t = 0;
    arena = false;
    _boss = null;
    _released = false;
    game.vessel.setHeading(0);
  }

  /// The arena: the duel is already on, the boss comes straight down.
  void startArena() {
    arena = true;
    _boss = null;
    _released = true;
    _enter(DuelPhase.entrance);
    placeShip();
  }

  /// The ship where a duel starts: low in the middle, nose up.
  void placeShip() {
    final p = duelToGame(0.5, config.duelShipStartV);
    game.vessel.position.setFrom(p);
    game.vessel.setHeading(uprightAngle);
  }

  void _begin(Fleet f) {
    _boss = f;
    _released = false;
    cutInOrdinal = f.bossSpec!.ordinal;
    _enter(DuelPhase.warning);
    _clearField(dissolveShots: true);
    game.vessel.caster.endRun();
  }

  void _enter(DuelPhase p) {
    phase = p;
    t = 0;
    switch (p) {
      case DuelPhase.cutIn:
        seen.add(_seenId);
        SharedPreferences.getInstance()
            .then((prefs) => prefs.setStringList(_seenKey, seen.toList()));
      case DuelPhase.turn:
        _clearField(dissolveShots: true, stragglers: true);
        game.vessel.caster.endRun();
        _from = game.vessel.position.clone();
        _fromHeading = game.vessel.heading;
      case DuelPhase.entrance:
        _released = true;
      case DuelPhase.turnBack:
        _from = game.vessel.position.clone();
        _fromHeading = game.vessel.heading;
      default:
        break;
    }
  }

  String get _seenId => '${AssetLibrary.instance.skinId}:$cutInOrdinal';

  bool get _wantsCutIn => switch (cutInMode) {
        CutInMode.never => false,
        CutInMode.always => true,
        CutInMode.firstTime => !seen.contains(_seenId),
      };

  /// Any button pressed during the close-up, once it may be skipped.
  void skip() {
    if (phase == DuelPhase.cutIn && t >= config.duelCutInSkippable) {
      _enter(DuelPhase.turn);
    }
  }

  /// Once per frame, wall clock, before the world moves.
  void update(double dt) {
    if (phase == DuelPhase.none) return;
    t += dt;
    final v = game.vessel;
    switch (phase) {
      case DuelPhase.none:
        break;
      case DuelPhase.warning:
        if (t >= config.duelWarning) {
          _enter(_wantsCutIn ? DuelPhase.cutIn : DuelPhase.turn);
        }
      case DuelPhase.cutIn:
        if (t >= config.duelCutIn) _enter(DuelPhase.turn);
      case DuelPhase.turn:
        final k = _turnK;
        final to = duelToGame(0.5, config.duelShipStartV);
        v.position.setValues(
            _from.x + (to.x - _from.x) * k, _from.y + (to.y - _from.y) * k);
        v.setHeading(_fromHeading + (uprightAngle - _fromHeading) * k);
        if (t >= config.duelTurn) {
          v.setHeading(uprightAngle);
          _enter(DuelPhase.entrance);
        }
      case DuelPhase.entrance:
        if (t >= config.duelEntrance) _enter(DuelPhase.fight);
      case DuelPhase.fight:
        final b = _boss;
        if (!arena && b != null && b.started && !b.active) {
          _enter(DuelPhase.outro);
        }
      case DuelPhase.outro:
        if (t >= config.duelOutro) _enter(DuelPhase.turnBack);
      case DuelPhase.turnBack:
        final k = _backK;
        final to = Vector2(config.gameWidth / 2, config.gameHeight * 0.75);
        v.position.setValues(
            _from.x + (to.x - _from.x) * k, _from.y + (to.y - _from.y) * k);
        v.setHeading(_fromHeading * (1 - k));
        if (t >= config.duelTurnBack) {
          v.setHeading(0);
          phase = DuelPhase.none;
          _boss = null;
        }
    }
  }

  /// Empty the field for the duel. Shots dissolve and pay nothing; enemies
  /// that are still about turn and leave — no kill, so no bounty — and at
  /// the turn the last of them simply go.
  void _clearField({bool dissolveShots = false, bool stragglers = false}) {
    if (dissolveShots) {
      var pops = 0;
      for (final p in [...game.enemyProjectiles]) {
        if (pops++ < 24) {
          game.addExplosion(p.position.x + p.size.x / 2, p.position.y + p.size.y / 2, 1);
        }
        p.removeFromParent();
      }
      game.enemyProjectiles.clear();
    }
    for (final f in game.activeFleets) {
      if (identical(f, _boss)) continue;
      for (final h in f.hostiles) {
        if (h.isDead) continue;
        if (stragglers) {
          // No kill: the fleet empties without its bonus.
          h.hp = 0;
          continue;
        }
        _leave(h);
      }
    }
    for (final s in [...game.activeStructures]) {
      if (stragglers) {
        game.addExplosion(s.position.x + s.size.x / 2, s.position.y + s.size.y / 2, 1);
        s.removeFromParent();
        game.activeStructures.remove(s);
      }
    }
  }

  /// A straggler turns back the way it came, quickly, and is gone.
  void _leave(Hostile h) {
    final x = h.position.x, y = h.position.y;
    final path = PathSystem()
      ..generate(40, x, y, x, -h.size.y - 120, PathType.linear,
          amplitude: 0, cycles: 1);
    path.onExit = PathAction.destroy;
    h.trace = path;
  }

  static double _ease(double t) => t * t * (3 - 2 * t);

  /// The close-up's progress 0..1, for the overlay.
  double get cutInK => (t / config.duelCutIn).clamp(0.0, 1.0).toDouble();

  /// The fight is on and the hint card has not been shown yet.
  bool get wantsHint => phase == DuelPhase.entrance && !hintShown;
}

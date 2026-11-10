import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entities/boss.dart';
import '../game/platform_config.dart' as platform;
import '../game/tyrian_game.dart';
import '../input/gamepad_input.dart';
import '../l10n/l10n.dart';
import '../rendering/sigil_hud.dart';
import '../systems/sigils/sigil_catalog.dart';
import '../systems/sigils/sigil_spec.dart';
import '../systems/training/arena.dart';
import '../systems/training/lesson.dart';
import 'sigil_glyph.dart';

/// The training arena's dials and scoreboard (Prompts/29 §3). Opens before
/// the first fight and whenever the arena is paused. Pad: up/down picks a
/// row, left/right turns it, B or Start confirms, A or View goes back.
class ArenaPanel extends StatefulWidget {
  final TyrianGame game;

  /// True when a fight is under way (the panel is the arena's pause).
  final bool inArena;
  final VoidCallback onFight;
  final VoidCallback onResume;
  final VoidCallback onLeave;

  const ArenaPanel({
    super.key,
    required this.game,
    required this.inArena,
    required this.onFight,
    required this.onResume,
    required this.onLeave,
  });

  @override
  State<ArenaPanel> createState() => _ArenaPanelState();
}

enum _Row { parts, companions, charge, speed, drill, kata, gauntlet, fight, newBoss, leave }

class _ArenaPanelState extends State<ArenaPanel> {
  final _focus = FocusNode();
  final GamepadInput _pad = GamepadInput();
  Timer? _poll;
  int _i = 0;
  // Start "held": the press that opened the panel must be let go first.
  bool _pl = true, _pr = true, _pu = true, _pd = true, _pc = true, _pb = true;

  /// The dials as they were when the panel opened: a change means a new boss.
  late final String _openedWith = _dialKey;

  ArenaSettings get _a => widget.game.arena;

  String get _dialKey =>
      '${_a.bossParts}|${_a.companions}|${_a.infiniteCharge}|${_a.drill}|${_a.kata?.id}|${_a.gauntlet}';

  List<_Row> get _rows => [
        _Row.parts,
        _Row.companions,
        _Row.charge,
        _Row.speed,
        _Row.drill,
        _Row.kata,
        _Row.gauntlet,
        _Row.fight,
        if (widget.inArena) _Row.newBoss,
        _Row.leave,
      ];

  @override
  void initState() {
    super.initState();
    if (platform.isDesktop) {
      _poll = Timer.periodic(const Duration(milliseconds: 16), (_) => _pollPad());
    }
    _i = _rows.indexOf(_Row.fight);
  }

  @override
  void dispose() {
    _poll?.cancel();
    _focus.dispose();
    super.dispose();
  }

  void _move(int d) => setState(() => _i = (_i + d).clamp(0, _rows.length - 1));

  void _turn(int dir) {
    setState(() {
      switch (_rows[_i]) {
        case _Row.parts:
          _a.stepParts(dir);
        case _Row.companions:
          _a.stepCompanions(dir);
        case _Row.charge:
          _a.infiniteCharge = !_a.infiniteCharge;
        case _Row.speed:
          _a.stepSpeed(dir);
        case _Row.drill:
          _a.stepDrill(dir);
        case _Row.kata:
          _a.stepKata(dir);
        case _Row.gauntlet:
          _a.gauntlet = !_a.gauntlet;
        default:
          break;
      }
    });
  }

  void _confirm() {
    switch (_rows[_i]) {
      case _Row.fight:
        // The confirming Start press must not also reach the game's pause.
        widget.game.suppressStartEdge();
        if (!widget.inArena) {
          widget.onFight();
        } else {
          if (_dialKey != _openedWith) widget.game.restartArenaRound();
          widget.game.vessel.caster.meter.infinite = _a.infiniteCharge;
          widget.onResume();
        }
      case _Row.newBoss:
        widget.game.suppressStartEdge();
        widget.game.restartArenaRound();
        widget.onResume();
      case _Row.leave:
        widget.onLeave();
      default:
        _turn(1);
    }
  }

  void _back() => widget.inArena ? widget.onResume() : widget.onLeave();

  Future<void> _pollPad() async {
    await _pad.poll();
    if (!mounted) return;
    final gp = _pad.primary;
    final l = gp.dpadLeft || GamepadInput.deadzone(gp.leftStickX) < -0.5;
    final r = gp.dpadRight || GamepadInput.deadzone(gp.leftStickX) > 0.5;
    final u = gp.dpadUp || GamepadInput.deadzone(gp.leftStickY) < -0.5;
    final d = gp.dpadDown || GamepadInput.deadzone(gp.leftStickY) > 0.5;
    final c = gp.buttonB || gp.start;
    final b = gp.buttonA || gp.back;
    if (l && !_pl) _turn(-1);
    if (r && !_pr) _turn(1);
    if (u && !_pu) _move(-1);
    if (d && !_pd) _move(1);
    if (c && !_pc) _confirm();
    if (b && !_pb) _back();
    _pl = l;
    _pr = r;
    _pu = u;
    _pd = d;
    _pc = c;
    _pb = b;
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (k == LogicalKeyboardKey.arrowUp) {
      _move(-1);
    } else if (k == LogicalKeyboardKey.arrowDown) {
      _move(1);
    } else if (k == LogicalKeyboardKey.arrowLeft) {
      _turn(-1);
    } else if (k == LogicalKeyboardKey.arrowRight) {
      _turn(1);
    } else if (k == LogicalKeyboardKey.enter || k == LogicalKeyboardKey.space) {
      _confirm();
    } else if (k == LogicalKeyboardKey.escape && !widget.inArena) {
      // In a fight, Escape reaches the game's own pause toggle, which
      // resumes — the same as the pause menu.
      _back();
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  String _partsLabel(AppLocalizations l) {
    if (_a.bossParts == 0) return '0 · ${l.arenaBareCore}';
    final names = [
      for (final p in bossPartsForOrdinal(_a.bossParts))
        switch (p) {
          PartKind.turret => l.bossPartTurret,
          PartKind.shieldPod => l.bossPartShieldPod,
          PartKind.thruster => l.bossPartThruster,
          PartKind.cannon => l.bossPartCannon,
        },
    ];
    return '${_a.bossParts} · ${names.join(' + ')}';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final rows = _rows;
    final drill = _a.drill == null ? null : SigilCatalog.of(_a.drill!);
    return Positioned.fill(
      child: Focus(
        focusNode: _focus,
        autofocus: true,
        onKeyEvent: _onKey,
        child: Container(
          color: Colors.black.withValues(alpha: 0.72),
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 980, maxHeight: 640),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xF20A0A1E),
              border: Border.all(color: Colors.cyanAccent.withAlpha(120)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 420,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.arena,
                          style: const TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 6)),
                      const SizedBox(height: 4),
                      Text(l.arenaHint,
                          style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      const SizedBox(height: 18),
                      for (var i = 0; i < rows.length; i++)
                        _row(context, rows[i], i == _i, drill),
                    ],
                  ),
                ),
                const SizedBox(width: 28),
                Expanded(child: _scoreboard(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, _Row r, bool on, SigilSpec? drill) {
    final l = context.l10n;
    final (label, value) = switch (r) {
      _Row.parts => (l.arenaBossParts, _partsLabel(l)),
      _Row.companions => (l.arenaCompanions, '${_a.companions}'),
      _Row.charge => (l.arenaCharge, _a.infiniteCharge ? '∞' : l.arenaChargeNormal),
      _Row.speed => (l.arenaSpeed, '${(_a.speed * 100).round()} %'),
      _Row.drill => (l.arenaDrill, drill?.name ?? l.arenaFreePlay),
      _Row.kata => (
          l.arenaKata,
          _a.kata == null
              ? l.arenaKataOff
              : '${_a.kata!.id.toUpperCase()} · ${_a.kata!.band}'
                  '${widget.game.kataBest[_a.kata!.id] == null ? '' : ' · ${widget.game.kataBest[_a.kata!.id]}'}'
        ),
      _Row.gauntlet => (
          l.arenaGauntlet,
          '${_a.gauntlet ? l.arenaOn : l.arenaOff} · ${widget.game.gauntletBest}'
        ),
      _Row.fight => (widget.inArena ? l.resume : l.arenaFight, ''),
      _Row.newBoss => (l.arenaNewBoss, ''),
      _Row.leave => (l.arenaLeave, ''),
    };
    final button = value.isEmpty;
    final col = on ? Colors.cyanAccent : Colors.white70;
    return InkWell(
      onTap: () {
        setState(() => _i = _rows.indexOf(r));
        _confirm();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
              color: on ? Colors.cyanAccent : Colors.white.withAlpha(30),
              width: on ? 2 : 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: col,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2)),
            ),
            if (!button) ...[
              if (r == _Row.drill && drill != null) ...[
                SigilGlyph(spec: drill, size: 28),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text('‹ $value ›',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: col, fontSize: 13, letterSpacing: 1)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _scoreboard(BuildContext context) {
    final l = context.l10n;
    final st = widget.game.arenaStats;
    final (casts, acc) = st.totals;
    final kinds = [
      for (final s in SigilCatalog.all)
        if (st.sigils.containsKey(s.kind)) s,
    ];
    const head = TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1);
    const cell = TextStyle(color: Colors.white70, fontSize: 12);
    String pct(double v) => '${(v * 100).round()} %';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.arenaSummary(st.bosses, st.knockouts),
            style: const TextStyle(color: Colors.white, fontSize: 15, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text('Σ $casts · ${pct(acc)}',
            style: const TextStyle(color: Color(0xFFFFE070), fontSize: 13)),
        const SizedBox(height: 12),
        Row(children: [
          const SizedBox(width: 34),
          const Expanded(flex: 3, child: Text('', style: head)),
          Expanded(flex: 2, child: Text(l.arenaColCast, style: head)),
          Expanded(flex: 2, child: Text(l.arenaColMiss, style: head)),
          Expanded(flex: 2, child: Text(l.arenaColAvg, style: head)),
          Expanded(flex: 2, child: Text(l.arenaColBest, style: head)),
          Expanded(flex: 2, child: Text(l.arenaColTime, style: head)),
        ]),
        const SizedBox(height: 4),
        Expanded(
          child: ListView(
            children: [
              for (final s in kinds)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(children: [
                    SigilGlyph(spec: s, size: 26),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Text(s.name,
                          style: TextStyle(
                              color: SigilHud.layerColors[s.layer],
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                    Expanded(flex: 2, child: Text('${st.sigils[s.kind]!.casts}', style: cell)),
                    Expanded(flex: 2, child: Text('${st.sigils[s.kind]!.misses}', style: cell)),
                    Expanded(
                        flex: 2,
                        child: Text(pct(st.sigils[s.kind]!.meanAccuracy), style: cell)),
                    Expanded(
                        flex: 2,
                        child: Text(pct(st.sigils[s.kind]!.bestAccuracy), style: cell)),
                    Expanded(
                        flex: 2,
                        child: Text(
                            st.sigils[s.kind]!.bestTime == null
                                ? '—'
                                : '${(st.sigils[s.kind]!.bestTime! * 1000).round()} ms',
                            style: cell)),
                  ]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A thin strip over the arena fight: the round, the drill and how it goes.
class ArenaStrip extends StatelessWidget {
  final TyrianGame game;
  const ArenaStrip({super.key, required this.game});

  /// The kata: the next sigil to draw and when, or the grade just earned.
  static List<Widget> _kata(TyrianGame game, AppLocalizations l) {
    final run = game.kataRun!;
    const gold = Color(0xFFFFE070);
    final next = run.next;
    final head = '  ${run.kata.id.toUpperCase()} ${run.step}/${run.kata.chain.length}';
    if (next == null) {
      return [
        Text('$head  ${game.lastKataGrade}',
            style: const TextStyle(color: gold, fontSize: 15, fontWeight: FontWeight.w900)),
      ];
    }
    final spec = SigilCatalog.of(next);
    final secs = run.dueIn.clamp(0.0, 99.0).toStringAsFixed(1);
    return [
      Text(head, style: const TextStyle(color: gold, fontSize: 13, fontWeight: FontWeight.bold)),
      const SizedBox(width: 8),
      SigilGlyph(spec: spec, size: 30),
      const SizedBox(width: 6),
      Text(l.kataNext(spec.name, secs),
          style: TextStyle(
              color: SigilHud.layerColors[spec.layer],
              fontSize: 13,
              fontWeight: FontWeight.bold)),
    ];
  }

  /// Where the lesson is: the step and its count, or the drill's tempo.
  static String _step(Lesson lesson, AppLocalizations l) {
    final label = switch (lesson.phase) {
      LessonPhase.watch => l.lessonWatch,
      LessonPhase.trace => l.lessonTrace,
      LessonPhase.slow => l.lessonSlow,
      LessonPhase.live => l.lessonLive,
      LessonPhase.streak => l.lessonStreak,
      LessonPhase.done => l.lessonLearned,
    };
    if (lesson.learned) {
      return '$label · ${l.lessonTempo((lesson.tempo * 100).round())}';
    }
    return '$label ${lesson.count}/${lesson.needed}';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final st = game.arenaStats;
    final (casts, acc) = st.totals;
    final drillKind = game.arena.drill;
    final drill = drillKind == null ? null : SigilCatalog.of(drillKind);
    final ds = drillKind == null ? null : st.sigils[drillKind];
    return Positioned(
      top: 8,
      left: 12,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('${l.arena} · ${l.arenaSummary(st.bosses, st.knockouts)} · Σ $casts · ${(acc * 100).round()} %',
                style: const TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1)),
            if (game.gauntlet != null) ...[
              const SizedBox(width: 12),
              Text(l.gauntletRating(game.gauntlet!.rating, game.gauntletBest),
                  style: const TextStyle(
                      color: Color(0xFFFF8A65), fontSize: 13, fontWeight: FontWeight.bold)),
            ],
            if (game.kataRun != null) ..._kata(game, l),
            if (drill != null) ...[
              const SizedBox(width: 14),
              SigilGlyph(spec: drill, size: 30),
              const SizedBox(width: 6),
              Text(
                  '${drill.name}  ${ds?.casts ?? 0}× · ${((ds?.lastAccuracy ?? 0) * 100).round()} %',
                  style: TextStyle(
                      color: SigilHud.layerColors[drill.layer],
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
              if (game.lesson != null) ...[
                const SizedBox(width: 12),
                Text(_step(game.lesson!, l),
                    style: const TextStyle(
                        color: Color(0xFFFFE070),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5)),
              ],
            ],
          ]),
        ),
      ),
    );
  }
}

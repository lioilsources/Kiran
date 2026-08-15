import 'dart:async';

import 'package:flutter/material.dart';

import '../game/tyrian_game.dart';

/// Big enemy tally, embedded in the OSD panel right under the credits.
///
/// Living inside the panel (rather than absolutely positioned over it) is what
/// guarantees it can never hide behind the HUD's scrim or stat bars, and it
/// rides along with the panel's safe-area handling for free.
///
/// Reads the live on-field count. A spawn snaps the numeral to well over
/// double size and lets it fall back; a kill drops it straight to rest —
/// so mounting pressure and progress read differently at a glance.
///
/// Runs on its own timer rather than the 4Hz OSD tick — a spawn landing
/// between OSD refreshes would otherwise pop late or not at all.
class EnemyCounter extends StatefulWidget {
  final TyrianGame game;

  const EnemyCounter({super.key, required this.game});

  @override
  State<EnemyCounter> createState() => _EnemyCounterState();
}

class _EnemyCounterState extends State<EnemyCounter>
    with SingleTickerProviderStateMixin {
  static const _restScale = 1.0;
  static const _popScale = 2.6;

  late final AnimationController _pop;
  Timer? _poll;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    // Value 1 = just spawned (numeral huge), 0 = at rest. reverse() drives it
    // 1 → 0 over the duration; an earlier revision called forward(from: 1.0),
    // which completes instantly and left the numeral stuck at full size until
    // the next kill — the opposite of a pop.
    _pop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
      value: 0,
    );
    _count = widget.game.hostileCount;
    // 20Hz is well inside human reaction time for a spawn, and cheap: it only
    // reads an int and rebuilds this one numeral.
    _poll = Timer.periodic(const Duration(milliseconds: 50), (_) {
      final n = widget.game.hostileCount;
      if (n == _count) return;
      final grew = n > _count;
      setState(() => _count = n);
      if (grew) {
        _pop.reverse(from: 1.0); // snap huge, settle back down
      } else {
        _pop.animateBack(0, duration: const Duration(milliseconds: 100));
      }
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.game.state != GameState.playing || _count <= 0) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _pop,
        builder: (context, child) {
          final t = _pop.value; // 1 right after a spawn, 0 at rest
          // easeOutBack overshoots slightly near t=1, so the snap has a hint
          // of recoil instead of a linear shrink.
          final eased = Curves.easeOutBack.transform(t);
          return Transform.scale(
            // Anchored to the top-right corner: the numeral sits under the
            // right-aligned credits, so it must grow left and down, away from
            // the screen edge and the text above it.
            alignment: Alignment.topRight,
            scale: _restScale + (_popScale - _restScale) * eased,
            child: Opacity(opacity: 0.55 + 0.45 * t.clamp(0.0, 1.0), child: child),
          );
        },
        child: Text(
          '$_count',
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            height: 1.0,
            shadows: [
              Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 5),
            ],
          ),
        ),
      ),
    );
  }
}

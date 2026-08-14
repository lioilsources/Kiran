import 'dart:async';

import 'package:flutter/material.dart';

import '../game/tyrian_game.dart';

/// Big enemy tally in the bottom-left corner.
///
/// Reads the live on-field count, so it rises as a fleet spawns and falls as
/// the player clears it. Each rise pops the numeral and lets it settle back;
/// a fall drops it straight to rest, so growing pressure reads differently
/// from progress at a glance.
///
/// Runs on its own timer rather than the 4Hz OSD tick — a spawn that lands
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
  static const _popScale = 1.85;

  late final AnimationController _pop;
  Timer? _poll;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    // Drives 1.0 → 0.0 after a spawn; scale is derived from it, so the numeral
    // starts big and eases down to rest.
    _pop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
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
        _pop.forward(from: 1.0); // snap large, then settle
      } else {
        _pop.animateTo(0, duration: const Duration(milliseconds: 120));
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
    final game = widget.game;
    // Nothing to count outside a live run, and the ComCenter owns the screen.
    if (game.state != GameState.playing || _count <= 0) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 14,
      bottom: 96, // clear of the OSD stat bars
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _pop,
          builder: (context, child) {
            final t = _pop.value; // 1 right after a spawn, 0 at rest
            final eased = Curves.easeOutCubic.transform(t);
            return Transform.scale(
              alignment: Alignment.bottomLeft,
              scale: _restScale + (_popScale - _restScale) * eased,
              child: Opacity(opacity: 0.55 + 0.45 * eased, child: child),
            );
          },
          child: Text(
            '$_count',
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              height: 1.0,
              shadows: [
                Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

import 'format.dart';

/// Credits readout that ripples when the value grows.
///
/// On an increment the digits bounce in a wave running left to right — each
/// character lifts and swells slightly, staggered by its position. Decrements
/// (purchases) just update the text; spending money should not celebrate.
///
/// The wave is deliberately subtle ("malinko rozhýbej"): peak scale 1.35 and a
/// 3px lift over ~0.7s. The label prefix stays static so only the number moves.
class CreditsWave extends StatefulWidget {
  final String prefix;
  final int value;
  final String suffix;
  final TextStyle style;
  final TextAlign textAlign;

  const CreditsWave({
    super.key,
    this.prefix = '',
    required this.value,
    this.suffix = '',
    required this.style,
    this.textAlign = TextAlign.right,
  });

  @override
  State<CreditsWave> createState() => _CreditsWaveState();
}

class _CreditsWaveState extends State<CreditsWave>
    with SingleTickerProviderStateMixin {
  static const _peakScale = 1.35;
  static const _lift = 3.0;

  /// Fraction of the timeline over which one character's bounce plays; the
  /// rest is the stagger budget that makes the wave travel.
  static const _charWindow = 0.45;

  late final AnimationController _wave;

  @override
  void initState() {
    super.initState();
    _wave = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      // Start finished, i.e. at rest — value 1 means "wave has passed".
      value: 1,
    );
  }

  @override
  void didUpdateWidget(CreditsWave old) {
    super.didUpdateWidget(old);
    if (widget.value > old.value) {
      _wave.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final digits = fmtNum(widget.value);

    return AnimatedBuilder(
      animation: _wave,
      builder: (context, _) {
        final t = _wave.value;
        final chars = <Widget>[];
        for (var i = 0; i < digits.length; i++) {
          // Each character's bounce starts later the further right it sits,
          // spread across the non-window part of the timeline.
          final start = digits.length == 1
              ? 0.0
              : (i / (digits.length - 1)) * (1 - _charWindow);
          final local = ((t - start) / _charWindow).clamp(0.0, 1.0);
          final bump = sin(pi * local); // 0 → 1 → 0 as the wave passes
          chars.add(Transform.translate(
            offset: Offset(0, -_lift * bump),
            child: Transform.scale(
              scale: 1.0 + (_peakScale - 1.0) * bump,
              child: Text(digits[i], style: widget.style),
            ),
          ));
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: widget.textAlign == TextAlign.right
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (widget.prefix.isNotEmpty)
              Text(widget.prefix, style: widget.style),
            ...chars,
            if (widget.suffix.isNotEmpty)
              Text(widget.suffix, style: widget.style),
          ],
        );
      },
    );
  }
}

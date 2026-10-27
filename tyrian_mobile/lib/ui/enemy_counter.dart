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
        child: SevenSegmentDisplay(
          value: _count,
          height: 30,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}

/// Flat seven-segment numeral, like a retro LED readout. The rest of the HUD
/// is flat and segmented (see HealthBar); the previous rounded, drop-shadowed
/// Text numeral was the one element that broke that language. Unlit segments
/// are painted as faint ghosts — the signature of a real segment display, and
/// what makes the numeral read as an instrument rather than text.
class SevenSegmentDisplay extends StatelessWidget {
  final int value;
  final double height;
  final Color color;

  const SevenSegmentDisplay({
    super.key,
    required this.value,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final digits = '$value';
    final digitW = height * 0.58;
    final gap = height * 0.14;
    return CustomPaint(
      size: Size(
          digits.length * digitW + (digits.length - 1) * gap, height),
      painter: _SevenSegmentPainter(digits, color, digitW, gap),
    );
  }
}

class _SevenSegmentPainter extends CustomPainter {
  final String digits;
  final Color color;
  final double digitW;
  final double gap;

  _SevenSegmentPainter(this.digits, this.color, this.digitW, this.gap);

  /// Segment bits per digit, classic layout:
  ///  -a-
  /// f   b
  ///  -g-
  /// e   c
  ///  -d-
  /// Bit order: a b c d e f g.
  static const _glyphs = <int>[
    0x7E, // 0: abcdef
    0x30, // 1: bc
    0x6D, // 2: abdeg
    0x79, // 3: abcdg
    0x33, // 4: bcfg
    0x5B, // 5: acdfg
    0x5F, // 6: acdefg
    0x70, // 7: abc
    0x7F, // 8: all
    0x7B, // 9: abcdfg
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final lit = Paint()..color = color;
    // The ghost is what sells the LED look; 11% is visible against the HUD
    // scrim without competing with the lit segments.
    final ghost = Paint()..color = color.withAlpha(28);

    var x = 0.0;
    for (final ch in digits.codeUnits) {
      final d = ch - 0x30;
      final mask = (d >= 0 && d <= 9) ? _glyphs[d] : 0;
      _paintDigit(canvas, x, size.height, mask, lit, ghost);
      x += digitW + gap;
    }
  }

  void _paintDigit(Canvas canvas, double x0, double h, int mask,
      Paint lit, Paint ghost) {
    final w = digitW;
    final t = h * 0.13; // segment thickness
    final half = t / 2;

    // Segment centrelines; lengths shrink slightly for the inter-segment gap.
    void hseg(double yc, bool on) =>
        _hex(canvas, x0 + w / 2, yc, (w - t) * 0.92, t, true, on ? lit : ghost);
    void vseg(double xc, double y0, double y1, bool on) => _hex(canvas,
        x0 + xc, (y0 + y1) / 2, (y1 - y0 - t * 0.16) * 0.92, t, false,
        on ? lit : ghost);

    hseg(half, mask & 0x40 != 0); // a
    vseg(w - half, half, h / 2, mask & 0x20 != 0); // b
    vseg(w - half, h / 2, h - half, mask & 0x10 != 0); // c
    hseg(h - half, mask & 0x08 != 0); // d
    vseg(half, h / 2, h - half, mask & 0x04 != 0); // e
    vseg(half, half, h / 2, mask & 0x02 != 0); // f
    hseg(h / 2, mask & 0x01 != 0); // g
  }

  /// One segment: a hexagon with 45° chamfered ends, the canonical LED shape.
  void _hex(Canvas canvas, double xc, double yc, double len, double t,
      bool horizontal, Paint paint) {
    final half = len / 2;
    final ht = t / 2;
    final path = Path();
    if (horizontal) {
      path
        ..moveTo(xc - half, yc)
        ..lineTo(xc - half + ht, yc - ht)
        ..lineTo(xc + half - ht, yc - ht)
        ..lineTo(xc + half, yc)
        ..lineTo(xc + half - ht, yc + ht)
        ..lineTo(xc - half + ht, yc + ht);
    } else {
      path
        ..moveTo(xc, yc - half)
        ..lineTo(xc + ht, yc - half + ht)
        ..lineTo(xc + ht, yc + half - ht)
        ..lineTo(xc, yc + half)
        ..lineTo(xc - ht, yc + half - ht)
        ..lineTo(xc - ht, yc - half + ht);
    }
    canvas.drawPath(path..close(), paint);
  }

  @override
  bool shouldRepaint(_SevenSegmentPainter old) =>
      old.digits != digits || old.color != color || old.digitW != digitW;
}

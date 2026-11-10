import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/platform_config.dart' as platform;
import '../rendering/sigil_hud.dart';
import '../systems/sigils/sigil_accuracy.dart';
import '../systems/sigils/sigil_grid.dart';
import '../systems/sigils/sigil_recognizer.dart';
import '../systems/sigils/sigil_spec.dart';

/// A sigil's shape on the 3×3 grid, the way the thumb draws it on this
/// screen (forward points where the ship flies). Flicks show all eight
/// spokes. Used by the arena, the grimoire and the tutorial cards.
class SigilGlyph extends StatelessWidget {
  final SigilSpec spec;
  final double size;
  final bool dim;

  const SigilGlyph({super.key, required this.spec, this.size = 44, this.dim = false});

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _GlyphPainter(spec, dim),
      );
}

class _GlyphPainter extends CustomPainter {
  final SigilSpec spec;
  final bool dim;
  _GlyphPainter(this.spec, this.dim);

  Offset _at(Size s, double x, double y) {
    final (sx, sy) = platform.gameToScreen(x, y);
    final r = s.width * 0.4;
    return Offset(s.width / 2 + sx * r, s.height / 2 + sy * r);
  }

  @override
  void paint(Canvas canvas, Size s) {
    final col = (SigilHud.layerColors[spec.layer] ?? Colors.white)
        .withValues(alpha: dim ? 0.35 : 1);
    for (var d = 0; d < 9; d++) {
      final (x, y) = d == 4
          ? (0.0, 0.0)
          : () {
              final a = SigilGrid.sectorAngle(SigilGrid.ring.indexOf(d));
              return (math.sin(a), -math.cos(a));
            }();
      canvas.drawCircle(_at(s, x, y), s.width * 0.035,
          Paint()..color = Colors.white.withValues(alpha: dim ? 0.2 : 0.45));
    }
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s.width * 0.07
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = col;
    final shape = spec.shape;
    if (shape == null) {
      for (final d in SigilGrid.ring) {
        final a = SigilGrid.sectorAngle(SigilGrid.ring.indexOf(d));
        canvas.drawLine(_at(s, 0, 0), _at(s, math.sin(a) * 0.8, -math.cos(a) * 0.8),
            stroke..strokeWidth = s.width * 0.04);
      }
      return;
    }
    final line = SigilAccuracy.idealLine(
        SigilRecognizer.idealFor(spec, drawn: shape));
    final path = Path();
    // Skip the final way home: the glyph ends where the stroke ends.
    for (var i = 0; i < line.length - 1; i++) {
      final p = _at(s, line[i].$1, line[i].$2);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, stroke);
    // An arrowhead at the end, so the direction reads.
    if (line.length >= 3) {
      final a = _at(s, line[line.length - 3].$1, line[line.length - 3].$2);
      final b = _at(s, line[line.length - 2].$1, line[line.length - 2].$2);
      final dir = math.atan2(b.dy - a.dy, b.dx - a.dx);
      final l = s.width * 0.14;
      final head = Path()
        ..moveTo(b.dx, b.dy)
        ..lineTo(b.dx - l * math.cos(dir - 0.5), b.dy - l * math.sin(dir - 0.5))
        ..moveTo(b.dx, b.dy)
        ..lineTo(b.dx - l * math.cos(dir + 0.5), b.dy - l * math.sin(dir + 0.5));
      canvas.drawPath(head, stroke);
    }
    canvas.drawCircle(_at(s, line[1].$1, line[1].$2), s.width * 0.06,
        Paint()..color = col);
  }

  @override
  bool shouldRepaint(_GlyphPainter old) => old.spec != spec || old.dim != dim;
}

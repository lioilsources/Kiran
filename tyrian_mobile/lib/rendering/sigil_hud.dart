import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../entities/sigil_caster.dart';
import '../game/game_config.dart' as config;
import '../game/platform_config.dart' as platform;
import '../game/tyrian_game.dart';
import '../l10n/l10n.dart';
import '../systems/sigils/sigil_accuracy.dart';
import '../systems/sigils/sigil_catalog.dart';
import '../systems/sigils/sigil_grid.dart';
import '../systems/sigils/sigil_hints.dart';
import '../systems/sigils/sigil_recognizer.dart';
import '../systems/sigils/sigil_spec.dart';

/// The sigil pad (Prompts/28 §11): always on screen while sigils are on, so
/// the player sees what the stick drew and how well.
///
/// - while drawing: the live stroke, the stick cursor and the dots picked up,
///   in the colour of the layer held;
/// - after every gesture, until the next one starts: the stroke as drawn
///   over the ideal line it is judged against, the sigil's name, the
///   precision and the drawing time — or, for a miss, the nearest sigil and
///   why it did not cast;
/// - around it: CHARGE as a ring, FLOW's letter and the OVERSTREAM gear.
///
/// Lives in `camera.viewport`, so it draws in screen space. Strokes come in
/// ship space and are turned back to the screen the way the thumb drew them.
class SigilHud extends Component with HasGameReference<TyrianGame> {
  static const double radius = 52;

  static const Map<SigilLayer, Color> layerColors = {
    SigilLayer.hull: Color(0xFF5CF2E8),
    SigilLayer.arms: Color(0xFFFFB84D),
    SigilLayer.wing: Color(0xFF7CFF8A),
  };
  static const Color missColor = Color(0xFFFF5A6A);

  final Map<String, TextPainter> _text = {};

  double get _w => platform.isLandscape ? config.gameHeight : config.gameWidth;
  double get _h => platform.isLandscape ? config.gameWidth : config.gameHeight;

  /// Pad centre: bottom right, clear of the OSD strip.
  Offset get centre => Offset(_w - radius - 26, _h - radius - 78);

  @override
  void render(Canvas canvas) {
    if (game.state != GameState.playing && game.state != GameState.paused) {
      return;
    }
    final caster = game.vessel.caster;
    if (!caster.enabled) return;
    // Filmed takes get their input panel drawn by the assembler, upright.
    if (game.capture != null) return;
    final c = centre;
    final rec = caster.recognizer;
    final drawing = rec.drawing;
    final last = caster.lastReading;
    final layer = drawing ? rec.layer : (last?.layer ?? SigilLayer.hull);
    final hue = layerColors[layer]!;

    // Backplate and grid.
    canvas.drawCircle(c, radius + 14, Paint()..color = const Color(0x8C05080F));
    _chargeRing(canvas, c, caster);
    canvas.drawCircle(
        c,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = hue.withValues(alpha: 0.25));

    final picked = drawing ? rec.drawn.toSet() : const <int>{};
    for (var d = 0; d < 9; d++) {
      final p = _dot(c, d);
      final on = picked.contains(d);
      canvas.drawCircle(p, on ? 5.5 : 3.5,
          Paint()..color = on ? hue : Colors.white.withValues(alpha: 0.35));
    }

    final hint = SigilHints.instance.active;
    if (drawing) {
      _stroke(canvas, c, rec.trail, hue, 3);
    } else if (hint != null) {
      _hint(canvas, c, hint);
    } else if (last != null) {
      _result(canvas, c, last, caster);
    }

    // The stick itself.
    final (sx, sy) = platform.gameToScreen(rec.stickX, rec.stickY);
    final cur = c + Offset(sx, sy) * radius;
    canvas.drawCircle(cur, 6, Paint()..color = Colors.white.withValues(alpha: 0.9));
    canvas.drawCircle(
        cur,
        9,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = hue);

    _sideInfo(canvas, c, caster);
  }

  /// A rim dot's place on screen: the grid is ship space, the pad screen.
  Offset _dot(Offset c, int dot) {
    if (dot == 4) return c;
    final a = SigilGrid.sectorAngle(SigilGrid.ring.indexOf(dot));
    final (x, y) = platform.gameToScreen(math.sin(a), -math.cos(a));
    return c + Offset(x, y) * radius;
  }

  void _stroke(Canvas canvas, Offset c, List<(double, double)> pts, Color col,
      double width) {
    if (pts.length < 2) return;
    final path = Path();
    for (var i = 0; i < pts.length; i++) {
      final (x, y) = platform.gameToScreen(pts[i].$1, pts[i].$2);
      final p = c + Offset(x, y) * radius;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = col);
  }

  void _result(Canvas canvas, Offset c, SigilReading r, SigilCaster caster) {
    final ok = r.cast && !caster.lastDry;
    final col = ok ? layerColors[r.layer]! : missColor;
    if (r.ideal.isNotEmpty) {
      final reach = SigilAccuracy.reach(r.trail);
      _stroke(canvas, c, SigilAccuracy.idealLine(r.ideal, r: reach),
          Colors.white.withValues(alpha: 0.28), 7);
    }
    _stroke(canvas, c, r.trail, col.withValues(alpha: 0.9), 2.5);

    final l = L10n.current;
    // Typed on the keyboard: nothing was drawn, so nothing to judge.
    final pct = r.keyed ? '⌨' : '${(r.accuracy * 100).round()} %';
    final ms = '${(r.drawTime * 1000).round()} ms';
    String title, sub;
    if (r.cast) {
      title = r.spec!.name;
      sub = caster.lastDry
          ? l.sigilDry
          : (caster.lastBusy ? l.sigilBusy : '$pct · $ms');
    } else {
      final near = r.miss?.nearest;
      title = near == null ? '?' : '${near.name}?';
      sub = '${_why(r.miss?.reason, l)} · $pct';
    }
    final top = c.dy - radius - 52;
    _label(canvas, title, Offset(c.dx, top), 15, col, bold: true);
    _label(canvas, sub, Offset(c.dx, top + 19), 11, Colors.white70);
  }

  double _pulse = 0;

  @override
  void update(double dt) => _pulse += dt;

  /// A one-time nudge: the sigil's line pulsing in the pad and what to do.
  void _hint(Canvas canvas, Offset c, SigilHint h) {
    final l = L10n.current;
    final glow = 0.45 + 0.4 * math.sin(_pulse * 6);
    const gold = Color(0xFFFFE070);
    final spec = switch (h) {
      SigilHint.hop => SigilCatalog.of(SigilKind.hop),
      SigilHint.loop => SigilCatalog.of(SigilKind.loop),
      SigilHint.stream => null,
    };
    if (spec != null) {
      final dots = SigilRecognizer.idealFor(spec, flickDot: 1, drawn: spec.shape ?? const [1]);
      _stroke(canvas, c, SigilAccuracy.idealLine(dots), gold.withValues(alpha: glow), 6);
    }
    final text = switch (h) {
      SigilHint.hop => l.hintHop,
      SigilHint.loop => l.hintLoop,
      SigilHint.stream => l.hintStream,
    };
    final top = c.dy - radius - 52;
    if (spec != null) _label(canvas, spec.name, Offset(c.dx, top), 15, gold, bold: true);
    // Right-aligned to the pad so a long sentence runs into the field, not
    // off the screen.
    _label(canvas, text, Offset(c.dx + radius + 10, top + 19), 11, Colors.white,
        rightAligned: true);
  }

  String _why(SigilMiss? m, AppLocalizations l) => switch (m) {
        SigilMiss.tooSlow => l.sigilMissTooSlow,
        SigilMiss.skippedDot => l.sigilMissSkippedDot,
        SigilMiss.leftRimEarly => l.sigilMissLeftRimEarly,
        SigilMiss.wrongDirection => l.sigilMissWrongDirection,
        SigilMiss.wrongLayer => l.sigilMissWrongLayer,
        _ => l.sigilMissUnknown,
      };

  void _chargeRing(Canvas canvas, Offset c, SigilCaster caster) {
    final m = caster.meter;
    final frac = m.infinite ? 1.0 : (m.charge / config.chargeMax).clamp(0.0, 1.0);
    final rect = Rect.fromCircle(center: c, radius: radius + 9);
    canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = Colors.white.withValues(alpha: 0.12));
    canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * frac,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..color = caster.lastDry ? missColor : const Color(0xFFB98CFF));
  }

  void _sideInfo(Canvas canvas, Offset c, SigilCaster caster) {
    final m = caster.meter;
    final charge = m.infinite ? '∞' : m.charge.floor().toString();
    _label(canvas, charge, Offset(c.dx, c.dy + radius + 20), 12,
        const Color(0xFFB98CFF), bold: true);
    final x = c.dx - radius - 30;
    if (m.grade.isNotEmpty) {
      _label(canvas, m.grade, Offset(x, c.dy - 18), 22, const Color(0xFFFFE070),
          bold: true);
      _label(canvas, 'FLOW ${m.flow}', Offset(x, c.dy + 4), 9, Colors.white60);
    }
    if (caster.gear > 1) {
      _label(canvas, '×${caster.gear}', Offset(x, c.dy + 26), 13,
          const Color(0xFF66E0FF), bold: true);
    }
  }

  void _label(Canvas canvas, String s, Offset at, double size, Color col,
      {bool bold = false, bool rightAligned = false}) {
    final key = '$s|$size|${col.toARGB32()}|$bold';
    final tp = _text.putIfAbsent(key, () {
      if (_text.length > 64) _text.clear();
      return TextPainter(
        text: TextSpan(
            text: s,
            style: TextStyle(
                color: col,
                fontSize: size,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                // Spacing breaks the joined Arabic/Urdu script.
                letterSpacing: L10n.textDirection == TextDirection.rtl ? 0 : 1)),
        textDirection: L10n.textDirection,
      )..layout();
    });
    tp.paint(canvas,
        at - Offset(rightAligned ? tp.width : tp.width / 2, tp.height / 2));
  }
}

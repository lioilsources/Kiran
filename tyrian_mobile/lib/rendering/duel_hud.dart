import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/game_config.dart' as config;
import '../game/platform_config.dart' as platform;
import '../game/tyrian_game.dart';
import '../input/pad_scheme.dart';
import '../l10n/l10n.dart';
import '../services/asset_library.dart';
import '../systems/duel_director.dart';

/// The duel's screen layer (Prompts/30 §8): the WARNING strip, the boss
/// close-up and the first duel's two-line hint. Lives in `camera.viewport`,
/// so it draws upright in screen space.
///
/// The close-up is built from the sprites every skin already has (§8.2,
/// variant A): the boss enlarged and cropped to its head, a slow push in, a
/// blink and a twitch for a creature, a scan line for a ship.
class DuelHud extends Component with HasGameReference<TyrianGame> {
  final Map<String, TextPainter> _text = {};
  double _pulse = 0;
  double _hintLeft = 0;

  /// What the hint card says, set when it opens.
  (String, String)? _hint;

  double get _w => platform.isLandscape ? config.gameHeight : config.gameWidth;
  double get _h => platform.isLandscape ? config.gameWidth : config.gameHeight;

  @override
  void update(double dt) {
    _pulse += dt;
    final d = game.duel;
    if (d.wantsHint && _hint == null && game.state == GameState.playing) {
      final l = L10n.current;
      _hint = game.gamepadInput.isConnected
          ? (
              l.duelHintPad1,
              !game.sigilsEnabled
                  ? l.duelHintClassic
                  : (PadSettings.duelBinding == DuelBinding.rtStance
                      ? l.duelHintPad2Rt
                      : l.duelHintPad2Lt)
            )
          : (l.duelHintKeys1, l.duelHintKeys2);
      _hintLeft = 6;
      DuelDirector.markHintShown();
    }
    if (_hintLeft > 0) {
      _hintLeft -= dt;
      if (_hintLeft <= 0) _hint = null;
    }
  }

  @override
  void render(Canvas canvas) {
    if (game.state != GameState.playing && game.state != GameState.paused) {
      return;
    }
    final d = game.duel;
    switch (d.phase) {
      case DuelPhase.warning:
        _warning(canvas, (d.t / config.duelWarning).clamp(0.0, 1.0).toDouble());
      case DuelPhase.cutIn:
        _cutIn(canvas, d);
      default:
        break;
    }
    final h = _hint;
    if (h != null && d.controls) _hintCard(canvas, h);
  }

  /// A red strip across the middle, flashing, with the boss's number in dots.
  void _warning(Canvas canvas, double k) {
    final on = (_pulse * 4).floor().isEven;
    final cy = _h * 0.32;
    final fade = k < 0.15 ? k / 0.15 : (k > 0.85 ? (1 - k) / 0.15 : 1.0);
    final band = Paint()..color = const Color(0xFFFF2A3A).withValues(alpha: 0.22 * fade);
    canvas.drawRect(Rect.fromLTWH(0, cy - 34, _w, 68), band);
    final edge = Paint()
      ..color = const Color(0xFFFF2A3A).withValues(alpha: 0.8 * fade)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, cy - 34), Offset(_w, cy - 34), edge);
    canvas.drawLine(Offset(0, cy + 34), Offset(_w, cy + 34), edge);
    if (on) {
      _label(canvas, L10n.current.duelWarning, Offset(_w / 2, cy - 4), 34,
          const Color(0xFFFF5A6A).withValues(alpha: fade), bold: true);
    }
    _dots(canvas, Offset(_w / 2, cy + 22), game.duel.cutInOrdinal, fade);
  }

  void _dots(Canvas canvas, Offset at, int n, double alpha) {
    final count = n.clamp(1, 12);
    const gap = 12.0;
    final x0 = at.dx - (count - 1) * gap / 2;
    for (var i = 0; i < count; i++) {
      canvas.drawCircle(Offset(x0 + i * gap, at.dy), 3.2,
          Paint()..color = const Color(0xFFFFB0B8).withValues(alpha: alpha));
    }
  }

  void _cutIn(Canvas canvas, DuelDirector d) {
    final k = d.cutInK;
    final lib = AssetLibrary.instance;
    final creature = lib.getSprite('rododendron_blink') != null;
    final t = d.t;
    // A creature blinks at 0.9 s and twitches at 1.5 s; a ship is scanned.
    final name = !creature
        ? 'rododendron'
        : (t > 0.9 && t < 1.05
            ? 'rododendron_blink'
            : (t > 1.5 && t < 1.62
                ? 'rododendron_twitch_l'
                : (t > 1.62 && t < 1.74 ? 'rododendron_twitch_r' : 'rododendron')));
    final sprite = lib.getSprite(name) ??
        lib.getSprite('rododendron') ??
        lib.getSprite('bouncer');
    final bar = _h * 0.14 * math.min(1.0, k * 6);
    canvas.drawRect(Rect.fromLTWH(0, 0, _w, _h), Paint()..color = const Color(0xCC000000));
    if (sprite != null) {
      // The head: the top of the art, filling the band between the bars.
      final src = sprite.src;
      const cropTop = 0.0, cropH = 0.58;
      final crop = Rect.fromLTWH(
          src.left, src.top + src.height * cropTop, src.width, src.height * cropH);
      final zoom = 1.0 + 0.15 * k;
      final boxH = (_h - 2 * bar) * 1.05 * zoom;
      final boxW = boxH * crop.width / crop.height;
      final dst = Rect.fromCenter(
          center: Offset(_w / 2, _h / 2 + _h * 0.04 * (1 - k)),
          width: boxW,
          height: boxH);
      final fade = math.min(1.0, k * 5) * math.min(1.0, (1 - k) * 8);
      canvas.drawImageRect(
          sprite.image,
          crop,
          dst,
          Paint()
            ..filterQuality = FilterQuality.medium
            ..color = Colors.white.withValues(alpha: fade.clamp(0.0, 1.0)));
      if (!creature) {
        // A scan line runs down the ship.
        final y = dst.top + dst.height * ((t * 0.7) % 1.0);
        canvas.drawRect(Rect.fromLTWH(dst.left, y, dst.width, 3),
            Paint()..color = const Color(0x8866E0FF));
      }
    }
    final barPaint = Paint()..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, _w, bar), barPaint);
    canvas.drawRect(Rect.fromLTWH(0, _h - bar, _w, bar), barPaint);
    if (bar > 10) {
      _label(canvas, L10n.current.duelWarning, Offset(_w / 2, _h - bar / 2), 18,
          const Color(0xFFFF5A6A), bold: true);
      _dots(canvas, Offset(_w / 2, bar / 2), d.cutInOrdinal, 1);
    }
  }

  void _hintCard(Canvas canvas, (String, String) h) {
    final fade = (_hintLeft.clamp(0.0, 0.6) / 0.6).toDouble();
    final top = _h * 0.08;
    final a = _painter(h.$1, 14, const Color(0xFF5CF2E8), true);
    final b = _painter(h.$2, 13, Colors.white, false);
    final width = math.min(_w - 24, math.max(a.width, b.width) + 40);
    final rect = Rect.fromCenter(center: Offset(_w / 2, top + 26), width: width, height: 56);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        Paint()..color = const Color(0xCC05080F).withValues(alpha: 0.8 * fade));
    _label(canvas, h.$1, Offset(_w / 2, top + 14), 14,
        const Color(0xFF5CF2E8).withValues(alpha: fade), bold: true);
    _label(canvas, h.$2, Offset(_w / 2, top + 36), 13,
        Colors.white.withValues(alpha: 0.9 * fade));
  }

  TextPainter _painter(String s, double size, Color col, bool bold) =>
      _text.putIfAbsent('$s|$size|${col.toARGB32()}|$bold', () {
        if (_text.length > 48) _text.clear();
        return TextPainter(
          text: TextSpan(
              text: s,
              style: TextStyle(
                  color: col,
                  fontSize: size,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                  letterSpacing: bold ? 6 : 1)),
          textDirection: TextDirection.ltr,
        )..layout();
      });

  void _label(Canvas canvas, String s, Offset at, double size, Color col,
      {bool bold = false}) {
    final tp = _painter(s, size, col, bold);
    tp.paint(canvas, at - Offset(tp.width / 2, tp.height / 2));
  }
}

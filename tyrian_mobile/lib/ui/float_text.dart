import 'dart:math' show pi;

import 'package:cute_kid_fonts/cute_kid_fonts_flame.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/game_config.dart' as config;
import '../game/platform_config.dart' as platform;

/// Ported from FloatText.cls — floating text that drifts upward and fades.
/// Used for "Complete", "Game Over", weapon unlock messages, etc.
class FloatText extends PositionComponent {
  final String text;
  final Color color;
  final double fontSize;
  final double duration; // seconds
  double _elapsed = 0;
  final bool stationary;
  final double driftSpeed; // pixels per second upward

  /// When set, the text renders as a CuteKidFonts bubble sprite (outline,
  /// extrusion, pastel gradient) instead of plain [color] text.
  final KidPalette? palette;
  KidRasterText? _raster;

  FloatText({
    required this.text,
    this.color = Colors.white,
    this.fontSize = 24,
    this.duration = 2.0,
    this.stationary = false,
    this.driftSpeed = 30,
    this.palette,
    Vector2? position,
  }) : super(position: position ?? Vector2(config.gameWidth / 2, config.gameHeight / 2));

  @override
  Future<void> onLoad() async {
    final p = palette;
    if (p == null) return;
    // Rasterised once per (text, palette, size) and cached — messages repeat.
    _raster = await KidRasterCache.instance.get(
      text,
      role: KidRole.title,
      palette: p,
      size: fontSize,
      pixelRatio: 3,
    );
  }

  @override
  void update(double dt) {
    _elapsed += dt;
    if (_elapsed >= duration) {
      removeFromParent();
      return;
    }
    if (!stationary) {
      // Screen-up drift. In landscape the camera is rotated +90 CCW (game up
      // renders as screen right), so screen-up corresponds to game -X.
      if (platform.isLandscape) {
        position.x -= driftSpeed * dt;
      } else {
        position.y -= driftSpeed * dt;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Counter the landscape camera rotation (+90 CCW) so glyphs read upright.
    // The canvas origin is this component's position, which the paint below
    // treats as the text centre, so rotating about the origin is exact.
    if (platform.isLandscape) {
      canvas.rotate(-pi / 2);
    }
    final alpha = ((1.0 - _elapsed / duration) * 255).round().clamp(0, 255);
    final raster = _raster;
    if (raster != null) {
      final img = raster.image;
      canvas.drawImageRect(
        img,
        Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
        Rect.fromCenter(center: Offset.zero, width: raster.size.width, height: raster.size.height),
        Paint()
          ..color = Color.fromARGB(alpha, 255, 255, 255)
          ..filterQuality = FilterQuality.medium,
      );
      return;
    }
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color.withAlpha(alpha),
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black.withAlpha(alpha),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }
}

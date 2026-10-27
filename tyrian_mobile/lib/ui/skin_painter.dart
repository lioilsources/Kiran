import 'package:flame/components.dart' show Sprite;
import 'package:flutter/material.dart';

/// Paints a [Sprite] (Flame) onto a Flutter Canvas covering the entire widget.
/// [darkOverlay] (0.0–1.0) adds a semi-transparent black layer for readability.
class SpritePainter extends CustomPainter {
  final Sprite sprite;
  final double darkOverlay;

  const SpritePainter(this.sprite, {this.darkOverlay = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final src = Rect.fromLTWH(
      sprite.srcPosition.x,
      sprite.srcPosition.y,
      sprite.srcSize.x,
      sprite.srcSize.y,
    );
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(sprite.image, src, dst,
        Paint()..filterQuality = FilterQuality.medium);

    if (darkOverlay > 0) {
      canvas.drawRect(
        dst,
        Paint()..color = Color.fromARGB((darkOverlay * 255).round(), 0, 0, 0),
      );
    }
  }

  @override
  bool shouldRepaint(SpritePainter old) =>
      old.sprite != sprite || old.darkOverlay != darkOverlay;
}

/// Wraps [child] in a Stack with [sprite] painted full-size behind it.
/// Falls back to plain [child] when [sprite] is null (pipeline assets not generated yet).
Widget spriteBox({
  required Sprite? sprite,
  double darkOverlay = 0.0,
  required Widget child,
}) {
  if (sprite == null) return child;
  return Stack(
    fit: StackFit.passthrough,
    children: [
      Positioned.fill(
        child: CustomPaint(
          painter: SpritePainter(sprite, darkOverlay: darkOverlay),
        ),
      ),
      child,
    ],
  );
}

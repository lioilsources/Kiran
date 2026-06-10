import 'dart:ui';
import 'package:flutter/painting.dart';

// Draws a radial glow ring around a sprite: transparent inside, peak glow at
// the sprite edge, fading to transparent beyond. Uses RadialGradient so it
// renders correctly on both Skia and Impeller (no MaskFilter needed).
//
// [radius] should be roughly half the sprite's width so the glow peak lands
// just outside the sprite boundary.
void drawEntityGlow(Canvas canvas, Offset center, double radius, Color color) {
  final outerR = radius * 1.8;
  final rect = Rect.fromCircle(center: center, radius: outerR);
  final r = color.red;
  final g = color.green;
  final b = color.blue;
  final shader = RadialGradient(
    colors: [
      Color.fromARGB(0,   r, g, b),  // transparent at center
      Color.fromARGB(0,   r, g, b),  // transparent inside sprite
      Color.fromARGB(120, r, g, b),  // soft glow peak
      Color.fromARGB(28,  r, g, b),  // wide outer halo
      Color.fromARGB(0,   r, g, b),  // fade to transparent
    ],
    stops: const [0.0, 0.45, 0.60, 0.88, 1.0],
  ).createShader(rect);

  canvas.drawCircle(center, outerR, Paint()..shader = shader);
}

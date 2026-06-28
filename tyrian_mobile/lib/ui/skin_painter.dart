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

/// 9-slice painter — corners are drawn at a fixed [dstInset] pt, edges/center stretch.
/// [srcInset] is the border thickness in SOURCE image pixels.
/// Works correctly with atlas sprites (draws 9 separate drawImageRect calls).
class _SpriteFramePainter extends CustomPainter {
  final Sprite sprite;
  final double srcInset;
  final double dstInset;
  final double darkOverlay;

  const _SpriteFramePainter(this.sprite, {
    required this.srcInset,
    required this.dstInset,
    this.darkOverlay = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sx = sprite.srcPosition.x;
    final sy = sprite.srcPosition.y;
    final sw = sprite.srcSize.x;
    final sh = sprite.srcSize.y;
    final img = sprite.image;
    final p = Paint()..filterQuality = FilterQuality.medium;
    final s = srcInset;
    final d = dstInset;
    final W = size.width;
    final H = size.height;

    void draw(Rect src, Rect dst) => canvas.drawImageRect(img, src, dst, p);

    // Corners (fixed d×d destination)
    draw(Rect.fromLTWH(sx,       sy,       s,        s       ), Rect.fromLTWH(0,    0,    d,      d      ));
    draw(Rect.fromLTWH(sx+sw-s,  sy,       s,        s       ), Rect.fromLTWH(W-d,  0,    d,      d      ));
    draw(Rect.fromLTWH(sx,       sy+sh-s,  s,        s       ), Rect.fromLTWH(0,    H-d,  d,      d      ));
    draw(Rect.fromLTWH(sx+sw-s,  sy+sh-s,  s,        s       ), Rect.fromLTWH(W-d,  H-d,  d,      d      ));
    // Edges (stretch)
    draw(Rect.fromLTWH(sx+s,     sy,       sw-2*s,   s       ), Rect.fromLTWH(d,    0,    W-2*d,  d      ));
    draw(Rect.fromLTWH(sx+s,     sy+sh-s,  sw-2*s,   s       ), Rect.fromLTWH(d,    H-d,  W-2*d,  d      ));
    draw(Rect.fromLTWH(sx,       sy+s,     s,        sh-2*s  ), Rect.fromLTWH(0,    d,    d,      H-2*d  ));
    draw(Rect.fromLTWH(sx+sw-s,  sy+s,     s,        sh-2*s  ), Rect.fromLTWH(W-d,  d,    d,      H-2*d  ));
    // Center (stretch both)
    draw(Rect.fromLTWH(sx+s,     sy+s,     sw-2*s,   sh-2*s  ), Rect.fromLTWH(d,    d,    W-2*d,  H-2*d  ));

    if (darkOverlay > 0) {
      canvas.drawRect(Rect.fromLTWH(0, 0, W, H),
        Paint()..color = Color.fromARGB((darkOverlay * 255).round(), 0, 0, 0));
    }
  }

  @override
  bool shouldRepaint(_SpriteFramePainter old) =>
      old.sprite != sprite || old.srcInset != srcInset ||
      old.dstInset != dstInset || old.darkOverlay != darkOverlay;
}

/// 9-slice version of [spriteBox] for card/frame backgrounds.
/// [srcInset]: border thickness in source image pixels (default 22 for 192px sprites).
/// [dstInset]: rendered border thickness in logical pixels — use this value as card padding.
Widget spriteCardBox({
  required Sprite? sprite,
  double darkOverlay = 0.0,
  double srcInset = 22,
  double dstInset = 22,
  required Widget child,
}) {
  if (sprite == null) return child;
  return Stack(
    fit: StackFit.passthrough,
    children: [
      Positioned.fill(
        child: CustomPaint(
          painter: _SpriteFramePainter(sprite,
              srcInset: srcInset, dstInset: dstInset, darkOverlay: darkOverlay),
        ),
      ),
      child,
    ],
  );
}

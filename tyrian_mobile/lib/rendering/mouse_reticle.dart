import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/tyrian_game.dart';

/// Where the ship is flying to under the mouse (Prompts/36 §3.3). The
/// system cursor is hidden in flight; this small mark stands in for it while
/// the ship has not caught up, so the hand always sees where it points.
/// Lives in `world`: it draws at [TyrianGame.mouseReticle], world space.
class MouseReticle extends Component with HasGameReference<TyrianGame> {
  MouseReticle() : super(priority: 900);

  static final Paint _ring = Paint()
    ..color = const Color(0xCC00FFFF)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  @override
  void render(Canvas canvas) {
    final p = game.mouseReticle;
    if (p == null) return;
    final c = Offset(p.x, p.y);
    canvas.drawCircle(c, 6, _ring);
    canvas.drawLine(c.translate(-10, 0), c.translate(-7, 0), _ring);
    canvas.drawLine(c.translate(7, 0), c.translate(10, 0), _ring);
    canvas.drawLine(c.translate(0, -10), c.translate(0, -7), _ring);
    canvas.drawLine(c.translate(0, 7), c.translate(0, 10), _ring);
  }
}

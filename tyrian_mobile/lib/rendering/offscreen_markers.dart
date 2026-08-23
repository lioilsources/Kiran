import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';

/// Edge markers pointing at enemies the camera cannot show.
///
/// The immersive camera renders only [config.immersiveVisibleFraction] of the
/// field width and pans within it, so roughly a fifth of the play area is off
/// screen at any moment — and both side edges are never visible together.
/// Enemies that come to rest out there (Planet Orbit parks whole rows at x≈2
/// and x≈534) are perfectly reachable, but the player has no way to know they
/// exist, or which way to fly. The result reads as a stalled sector: the enemy
/// counter sits above zero and nothing is on screen.
///
/// Lives in `camera.viewport`, not in `world`, so it draws in fixed
/// viewport-sized coordinates regardless of the viewfinder's zoom and pan.
/// NOTE(landscape): the maths below assumes the portrait field
/// (config.gameWidth x gameHeight) while the landscape viewport swaps the
/// dimensions. This is dormant, not broken: in landscape the camera shows the
/// whole field at zoom 1, so no enemy is ever off-screen and render() draws
/// nothing. If landscape ever gets a zoomed camera, revisit this first.
class OffscreenEnemyMarkers extends Component
    with HasGameReference<TyrianGame> {
  /// Per-edge counts: left, right, up, down.
  int _left = 0, _right = 0, _up = 0, _down = 0;

  static const double _margin = 10;
  static const double _size = 9;

  @override
  void update(double dt) {
    _left = _right = _up = _down = 0;
    if (game.state != GameState.playing) return;

    // Visible world window, mirroring _updateImmersiveCamera's geometry.
    final zoom = game.camera.viewfinder.zoom;
    final halfW = (config.gameWidth / zoom) / 2;
    final halfH = (config.gameHeight / zoom) / 2;
    final cam = game.camera.viewfinder.position;

    for (final f in game.activeFleets) {
      for (final h in f.hostiles) {
        if (h.isDead) continue;
        // Only flag enemies that are wholly past an edge; one that is merely
        // clipped is already visible enough to find.
        if (h.x2 < cam.x - halfW) {
          _left++;
        } else if (h.position.x > cam.x + halfW) {
          _right++;
        } else if (h.y2 < cam.y - halfH) {
          _up++;
        } else if (h.position.y > cam.y + halfH) {
          _down++;
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (_left == 0 && _right == 0 && _up == 0 && _down == 0) return;

    final w = config.gameWidth;
    final h = config.gameHeight;
    // Sit above the OSD panel rather than behind it.
    final midY = h * 0.45;

    if (_left > 0) _marker(canvas, Offset(_margin, midY), -pi / 2, _left);
    if (_right > 0) _marker(canvas, Offset(w - _margin, midY), pi / 2, _right);
    if (_up > 0) _marker(canvas, Offset(w / 2, _margin), 0, _up);
    if (_down > 0) _marker(canvas, Offset(w / 2, h * 0.78), pi, _down);
  }

  /// A chevron pointing outward at [angle] (0 = up), with the count beside it.
  void _marker(Canvas canvas, Offset at, double angle, int count) {
    final paint = Paint()..color = const Color(0xCCFF5252);

    canvas.save();
    canvas.translate(at.dx, at.dy);
    canvas.rotate(angle);
    final path = Path()
      ..moveTo(0, -_size)
      ..lineTo(_size * 0.8, _size * 0.6)
      ..lineTo(-_size * 0.8, _size * 0.6)
      ..close();
    canvas.drawPath(path, paint);
    canvas.restore();

    final tp = TextPainter(
      text: TextSpan(
        text: '$count',
        style: const TextStyle(
          color: Color(0xCCFF5252),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Keep the number inside the frame on every edge.
    final dx = angle.abs() < 0.1 || (angle - pi).abs() < 0.1
        ? -tp.width / 2
        : (angle < 0 ? _size + 2 : -_size - 2 - tp.width);
    final dy = angle.abs() < 0.1
        ? _size + 2
        : ((angle - pi).abs() < 0.1 ? -_size - 2 - tp.height : -tp.height / 2);
    tp.paint(canvas, Offset(at.dx + dx, at.dy + dy));
  }
}

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/game/duel_space.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/game/platform_config.dart' as platform;

/// The duel's directions (Prompts/30 §3): derived from the camera, never
/// written down as numbers anywhere else.
void main() {
  test('the duel is a desktop affair: the tests run landscape', () {
    expect(platform.isLandscape, isTrue);
  });

  test('duelUp is up on screen, and the others where they say', () {
    for (final (v, sx, sy) in [
      (duelUp, 0.0, -1.0),
      (duelDown, 0.0, 1.0),
      (duelRight, 1.0, 0.0),
      (duelLeft, -1.0, 0.0),
    ]) {
      final (x, y) = platform.gameToScreen(v.x, v.y);
      expect(x, closeTo(sx, 1e-12));
      expect(y, closeTo(sy, 1e-12));
    }
  });

  test('uprightAngle stands nose-up art upright on screen', () {
    // Art is nose-up: its "up" is (0, −1). Drawn turned by the angle, it
    // must point up the screen.
    final a = uprightAngle;
    final (gx, gy) = (sin(a), -cos(a));
    expect(gx, closeTo(duelUp.x, 1e-12));
    expect(gy, closeTo(duelUp.y, 1e-12));
  });

  test('duelToGame puts the corners where the player sees them', () {
    final tl = duelToGame(0, 0), br = duelToGame(1, 1);
    final (x0, y0) = platform.gameToScreen(tl.x - config.gameWidth / 2,
        tl.y - config.gameHeight / 2);
    final (x1, y1) = platform.gameToScreen(br.x - config.gameWidth / 2,
        br.y - config.gameHeight / 2);
    expect(x0, lessThan(0));
    expect(y0, lessThan(0));
    expect(x1, greaterThan(0));
    expect(y1, greaterThan(0));
    final (u, v) = gameToDuel(tl.x, tl.y);
    expect(u, closeTo(0, 1e-12));
    expect(v, closeTo(0, 1e-12));
  });

  test('the arena is the field turned: wide and low', () {
    expect(duelWidth, config.gameHeight);
    expect(duelHeight, config.gameWidth);
  });
}

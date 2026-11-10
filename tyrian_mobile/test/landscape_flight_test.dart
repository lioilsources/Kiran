import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/game/platform_config.dart' as platform;

/// Where the landscape camera draws a game-space direction: the world is
/// rendered turned by -[platform.landscapeCameraAngle] (y down).
(double, double) _toScreen(double gx, double gy) {
  const a = -platform.landscapeCameraAngle;
  return (gx * cos(a) - gy * sin(a), gx * sin(a) + gy * cos(a));
}

void main() {
  test('in landscape the ship flies right to left', () {
    // Game UP (forward) is drawn as screen LEFT.
    final (sx, sy) = _toScreen(0, -1);
    expect(sx, closeTo(-1, 1e-9));
    expect(sy, closeTo(0, 1e-9));
  });

  test('a stick pushed left flies forward, down flies to the ship\'s left', () {
    expect(platform.screenToGame(-1, 0, landscape: true), (0, -1));
    expect(platform.screenToGame(0, 1, landscape: true), (-1, 0));
  });

  test('screen → game → screen is the identity for every direction', () {
    for (var k = 0; k < 8; k++) {
      final sx = cos(k * pi / 4), sy = sin(k * pi / 4);
      final (gx, gy) = platform.screenToGame(sx, sy, landscape: true);
      final (bx, by) = _toScreen(gx, gy);
      expect(bx, closeTo(sx, 1e-9), reason: 'k=$k');
      expect(by, closeTo(sy, 1e-9), reason: 'k=$k');
    }
  });

  test('portrait passes input through untouched', () {
    expect(platform.screenToGame(0.3, -0.7, landscape: false), (0.3, -0.7));
  });
}

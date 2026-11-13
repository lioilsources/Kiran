import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/ship_frame.dart';
import 'package:tyrian_mobile/game/duel_space.dart';
import 'package:tyrian_mobile/game/platform_config.dart' as platform;

/// The ship's frame (Prompts/30 §4). Heading 0 is the flight, and there
/// every conversion must hand its input back untouched — that is the whole
/// of the flight's parity with the game before the duel.
void main() {
  test('heading 0 is the identity, bit for bit', () {
    final f = ShipFrame(0);
    expect(f.isIdentity, isTrue);
    for (final (x, y) in const [
      (0.0, -1.0),
      (17.25, 3.5),
      (-0.1, 1e-9),
      (123456.789, -98765.4321),
    ]) {
      expect(f.toWorld(x, y), (x, y));
      expect(f.toShip(x, y), (x, y));
      expect(f.about(300, 800, x, y), (x, y));
    }
    expect((f.fx, f.fy, f.rx, f.ry), (0.0, -1.0, 1.0, 0.0));
  });

  test('toShip undoes toWorld at every heading', () {
    for (var k = 0; k < 16; k++) {
      final f = ShipFrame(k * pi / 8 - pi);
      for (final (x, y) in const [(1.0, 0.0), (0.0, -1.0), (3.0, 4.0)]) {
        final (wx, wy) = f.toWorld(x, y);
        final (bx, by) = f.toShip(wx, wy);
        expect(bx, closeTo(x, 1e-9), reason: 'k=$k');
        expect(by, closeTo(y, 1e-9), reason: 'k=$k');
      }
    }
  });

  test('forward is the heading: headingOf inverts it', () {
    for (var k = 0; k < 16; k++) {
      final h = ShipFrame.wrap(k * pi / 8);
      final f = ShipFrame(h);
      expect(ShipFrame.headingOf(f.fx, f.fy), closeTo(h, 1e-9), reason: 'k=$k');
      // Ship-space forward (0, -1) is the frame's forward.
      final (wx, wy) = f.toWorld(0, -1);
      expect(wx, closeTo(f.fx, 1e-12));
      expect(wy, closeTo(f.fy, 1e-12));
      // Right is forward turned a quarter clockwise (y down).
      expect(f.rx, closeTo(-f.fy, 1e-12));
      expect(f.ry, closeTo(f.fx, 1e-12));
    }
  });

  test('nose up, the ship frame is the screen', () {
    // In a duel with the nose up, a stick pushed anywhere reads in ship
    // space exactly as it reads on screen.
    final f = ShipFrame(uprightAngle);
    for (var k = 0; k < 8; k++) {
      final sx = cos(k * pi / 4), sy = sin(k * pi / 4);
      final (gx, gy) = platform.screenToGame(sx, sy);
      final (lx, ly) = f.toShip(gx, gy);
      expect(lx, closeTo(sx, 1e-9), reason: 'k=$k');
      expect(ly, closeTo(sy, 1e-9), reason: 'k=$k');
    }
  });

  test('turn goes the short way and stops on the target', () {
    expect(ShipFrame.turn(0, 1, 0.25), closeTo(0.25, 1e-12));
    expect(ShipFrame.turn(0, 0.1, 0.25), 0.1);
    // From just below +π to just above −π: across, not all the way round.
    final t = ShipFrame.turn(pi - 0.1, -pi + 0.1, 0.05);
    expect(t, closeTo(pi - 0.05, 1e-12));
  });

  test('about turns a point round the centre it was laid out on', () {
    final f = ShipFrame(pi / 2);
    final (x, y) = f.about(100, 200, 100, 150); // 50 ahead at heading 0
    expect(x, closeTo(150, 1e-9)); // forward at π/2 is +x
    expect(y, closeTo(200, 1e-9));
  });
}

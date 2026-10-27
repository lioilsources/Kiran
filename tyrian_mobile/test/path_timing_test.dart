import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/systems/path_system.dart';

/// Paths are authored at 40fps: `steps = durationSec * 1000 / frameDelay`.
/// Advancing one node per rendered frame therefore made every enemy 1.5x faster
/// at 60Hz and 3x at 120Hz, while the player's weapons stayed timed in seconds.
/// These tests pin that a path now takes the same wall-clock time everywhere.
void main() {
  const durationSec = 12.0;
  final steps = (durationSec * 1000 / config.frameDelay).round();

  PathSystem straight() {
    final p = PathSystem();
    p.generate(steps, 0, 0, 0, 1000, PathType.linear);
    return p;
  }

  /// Seconds of simulated time until the path runs out at [fps].
  double timeToFinish(int fps) {
    final p = straight();
    final dt = 1.0 / fps;
    var t = 0.0;
    while (p.advanceBy(dt * config.originalFps)) {
      t += dt;
      if (t > 120) fail('path never finished at ${fps}fps');
    }
    return t + dt;
  }

  group('path duration is refresh-rate independent', () {
    test('40, 60 and 120 fps all take the authored duration', () {
      for (final fps in [40, 60, 120, 144]) {
        expect(timeToFinish(fps), closeTo(durationSec, 2.0 / fps + 0.05),
            reason: '${fps}fps');
      }
    });

    test('60Hz is no longer 1.5x fast relative to 40Hz', () {
      final ratio = timeToFinish(60) / timeToFinish(40);
      expect(ratio, closeTo(1.0, 0.02));
    });

    test('120Hz is no longer 3x fast', () {
      final ratio = timeToFinish(120) / timeToFinish(40);
      expect(ratio, closeTo(1.0, 0.02));
    });
  });

  group('advanceBy', () {
    test('accumulates fractions instead of dropping them', () {
      final p = straight();
      // Three thirds of a step must move exactly one node, not zero.
      p.advanceBy(1 / 3);
      expect(p.currentIndex, 0);
      p.advanceBy(1 / 3);
      expect(p.currentIndex, 0);
      p.advanceBy(1 / 3);
      expect(p.currentIndex, 1);
    });

    test('a long frame catches up rather than crawling', () {
      final p = straight();
      p.advanceBy(50.0);
      expect(p.currentIndex, 50);
    });

    test('advance() still means exactly one node', () {
      final p = straight();
      p.advance();
      expect(p.currentIndex, 1);
    });

    test('a cycled path wraps keeping the overshoot', () {
      final p = straight();
      p.encycle();
      final n = p.nodes.length;
      expect(p.advanceBy(n + 5.0), isTrue);
      expect(p.currentIndex, 5);
    });
  });

  group('interpolation keeps motion smooth between nodes', () {
    test('a fractional step lands between the two nodes', () {
      final p = straight();
      final a = p.nodes[0], b = p.nodes[1];
      p.advanceBy(0.5);
      final mid = p.interpolated!;
      expect(mid.y, closeTo((a.y + b.y) / 2, 1e-9));
    });

    test('with no fraction pending it is the current node exactly', () {
      final p = straight();
      expect(p.interpolated!.y, p.current!.y);
    });

    test('never overshoots the final node', () {
      final p = straight();
      while (p.advanceBy(1.0)) {}
      expect(p.interpolated, isNull);
    });
  });
}

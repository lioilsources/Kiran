import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/hostile.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/systems/path_system.dart';

void main() {
  group('Hostile.inPlayField', () {
    // A falcon is roughly 50px wide in a 600px-wide field.
    const w = 50.0, h = 50.0;
    final midY = config.gameHeight / 2;

    test('a hostile stranded at the spawn point is out', () {
      // srcX: -50 in sector 4's replacePath fleets — the softlock position.
      expect(Hostile.inPlayField(-50, midY, w, h), isFalse);
      expect(Hostile.inPlayField(config.gameWidth + 5, midY, w, h), isFalse);
    });

    test('sector 4 parked rows count as in-field', () {
      // These sit at x=2 and x=542 — outside the immersive camera window but
      // reachable by flying over. Culling them would delete real formations.
      expect(Hostile.inPlayField(2, midY, w, h), isTrue);
      expect(Hostile.inPlayField(config.gameWidth - 58, midY, w, h), isTrue);
    });

    test('sector 3 bosses parked near the top count as in-field', () {
      expect(Hostile.inPlayField(config.gameWidth / 2, 20, w, h), isTrue);
    });

    test('a box straddling an edge still counts as in-field', () {
      // Only fully-outside boxes may ever be written off.
      expect(Hostile.inPlayField(-w + 1, midY, w, h), isTrue);
      expect(Hostile.inPlayField(-w, midY, w, h), isFalse);
      expect(Hostile.inPlayField(config.gameWidth - 1, midY, w, h), isTrue);
      expect(Hostile.inPlayField(config.gameWidth, midY, w, h), isFalse);
    });

    test('vertical bounds behave the same', () {
      expect(Hostile.inPlayField(300, -h, w, h), isFalse);
      expect(Hostile.inPlayField(300, -h + 1, w, h), isTrue);
      expect(Hostile.inPlayField(300, config.gameHeight, w, h), isFalse);
    });
  });

  group('Hostile.clampAnchor', () {
    test('pulls an off-field anchor back to the edge', () {
      expect(Hostile.clampAnchor(-50, config.gameWidth - 50), 0.0);
      expect(Hostile.clampAnchor(605, config.gameWidth - 50), config.gameWidth - 50);
    });

    test('leaves an in-field anchor untouched', () {
      expect(Hostile.clampAnchor(300, config.gameWidth - 50), 300.0);
      expect(Hostile.clampAnchor(0, config.gameWidth - 50), 0.0);
    });

    test('survives a sprite that has not been laid out yet', () {
      // size is (0,0) before onLoad, so `upper` can go negative.
      expect(Hostile.clampAnchor(300, -10), 0.0);
    });
  });

  group('PathSystem.isComplete — the replacePath arrival predicate', () {
    // The replacePath fix skips fleet members whose own path is still running.
    // These assertions pin the exact property that skip rests on.
    PathSystem straight() {
      final p = PathSystem();
      p.generate(10, 0, 0, 100, 100, PathType.linear);
      return p;
    }

    test('a mid-flight path is not complete', () {
      final p = straight();
      expect(p.isComplete, isFalse);
      p.advance();
      expect(p.isComplete, isFalse);
    });

    test('a path becomes complete exactly when advance fails', () {
      final p = straight();
      while (p.advance()) {}
      expect(p.isComplete, isTrue);
      expect(p.current, isNull);
    });

    test('a cycled path never completes, which is why cycling counts as stranded', () {
      final p = straight();
      p.encycle();
      for (var i = 0; i < p.nodes.length * 3; i++) {
        expect(p.advance(), isTrue);
      }
      expect(p.isComplete, isFalse);
    });
  });
}

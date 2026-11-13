import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/input/keyboard_sigils.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_catalog.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_recognizer.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_spec.dart';

void main() {
  group('keyboard sigils (Prompts/28 §12)', () {
    test('portrait: the numpad is the circle as drawn, 8 forward', () {
      expect(KeyboardSigils.dotFor(LogicalKeyboardKey.numpad8, landscape: false), 1);
      expect(KeyboardSigils.dotFor(LogicalKeyboardKey.numpad6, landscape: false), 5);
      expect(KeyboardSigils.dotFor(LogicalKeyboardKey.numpad1, landscape: false), 6);
      expect(KeyboardSigils.dotFor(LogicalKeyboardKey.numpad5, landscape: false), 4);
    });

    test('landscape: the ship flies left, so 4 is forward', () {
      expect(KeyboardSigils.dotFor(LogicalKeyboardKey.numpad4, landscape: true), 1);
      expect(KeyboardSigils.dotFor(LogicalKeyboardKey.numpad6, landscape: true), 7);
      expect(KeyboardSigils.dotFor(LogicalKeyboardKey.numpad8, landscape: true), 5,
          reason: 'screen up is the ship\'s right');
    });

    test('the letter block mirrors the numpad', () {
      for (final (a, b) in [
        (LogicalKeyboardKey.keyU, LogicalKeyboardKey.numpad7),
        (LogicalKeyboardKey.keyI, LogicalKeyboardKey.numpad8),
        (LogicalKeyboardKey.period, LogicalKeyboardKey.numpad3),
        (LogicalKeyboardKey.keyK, LogicalKeyboardKey.numpad5),
      ]) {
        expect(KeyboardSigils.dotFor(a, landscape: true),
            KeyboardSigils.dotFor(b, landscape: true));
      }
    });

    test('typed dots resolve like a stroke, without a precision', () {
      final r = SigilRecognizer();
      final strike = r.resolveDots(SigilCatalog.forward, SigilLayer.hull);
      expect(strike.spec?.kind, SigilKind.strike);
      expect(strike.keyed, isTrue);
      final circle = r.resolveDots([5, 8, 7, 6, 3, 0, 1, 2], SigilLayer.arms);
      expect(circle.spec?.kind, SigilKind.radial);
      final miss = r.resolveDots([0, 8], SigilLayer.hull);
      expect(miss.cast, isFalse);
    });
  });
}

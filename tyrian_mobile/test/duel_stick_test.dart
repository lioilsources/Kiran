import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/input/duel_stick.dart';
import 'package:tyrian_mobile/input/pad_scheme.dart';

/// The right stick in a duel (Prompts/30 §6.3): it aims; while something
/// is held, it draws — and it only changes role with the stick in the
/// centre.
void main() {
  DuelStickFrame frame(DuelStick s, double x, double y,
          {double rt = 0, double lt = 0, bool arms = false, bool wing = false}) =>
      s.step(x, y, rt: rt, lt: lt, arms: arms, wing: wing);

  group('rtStance', () {
    test('the stick alone aims, and past the fire zone fires', () {
      final s = DuelStick();
      final f = frame(s, 0.9, 0);
      expect(f.role, StickRole.aim);
      expect(f.aimX, closeTo(1, 1e-12));
      expect(f.aimFire, isTrue);
      expect(f.feed, isFalse, reason: 'aiming never feeds the recogniser');
      expect(frame(s, 0.1, 0).aiming, isFalse, reason: 'inside the deadzone');
    });

    test('RT with the stick at rest opens the hull stance: it draws', () {
      final s = DuelStick();
      final f = frame(s, 0, 0, rt: 1);
      expect(f.stanceOpened, isTrue);
      expect(f.role, StickRole.draw);
      expect(frame(s, 0.9, 0, rt: 1).feed, isTrue);
    });

    test('RT with the stick out latches until the stick passes the centre',
        () {
      final s = DuelStick();
      frame(s, 0.9, 0);
      final f = frame(s, 0.9, 0, rt: 1);
      expect(f.role, StickRole.latch);
      expect(f.stanceOpened, isTrue);
      expect(f.aiming, isFalse, reason: 'the nose holds');
      expect(f.feed, isFalse, reason: 'no stroke starts mid-air');
      expect(frame(s, 0, 0, rt: 1).role, StickRole.draw);
    });

    test('a short squeeze while aiming changes nothing', () {
      final s = DuelStick();
      frame(s, 0.9, 0);
      frame(s, 0.9, 0, rt: 1);
      final f = frame(s, 0.9, 0);
      expect(f.role, StickRole.aim);
      expect(f.aiming, isTrue);
    });

    test('LB and RB open the stance without RT', () {
      for (final (arms, wing) in const [(true, false), (false, true)]) {
        final s = DuelStick();
        final f = frame(s, 0, 0, arms: arms, wing: wing);
        expect(f.role, StickRole.draw, reason: 'arms=$arms wing=$wing');
      }
    });

    test('letting go mid-stroke waits for the centre, then aims', () {
      final s = DuelStick();
      frame(s, 0, 0, rt: 1);
      frame(s, 0.9, 0, rt: 1);
      final f = frame(s, 0.9, 0);
      expect(f.role, StickRole.settle);
      expect(f.feed, isFalse, reason: 'the open stroke closes');
      expect(f.aiming, isFalse);
      expect(frame(s, 0, 0).role, StickRole.aim);
      expect(frame(s, 0.9, 0).aiming, isTrue);
    });

    test('the trigger has hysteresis: a light touch does not flicker', () {
      final s = DuelStick();
      expect(frame(s, 0, 0, rt: 0.12).role, StickRole.aim);
      expect(frame(s, 0, 0, rt: 0.16).role, StickRole.draw);
      expect(frame(s, 0, 0, rt: 0.10).role, StickRole.draw);
      expect(frame(s, 0, 0, rt: 0.07).role, StickRole.aim);
    });

    test('both shoulders aim MEGA BLAST, then the stick aims on', () {
      final s = DuelStick();
      final f = frame(s, 0.9, 0, arms: true, wing: true);
      expect(f.role, StickRole.mega);
      expect(f.aiming, isTrue, reason: 'the beam goes where the nose does');
      expect(f.feed, isTrue, reason: 'the caster aims the beam with it');
      expect(f.aimFire, isFalse);
      expect(frame(s, 0.9, 0).role, StickRole.aim);
    });

    test('LT does not open the stance', () {
      final s = DuelStick();
      expect(frame(s, 0, 0, lt: 1).role, StickRole.aim);
    });

    test('aiming fires only when that is on', () {
      final s = DuelStick(aimFires: false);
      final f = frame(s, 0.9, 0);
      expect(f.aiming, isTrue);
      expect(f.aimFire, isFalse);
    });
  });

  group('ltStance', () {
    test('LT opens the hull stance, RT does not', () {
      final s = DuelStick(binding: DuelBinding.ltStance);
      expect(frame(s, 0, 0, rt: 1).role, StickRole.aim);
      expect(frame(s, 0, 0, lt: 0.3).role, StickRole.draw);
    });
  });
}

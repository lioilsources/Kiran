import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/idle_anim.dart';

void main() {
  const dt = 1 / 60;

  Map<IdleFrame, int> run(IdleAnimator a, double seconds, {int? strikeAt}) {
    final counts = {for (final f in IdleFrame.values) f: 0};
    final n = (seconds / dt).round();
    for (var i = 0; i < n; i++) {
      counts[a.step(dt, struck: i == strikeAt)] = counts[a.frame]! + 1;
    }
    return counts;
  }

  test('rests on the open frame most of the time', () {
    final c = run(IdleAnimator(rng: Random(1)), 60);
    final total = c.values.reduce((a, b) => a + b);
    expect(c[IdleFrame.open]! / total, greaterThan(0.85));
  });

  test('blinks and twitches both turn up within a minute', () {
    final c = run(IdleAnimator(rng: Random(2)), 60);
    expect(c[IdleFrame.blink], greaterThan(0));
    expect(c[IdleFrame.twitchL]! + c[IdleFrame.twitchR]!, greaterThan(0));
  });

  test('a non-resting frame is held only for a split second', () {
    final a = IdleAnimator(rng: Random(3));
    var run = 0, longest = 0;
    for (var i = 0; i < 60 * 60; i++) {
      if (a.step(dt) == IdleFrame.open) {
        run = 0;
      } else {
        longest = ++run > longest ? run : longest;
      }
    }
    expect(longest * dt, lessThan(0.2));
  });

  test('a hit flinches at once, whatever the countdown says', () {
    final a = IdleAnimator(rng: Random(4));
    final f = a.step(dt, struck: true);
    expect(f == IdleFrame.twitchL || f == IdleFrame.twitchR, isTrue);
  });
}

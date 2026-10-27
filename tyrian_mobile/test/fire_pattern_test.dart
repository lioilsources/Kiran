import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/hostile.dart';
import 'package:tyrian_mobile/systems/fire_pattern.dart';

/// The pure parts of enemy fire shapes. The tier defaults are what every
/// existing `addWeapon` call silently inherits, so they are pinned here; the
/// aim maths has one invariant that matters in play — a shot keeps its speed
/// and always travels down — and that is pinned too.
void main() {
  test('basic fighters keep the VB6 straight shot', () {
    for (final t in [HostType.falcon1, HostType.falcon2, HostType.falcon3]) {
      expect(FirePattern.defaultFor(t), FirePattern.straight, reason: '$t');
    }
  });

  test('tiers escalate: medium aims, heavies fan, bosses burst', () {
    expect(FirePattern.defaultFor(HostType.falcon5), FirePattern.aimed);
    expect(FirePattern.defaultFor(HostType.falconx), FirePattern.spread);
    expect(FirePattern.defaultFor(HostType.falconx3), FirePattern.burst);
    expect(FirePattern.defaultFor(HostType.falconxt), FirePattern.burst);
  });

  test('volley is never a default — it is an authoring choice', () {
    for (final t in HostType.values) {
      expect(FirePattern.defaultFor(t), isNot(FirePattern.volley), reason: '$t');
    }
  });

  test('an aimed shot keeps its speed', () {
    final (vx, vy) = FirePattern.aim(300, 400, 15);
    expect(sqrt(vx * vx + vy * vy), closeTo(15, 1e-9));
    expect(vx, closeTo(9, 1e-9));
    expect(vy, closeTo(12, 1e-9));
  });

  test('an aimed shot never crawls or climbs when the target is level or above',
      () {
    for (final dy in [0.0, -200.0, 2.0]) {
      final (vx, vy) = FirePattern.aim(100, dy, 15);
      expect(vy, greaterThanOrEqualTo(6.0), reason: 'dy=$dy');
      expect(sqrt(vx * vx + vy * vy), lessThanOrEqualTo(15 + 1e-9),
          reason: 'dy=$dy');
      expect(vx, greaterThan(0), reason: 'still leans toward the target');
    }
  });

  test('a target dead ahead with no offset falls back to straight down', () {
    expect(FirePattern.aim(0, 0, 15), (0.0, 15.0));
  });
}

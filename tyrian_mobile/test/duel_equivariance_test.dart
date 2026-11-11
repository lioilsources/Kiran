import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/entities/projectile.dart';
import 'package:tyrian_mobile/entities/ship_frame.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/device.dart';
import 'package:tyrian_mobile/systems/mods/mod_spec.dart';
import 'package:tyrian_mobile/systems/mods/shot_plan.dart';
import 'package:tyrian_mobile/game/duel_space.dart';
import 'package:tyrian_mobile/game/platform_config.dart' as platform;
import 'package:tyrian_mobile/systems/sigils/sigil_catalog.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_recognizer.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_run.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_spec.dart';
import 'package:tyrian_mobile/systems/sigils/stick_trace.dart';

/// What a ship does at heading h is what it does at heading 0, turned by h
/// (Prompts/30 §13.2). One property for everything with a "forward": a gun
/// written along the y axis by hand breaks it at once.
void main() {
  const ox = 300.0, oy = 520.0;
  const headings = [0.0, pi / 4, pi / 2, pi, -pi / 2, 3 * pi / 2];

  (double, double) rot(double x, double y, double h) =>
      (x * cos(h) - y * sin(h), x * sin(h) + y * cos(h));

  List<Projectile> volley(WeaponSlot slot, ModEffects fx, double heading) {
    final d = Device.fromType(DevType.bubbleGun, slot);
    final world = Component();
    final plan = ShotPlan.of(d, fx);
    d.fire(ox - 20, oy - 24, ox, 40, world,
        plan: plan, frame: ShipFrame(heading), ox: ox, oy: oy);
    return List.of(d.projectiles);
  }

  const shapes = {
    'plain': ModEffects(),
    'fan': ModEffects(fan: 3, fanAngle: 20),
    'streams': ModEffects(streams: 3),
    'crossfire + rearguard': ModEffects(crossfire: true, rearguard: true),
    'hydra': ModEffects(streams: 2, fan: 5, fanAngle: 30),
  };

  for (final slot in const [WeaponSlot.frontGun, WeaponSlot.leftGun, WeaponSlot.rightGun]) {
    for (final e in shapes.entries) {
      test('${slot.name} ${e.key}: the volley turns with the ship', () {
        final base = volley(slot, e.value, 0);
        expect(base, isNotEmpty);
        for (final h in headings) {
          final shots = volley(slot, e.value, h);
          expect(shots.length, base.length, reason: 'h=$h');
          for (var i = 0; i < base.length; i++) {
            final b = base[i], s = shots[i];
            final (px, py) = rot(b.position.x - ox, b.position.y - oy, h);
            // Positions are Float32 (Vector2).
            expect(s.position.x, closeTo(ox + px, 1e-3), reason: 'h=$h shot $i');
            expect(s.position.y, closeTo(oy + py, 1e-3), reason: 'h=$h shot $i');
            final (vx, vy) = rot(b.vx, b.speed, h);
            expect(s.vx, closeTo(vx, 1e-9), reason: 'h=$h shot $i');
            expect(s.speed, closeTo(vy, 1e-9), reason: 'h=$h shot $i');
            expect(s.centred, h != 0, reason: 'a duel shot is centred');
          }
        }
      });
    }
  }

  test('heading 0 fires exactly what the flight always fired', () {
    // Without a frame and with the flight's frame: the same numbers.
    final a = Device.fromType(DevType.bubbleGun, WeaponSlot.leftGun);
    final b = Device.fromType(DevType.bubbleGun, WeaponSlot.leftGun);
    const fx = ModEffects(streams: 2, fan: 3, fanAngle: 18, crossfire: true);
    a.fire(ox - 20, oy - 24, ox, 40, Component(), plan: ShotPlan.of(a, fx));
    b.fire(ox - 20, oy - 24, ox, 40, Component(),
        plan: ShotPlan.of(b, fx), frame: ShipFrame(0), ox: ox, oy: oy);
    expect(a.projectiles.length, b.projectiles.length);
    for (var i = 0; i < a.projectiles.length; i++) {
      final p = a.projectiles[i], q = b.projectiles[i];
      expect(q.position.x, p.position.x);
      expect(q.position.y, p.position.y);
      expect(q.vx, p.vx);
      expect(q.speed, p.speed);
      expect(q.centred, isFalse);
    }
  });

  test('every hull sigil flies its path turned with the ship', () {
    for (final spec in SigilCatalog.all) {
      if (spec.path.isEmpty) continue;
      final run = SigilRun(spec);
      for (var k = 0; k <= 10; k++) {
        final pose = run.poseAt(k / 10);
        for (final h in headings) {
          final (wx, wy) = ShipFrame(h).toWorld(pose.dx, pose.dy);
          final (rx, ry) = rot(pose.dx, pose.dy, h);
          expect(wx, closeTo(rx, 1e-9), reason: '${spec.id} h=$h');
          expect(wy, closeTo(ry, 1e-9), reason: '${spec.id} h=$h');
        }
      }
    }
  });

  /// The thumb's stroke on screen, read the way the game reads it in a duel.
  SigilReading? read(List<StickSample> screen, ShipFrame padFrame) {
    final r = SigilRecognizer();
    SigilReading? out;
    var last = 0.0;
    for (final (t, sx, sy) in screen) {
      final (gx, gy) = platform.screenToGame(sx, sy);
      final (x, y) = padFrame.toShip(gx, gy);
      out ??= r.feed(x, y, t - last == 0 ? 1 / 60 : t - last, SigilLayer.hull);
      last = t;
    }
    return out;
  }

  test('nose frame: the ship goes the way the thumb went (Prompts/30 §6.4)', () {
    final strike = SigilCatalog.of(SigilKind.strike);
    for (var k = 0; k < 8; k++) {
      final h = ShipFrame.wrap(uprightAngle + k * pi / 4);
      final f = ShipFrame(h);
      // The player pushes toward the nose, on screen.
      final screen = [
        for (final (t, x, y) in StickTrace().draw(strike.shape!))
          () {
            final (wx, wy) = f.toWorld(x, y);
            final (sx, sy) = platform.gameToScreen(wx, wy);
            return (t, sx, sy);
          }(),
      ];
      final r = read(screen, f);
      expect(r?.spec?.kind, SigilKind.strike, reason: 'k=$k');
      // The lunge, on screen, is along the thumb's push.
      final pose = SigilRun(strike).poseAt(0.4);
      final (wx, wy) = f.toWorld(pose.dx, pose.dy);
      final (mx, my) = platform.gameToScreen(wx, wy);
      final (px, py) = platform.gameToScreen(f.fx, f.fy);
      final cosA = (mx * px + my * py) / sqrt(mx * mx + my * my);
      expect(cosA, closeTo(1, 1e-9), reason: 'k=$k');
    }
  });

  test('screen-up frame: up on the pad is STRIKE wherever the nose is', () {
    final strike = SigilCatalog.of(SigilKind.strike);
    final up = ShipFrame(uprightAngle);
    final screen = [
      for (final (t, x, y) in StickTrace().draw(strike.shape!))
        () {
          final (wx, wy) = up.toWorld(x, y);
          final (sx, sy) = platform.gameToScreen(wx, wy);
          return (t, sx, sy);
        }(),
    ];
    expect(screen.map((e) => e.$3).reduce(min), lessThan(-0.5),
        reason: 'drawn up the pad');
    expect(read(screen, up)?.spec?.kind, SigilKind.strike);
  });

  group('shots that fly every way', () {
    test('a sideways duel shot lays its box along x', () {
      final p = Projectile(
          damage: 1, imgName: 'missing', position: Vector2(0, 0), speed: 1, vx: 10, centred: true)
        ..refreshSprite();
      expect(p.size.x, greaterThan(p.size.y));
      final q = Projectile(damage: 1, imgName: 'missing', position: Vector2(0, 0), speed: -10, vx: 1)
        ..refreshSprite();
      expect(q.size.y, greaterThan(q.size.x), reason: 'a flight shot stands');
    });

    test('BOUNCE leaves a wall met at a glance, PINBALL any wall', () {
      final p = Projectile(
          damage: 1, imgName: 'missing', position: Vector2(-2, 300), speed: -10, vx: -2, centred: true)
        ..refreshSprite()
        ..bounces = 1;
      p.update(1 / config.originalFps);
      expect(p.vx, 2, reason: 'glancing off the side');
      final head = Projectile(
          damage: 1, imgName: 'missing', position: Vector2(-2, 300), speed: 1, vx: -10, centred: true)
        ..refreshSprite()
        ..bounces = 1;
      head.update(1 / config.originalFps);
      expect(head.vx, -10, reason: 'BOUNCE does not turn a head-on hit');
      final pin = Projectile(
          damage: 1, imgName: 'missing', position: Vector2(-2, 300), speed: 1, vx: -10, centred: true)
        ..refreshSprite()
        ..bounces = 1
        ..bounceTop = true;
      pin.update(1 / config.originalFps);
      expect(pin.vx, 10, reason: 'PINBALL turns anything');
    });

    test('ORBIT weaves across the shot\'s own line', () {
      final p = Projectile(
          damage: 1, imgName: 'missing', position: Vector2(100, 300), speed: 0, vx: 10, centred: true)
        ..refreshSprite()
        ..orbitAmp = 20;
      p.update(1 / 60);
      expect(p.position.y, isNot(300.0), reason: 'across a sideways shot is y');
      expect(p.position.x, closeTo(100 + 10 * config.originalFps / 60, 1e-3));
    });
  });
}

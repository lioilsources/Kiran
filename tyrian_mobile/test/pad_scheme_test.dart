import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/input/gamepad_input.dart';
import 'package:tyrian_mobile/input/pad_scheme.dart';
import 'package:tyrian_mobile/systems/dev_type.dart';
import 'package:tyrian_mobile/systems/device.dart';
import 'package:tyrian_mobile/systems/mods/mod_spec.dart';
import 'package:tyrian_mobile/systems/mods/shot_plan.dart';

void main() {
  group('PadFrame (Prompts/28 §3)', () {
    test('classic is the old pad: B, RB or RT fire, nothing else bound', () {
      for (final gp in const [
        GamepadState(buttonB: true),
        GamepadState(rightShoulder: true),
        GamepadState(rightTrigger: 0.4),
      ]) {
        final f = PadFrame.read(gp, scheme: PadScheme.classic);
        expect(f.fire, gp.fire);
        expect(f.fireRate, gp.fireRate);
        expect(f.arms || f.wing || f.focus || f.breakSigil || f.swap, isFalse);
        expect(f.drawX, 0);
        expect(f.stream, 0);
      }
    });

    test('sigil: only RT fires, with its analog cadence', () {
      expect(PadFrame.read(const GamepadState(buttonB: true)).fire, isFalse);
      expect(PadFrame.read(const GamepadState(rightShoulder: true)).fire, isFalse);
      final f = PadFrame.read(const GamepadState(rightTrigger: 0.3));
      expect(f.fire, isTrue);
      expect(f.fireRate, 0.3);
    });

    test('sigil: shoulders pick the layer, face buttons their actions', () {
      final f = PadFrame.read(const GamepadState(
          leftShoulder: true,
          buttonA: true,
          buttonB: true,
          buttonY: true,
          buttonX: true,
          back: true,
          leftTrigger: 0.9));
      expect(f.arms, isTrue);
      expect(f.wing, isFalse);
      expect(f.focus && f.breakSigil && f.swap && f.grimoireSet && f.grimoire, isTrue);
      expect(f.stream, 0.9);
    });

    test('left stick past its deadzone and the d-pad both fly, capped at 1', () {
      final f = PadFrame.read(const GamepadState(
          leftStickX: 0.9, dpadRight: true, dpadUp: true));
      expect(f.moveX * f.moveX + f.moveY * f.moveY, closeTo(1, 1e-9));
      expect(f.moveY, lessThan(0));
      expect(PadFrame.read(const GamepadState(leftStickX: 0.1)).moveX, 0);
    });

    test('southpaw swaps sticks, triggers and shoulders', () {
      final f = PadFrame.read(
          const GamepadState(
              rightStickX: 1, leftStickY: -0.8, leftTrigger: 0.7, rightShoulder: true),
          southpaw: true);
      expect(f.moveX, closeTo(1, 1e-9));
      expect(f.drawY, -0.8);
      expect(f.fire, isTrue, reason: 'LT fires for a left-hander');
      expect(f.fireRate, 0.7);
      expect(f.arms, isTrue, reason: 'RB is the left hand\'s LB');
    });
  });

  group('OVERSTREAM through ShotPlan.shifted (Prompts/28 §7)', () {
    final gun = Device.fromType(DevType.bubbleGun, WeaponSlot.frontGun);
    final base = ShotPlan.of(gun, ModEffects.none);

    test('gear 1 with nothing shifted is the plan as it was', () {
      final p = base.shifted();
      expect(p.streams, base.streams);
      expect(p.pwrNeed, base.pwrNeed);
      expect(p.cooldown, base.cooldown);
    });

    test('gear 2 and 3 add a stream each and cost more per shot', () {
      final g2 = base.shifted(gear: 2), g3 = base.shifted(gear: 3);
      expect(g2.streams, base.streams + 1);
      expect(g3.streams, base.streams + 2);
      expect(g2.pwrNeed, closeTo(base.pwrNeed * config.overstreamCost[1], 1e-9));
      expect(g3.pwrNeed, closeTo(base.pwrNeed * config.overstreamCost[2], 1e-9));
      // Wider is a little worse per point of power: the cost outruns the streams.
      expect(g3.pwrNeed / g3.streams, greaterThan(base.pwrNeed / base.streams));
    });

    test('streams never pass the cap, whatever the mods', () {
      final fx = ModEffects.combine([
        for (var i = 0; i < 6; i++) ModSpec.byId('triple')!.effects,
      ]);
      final heavy = ShotPlan.of(gun, fx).shifted(gear: 3);
      expect(heavy.streams, lessThanOrEqualTo(ShotPlan.maxStreams));
    });

    test('FRENZY shortens the cooldown, STORM makes the shot free', () {
      final p = base.shifted(cooldownMul: config.frenzyCooldown, pwrMul: 0);
      expect(p.cooldown, closeTo(base.cooldown * config.frenzyCooldown, 1e-12));
      expect(p.pwrNeed, 0);
    });
  });
}

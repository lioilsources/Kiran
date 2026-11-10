import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/game/game_config.dart' as config;
import 'package:tyrian_mobile/systems/sigils/sigil_catalog.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_grid.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_meter.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_run.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_spec.dart';

void main() {
  group('catalogue rules (Prompts/28 §5)', () {
    test('every kind has exactly one spec', () {
      expect(SigilCatalog.all.map((s) => s.kind).toSet(),
          SigilKind.values.toSet());
      expect(SigilCatalog.all, hasLength(SigilKind.values.length));
    });

    test('no two sigils of a layer share a drawing, mirrors included', () {
      for (final layer in SigilLayer.values) {
        final seen = <String, SigilKind>{};
        for (final s in SigilCatalog.inLayer(layer)) {
          final shape = s.shape;
          if (shape == null) continue;
          for (final v in [shape, if (s.mirrorable) SigilGrid.mirrorShape(shape)]) {
            final key = v.join();
            expect(seen[key] == null || seen[key] == s.kind, isTrue,
                reason: '${layer.name}: ${s.id} draws like ${seen[key]?.name}');
            seen[key] = s.kind;
          }
        }
      }
    });

    test('one flick per layer', () {
      for (final layer in SigilLayer.values) {
        expect(SigilCatalog.inLayer(layer).where((s) => s.isFlick), hasLength(1),
            reason: layer.name);
      }
    });

    test('every stroke is stick-natural: rim to its neighbour, or via the centre', () {
      for (final s in SigilCatalog.all) {
        final shape = s.shape;
        if (shape == null) continue;
        expect(shape.first, isNot(4), reason: s.id);
        expect(shape.last, isNot(4), reason: s.id);
        for (var i = 1; i < shape.length; i++) {
          final a = shape[i - 1], b = shape[i];
          expect(a == 4 || b == 4 || SigilGrid.adjacentOnRing(a, b), isTrue,
              reason: '${s.id}: $a→$b is a knight move');
        }
      }
    });

    test('a mirrorable sigil really has a mirror image', () {
      for (final s in SigilCatalog.all.where((s) => s.mirrorable)) {
        final shape = s.shape!;
        final circle = shape.length % 8 == 0 && SigilGrid.isCircle(shape.sublist(0, 8));
        expect(circle || SigilGrid.mirrorShape(shape).join() != shape.join(), isTrue,
            reason: s.id);
      }
    });

    test('untouchable windows stay short (≤ 0.6 s) and inside the run', () {
      for (final s in SigilCatalog.all) {
        final ph = s.phase;
        if (ph == null) continue;
        expect(ph.$1, greaterThanOrEqualTo(0), reason: s.id);
        expect(ph.$2, lessThanOrEqualTo(1), reason: s.id);
        expect((ph.$2 - ph.$1) * s.duration, lessThanOrEqualTo(0.6 + 1e-9),
            reason: s.id);
      }
    });

    test('costs fit the meter; tiers run 1 to 5', () {
      for (final s in SigilCatalog.all) {
        expect(s.cost, inInclusiveRange(0, config.chargeMax.toInt()), reason: s.id);
        expect(s.tier, inInclusiveRange(1, 5), reason: s.id);
      }
      for (final layer in SigilLayer.values) {
        expect(SigilCatalog.inLayer(layer).any((s) => s.tier == 1), isTrue);
      }
    });

    test('hull sigils that take the stick also fly a path', () {
      for (final s in SigilCatalog.inLayer(SigilLayer.hull)) {
        if (s.control == SigilControl.none) {
          expect(s.path.length, greaterThanOrEqualTo(2), reason: s.id);
          expect(s.path.first.t, 0, reason: s.id);
          expect(s.path.last.t, 1, reason: s.id);
        }
      }
    });

    test('fire cues sit inside the run', () {
      for (final s in SigilCatalog.all) {
        for (final c in s.fire) {
          expect(c.t, inInclusiveRange(0, 1), reason: s.id);
          expect(c.shots, greaterThan(0), reason: s.id);
        }
      }
    });

    test('sigil names never collide with mod or hull names', () {
      const taken = {
        'double', 'triple', 'hydra', 'salvo', 'wide', 'crossfire', 'rearguard',
        'orbit', 'rate', 'overdrive', 'heavy', 'crit', 'deadeye', 'pierce',
        'lance', 'homing', 'seeker', 'swift', 'fork', 'chain', 'split',
        'bounce', 'pinball', 'frost', 'bigshot', 'furnace', 'coil', 'reactor',
        'cell', 'surge', 'siphon', 'flux', 'plate', 'aegis', 'regen', 'leech',
        'magnet', 'reflect', 'mirror', 'ghost', 'nova', 'afterburn',
        'scavenger', 'bounty', 'satellite', 'timewarp', 'gambler', 'glass',
        'anchor', 'falcon', 'dart', 'bastion', 'dynamo', 'colossus',
      };
      for (final s in SigilCatalog.all) {
        expect(taken.contains(s.id), isFalse, reason: s.id);
      }
    });
  });

  group('SigilRun', () {
    test('a path starts and ends where its keys say, deterministically', () {
      final run = SigilRun(SigilCatalog.of(SigilKind.strike));
      expect(run.poseAt(0).dy, 0);
      expect(run.poseAt(0.4).dy, closeTo(-220, 1e-9));
      expect(run.poseAt(1).dy, closeTo(0, 1e-9));
      final again = SigilRun(SigilCatalog.of(SigilKind.strike));
      for (var p = 0.0; p <= 1; p += 0.05) {
        expect(again.poseAt(p).dy, run.poseAt(p).dy);
      }
    });

    test('mirrored runs fly the other way', () {
      final s = SigilCatalog.of(SigilKind.sidestep);
      expect(SigilRun(s).poseAt(1).dx, closeTo(240, 1e-9));
      expect(SigilRun(s, mirrored: true).poseAt(1).dx, closeTo(-240, 1e-9));
    });

    test('a hop goes the way it was flicked', () {
      final hop = SigilCatalog.of(SigilKind.hop);
      final right = SigilRun(hop, flickDot: 5).poseAt(1);
      expect(right.dx, closeTo(90, 1e-9));
      expect(right.dy, closeTo(0, 1e-9));
      final back = SigilRun(hop, flickDot: 7).poseAt(1);
      expect(back.dy, closeTo(90, 1e-9));
      final fwdLeft = SigilRun(hop, flickDot: 0).poseAt(1);
      expect(fwdLeft.dx, lessThan(0));
      expect(fwdLeft.dy, lessThan(0));
      expect(fwdLeft.dx * fwdLeft.dx + fwdLeft.dy * fwdLeft.dy,
          closeTo(90 * 90, 1e-6));
    });

    test('the untouchable window opens and closes on time', () {
      final run = SigilRun(SigilCatalog.of(SigilKind.loop));
      final d = run.spec.duration;
      run.advance(d * 0.2);
      expect(run.untouchable, isFalse);
      run.advance(d * 0.1);
      expect(run.untouchable, isTrue);
      run.advance(d * 0.3);
      expect(run.untouchable, isFalse);
    });

    test('each fire cue fires exactly once', () {
      final run = SigilRun(SigilCatalog.of(SigilKind.shadow));
      var fired = 0;
      for (var i = 0; i < 200; i++) {
        run.advance(run.spec.duration / 150);
        fired += run.dueCues().length;
      }
      expect(fired, run.spec.fire.length);
    });
  });

  group('SigilMeter', () {
    test('a full generator surplus pays 12 charge a second', () {
      final m = SigilMeter()..charge = 0;
      // genPower 4 × 40 fps = 160 units a second, all of it surplus.
      for (var i = 0; i < 60; i++) {
        m.addSurplus(160 / 60);
      }
      expect(m.charge, closeTo(12, 1e-9));
    });

    test('charge never passes the cap and never goes negative', () {
      final m = SigilMeter()..charge = 95;
      m.add(20);
      expect(m.charge, config.chargeMax);
      m.charge = 5;
      expect(m.pay(10), isFalse);
      expect(m.charge, 5);
    });

    test('the arena meter pays for anything and never empties', () {
      final m = SigilMeter()
        ..infinite = true
        ..charge = 0;
      expect(m.canPay(70), isTrue);
      expect(m.pay(70), isTrue);
      expect(m.charge, 0);
    });

    test('FLOW grows on variety, not on repeats, and a hull hit ends it', () {
      final m = SigilMeter();
      m.onCast(SigilKind.loop);
      m.onCast(SigilKind.loop);
      expect(m.flow, 1);
      m.onCast(SigilKind.strike);
      m.onCast(SigilKind.hop);
      expect(m.flow, 3);
      m.onCast(SigilKind.strike); // one of the last two
      expect(m.flow, 3);
      m.onCast(SigilKind.loop);
      expect(m.flow, 4);
      expect(m.grade, 'C');
      m.onHullHit();
      expect(m.flow, 0);
      expect(m.grade, '');
    });

    test('FLOW drains one step a second once the window lapses', () {
      final m = SigilMeter();
      for (final k in [SigilKind.hop, SigilKind.loop, SigilKind.strike]) {
        m.onCast(k);
      }
      m.tick(config.flowWindow);
      expect(m.flow, 3);
      m.tick(1.01);
      expect(m.flow, 2);
      m.tick(5, busy: true);
      expect(m.flow, 2);
    });

    test('score multiplier follows FLOW', () {
      final m = SigilMeter()..flow = 9;
      expect(m.scoreMul, closeTo(1.9, 1e-9));
      expect(m.grade, 'S');
    });
  });
}

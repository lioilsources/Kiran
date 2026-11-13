import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_catalog.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_grid.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_recognizer.dart';
import 'package:tyrian_mobile/systems/sigils/sigil_spec.dart';

import 'support/stick_traces.dart';

/// Feed a whole trace; every reading it produced, in order.
List<SigilReading> run(SigilRecognizer r, List<StickSample> trace,
    SigilLayer layer) {
  final out = <SigilReading>[];
  var last = 0.0;
  for (final (t, x, y) in trace) {
    final reading = r.feed(x, y, t - last == 0 ? 1 / 60 : t - last, layer);
    last = t;
    if (reading != null) out.add(reading);
  }
  return out;
}

SigilReading one(List<StickSample> trace, SigilLayer layer) {
  final readings = run(SigilRecognizer(), trace, layer);
  expect(readings, hasLength(1), reason: 'readings: ${[
    for (final r in readings) '${r.spec?.id ?? r.miss?.reason}:${r.drawn}'
  ]}');
  return readings.single;
}

void main() {
  final shaped = SigilCatalog.all.where((s) => !s.isFlick).toList();

  group('every sigil from a clean stroke', () {
    for (final s in shaped) {
      test('${s.layer.name} ${s.id}', () {
        final r = one(StickTrace().draw(s.shape!), s.layer);
        expect(r.spec?.kind, s.kind, reason: 'drawn ${r.drawn}');
        expect(r.mirrored, isFalse);
      });
    }
  });

  group('mirrored strokes cast the mirrored sigil', () {
    for (final s in shaped.where((s) => s.mirrorable)) {
      test('${s.layer.name} ${s.id}', () {
        final r = one(StickTrace().draw(SigilGrid.mirrorShape(s.shape!)), s.layer);
        expect(r.spec?.kind, s.kind, reason: 'drawn ${r.drawn}');
        expect(r.mirrored, isTrue);
      });
    }
  });

  group('shaky thumb (±0.08 noise)', () {
    for (final s in shaped) {
      test('${s.layer.name} ${s.id}', () {
        for (var seed = 1; seed <= 5; seed++) {
          final r = one(StickTrace(jitter: 0.08, seed: seed).draw(s.shape!), s.layer);
          expect(r.spec?.kind, s.kind, reason: 'seed $seed drawn ${r.drawn}');
        }
      });
    }
  });

  test('a stick that does not reach the full rim still draws', () {
    for (final s in shaped) {
      final r = one(StickTrace(reach: 0.8).draw(s.shape!), s.layer);
      expect(r.spec?.kind, s.kind, reason: '${s.id} drawn ${r.drawn}');
    }
  });

  test('slow but inside the time limit', () {
    final r = one(StickTrace(arcStep: 0.06, stroke: 0.12).draw(SigilCatalog.overTop),
        SigilLayer.hull);
    expect(r.spec?.kind, SigilKind.shadow);
  });

  test('a slow pass through the centre ends the gesture there', () {
    final readings = run(SigilRecognizer(),
        StickTrace(stroke: 0.5).draw(SigilCatalog.forward), SigilLayer.hull);
    expect(readings.map((r) => (r.spec?.kind, r.flickDot)),
        [(SigilKind.hop, 7), (SigilKind.hop, 1)]);
  });

  test('too slow is a miss that says so', () {
    final r = one(StickTrace(arcStep: 0.35).draw(SigilCatalog.circle), SigilLayer.hull);
    expect(r.cast, isFalse);
    expect(r.miss?.reason, SigilMiss.tooSlow);
  });

  test('a fast stick that skips sectors on the rim still sweeps them', () {
    // 10 ms per 45°: under one 60 Hz sample per sector.
    final r = one(StickTrace(arcStep: 0.01).draw(SigilCatalog.circle), SigilLayer.hull);
    expect(r.spec?.kind, SigilKind.loop);
  });

  group('a circle begun anywhere, either way round', () {
    for (var start = 0; start < 8; start++) {
      for (final dir in [1, -1]) {
        test('start ${SigilGrid.ring[start]} dir $dir', () {
          final dots = [
            for (var i = 0; i < 8; i++) SigilGrid.ring[(start + dir * i + 8) % 8],
          ];
          final r = one(StickTrace().draw(dots), SigilLayer.hull);
          expect(r.spec?.kind, SigilKind.loop);
          expect(r.mirrored, dir < 0);
        });
      }
    }
  });

  test('a circle overshot by two sectors is still a circle', () {
    final dots = [...SigilGrid.ring, 1, 2];
    expect(one(StickTrace().draw(dots), SigilLayer.arms).spec?.kind,
        SigilKind.radial);
  });

  test('two circles are the double circle', () {
    expect(one(StickTrace().draw(SigilCatalog.doubleCircle), SigilLayer.hull).spec?.kind,
        SigilKind.corkscrew);
    expect(one(StickTrace().draw(SigilCatalog.doubleCircle), SigilLayer.arms).spec?.kind,
        SigilKind.storm);
  });

  test('a half circle overshot by one dot keeps its meaning', () {
    final r = one(StickTrace().draw([...SigilCatalog.overTop, 8]), SigilLayer.hull);
    expect(r.spec?.kind, SigilKind.shadow);
  });

  group('flicks in all eight directions', () {
    for (final d in SigilGrid.ring) {
      test('dot $d', () {
        final r = one(StickTrace().draw([d]), SigilLayer.hull);
        expect(r.spec?.kind, SigilKind.hop);
        expect(r.flickDot, d);
      });
    }
  });

  test('a flick that grazes the next sector keeps the one it dwelt in', () {
    // Out to 2, a brief brush of 1 on the way home.
    final trace = <StickSample>[];
    var t = 0.0;
    void add(double x, double y, int frames) {
      for (var i = 0; i < frames; i++) {
        trace.add((t, x, y));
        t += 1 / 60;
      }
    }
    add(0, 0, 5);
    add(0.72, -0.72, 6); // dot 2, held
    add(0.30, -0.95, 1); // dot 1, one frame
    add(0, 0, 15);
    final r = one(trace, SigilLayer.hull);
    expect(r.spec?.kind, SigilKind.hop);
    expect(r.flickDot, 2);
  });

  test('a stroke nothing longer starts with casts before the stick is home', () {
    final r = SigilRecognizer();
    final trace = StickTrace().draw(SigilCatalog.across);
    SigilReading? got;
    var gotAt = -1;
    var last = 0.0;
    for (var i = 0; i < trace.length; i++) {
      final (t, x, y) = trace[i];
      final reading = r.feed(x, y, t - last, SigilLayer.hull);
      last = t;
      if (reading != null) {
        got = reading;
        gotAt = i;
        break;
      }
    }
    expect(got?.spec?.kind, SigilKind.sidestep);
    final (_, x, y) = trace[gotAt];
    expect(x * x + y * y, greaterThan(0.5), reason: 'still out on the rim');
  });

  test('a cast leaves nothing armed until the stick comes home', () {
    final r = SigilRecognizer();
    final readings = run(r, StickTrace().draw(SigilCatalog.across), SigilLayer.hull);
    expect(readings.map((e) => e.spec?.kind), [SigilKind.sidestep]);
  });

  test('two sigils back to back', () {
    final r = SigilRecognizer();
    final trace = [
      ...StickTrace().draw(SigilCatalog.across, hold: 0.15),
      ...StickTrace().draw([1], hold: 0.15).map((s) => (s.$1 + 2, s.$2, s.$3)),
    ];
    final readings = run(r, trace, SigilLayer.hull);
    expect(readings.map((e) => e.spec?.kind), [SigilKind.sidestep, SigilKind.hop]);
  });

  test('drift near the centre draws nothing', () {
    final trace = [for (var i = 0; i < 120; i++) (i / 60, 0.25, -0.1)];
    expect(run(SigilRecognizer(), trace, SigilLayer.hull), isEmpty);
  });

  test('a wobble short of the rim draws nothing', () {
    final trace = StickTrace(reach: 0.55).draw([5]);
    expect(run(SigilRecognizer(), trace, SigilLayer.hull), isEmpty);
  });

  test('the layer is the one held as the stick left the centre', () {
    final r = SigilRecognizer();
    final trace = StickTrace().draw(SigilCatalog.forward);
    final out = <SigilReading>[];
    var last = 0.0;
    for (var i = 0; i < trace.length; i++) {
      final (t, x, y) = trace[i];
      // LB held at the start only, released mid-stroke.
      final layer = i < 8 ? SigilLayer.arms : SigilLayer.hull;
      final reading = r.feed(x, y, t - last, layer);
      last = t;
      if (reading != null) out.add(reading);
    }
    expect(out.single.spec?.kind, SigilKind.volley);
  });

  group('misses say why', () {
    test('a hull-only shape drawn with LB held is the wrong layer', () {
      final r = one(StickTrace().draw(SigilCatalog.zed), SigilLayer.arms);
      expect(r.cast, isFalse);
      expect(r.miss?.reason, SigilMiss.wrongLayer);
      expect(r.miss?.nearest?.kind, SigilKind.slalom);
    });

    test('a stroke that stops short of a longer sigil left the rim early', () {
      final r = one(StickTrace().draw([0, 1, 2, 4, 6]), SigilLayer.hull);
      expect(r.miss?.reason, SigilMiss.leftRimEarly);
      expect(r.miss?.nearest?.kind, SigilKind.slalom);
    });

    test('a known sigil drawn backwards', () {
      final r = SigilRecognizer().diagnose([2, 4, 6], SigilLayer.hull);
      expect(r.reason, SigilMiss.wrongDirection);
    });

    test('a shape with one dot missing', () {
      final r = SigilRecognizer().diagnose([0, 1, 2, 6, 7, 8], SigilLayer.hull);
      expect(r.reason, SigilMiss.skippedDot);
      expect(r.nearest?.kind, SigilKind.slalom);
      expect(r.firstMismatchAt, 3);
    });
  });

  test('only unlocked sigils are recognised', () {
    final r = SigilRecognizer(
        SigilCatalog.all.where((s) => s.kind != SigilKind.loop));
    final readings = run(r, StickTrace().draw(SigilCatalog.circle), SigilLayer.hull);
    expect(readings.single.cast, isFalse);
  });
  group('precision (what you drew, how well)', () {
    test('a clean stroke scores near 100 %', () {
      for (final s in shaped) {
        final r = one(StickTrace().draw(s.shape!), s.layer);
        expect(r.accuracy, greaterThan(0.9), reason: '${s.id}: ${r.accuracy}');
        expect(r.trail, isNotEmpty);
        expect(r.ideal, isNotEmpty);
      }
    });

    test('a shaky stroke scores lower than a clean one', () {
      final clean = one(StickTrace().draw(SigilCatalog.overTop), SigilLayer.hull);
      final shaky = one(StickTrace(jitter: 0.15, seed: 3).draw(SigilCatalog.overTop),
          SigilLayer.hull);
      expect(shaky.spec?.kind, SigilKind.shadow);
      expect(shaky.accuracy, lessThan(clean.accuracy - 0.1));
    });

    test('a short-reaching stick is judged on its shape, not its travel', () {
      final r = one(StickTrace(reach: 0.8).draw(SigilCatalog.circle), SigilLayer.hull);
      expect(r.accuracy, greaterThan(0.85));
    });

    test('a miss still shows the line it should have been', () {
      final r = one(StickTrace().draw([0, 1, 2, 4, 6]), SigilLayer.hull);
      expect(r.cast, isFalse);
      expect(r.ideal, SigilCatalog.zed);
      expect(r.accuracy, inExclusiveRange(0, 1));
    });

    test('a circle is judged from where it began, the way it went', () {
      final dots = [for (var i = 0; i < 8; i++) SigilGrid.ring[(5 - i + 8) % 8]];
      final r = one(StickTrace().draw(dots), SigilLayer.hull);
      expect(r.ideal, dots);
      expect(r.accuracy, greaterThan(0.9));
    });
  });
}

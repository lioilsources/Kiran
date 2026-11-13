import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/net/protocol.dart';

Uint8List frameWith({List<SigilSnap> sigils = const []}) => encodeGameSnapshot(
      gameState: 1,
      sectorIndex: 3,
      elapsed: 1.5,
      v1Data: List.filled(6, 0.0),
      v1Ints: List.filled(7, 0),
      v2Data: List.filled(6, 0.0),
      v2Ints: List.filled(7, 0),
      hostiles: const [],
      enemyProjs: const [],
      playerProjs: const [],
      collectables: const [],
      beams: const [],
      structures: const [],
      sigils: sigils,
    );

void main() {
  const host = SigilSnap(
    enabled: true,
    untouchable: true,
    focus: true,
    megaCharging: false,
    poseScale: 1.35,
    poseRoll: -0.75,
    gear: 3,
    flow: 7,
    charge: 64,
    megaProgress: 0.5,
    effects: [1, 0, 0.5, 0, 0.25, 0],
    companions: [(1, 120.5, 600.25, false), (3, 300, 540, true)],
    echo: (200, 610),
    caltrops: [(250, 700)],
    beam: (300, 640, 0.3, 120),
  );

  test('a ship\'s sigil look survives the wire (Prompts/28 §13)', () {
    final frame = frameWith(sigils: [host, SigilSnap.none]);
    final snap = decodeGameSnapshot(frame.sublist(5));
    final s = snap.sigils1;
    expect(s.enabled && s.untouchable && s.focus, isTrue);
    expect(s.megaCharging, isFalse);
    expect(s.poseScale, closeTo(1.35, 0.01));
    expect(s.poseRoll, closeTo(-0.75, 0.001));
    expect([s.gear, s.flow, s.charge], [3, 7, 64]);
    expect(s.megaProgress, closeTo(0.5, 0.01));
    expect(s.effects[0], closeTo(1, 0.01));
    expect(s.effects[2], closeTo(0.5, 0.01));
    expect(s.companions, hasLength(2));
    expect(s.companions[0].$1, 1);
    expect(s.companions[0].$2, closeTo(120.5, 0.01));
    expect(s.companions[1].$4, isTrue);
    expect(s.echo!.$1, closeTo(200, 0.01));
    expect(s.caltrops.single.$2, closeTo(700, 0.01));
    expect(s.beam!.$3, closeTo(0.3, 0.001));
    expect(s.beam!.$4, 120);
    expect(snap.sigils2.enabled, isFalse);
  });

  test('a host without sigils sends no tail, and the client reads none', () {
    final frame = frameWith();
    final snap = decodeGameSnapshot(frame.sublist(5));
    expect(snap.sigils1.enabled, isFalse);
    expect(snap.sectorIndex, 3);
  });

  test('the tail rides after the structures: an older reader stops before it', () {
    final without = frameWith().length;
    final withTail = frameWith(sigils: [host, SigilSnap.none]).length;
    expect(withTail - without, 1 + 2 * SigilSnap.size);
  });
}

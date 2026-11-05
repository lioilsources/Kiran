import 'package:flutter_test/flutter_test.dart';
import 'package:tyrian_mobile/net/protocol.dart';

void main() {
  test('player shots keep their sprite and gun slot across the wire', () {
    final frame = encodeGameSnapshot(
      gameState: 1,
      sectorIndex: 0,
      elapsed: 0,
      v1Data: List.filled(6, 0.0),
      v1Ints: List.filled(7, 0),
      v2Data: List.filled(6, 0.0),
      v2Ints: List.filled(7, 0),
      hostiles: const [],
      enemyProjs: [ProjSnap(x: 1, y: 2, sizeX: 3, sizeY: 4, speed: 5)],
      playerProjs: [
        ProjSnap(x: 10, y: 20, sizeX: 7, sizeY: 18, speed: -30,
            img: projSnapImgs.indexOf('laser'), side: true),
        ProjSnap(x: 11, y: 21, sizeX: 18, sizeY: 18, speed: -30,
            img: projSnapImgs.indexOf('starg')),
      ],
      collectables: const [],
      beams: const [],
    );
    final snap = decodeGameSnapshot(frame.sublist(5));

    expect(snap.enemyProjectiles.single.x, 1);
    final shots = snap.playerProjectiles;
    expect(shots, hasLength(2));
    expect(projSnapImgs[shots[0].img], 'laser');
    expect(shots[0].side, isTrue);
    expect(shots[0].sizeY, 18);
    expect(projSnapImgs[shots[1].img], 'starg');
    expect(shots[1].side, isFalse);
  });

  test('each ship carries its hull across the wire (protocol 4)', () {
    expect(protocolVersion, 4);
    final frame = encodeGameSnapshot(
      gameState: 1,
      sectorIndex: 0,
      elapsed: 0,
      v1Data: List.filled(6, 0.0),
      v1Ints: [1, 2, 3, 4, 0, 0, 1, 4],
      v2Data: List.filled(6, 0.0),
      v2Ints: List.filled(7, 0),
      hostiles: const [],
      enemyProjs: const [],
      playerProjs: const [],
      collectables: const [],
      beams: const [],
    );
    final snap = decodeGameSnapshot(frame.sublist(5));
    expect(snap.vessel1.hull, 4);
    expect(snap.vessel1.hp, 1);
    expect(snap.vessel1.visible, isTrue);
    expect(snap.vessel2.hull, 0, reason: 'no hull field reads as the stock hull');
  });
}

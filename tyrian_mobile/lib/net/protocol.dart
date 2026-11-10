import 'dart:typed_data';

/// Message type IDs for co-op protocol
class MsgType {
  static const int clientInput = 0x01;
  static const int gameStateSnapshot = 0x02;
  static const int gameEvent = 0x03;
  static const int lobbyHandshake = 0x04;
  static const int shopAction = 0x05;
  static const int shopState = 0x06;
  static const int readySignal = 0x07;
}

/// Game event sub-types
class EventType {
  static const int explosion = 1;
  static const int message = 2;
  static const int sectorComplete = 3;
  static const int gameOver = 4;
  static const int paused = 5;
  static const int resumed = 6;
  static const int gameStart = 7;
  static const int playerJoined = 8;
}

/// Shop action sub-types
class ShopActionType {
  static const int buy = 1;
  static const int sell = 2;
  static const int upgrade = 3;
}

// ---- Frame-delimited TCP helpers ----
// Wire format: [4B length (big-endian)][1B type][payload]

/// Build a framed message from type + payload bytes
Uint8List frameMessage(int type, Uint8List payload) {
  final length = 1 + payload.length; // type byte + payload
  final frame = Uint8List(4 + length);
  final bd = ByteData.sublistView(frame);
  bd.setUint32(0, length, Endian.big);
  frame[4] = type;
  frame.setRange(5, 5 + payload.length, payload);
  return frame;
}

/// Accumulates incoming TCP bytes and extracts complete framed messages.
class MessageFramer {
  final _buffer = BytesBuilder(copy: false);
  int _bufferedLength = 0;

  /// Add incoming data. Returns list of (type, payload) tuples.
  List<(int, Uint8List)> addData(Uint8List data) {
    _buffer.add(data);
    _bufferedLength += data.length;

    final messages = <(int, Uint8List)>[];
    while (_bufferedLength >= 4) {
      final bytes = _buffer.takeBytes();
      _bufferedLength = 0;

      final bd = ByteData.sublistView(bytes);
      final length = bd.getUint32(0, Endian.big);

      if (bytes.length < 4 + length) {
        // Incomplete message — put back
        _buffer.add(bytes);
        _bufferedLength = bytes.length;
        break;
      }

      final type = bytes[4];
      final payload = Uint8List.sublistView(bytes, 5, 4 + length);
      messages.add((type, payload));

      // Put remainder back
      if (bytes.length > 4 + length) {
        final remainder = Uint8List.sublistView(bytes, 4 + length);
        _buffer.add(remainder);
        _bufferedLength = remainder.length;
      }
    }
    return messages;
  }
}

// ---- ClientInput (0x01) ----
// dx: float64, dy: float64, fire: uint8 = 17 bytes

Uint8List encodeClientInput(double dx, double dy, bool fire) {
  final payload = Uint8List(17);
  final bd = ByteData.sublistView(payload);
  bd.setFloat64(0, dx, Endian.big);
  bd.setFloat64(8, dy, Endian.big);
  payload[16] = fire ? 1 : 0;
  return frameMessage(MsgType.clientInput, payload);
}

({double dx, double dy, bool fire}) decodeClientInput(Uint8List payload) {
  final bd = ByteData.sublistView(payload);
  return (
    dx: bd.getFloat64(0, Endian.big),
    dy: bd.getFloat64(8, Endian.big),
    fire: payload[16] != 0,
  );
}

// ---- LobbyHandshake (0x04) ----
// protocolVersion: uint8, pilotName: UTF-8 string (rest of payload)

// v2: the 18-part sector table (v2.4.0) renumbered sector indices — a v1
// client would mirror the wrong sector content, so the versions must not pair.
// v3: player shots carry their sprite and gun slot (2 more bytes each).
const int protocolVersion = 4;

Uint8List encodeLobbyHandshake(String pilotName) {
  final nameBytes = Uint8List.fromList(pilotName.codeUnits);
  final payload = Uint8List(1 + nameBytes.length);
  payload[0] = protocolVersion;
  payload.setRange(1, payload.length, nameBytes);
  return frameMessage(MsgType.lobbyHandshake, payload);
}

({int version, String pilotName}) decodeLobbyHandshake(Uint8List payload) {
  return (
    version: payload[0],
    pilotName: String.fromCharCodes(payload, 1),
  );
}

// ---- ReadySignal (0x07) ----

Uint8List encodeReadySignal() {
  return frameMessage(MsgType.readySignal, Uint8List(0));
}

// ---- GameEvent (0x03) ----
// type: uint8, then variable data

Uint8List encodeGameEvent(int eventType, {double x = 0, double y = 0, String text = ''}) {
  final textBytes = Uint8List.fromList(text.codeUnits);
  final payload = Uint8List(1 + 16 + textBytes.length);
  final bd = ByteData.sublistView(payload);
  payload[0] = eventType;
  bd.setFloat64(1, x, Endian.big);
  bd.setFloat64(9, y, Endian.big);
  payload.setRange(17, 17 + textBytes.length, textBytes);
  return frameMessage(MsgType.gameEvent, payload);
}

({int eventType, double x, double y, String text}) decodeGameEvent(Uint8List payload) {
  final bd = ByteData.sublistView(payload);
  return (
    eventType: payload[0],
    x: bd.getFloat64(1, Endian.big),
    y: bd.getFloat64(9, Endian.big),
    text: String.fromCharCodes(payload, 17),
  );
}

// ---- ShopAction (0x05) ----
// action: uint8, weaponName: UTF-8 string, slot: uint8

Uint8List encodeShopAction(int action, String weaponName, int slot) {
  final nameBytes = Uint8List.fromList(weaponName.codeUnits);
  final payload = Uint8List(2 + nameBytes.length);
  payload[0] = action;
  payload[1] = slot;
  payload.setRange(2, payload.length, nameBytes);
  return frameMessage(MsgType.shopAction, payload);
}

({int action, int slot, String weaponName}) decodeShopAction(Uint8List payload) {
  return (
    action: payload[0],
    slot: payload[1],
    weaponName: String.fromCharCodes(payload, 2),
  );
}

// ---- GameStateSnapshot (0x02) ----
// Variable-length binary snapshot of entire game state.
// Format:
//   gameState: uint8
//   sectorIndex: uint16
//   elapsed: float64
//   vessel1 data (VesselSnap)
//   vessel2 data (VesselSnap)
//   hostileCount: uint16, then hostile data[]
//   enemyProjCount: uint16, then proj data[]
//   playerProjCount: uint16, then proj data[]
//   collectableCount: uint16, then collectable data[]
//   beamCount: uint16, then beam data[]

// VesselSnap: x,y: float64 each, hp,hpMax: int32 each, shield,shieldMax: float64,
//   gen,genMax: float64, score,credit: int32, fire: uint8, dmgTaken: uint8, visible: uint8,
//   hull: uint8 (index into kHulls, protocol 4)
// = 8+8+4+4+8+8+8+8+4+4+1+1+1+1 = 68 bytes

const int _vesselSnapSize = 68;

Uint8List _encodeVesselSnap(ByteData bd, int offset,
    double x, double y, int hp, int hpMax, double shield, double shieldMax,
    double gen, double genMax, int score, int credit, bool fire, int dmgTaken, bool visible,
    [int hull = 0]) {
  bd.setFloat64(offset, x, Endian.big);
  bd.setFloat64(offset + 8, y, Endian.big);
  bd.setInt32(offset + 16, hp, Endian.big);
  bd.setInt32(offset + 20, hpMax, Endian.big);
  bd.setFloat64(offset + 24, shield, Endian.big);
  bd.setFloat64(offset + 32, shieldMax, Endian.big);
  bd.setFloat64(offset + 40, gen, Endian.big);
  bd.setFloat64(offset + 48, genMax, Endian.big);
  bd.setInt32(offset + 56, score, Endian.big);
  bd.setInt32(offset + 60, credit, Endian.big);
  // fire, dmgTaken, visible at offset+64,65,66
  final bytes = bd.buffer.asUint8List(bd.offsetInBytes, bd.lengthInBytes);
  bytes[offset + 64] = fire ? 1 : 0;
  bytes[offset + 65] = dmgTaken.clamp(0, 255);
  bytes[offset + 66] = visible ? 1 : 0;
  bytes[offset + 67] = hull.clamp(0, 255);
  return bytes;
}

/// Decoded vessel snapshot
class VesselSnap {
  final double x, y;
  final int hp, hpMax;
  final double shield, shieldMax;
  final double gen, genMax;
  final int score, credit;
  final bool fire;
  final int dmgTaken;
  final bool visible;

  /// Index into kHulls of the hull this ship flies.
  final int hull;

  VesselSnap({
    required this.x, required this.y,
    required this.hp, required this.hpMax,
    required this.shield, required this.shieldMax,
    required this.gen, required this.genMax,
    required this.score, required this.credit,
    required this.fire, required this.dmgTaken,
    required this.visible,
    this.hull = 0,
  });
}

VesselSnap _decodeVesselSnap(ByteData bd, int offset) {
  return VesselSnap(
    x: bd.getFloat64(offset, Endian.big),
    y: bd.getFloat64(offset + 8, Endian.big),
    hp: bd.getInt32(offset + 16, Endian.big),
    hpMax: bd.getInt32(offset + 20, Endian.big),
    shield: bd.getFloat64(offset + 24, Endian.big),
    shieldMax: bd.getFloat64(offset + 32, Endian.big),
    gen: bd.getFloat64(offset + 40, Endian.big),
    genMax: bd.getFloat64(offset + 48, Endian.big),
    score: bd.getInt32(offset + 56, Endian.big),
    credit: bd.getInt32(offset + 60, Endian.big),
    fire: bd.buffer.asUint8List()[bd.offsetInBytes + offset + 64] != 0,
    dmgTaken: bd.buffer.asUint8List()[bd.offsetInBytes + offset + 65],
    visible: bd.buffer.asUint8List()[bd.offsetInBytes + offset + 66] != 0,
    hull: bd.buffer.asUint8List()[bd.offsetInBytes + offset + 67],
  );
}

// HostileSnap: fleetId: uint16, hostileId: uint16, x,y: float64, hp: int32,
//   hit: uint8, sizeX,sizeY: float32, hostType: uint8 = 2+2+8+8+4+1+4+4+1 = 34 bytes
const int _hostileSnapSize = 34;

class HostileSnap {
  final int fleetId, hostileId;
  final double x, y;
  final int hp;
  final int hit;
  final double sizeX, sizeY;
  final int hostType;

  HostileSnap({
    required this.fleetId, required this.hostileId,
    required this.x, required this.y,
    required this.hp, required this.hit,
    required this.sizeX, required this.sizeY,
    required this.hostType,
  });
}

// ProjSnap: x,y: float64, sizeX,sizeY: float32, speed: float32 = 8+8+4+4+4 = 28 bytes
const int _projSnapSize = 28;
// Player shots add img: uint8 (index into [projSnapImgs]), side: uint8 —
// the client draws the right sprite at the right size instead of a bubble.
const int _playerProjSnapSize = _projSnapSize + 2;

/// Sprite names a player shot can carry over the wire, by index.
const List<String> projSnapImgs = ['bubble', 'vulcan', 'blaster', 'laser', 'starg'];

class ProjSnap {
  final double x, y;
  final double sizeX, sizeY;
  final double speed;
  final int img; // index into projSnapImgs; player shots only
  final bool side; // fired by a side gun; player shots only

  ProjSnap({
    required this.x, required this.y,
    required this.sizeX, required this.sizeY,
    required this.speed,
    this.img = 0,
    this.side = false,
  });
}

// CollSnap: x,y: float64, type: uint8 = 8+8+1 = 17 bytes
const int _collSnapSize = 17;

class CollSnap {
  final double x, y;
  final int type;

  CollSnap({required this.x, required this.y, required this.type});
}

// BeamSnap: sx,sy,dx,dy: float64 each, active: uint8 = 8*4+1 = 33 bytes
const int _beamSnapSize = 33;

class BeamSnap {
  final double sx, sy, dx, dy;
  final bool active;

  BeamSnap({
    required this.sx, required this.sy,
    required this.dx, required this.dy,
    required this.active,
  });
}

// StructSnap: id(uint16) + x,y(float64) + sizeX,sizeY(float32) + hp(int32) + hit(uint8)
//   + structType(uint8) + imgNameLen(uint8) + imgName(variable)
// Fixed part = 2+8+8+4+4+4+1+1+1 = 33 bytes + imgName bytes

class StructSnap {
  final int id;
  final double x, y;
  final double sizeX, sizeY;
  final int hp;
  final int hit;
  final int structType;
  final String imgName;

  StructSnap({
    required this.id,
    required this.x, required this.y,
    required this.sizeX, required this.sizeY,
    required this.hp, required this.hit,
    required this.structType, required this.imgName,
  });
}

/// What a ship's sigils look like this frame (Prompts/28 §13), for the
/// co-op client to draw. Only the look travels: the host runs the sigils.
///
/// Rides as an optional tail after the structures, one block per vessel, so
/// an older client stops reading before it and plays on without the
/// effects — the protocol version did not have to move.
class SigilSnap {
  final bool enabled, untouchable, focus, megaCharging;
  final double poseScale, poseRoll;
  final int gear, flow, charge;
  final double megaProgress;

  /// Remaining share 0..1 of FRENZY, STASIS, HALO, STORM, ECHO, WHIRL.
  final List<double> effects;

  /// Up to two companions: role 1..3 (wingman, hunter, warden), position,
  /// and whether it is catching shots.
  final List<(int role, double x, double y, bool absorbs)> companions;
  final (double, double)? echo;
  final List<(double, double)> caltrops;

  /// The MEGA BLAST beam while it is drawn: origin, angle, width.
  final (double x, double y, double angle, double width)? beam;

  const SigilSnap({
    this.enabled = false,
    this.untouchable = false,
    this.focus = false,
    this.megaCharging = false,
    this.poseScale = 1,
    this.poseRoll = 0,
    this.gear = 1,
    this.flow = 0,
    this.charge = 0,
    this.megaProgress = 0,
    this.effects = const [0, 0, 0, 0, 0, 0],
    this.companions = const [],
    this.echo,
    this.caltrops = const [],
    this.beam,
  });

  static const size = 72;
  static const none = SigilSnap();

  void encode(ByteData bd, int off) {
    final b = bd.buffer.asUint8List(bd.offsetInBytes, bd.lengthInBytes);
    b[off] = (enabled ? 1 : 0) |
        (untouchable ? 2 : 0) |
        (focus ? 4 : 0) |
        (megaCharging ? 8 : 0) |
        (beam != null ? 16 : 0) |
        (echo != null ? 32 : 0);
    b[off + 1] = (poseScale * 100).round().clamp(0, 255);
    bd.setInt16(off + 2, (poseRoll * 1000).round().clamp(-32768, 32767), Endian.big);
    b[off + 4] = gear.clamp(0, 255);
    b[off + 5] = flow.clamp(0, 255);
    b[off + 6] = charge.clamp(0, 255);
    b[off + 7] = (megaProgress * 255).round().clamp(0, 255);
    for (var i = 0; i < 6; i++) {
      b[off + 8 + i] = ((i < effects.length ? effects[i] : 0) * 255).round().clamp(0, 255);
    }
    for (var i = 0; i < 2; i++) {
      final o = off + 14 + i * 10;
      if (i < companions.length) {
        final c = companions[i];
        b[o] = c.$1.clamp(0, 255);
        bd.setFloat32(o + 1, c.$2, Endian.big);
        bd.setFloat32(o + 5, c.$3, Endian.big);
        b[o + 9] = c.$4 ? 1 : 0;
      } else {
        b[o] = 0;
      }
    }
    bd.setFloat32(off + 34, echo?.$1 ?? 0, Endian.big);
    bd.setFloat32(off + 38, echo?.$2 ?? 0, Endian.big);
    b[off + 42] = caltrops.length.clamp(0, 2);
    for (var i = 0; i < 2; i++) {
      final m = i < caltrops.length ? caltrops[i] : (0.0, 0.0);
      bd.setFloat32(off + 43 + i * 8, m.$1, Endian.big);
      bd.setFloat32(off + 47 + i * 8, m.$2, Endian.big);
    }
    final bm = beam ?? (0.0, 0.0, 0.0, 0.0);
    bd.setFloat32(off + 59, bm.$1, Endian.big);
    bd.setFloat32(off + 63, bm.$2, Endian.big);
    bd.setInt16(off + 67, (bm.$3 * 10000).round().clamp(-32768, 32767), Endian.big);
    b[off + 69] = bm.$4.round().clamp(0, 255);
  }

  static SigilSnap decode(ByteData bd, int off) {
    final b = bd.buffer.asUint8List(bd.offsetInBytes, bd.lengthInBytes);
    final f = b[off];
    final comps = <(int, double, double, bool)>[];
    for (var i = 0; i < 2; i++) {
      final o = off + 14 + i * 10;
      if (b[o] == 0) continue;
      comps.add((b[o], bd.getFloat32(o + 1, Endian.big),
          bd.getFloat32(o + 5, Endian.big), b[o + 9] != 0));
    }
    final n = b[off + 42].clamp(0, 2);
    return SigilSnap(
      enabled: f & 1 != 0,
      untouchable: f & 2 != 0,
      focus: f & 4 != 0,
      megaCharging: f & 8 != 0,
      poseScale: b[off + 1] / 100,
      poseRoll: bd.getInt16(off + 2, Endian.big) / 1000,
      gear: b[off + 4],
      flow: b[off + 5],
      charge: b[off + 6],
      megaProgress: b[off + 7] / 255,
      effects: [for (var i = 0; i < 6; i++) b[off + 8 + i] / 255],
      companions: comps,
      echo: f & 32 != 0
          ? (bd.getFloat32(off + 34, Endian.big), bd.getFloat32(off + 38, Endian.big))
          : null,
      caltrops: [
        for (var i = 0; i < n; i++)
          (bd.getFloat32(off + 43 + i * 8, Endian.big),
              bd.getFloat32(off + 47 + i * 8, Endian.big)),
      ],
      beam: f & 16 != 0
          ? (
              bd.getFloat32(off + 59, Endian.big),
              bd.getFloat32(off + 63, Endian.big),
              bd.getInt16(off + 67, Endian.big) / 10000,
              b[off + 69].toDouble(),
            )
          : null,
    );
  }
}

/// Full game state snapshot (decoded)
class GameSnapshot {
  final int gameState;
  final int sectorIndex;
  final double elapsed;
  final VesselSnap vessel1;
  final VesselSnap vessel2;
  final List<HostileSnap> hostiles;
  final List<ProjSnap> enemyProjectiles;
  final List<ProjSnap> playerProjectiles;
  final List<CollSnap> collectables;
  final List<BeamSnap> beams;
  final List<StructSnap> structures;

  /// The two ships' sigil looks; [SigilSnap.none] from an older host.
  final SigilSnap sigils1, sigils2;

  GameSnapshot({
    required this.gameState,
    required this.sectorIndex,
    required this.elapsed,
    required this.vessel1,
    required this.vessel2,
    required this.hostiles,
    required this.enemyProjectiles,
    required this.playerProjectiles,
    required this.collectables,
    required this.beams,
    required this.structures,
    this.sigils1 = SigilSnap.none,
    this.sigils2 = SigilSnap.none,
  });
}

/// Encode a full game snapshot into a framed message.
/// Takes raw data lists to avoid importing game types.
Uint8List encodeGameSnapshot({
  required int gameState,
  required int sectorIndex,
  required double elapsed,
  required List<double> v1Data, // [x,y,shield,shieldMax,gen,genMax] + ints packed
  required List<int> v1Ints, // [hp,hpMax,score,credit,fire(0/1),dmgTaken,visible(0/1)]
  required List<double> v2Data,
  required List<int> v2Ints,
  required List<HostileSnap> hostiles,
  required List<ProjSnap> enemyProjs,
  required List<ProjSnap> playerProjs,
  required List<CollSnap> collectables,
  required List<BeamSnap> beams,
  List<StructSnap> structures = const [],
  List<SigilSnap> sigils = const [],
}) {
  final headerSize = 11 + 2 * _vesselSnapSize;
  final hostileSize = 2 + hostiles.length * _hostileSnapSize;
  final enemyProjSize = 2 + enemyProjs.length * _projSnapSize;
  final playerProjSize = 2 + playerProjs.length * _playerProjSnapSize;
  final collSize = 2 + collectables.length * _collSnapSize;
  final beamSize = 2 + beams.length * _beamSnapSize;
  // Structures: count(2) + per-struct(33 fixed + variable imgName)
  int structSize = 2;
  for (final s in structures) {
    structSize += 33 + s.imgName.codeUnits.length;
  }

  final sigilSize = sigils.isEmpty ? 0 : 1 + sigils.length * SigilSnap.size;
  final totalSize = headerSize + hostileSize + enemyProjSize + playerProjSize +
      collSize + beamSize + structSize + sigilSize;
  final payload = Uint8List(totalSize);
  final bd = ByteData.sublistView(payload);
  int off = 0;

  // Header
  payload[off] = gameState; off += 1;
  bd.setUint16(off, sectorIndex, Endian.big); off += 2;
  bd.setFloat64(off, elapsed, Endian.big); off += 8;

  // Vessel 1
  _encodeVesselSnap(bd, off,
      v1Data[0], v1Data[1], v1Ints[0], v1Ints[1],
      v1Data[2], v1Data[3], v1Data[4], v1Data[5],
      v1Ints[2], v1Ints[3], v1Ints[4] != 0, v1Ints[5], v1Ints[6] != 0,
      v1Ints.length > 7 ? v1Ints[7] : 0);
  off += _vesselSnapSize;

  // Vessel 2
  _encodeVesselSnap(bd, off,
      v2Data[0], v2Data[1], v2Ints[0], v2Ints[1],
      v2Data[2], v2Data[3], v2Data[4], v2Data[5],
      v2Ints[2], v2Ints[3], v2Ints[4] != 0, v2Ints[5], v2Ints[6] != 0,
      v2Ints.length > 7 ? v2Ints[7] : 0);
  off += _vesselSnapSize;

  // Hostiles
  bd.setUint16(off, hostiles.length, Endian.big); off += 2;
  for (final h in hostiles) {
    bd.setUint16(off, h.fleetId, Endian.big); off += 2;
    bd.setUint16(off, h.hostileId, Endian.big); off += 2;
    bd.setFloat64(off, h.x, Endian.big); off += 8;
    bd.setFloat64(off, h.y, Endian.big); off += 8;
    bd.setInt32(off, h.hp, Endian.big); off += 4;
    payload[off] = h.hit; off += 1;
    bd.setFloat32(off, h.sizeX, Endian.big); off += 4;
    bd.setFloat32(off, h.sizeY, Endian.big); off += 4;
    payload[off] = h.hostType; off += 1;
  }

  // Enemy projectiles
  bd.setUint16(off, enemyProjs.length, Endian.big); off += 2;
  for (final p in enemyProjs) {
    bd.setFloat64(off, p.x, Endian.big); off += 8;
    bd.setFloat64(off, p.y, Endian.big); off += 8;
    bd.setFloat32(off, p.sizeX, Endian.big); off += 4;
    bd.setFloat32(off, p.sizeY, Endian.big); off += 4;
    bd.setFloat32(off, p.speed, Endian.big); off += 4;
  }

  // Player projectiles
  bd.setUint16(off, playerProjs.length, Endian.big); off += 2;
  for (final p in playerProjs) {
    bd.setFloat64(off, p.x, Endian.big); off += 8;
    bd.setFloat64(off, p.y, Endian.big); off += 8;
    bd.setFloat32(off, p.sizeX, Endian.big); off += 4;
    bd.setFloat32(off, p.sizeY, Endian.big); off += 4;
    bd.setFloat32(off, p.speed, Endian.big); off += 4;
    payload[off] = p.img; off += 1;
    payload[off] = p.side ? 1 : 0; off += 1;
  }

  // Collectables
  bd.setUint16(off, collectables.length, Endian.big); off += 2;
  for (final c in collectables) {
    bd.setFloat64(off, c.x, Endian.big); off += 8;
    bd.setFloat64(off, c.y, Endian.big); off += 8;
    payload[off] = c.type; off += 1;
  }

  // Beams
  bd.setUint16(off, beams.length, Endian.big); off += 2;
  for (final b in beams) {
    bd.setFloat64(off, b.sx, Endian.big); off += 8;
    bd.setFloat64(off, b.sy, Endian.big); off += 8;
    bd.setFloat64(off, b.dx, Endian.big); off += 8;
    bd.setFloat64(off, b.dy, Endian.big); off += 8;
    payload[off] = b.active ? 1 : 0; off += 1;
  }

  // Structures
  bd.setUint16(off, structures.length, Endian.big); off += 2;
  for (final s in structures) {
    bd.setUint16(off, s.id, Endian.big); off += 2;
    bd.setFloat64(off, s.x, Endian.big); off += 8;
    bd.setFloat64(off, s.y, Endian.big); off += 8;
    bd.setFloat32(off, s.sizeX, Endian.big); off += 4;
    bd.setFloat32(off, s.sizeY, Endian.big); off += 4;
    bd.setInt32(off, s.hp, Endian.big); off += 4;
    payload[off] = s.hit; off += 1;
    payload[off] = s.structType; off += 1;
    final nameBytes = s.imgName.codeUnits;
    payload[off] = nameBytes.length; off += 1;
    payload.setRange(off, off + nameBytes.length, nameBytes); off += nameBytes.length;
  }

  // Sigils (optional tail — an older client stops before it)
  if (sigils.isNotEmpty) {
    payload[off] = sigils.length; off += 1;
    for (final s in sigils) {
      s.encode(bd, off);
      off += SigilSnap.size;
    }
  }

  return frameMessage(MsgType.gameStateSnapshot, payload);
}

/// Decode a game state snapshot from payload (without frame header)
GameSnapshot decodeGameSnapshot(Uint8List payload) {
  final bd = ByteData.sublistView(payload);
  int off = 0;

  final gameState = payload[off]; off += 1;
  final sectorIndex = bd.getUint16(off, Endian.big); off += 2;
  final elapsed = bd.getFloat64(off, Endian.big); off += 8;

  final vessel1 = _decodeVesselSnap(bd, off); off += _vesselSnapSize;
  final vessel2 = _decodeVesselSnap(bd, off); off += _vesselSnapSize;

  // Hostiles
  final hostileCount = bd.getUint16(off, Endian.big); off += 2;
  final hostiles = <HostileSnap>[];
  for (int i = 0; i < hostileCount; i++) {
    final fleetId = bd.getUint16(off, Endian.big); off += 2;
    final hostileId = bd.getUint16(off, Endian.big); off += 2;
    final x = bd.getFloat64(off, Endian.big); off += 8;
    final y = bd.getFloat64(off, Endian.big); off += 8;
    final hp = bd.getInt32(off, Endian.big); off += 4;
    final hit = payload[off]; off += 1;
    final sizeX = bd.getFloat32(off, Endian.big); off += 4;
    final sizeY = bd.getFloat32(off, Endian.big); off += 4;
    final hostType = payload[off]; off += 1;
    hostiles.add(HostileSnap(
      fleetId: fleetId, hostileId: hostileId,
      x: x, y: y, hp: hp, hit: hit,
      sizeX: sizeX.toDouble(), sizeY: sizeY.toDouble(),
      hostType: hostType,
    ));
  }

  // Enemy projectiles
  final eProjCount = bd.getUint16(off, Endian.big); off += 2;
  final enemyProjs = <ProjSnap>[];
  for (int i = 0; i < eProjCount; i++) {
    final x = bd.getFloat64(off, Endian.big); off += 8;
    final y = bd.getFloat64(off, Endian.big); off += 8;
    final sizeX = bd.getFloat32(off, Endian.big); off += 4;
    final sizeY = bd.getFloat32(off, Endian.big); off += 4;
    final speed = bd.getFloat32(off, Endian.big); off += 4;
    enemyProjs.add(ProjSnap(x: x, y: y, sizeX: sizeX.toDouble(), sizeY: sizeY.toDouble(), speed: speed.toDouble()));
  }

  // Player projectiles
  final pProjCount = bd.getUint16(off, Endian.big); off += 2;
  final playerProjs = <ProjSnap>[];
  for (int i = 0; i < pProjCount; i++) {
    final x = bd.getFloat64(off, Endian.big); off += 8;
    final y = bd.getFloat64(off, Endian.big); off += 8;
    final sizeX = bd.getFloat32(off, Endian.big); off += 4;
    final sizeY = bd.getFloat32(off, Endian.big); off += 4;
    final speed = bd.getFloat32(off, Endian.big); off += 4;
    final img = payload[off]; off += 1;
    final side = payload[off] != 0; off += 1;
    playerProjs.add(ProjSnap(x: x, y: y, sizeX: sizeX.toDouble(), sizeY: sizeY.toDouble(), speed: speed.toDouble(),
        img: img < projSnapImgs.length ? img : 0, side: side));
  }

  // Collectables
  final collCount = bd.getUint16(off, Endian.big); off += 2;
  final collectables = <CollSnap>[];
  for (int i = 0; i < collCount; i++) {
    final x = bd.getFloat64(off, Endian.big); off += 8;
    final y = bd.getFloat64(off, Endian.big); off += 8;
    final type = payload[off]; off += 1;
    collectables.add(CollSnap(x: x, y: y, type: type));
  }

  // Beams
  final beamCount = bd.getUint16(off, Endian.big); off += 2;
  final beamsOut = <BeamSnap>[];
  for (int i = 0; i < beamCount; i++) {
    final sx = bd.getFloat64(off, Endian.big); off += 8;
    final sy = bd.getFloat64(off, Endian.big); off += 8;
    final dxv = bd.getFloat64(off, Endian.big); off += 8;
    final dyv = bd.getFloat64(off, Endian.big); off += 8;
    final active = payload[off] != 0; off += 1;
    beamsOut.add(BeamSnap(sx: sx, sy: sy, dx: dxv, dy: dyv, active: active));
  }

  // Structures (optional — absent in older snapshots)
  final structsOut = <StructSnap>[];
  if (off < payload.length) {
    final structCount = bd.getUint16(off, Endian.big); off += 2;
    for (int i = 0; i < structCount; i++) {
      final id = bd.getUint16(off, Endian.big); off += 2;
      final x = bd.getFloat64(off, Endian.big); off += 8;
      final y = bd.getFloat64(off, Endian.big); off += 8;
      final sizeX = bd.getFloat32(off, Endian.big); off += 4;
      final sizeY = bd.getFloat32(off, Endian.big); off += 4;
      final hp = bd.getInt32(off, Endian.big); off += 4;
      final hit = payload[off]; off += 1;
      final structType = payload[off]; off += 1;
      final nameLen = payload[off]; off += 1;
      final imgName = String.fromCharCodes(payload, off, off + nameLen); off += nameLen;
      structsOut.add(StructSnap(
        id: id, x: x, y: y,
        sizeX: sizeX.toDouble(), sizeY: sizeY.toDouble(),
        hp: hp, hit: hit, structType: structType, imgName: imgName,
      ));
    }
  }

  // Sigils (optional — absent from older hosts)
  var sig1 = SigilSnap.none, sig2 = SigilSnap.none;
  if (off < payload.length) {
    final n = payload[off]; off += 1;
    if (n >= 1 && off + SigilSnap.size <= payload.length) {
      sig1 = SigilSnap.decode(bd, off);
      off += SigilSnap.size;
    }
    if (n >= 2 && off + SigilSnap.size <= payload.length) {
      sig2 = SigilSnap.decode(bd, off);
      off += SigilSnap.size;
    }
  }

  return GameSnapshot(
    gameState: gameState,
    sectorIndex: sectorIndex,
    elapsed: elapsed,
    vessel1: vessel1,
    vessel2: vessel2,
    hostiles: hostiles,
    enemyProjectiles: enemyProjs,
    playerProjectiles: playerProjs,
    collectables: collectables,
    beams: beamsOut,
    structures: structsOut,
    sigils1: sig1,
    sigils2: sig2,
  );
}

// ---- ShopState (0x06) ----
// Encodes vessel2 full state for ComCenter display on client.
// Uses same VesselSnap format + weapon list

Uint8List encodeShopState({
  required VesselSnap vesselData,
  required List<({String name, int slot, int level, int damage, int price})> weapons,
}) {
  final weaponBytes = <int>[];
  for (final w in weapons) {
    final nameBytes = w.name.codeUnits;
    weaponBytes.add(nameBytes.length);
    weaponBytes.addAll(nameBytes);
    weaponBytes.add(w.slot);
    weaponBytes.add(w.level);
    weaponBytes.addAll(_int32Bytes(w.damage));
    weaponBytes.addAll(_int32Bytes(w.price));
  }

  final payload = Uint8List(_vesselSnapSize + 1 + weaponBytes.length);
  final bd = ByteData.sublistView(payload);

  _encodeVesselSnap(bd, 0,
      vesselData.x, vesselData.y, vesselData.hp, vesselData.hpMax,
      vesselData.shield, vesselData.shieldMax,
      vesselData.gen, vesselData.genMax,
      vesselData.score, vesselData.credit,
      vesselData.fire, vesselData.dmgTaken, vesselData.visible);

  payload[_vesselSnapSize] = weapons.length;
  payload.setRange(_vesselSnapSize + 1, payload.length, weaponBytes);

  return frameMessage(MsgType.shopState, payload);
}

List<int> _int32Bytes(int value) {
  final bd = ByteData(4);
  bd.setInt32(0, value, Endian.big);
  return bd.buffer.asUint8List().toList();
}

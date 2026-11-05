import 'mod_spec.dart';

/// What a hull does beyond its numbers.
enum HullPerk {
  none,

  /// Holding still for [HullSpec.afterimageDelay] makes every shot hit
  /// harder until the ship moves again.
  afterimage,

  /// Damage that gets through the shield is halved, and the first asteroid
  /// ram only takes half the shield.
  bulwark,

  /// A gun that needs up to 130 % of the generator's capacity still fires,
  /// slower, off a full generator.
  overclock,

  /// A gun drone rides along for free.
  battery,
}

/// A ship class. Stats are multipliers on the stock VB6 ship, so [falcon]
/// is exactly 1.0 everywhere and the parity numbers never move. A skin gives
/// a hull its look; the numbers are the same in every skin.
class HullSpec {
  /// Stable save key.
  final String id;

  /// Proper noun, never translated.
  final String name;
  final double hpMul;
  final double shieldMul;
  final double genPowerMul;
  final double genMaxMul;

  /// Keyboard and pad movement speed. Touch drag stays 1:1 for every hull —
  /// a finger that the ship lags behind feels broken, not heavy.
  final double agility;

  /// Size of the box enemy fire has to hit.
  final double hitbox;
  final Map<RackKind, int> sockets;
  final HullPerk perk;

  /// Tint for skins that have no art for this hull yet, so the five still
  /// read as five ships.
  final int tint;

  const HullSpec({
    required this.id,
    required this.name,
    this.hpMul = 1,
    this.shieldMul = 1,
    this.genPowerMul = 1,
    this.genMaxMul = 1,
    this.agility = 1,
    this.hitbox = 1,
    required this.sockets,
    this.perk = HullPerk.none,
    this.tint = 0xFFFFFFFF,
  });

  int socketsFor(RackKind r) => sockets[r] ?? 0;

  static const afterimageDelay = 0.4;
  static const afterimageDmg = 1.5;
  static const overclockReach = 1.3;

  static const falcon = HullSpec(
    id: 'falcon',
    name: 'FALCON',
    sockets: {
      RackKind.front: 2,
      RackKind.side: 1,
      RackKind.gen: 1,
      RackKind.hull: 1,
    },
  );

  static HullSpec byId(String? id) =>
      kHulls.firstWhere((h) => h.id == id, orElse: () => falcon);
}

const List<HullSpec> kHulls = [
  HullSpec.falcon,
  HullSpec(
    id: 'dart',
    name: 'DART',
    hpMul: 0.72,
    shieldMul: 0.8,
    genPowerMul: 0.9,
    genMaxMul: 0.9,
    agility: 1.35,
    hitbox: 0.8,
    sockets: {
      RackKind.front: 2,
      RackKind.side: 0,
      RackKind.gen: 1,
      RackKind.hull: 1,
    },
    perk: HullPerk.afterimage,
    tint: 0xFF80F0FF,
  ),
  HullSpec(
    id: 'bastion',
    name: 'BASTION',
    hpMul: 1.6,
    shieldMul: 1.6,
    genMaxMul: 1.2,
    agility: 0.8,
    hitbox: 1.15,
    sockets: {
      RackKind.front: 1,
      RackKind.side: 2,
      RackKind.gen: 1,
      RackKind.hull: 2,
    },
    perk: HullPerk.bulwark,
    tint: 0xFFFFB070,
  ),
  HullSpec(
    id: 'dynamo',
    name: 'DYNAMO',
    hpMul: 0.88,
    shieldMul: 0.9,
    genPowerMul: 1.5,
    genMaxMul: 1.4,
    sockets: {
      RackKind.front: 2,
      RackKind.side: 1,
      RackKind.gen: 2,
      RackKind.hull: 1,
    },
    perk: HullPerk.overclock,
    tint: 0xFFFFF080,
  ),
  HullSpec(
    id: 'colossus',
    name: 'COLOSSUS',
    hpMul: 1.36,
    shieldMul: 1.3,
    genPowerMul: 1.2,
    genMaxMul: 1.3,
    agility: 0.7,
    hitbox: 1.25,
    sockets: {
      RackKind.front: 3,
      RackKind.side: 2,
      RackKind.gen: 1,
      RackKind.hull: 2,
    },
    perk: HullPerk.battery,
    tint: 0xFFFF90F0,
  ),
];

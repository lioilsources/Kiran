// Weapon definition — ported from DevType.cls and ComCenter.GetDevType.
// Contains base stats for all weapon types.

enum WeaponSlot {
  frontGun,  // 1
  generator, // 2
  leftGun,   // 3
  notAvailable, // 4
  rightGun,  // 5
  satellite, // 6
  shieldCapacitor, // 7
}

class DevType {
  final String name;
  final String imgName;
  final int damage;
  final int speed;
  final int guide;
  final double pwrNeed;
  final double pwrGen;
  final int cooldown; // in frames (convert to seconds: * 25 / 1000)
  final int beam; // 0 = projectile, >0 = beam weapon
  final int seqs; // beam animation steps
  final int xShiftMax;
  final int price;
  final double upgCost;
  final bool scaleProjectile;
  final double minProjScale;
  final double maxProjScale;

  const DevType({
    required this.name,
    required this.imgName,
    this.damage = 10,
    this.speed = 5,
    this.guide = 0,
    this.pwrNeed = 1.0,
    this.pwrGen = 0.0,
    this.cooldown = 10,
    this.beam = 0,
    this.seqs = 0,
    this.xShiftMax = 0,
    this.price = 100,
    this.upgCost = 0.1,
    this.scaleProjectile = false,
    this.minProjScale = 1.0,
    this.maxProjScale = 1.0,
  });

  double get cooldownSeconds => cooldown * 25.0 / 1000.0;

  /// All front weapons
  static const List<DevType> frontWeapons = [
    bubbleGun,
    vulcanCannon,
    blaster,
    laser,
  ];

  /// All side weapons
  static const List<DevType> sideWeapons = [
    smallBubble,
    smallVulcan,
    starGun,
    smallLaser,
  ];

  // ---- Front Weapons ----

  static const bubbleGun = DevType(
    name: 'Bubble Gun',
    imgName: 'bubble',
    damage: 15,
    speed: 6,
    guide: 0,
    pwrNeed: 0.3,
    cooldown: 8,
    price: 0, // starter weapon
    upgCost: 0.12,
    scaleProjectile: true,
    minProjScale: 0.7,
    maxProjScale: 1.5,
  );

  static const vulcanCannon = DevType(
    name: 'Vulcan Cannon',
    imgName: 'vulcan',
    damage: 8,
    speed: 10,
    guide: 0,
    pwrNeed: 0.15,
    cooldown: 3,
    price: 500,
    upgCost: 0.1,
    scaleProjectile: true,
    minProjScale: 0.5,
    maxProjScale: 1.0,
  );

  static const blaster = DevType(
    name: 'Blaster',
    imgName: 'blaster',
    damage: 25,
    speed: 7,
    guide: 5,
    pwrNeed: 0.5,
    cooldown: 12,
    price: 800,
    upgCost: 0.15,
    scaleProjectile: true,
    minProjScale: 0.8,
    maxProjScale: 1.8,
  );

  static const laser = DevType(
    name: 'Laser',
    imgName: 'laser',
    damage: 35,
    speed: 0,
    guide: 0,
    pwrNeed: 0.8,
    cooldown: 15,
    beam: 1,
    seqs: 6,
    price: 1200,
    upgCost: 0.2,
  );

  // ---- Side Weapons ----

  static const smallBubble = DevType(
    name: 'Small Bubble',
    imgName: 'bubble',
    damage: 8,
    speed: 5,
    guide: 0,
    pwrNeed: 0.2,
    cooldown: 10,
    price: 300,
    upgCost: 0.1,
    scaleProjectile: true,
    minProjScale: 0.5,
    maxProjScale: 1.0,
  );

  static const smallVulcan = DevType(
    name: 'Small Vulcan',
    imgName: 'vulcan',
    damage: 5,
    speed: 8,
    guide: 0,
    pwrNeed: 0.1,
    cooldown: 4,
    price: 400,
    upgCost: 0.1,
    scaleProjectile: true,
    minProjScale: 0.4,
    maxProjScale: 0.8,
  );

  static const starGun = DevType(
    name: 'Star Gun',
    imgName: 'starg',
    damage: 12,
    speed: 6,
    guide: 8,
    pwrNeed: 0.25,
    cooldown: 8,
    xShiftMax: 3,
    price: 600,
    upgCost: 0.12,
    scaleProjectile: true,
    minProjScale: 0.6,
    maxProjScale: 1.2,
  );

  static const smallLaser = DevType(
    name: 'Small Laser',
    imgName: 'laser',
    damage: 20,
    speed: 0,
    guide: 0,
    pwrNeed: 0.5,
    cooldown: 18,
    beam: 1,
    seqs: 4,
    price: 900,
    upgCost: 0.18,
  );
}

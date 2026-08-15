// Hand-authored sector content — eighteen ~60-second parts, three per level.
//
// As of v2.4.0 this file is original wave design. VB6 remains the reference
// for STATS (enemy HP, collision damage, prices, the per-level HP economy
// within ±20%) but NOT for composition. Design rules, enforced by
// test/sector_parts_test.dart:
//
//  - the script ends within ~58 s (+2 s completion delay = a minute session);
//  - durationSec is authored in BARE seconds — no `hs` multiplier — so the
//    session length does not depend on the phone's aspect ratio. `hs` stays
//    on Y positions and vertical amplitudes, which must track the field;
//  - every part uses at least two enemy types and two path shapes, and
//    adjacent parts never share their dominant type or shape;
//  - fleets are listed in enterTime order with ids 0..n-1 (the dead-time skip
//    reads the first unstarted fleet in list order);
//  - big bonusMoney drops ride parked fleets (stay/freeze/replacePath), where
//    the kills >= count drop condition cannot be voided by a path-exit;
//  - no falconxb/falconxt/bouncer — the boss-tier set flips boss music on.
part of 'sector.dart';

/// VB6 Sector.AddAsteroids — staggered asteroid spawning with paths
void _addAsteroids(Sector s, double enterTime, int count, double x, double width) {
  final rng = Random();
  for (int i = 0; i < count; i++) {
    final ax = rng.nextDouble() * width + x;
    final ast = Structure(
      caption: 'Asteroid ${i + 1}',
      behavior: StructBehavior.byPath,
      structType: StructType.asteroid,
      hp: 100000,
      hpMax: 100000,
      imgName: 'asteroid${rng.nextInt(4) == 0 ? '' : (rng.nextInt(3) + 1).toString()}',
    );
    ast.enterTime = enterTime + i;
    ast.collisionDmg = s.level;
    // Linear path top to bottom
    final path = PathSystem();
    path.generate(
      (20.0 * 1000 / config.frameDelay).round(),
      ax, -50, ax, config.gameHeight + 100,
      PathType.linear,
    );
    ast.trace = path;
    s.structures.add(ast);
  }
}

/// Homing falling hazards — StructBehavior.fallAndFollow's first use.
///
/// Spawned ON-screen: the fall speed is ~2 px/s, so an off-screen spawn would
/// never arrive. They home on the player's X, shatter on ram contact (with the
/// escalating ram punishment), and are excluded from the completion check like
/// all structures. Capped small by the caller: projectile hits on asteroids pay
/// credit, so each hunter is a slow credit faucet while alive.
void _addHunters(Sector s, double enterTime, int count) {
  final w = config.gameWidth;
  final hs = config.gameHeight / config.scrHeight;
  final rng = Random();
  for (int i = 0; i < count; i++) {
    final hunter = Structure(
      caption: 'Hunter ${i + 1}',
      behavior: StructBehavior.fallAndFollow,
      structType: StructType.asteroid,
      hp: 100000,
      hpMax: 100000,
      imgName: 'asteroid2',
    );
    hunter.enterTime = enterTime + i * 2.0;
    hunter.collisionDmg = s.level;
    hunter.position.setValues(60.0 + rng.nextDouble() * (w - 120), 60 * hs);
    s.structures.add(hunter);
  }
}

/// VB6 Sector.SetAltParams
void _setAltParams(Fleet f, int p1, int p2, int p3, PathType p4) {
  f.altParam1 = p1;
  f.altParam2 = p2;
  f.altParam3 = p3;
  f.altParam4 = p4;
}

// ═══════════════════ Level 1 — System Perimeter ═══════════════════
// Theme: scout streams on the empty frontier. HP total 17,720 (VB6 21,020).

/// I — sparse lane streams. Dominant falcon1 / linear.
void _l1p1(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  s.fleets.add(Fleet.create(
    id: 0, enterTime: 1, caption: '',
    hostType: HostType.falcon1, count: 14, bonus: CollType.frontWepUpgrade,
    triggerSteps: 40, durationSec: 14, bonusMoney: 500,
    srcX: 150, srcY: -45 * hs, dstX: 250, dstY: h + 5,
  ));
  final f1 = Fleet.create(
    id: 1, enterTime: 9, caption: '',
    hostType: HostType.falcon2, count: 12, bonus: CollType.bonusCredit,
    triggerSteps: 40, durationSec: 14, bonusMoney: 500,
    srcX: w - 150, srcY: -45 * hs, dstX: w - 250, dstY: h + 5,
  );
  f1.addWeapon(10, 450);
  s.fleets.add(f1);
  s.fleets.add(Fleet.create(
    id: 2, enterTime: 20, caption: '',
    hostType: HostType.falcon1, count: 12,
    triggerSteps: 24, durationSec: 15,
    srcX: 60, srcY: -45 * hs, dstX: w - 60, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 110, cycles: 6,
  ));
  final f3 = Fleet.create(
    id: 3, enterTime: 30, caption: '',
    hostType: HostType.falcon3, count: 10, bonus: CollType.rightWepUpgrade,
    triggerSteps: 40, durationSec: 15,
    srcX: -50, srcY: 230 * hs, dstX: w + 50, dstY: 260 * hs,
    pathType: PathType.sinus, amplitude: 55 * hs, cycles: 7,
  );
  f3.addWeapon(12, 400);
  s.fleets.add(f3);
}

/// II — funnel debut with an asteroid garnish. Dominant falcon3 / cosinus.
void _l1p2(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 1, caption: '',
    hostType: HostType.falcon3, count: 14, bonus: CollType.generatorUpgrade,
    triggerSteps: 45, durationSec: 18,
    srcX: 80, srcY: -45 * hs, dstX: w / 2, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 150, cycles: 8, amplMultiplier: 0.9991,
  );
  f0.addWeapon(10, 400);
  s.fleets.add(f0);
  s.fleets.add(Fleet.create(
    id: 1, enterTime: 10, caption: '',
    hostType: HostType.falcon2, count: 12, bonus: CollType.bonusCredit,
    triggerSteps: 30, durationSec: 14, bonusMoney: 700,
    srcX: w - 80, srcY: -120 * hs, dstX: 100, dstY: h + 80,
    pathType: PathType.sinCos, amplitude: 140 * hs, cycles: 6,
  ));
  s.fleets.add(Fleet.create(
    id: 2, enterTime: 24, caption: '',
    hostType: HostType.falcon1, count: 18,
    triggerSteps: 12, durationSec: 13,
    srcX: w / 2, srcY: -45 * hs, dstX: w / 2, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 90, cycles: 9,
  ));
  final f3 = Fleet.create(
    id: 3, enterTime: 32, caption: '',
    hostType: HostType.falcon3, count: 10, bonus: CollType.leftWepUpgrade,
    triggerSteps: 32, durationSec: 15,
    srcX: w - 140, srcY: -45 * hs, dstX: 140, dstY: h + 5,
  );
  f3.addWeapon(12, 350);
  s.fleets.add(f3);

  _addAsteroids(s, 20, 6, w / 4, w / 2);
}

/// III — sinus surge crossfire, then the game's first falconx parks as an
/// ambush. Dominant falcon2 / sinus.
void _l1p3(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 1, caption: '',
    hostType: HostType.falcon2, count: 14, bonus: CollType.shieldUpgrade,
    triggerSteps: 32, durationSec: 15,
    srcX: -50, srcY: 180 * hs, dstX: w + 50, dstY: 320 * hs,
    pathType: PathType.sinus, amplitude: 70 * hs, cycles: 6,
  );
  f0.addWeapon(10, 400);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 8, caption: '',
    hostType: HostType.falcon2, count: 14, bonus: CollType.bonusCredit,
    triggerSteps: 32, durationSec: 15, bonusMoney: 600,
    srcX: w + 50, srcY: 260 * hs, dstX: -50, dstY: 420 * hs,
    pathType: PathType.sinus, amplitude: 70 * hs, cycles: 6,
  );
  f1.addWeapon(10, 400);
  s.fleets.add(f1);
  final f2 = Fleet.create(
    id: 2, enterTime: 18, caption: '',
    hostType: HostType.falcon4, count: 10, bonus: CollType.frontWepUpgrade,
    triggerSteps: 36, durationSec: 16,
    srcX: w - 60, srcY: -150 * hs, dstX: 60, dstY: h + 150,
    pathType: PathType.sinCos, amplitude: 160 * hs, cycles: 8,
  );
  f2.addWeapon(12, 380);
  s.fleets.add(f2);
  final f3 = Fleet.create(
    id: 3, enterTime: 34, caption: '',
    hostType: HostType.falconx, count: 1, bonus: CollType.bonusCredit,
    triggerSteps: 12, durationSec: 10, bonusMoney: 1200,
    srcX: w / 2, srcY: -80 * hs, dstX: w / 2, dstY: h * 0.3,
    defaultPathAction: PathAction.replacePath,
  );
  _setAltParams(f3, 60, 50, 0, PathType.cosinus);
  f3.addWeapon(15, 300);
  s.fleets.add(f3);
}

// ═══════════════════ Level 2 — Inner Zone ═══════════════════
// Theme: escorts learn formations. HP total 27,280 (VB6 31,640).

/// I — mirrored corkscrew crossfire. Dominant falcon4 / sinCos.
void _l2p1(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 1, caption: '',
    hostType: HostType.falcon4, count: 14, bonus: CollType.healthUpgrade,
    triggerSteps: 30, durationSec: 15,
    srcX: w - 100, srcY: -200 * hs, dstX: 140, dstY: h + 200,
    pathType: PathType.sinCos, amplitude: 170 * hs, cycles: 9,
  );
  f0.addWeapon(20, 400);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 12, caption: '',
    hostType: HostType.falcon4, count: 14, bonus: CollType.bonusCredit,
    triggerSteps: 30, durationSec: 15, bonusMoney: 900,
    srcX: 100, srcY: -200 * hs, dstX: w - 140, dstY: h + 200,
    pathType: PathType.sinCos, amplitude: 170 * hs, cycles: 9,
  );
  f1.addWeapon(20, 400);
  s.fleets.add(f1);
  s.fleets.add(Fleet.create(
    id: 2, enterTime: 22, caption: '',
    hostType: HostType.falcon2, count: 20, bonus: CollType.generatorUpgrade,
    triggerSteps: 16, durationSec: 13,
    srcX: w / 2 - 40, srcY: -45 * hs, dstX: w / 2 - 40, dstY: h + 5,
  ));
  final f3 = Fleet.create(
    id: 3, enterTime: 31, caption: '',
    hostType: HostType.falcon5, count: 12, bonus: CollType.rightWepUpgrade,
    triggerSteps: 32, durationSec: 14,
    srcX: w - 90, srcY: -45 * hs, dstX: w - 200, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 130, cycles: 8,
  );
  f3.addWeapon(22, 350);
  s.fleets.add(f3);
}

/// II — freeze-formation rows with a swarm threading through. Dominant
/// falcon6 / linear.
void _l2p2(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 1, caption: '',
    hostType: HostType.falcon6, count: 7, bonus: CollType.shieldUpgrade,
    triggerSteps: 25, durationSec: 8,
    srcX: -50, srcY: 120 * hs, dstX: w - 58, dstY: 120 * hs,
    defaultPathAction: PathAction.freezeFleet,
  );
  f0.addWeapon(22, 300);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 5, caption: '',
    hostType: HostType.falcon5, count: 7, bonus: CollType.bonusCredit,
    triggerSteps: 25, durationSec: 8, bonusMoney: 1000,
    srcX: w + 5, srcY: 230 * hs, dstX: 2, dstY: 230 * hs,
    defaultPathAction: PathAction.freezeFleet,
  );
  f1.addWeapon(20, 300);
  s.fleets.add(f1);
  s.fleets.add(Fleet.create(
    id: 2, enterTime: 20, caption: '',
    hostType: HostType.falcon1, count: 12, bonus: CollType.generatorUpgrade,
    triggerSteps: 12, durationSec: 14,
    srcX: w / 2, srcY: -150 * hs, dstX: w / 2, dstY: h + 150,
    pathType: PathType.sinCos, amplitude: 150 * hs, cycles: 8,
  ));
  final f3 = Fleet.create(
    id: 3, enterTime: 31, caption: '',
    hostType: HostType.falcon6, count: 12, bonus: CollType.frontWepUpgrade,
    triggerSteps: 40, durationSec: 11, bonusMoney: 1000,
    srcX: w / 2, srcY: -45 * hs, dstX: w / 2, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 140, cycles: 7, amplMultiplier: 0.9991,
  );
  f3.addWeapon(25, 280);
  s.fleets.add(f3);
  s.fleets.add(Fleet.create(
    id: 4, enterTime: 42, caption: '',
    hostType: HostType.falcon2, count: 10,
    triggerSteps: 16, durationSec: 11,
    srcX: 160, srcY: -45 * hs, dstX: w - 160, dstY: h + 5,
  ));
}

/// III — a mini-boss tours the field on a multi-segment entrance. Dominant
/// falcon5 / cosinus.
void _l2p3(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 1, caption: '',
    hostType: HostType.falcon5, count: 16, bonus: CollType.leftWepUpgrade,
    triggerSteps: 28, durationSec: 16,
    srcX: 100, srcY: -45 * hs, dstX: w - 100, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 150, cycles: 9,
  );
  f0.addWeapon(20, 350);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 10, caption: '',
    hostType: HostType.falcon3, count: 14, bonus: CollType.bonusCredit,
    triggerSteps: 22, durationSec: 14, bonusMoney: 1000,
    srcX: -50, srcY: 200 * hs, dstX: w + 50, dstY: 330 * hs,
    pathType: PathType.sinus, amplitude: 65 * hs, cycles: 8,
  );
  f1.addWeapon(18, 380);
  s.fleets.add(f1);
  final f2 = Fleet.create(
    id: 2, enterTime: 22, caption: '',
    hostType: HostType.falcon5, count: 12, bonus: CollType.shieldUpgrade,
    triggerSteps: 30, durationSec: 15,
    srcX: w - 120, srcY: -45 * hs, dstX: 200, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 130, cycles: 8, amplMultiplier: 0.9991,
  );
  f2.addWeapon(20, 320);
  s.fleets.add(f2);

  // Mini-boss: flies in, sweeps across on a cosinus arc, settles centre-top.
  final f3 = Fleet.create(
    id: 3, enterTime: 34, caption: 'Falcon X-II',
    hostType: HostType.falconx2, count: 1, bonus: CollType.shieldUpgrade,
    triggerSteps: 12, durationSec: 8, bonusMoney: 2000,
    srcX: w + 50, srcY: 100 * hs, dstX: w / 2, dstY: h * 0.35,
  );
  final ep = PathSystem();
  ep.generate(200, w / 2, h * 0.35, 100, h * 0.2, PathType.cosinus,
      amplitude: 120, cycles: 3);
  final ep2 = PathSystem();
  ep2.generate(240, 100, h * 0.2, w / 2, h * 0.15, PathType.linear);
  ep2.onExit = PathAction.stay; // addPath adopts the appended path's onExit
  ep.addPath(ep2);
  f3.setExtraPath(ep);
  f3.addWeapon(30, 150);
  s.fleets.add(f3);
}

// ═══════════════════ Level 3 — Planet Perimeter ═══════════════════
// The old anti-pattern fixed: falcon3 count 130 → 32, total 196 → 140,
// peak concurrency ~100 → ≤30. HP total 48,000 (VB6 59,000).

/// I — heavy escort lanes. Dominant falconx / linear.
void _l3p1(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 2, caption: '',
    hostType: HostType.falconx, count: 6, bonus: CollType.generatorUpgrade,
    triggerSteps: 60, durationSec: 20,
    srcX: w / 3, srcY: -80 * hs, dstX: w / 3, dstY: h + 80,
  );
  f0.addWeapon(33, 300);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 8, caption: '',
    hostType: HostType.falcon3, count: 16, bonus: CollType.bonusCredit,
    triggerSteps: 20, durationSec: 13, bonusMoney: 1200,
    srcX: w - 80, srcY: -150 * hs, dstX: 120, dstY: h + 150,
    pathType: PathType.sinCos, amplitude: 140 * hs, cycles: 7,
  );
  f1.addWeapon(25, 400);
  s.fleets.add(f1);
  final f2 = Fleet.create(
    id: 2, enterTime: 20, caption: '',
    hostType: HostType.falconx, count: 6, bonus: CollType.rightWepUpgrade,
    triggerSteps: 60, durationSec: 20,
    srcX: 2 * w / 3, srcY: -80 * hs, dstX: 2 * w / 3, dstY: h + 80,
  );
  f2.addWeapon(33, 300);
  s.fleets.add(f2);
  final f3 = Fleet.create(
    id: 3, enterTime: 30, caption: '',
    hostType: HostType.falcon4, count: 12, bonus: CollType.frontWepUpgrade,
    triggerSteps: 24, durationSec: 13,
    srcX: 60, srcY: -45 * hs, dstX: w - 60, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 110, cycles: 6,
  );
  f3.addWeapon(25, 350);
  s.fleets.add(f3);
}

/// II — crossing corkscrews over an asteroid field. Dominant falcon4 / sinCos.
void _l3p2(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 1, caption: '',
    hostType: HostType.falcon4, count: 16, bonus: CollType.healthUpgrade,
    triggerSteps: 25, durationSec: 16,
    srcX: -80, srcY: -150 * hs, dstX: w + 80, dstY: h + 150,
    pathType: PathType.sinCos, amplitude: 180 * hs, cycles: 9,
  );
  f0.addWeapon(28, 380);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 12, caption: '',
    hostType: HostType.falcon6, count: 18, bonus: CollType.bonusCredit,
    triggerSteps: 30, durationSec: 15, bonusMoney: 1500,
    srcX: w + 50, srcY: 220 * hs, dstX: -50, dstY: 380 * hs,
    pathType: PathType.sinus, amplitude: 70 * hs, cycles: 9,
  );
  f1.addWeapon(30, 320);
  s.fleets.add(f1);
  final f2 = Fleet.create(
    id: 2, enterTime: 24, caption: '',
    hostType: HostType.falcon4, count: 16, bonus: CollType.leftWepUpgrade,
    triggerSteps: 25, durationSec: 16,
    srcX: w + 80, srcY: -150 * hs, dstX: -80, dstY: h + 150,
    pathType: PathType.sinCos, amplitude: 180 * hs, cycles: 9,
  );
  f2.addWeapon(28, 380);
  s.fleets.add(f2);
  final f3 = Fleet.create(
    id: 3, enterTime: 32, caption: '',
    hostType: HostType.falconx, count: 4, bonus: CollType.bonusCredit,
    triggerSteps: 40, durationSec: 18, bonusMoney: 2000,
    srcX: w / 2, srcY: -80 * hs, dstX: w / 2, dstY: h + 80,
    pathType: PathType.cosinus, amplitude: 200, cycles: 5, amplMultiplier: 0.9991,
  );
  f3.addWeapon(35, 280);
  s.fleets.add(f3);

  _addAsteroids(s, 10, 8, 60, w - 120);
}

/// III — the grand funnel finale. Dominant falconx / cosinus.
void _l3p3(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 1, caption: '',
    hostType: HostType.falcon5, count: 16, bonus: CollType.generatorUpgrade,
    triggerSteps: 24, durationSec: 14,
    srcX: 80, srcY: -45 * hs, dstX: w - 160, dstY: h + 5,
  );
  f0.addWeapon(28, 350);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 10, caption: '',
    hostType: HostType.falconx, count: 8, bonus: CollType.frontWepUpgrade,
    triggerSteps: 50, durationSec: 22, bonusMoney: 2000,
    srcX: w / 2, srcY: -100 * hs, dstX: w / 2, dstY: h + 100,
    pathType: PathType.cosinus, amplitude: 170, cycles: 8, amplMultiplier: 0.9991,
  );
  f1.addWeapon(35, 260);
  s.fleets.add(f1);
  final f2 = Fleet.create(
    id: 2, enterTime: 26, caption: '',
    hostType: HostType.falcon3, count: 16, bonus: CollType.bonusCredit,
    triggerSteps: 16, durationSec: 13, bonusMoney: 1500,
    srcX: w - 100, srcY: -150 * hs, dstX: 100, dstY: h + 150,
    pathType: PathType.sinCos, amplitude: 150 * hs, cycles: 8,
  );
  f2.addWeapon(25, 400);
  s.fleets.add(f2);
  final f3 = Fleet.create(
    id: 3, enterTime: 33, caption: '',
    hostType: HostType.falconx, count: 6, bonus: CollType.shieldUpgrade,
    triggerSteps: 40, durationSec: 16,
    srcX: 140, srcY: -80 * hs, dstX: w - 140, dstY: h + 80,
    pathType: PathType.cosinus, amplitude: 140, cycles: 6,
  );
  f3.addWeapon(35, 260);
  s.fleets.add(f3);
}

// ═══════════════════ Level 4 — Planet Patrol ═══════════════════
// Theme: elite patrols. HP total 53,520 (VB6 61,000).

/// I — sinus surge elite. Dominant falcon5 / sinus.
void _l4p1(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 1, caption: '',
    hostType: HostType.falcon5, count: 18, bonus: CollType.healthUpgrade,
    triggerSteps: 24, durationSec: 15,
    srcX: -60, srcY: 160 * hs, dstX: w + 60, dstY: 300 * hs,
    pathType: PathType.sinus, amplitude: 80 * hs, cycles: 10,
  );
  f0.addWeapon(35, 350);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 9, caption: '',
    hostType: HostType.falcon5, count: 18, bonus: CollType.bonusCredit,
    triggerSteps: 24, durationSec: 15, bonusMoney: 2000,
    srcX: w + 60, srcY: 380 * hs, dstX: -60, dstY: 240 * hs,
    pathType: PathType.sinus, amplitude: 80 * hs, cycles: 10,
  );
  f1.addWeapon(35, 350);
  s.fleets.add(f1);
  final f2 = Fleet.create(
    id: 2, enterTime: 20, caption: '',
    hostType: HostType.falconx2, count: 3, bonus: CollType.shieldUpgrade,
    triggerSteps: 80, durationSec: 18, bonusMoney: 2500,
    srcX: w + 60, srcY: 120 * hs, dstX: -60, dstY: 520 * hs,
  );
  f2.addWeapon(40, 220);
  s.fleets.add(f2);
  s.fleets.add(Fleet.create(
    id: 3, enterTime: 32, caption: '',
    hostType: HostType.falcon1, count: 18, bonus: CollType.generatorUpgrade,
    triggerSteps: 14, durationSec: 12,
    srcX: 100, srcY: -150 * hs, dstX: w - 100, dstY: h + 150,
    pathType: PathType.sinCos, amplitude: 170 * hs, cycles: 9,
  ));
  final f4 = Fleet.create(
    id: 4, enterTime: 36, caption: '',
    hostType: HostType.falcon6, count: 10, bonus: CollType.rightWepUpgrade,
    triggerSteps: 24, durationSec: 14,
    srcX: w / 2, srcY: -45 * hs, dstX: w / 2 - 150, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 130, cycles: 7,
  );
  f4.addWeapon(35, 300);
  s.fleets.add(f4);
}

/// II — a parade of six X-II minis on a shared entrance (homage to the VB6
/// sector-3 boss carousel, at a sane density). Dominant falconx2 / cosinus.
void _l4p2(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  // Shared entrance: sweep to the left edge, arc across, settle centre-top.
  final sharedEp = PathSystem();
  sharedEp.generate(240, 140, h * 0.55, 100, 120 * hs, PathType.cosinus,
      amplitude: 100, cycles: 2);
  final epTail = PathSystem();
  epTail.generate(300, 100, 120 * hs, w / 2 - 20, 200 * hs, PathType.linear);
  epTail.onExit = PathAction.stay;
  sharedEp.addPath(epTail);

  const recharges = [220, 215, 210, 205, 200];
  const drops = [
    (CollType.none, 0),
    (CollType.bonusCredit, 2500),
    (CollType.shieldUpgrade, 0),
    (CollType.bonusCredit, 2500),
    (CollType.none, 0),
  ];
  for (var i = 0; i < 5; i++) {
    final f = Fleet.create(
      id: i, enterTime: 2 + i * 5, caption: 'Falcon X-II',
      hostType: HostType.falconx2, count: 1, bonus: drops[i].$1,
      triggerSteps: 12, durationSec: 10, bonusMoney: drops[i].$2,
      srcX: w + 50, srcY: 0, dstX: 140, dstY: h * 0.55,
    );
    f.setExtraPath(sharedEp.clone());
    f.addWeapon(40, recharges[i]);
    s.fleets.add(f);
  }
  final f5 = Fleet.create(
    id: 5, enterTime: 26, caption: '',
    hostType: HostType.falcon3, count: 17, bonus: CollType.generatorUpgrade,
    triggerSteps: 14, durationSec: 13,
    srcX: w - 120, srcY: -45 * hs, dstX: 120, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 130, cycles: 8,
  );
  f5.addWeapon(30, 400);
  s.fleets.add(f5);
  final f6 = Fleet.create(
    id: 6, enterTime: 27, caption: 'Falcon X-II',
    hostType: HostType.falconx2, count: 1, bonus: CollType.bonusCredit,
    triggerSteps: 12, durationSec: 10, bonusMoney: 3000,
    srcX: w + 50, srcY: 0, dstX: 140, dstY: h * 0.55,
  );
  f6.setExtraPath(sharedEp.clone());
  f6.addWeapon(40, 190);
  s.fleets.add(f6);
  final f7 = Fleet.create(
    id: 7, enterTime: 30, caption: '',
    hostType: HostType.falconx, count: 4, bonus: CollType.bonusCredit,
    triggerSteps: 40, durationSec: 16, bonusMoney: 2000,
    srcX: 2 * w / 3, srcY: -80 * hs, dstX: 2 * w / 3, dstY: h + 80,
  );
  f7.addWeapon(38, 280);
  s.fleets.add(f7);
  final f8 = Fleet.create(
    id: 8, enterTime: 36, caption: '',
    hostType: HostType.falcon6, count: 10, bonus: CollType.frontWepUpgrade,
    triggerSteps: 24, durationSec: 14,
    srcX: w / 2, srcY: -45 * hs, dstX: w / 2, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 120, cycles: 6, amplMultiplier: 0.9991,
  );
  f8.addWeapon(35, 300);
  s.fleets.add(f8);
}

/// III — heavy corkscrews with a top-line replacePath ambush. Dominant
/// falcon6 / sinCos.
void _l4p3(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 1, caption: '',
    hostType: HostType.falcon6, count: 20, bonus: CollType.shieldUpgrade,
    triggerSteps: 26, durationSec: 16,
    srcX: 80, srcY: -180 * hs, dstX: w - 80, dstY: h + 180,
    pathType: PathType.sinCos, amplitude: 190 * hs, cycles: 9,
  );
  f0.addWeapon(38, 320);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 13, caption: '',
    hostType: HostType.falcon4, count: 14, bonus: CollType.leftWepUpgrade,
    triggerSteps: 22, durationSec: 9, bonusMoney: 2000,
    srcX: -50, srcY: 60 * hs, dstX: w - 80, dstY: 60 * hs,
    defaultPathAction: PathAction.freezeFleet,
  );
  f1.addWeapon(35, 275);
  s.fleets.add(f1);
  final f2 = Fleet.create(
    id: 2, enterTime: 24, caption: '',
    hostType: HostType.falcon6, count: 14, bonus: CollType.bonusCredit,
    triggerSteps: 26, durationSec: 16, bonusMoney: 2500,
    srcX: w - 80, srcY: -180 * hs, dstX: 80, dstY: h + 180,
    pathType: PathType.sinCos, amplitude: 190 * hs, cycles: 9,
  );
  f2.addWeapon(38, 320);
  s.fleets.add(f2);
  final f3 = Fleet.create(
    id: 3, enterTime: 36, caption: '',
    hostType: HostType.falconx3, count: 2, bonus: CollType.frontWepUpgrade,
    triggerSteps: 60, durationSec: 16, bonusMoney: 3000,
    srcX: w / 2 - 20, srcY: -100 * hs, dstX: w / 2 - 20, dstY: h + 100,
  );
  f3.addWeapon(40, 250);
  s.fleets.add(f3);
}

// ═══════════════════ Level 5 — Planet Orbit ═══════════════════
// Theme: fortifications. HP total 70,360 (VB6 76,200).

/// I — the freeze gauntlet (VB6 sector-4 homage, halved). Dominant
/// falcon3 / linear.
void _l5p1(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 1, caption: '',
    hostType: HostType.falcon3, count: 8, bonus: CollType.bonusCredit,
    triggerSteps: 25, durationSec: 9, bonusMoney: 3000,
    srcX: -50, srcY: 140 * hs, dstX: w - 58, dstY: 140 * hs,
    defaultPathAction: PathAction.freezeFleet,
  );
  f0.addWeapon(30, 300);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 6, caption: '',
    hostType: HostType.falcon3, count: 8, bonus: CollType.bonusCredit,
    triggerSteps: 25, durationSec: 9, bonusMoney: 3000,
    srcX: w + 5, srcY: 260 * hs, dstX: 2, dstY: 260 * hs,
    defaultPathAction: PathAction.freezeFleet,
  );
  f1.addWeapon(30, 300);
  s.fleets.add(f1);
  final f2 = Fleet.create(
    id: 2, enterTime: 14, caption: '',
    hostType: HostType.falcon5, count: 12, bonus: CollType.shieldUpgrade,
    triggerSteps: 20, durationSec: 14,
    srcX: w - 90, srcY: -45 * hs, dstX: 150, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 140, cycles: 8,
  );
  f2.addWeapon(35, 280);
  s.fleets.add(f2);
  final f3 = Fleet.create(
    id: 3, enterTime: 26, caption: '',
    hostType: HostType.falconx, count: 5, bonus: CollType.healthUpgrade,
    triggerSteps: 50, durationSec: 18, bonusMoney: 3000,
    srcX: -70, srcY: 460 * hs, dstX: w + 70, dstY: 460 * hs,
    pathType: PathType.sinus, amplitude: 50 * hs, cycles: 6,
  );
  f3.addWeapon(42, 250);
  s.fleets.add(f3);
  s.fleets.add(Fleet.create(
    id: 4, enterTime: 30, caption: '',
    hostType: HostType.falcon2, count: 10, bonus: CollType.generatorUpgrade,
    triggerSteps: 14, durationSec: 10,
    srcX: 100, srcY: -150 * hs, dstX: w - 100, dstY: h + 150,
    pathType: PathType.sinCos, amplitude: 160 * hs, cycles: 8,
  ));
  final f5 = Fleet.create(
    id: 5, enterTime: 42, caption: '',
    hostType: HostType.falcon3, count: 12, bonus: CollType.frontWepUpgrade,
    triggerSteps: 16, durationSec: 11,
    srcX: 200, srcY: -45 * hs, dstX: w - 200, dstY: h + 5,
  );
  f5.addWeapon(30, 300);
  s.fleets.add(f5);
}

/// II — the elite wall: X-IIIs fly in and hold an oscillating line. Dominant
/// falconx3 / sinCos.
void _l5p2(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 2, caption: '',
    hostType: HostType.falconx3, count: 8, bonus: CollType.frontWepUpgrade,
    triggerSteps: 45, durationSec: 10, bonusMoney: 5000,
    srcX: -60, srcY: 90 * hs, dstX: w - 90, dstY: 90 * hs,
    defaultPathAction: PathAction.freezeFleet,
  );
  f0.addWeapon(50, 225);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 12, caption: '',
    hostType: HostType.falcon4, count: 16, bonus: CollType.bonusCredit,
    triggerSteps: 18, durationSec: 13, bonusMoney: 3000,
    srcX: w - 100, srcY: -150 * hs, dstX: 100, dstY: h + 150,
    pathType: PathType.sinCos, amplitude: 150 * hs, cycles: 8,
  );
  f1.addWeapon(35, 320);
  s.fleets.add(f1);
  final f2 = Fleet.create(
    id: 2, enterTime: 24, caption: '',
    hostType: HostType.falconx3, count: 4, bonus: CollType.shieldUpgrade,
    triggerSteps: 60, durationSec: 20, bonusMoney: 4000,
    srcX: w / 2, srcY: -100 * hs, dstX: w / 2, dstY: h + 100,
    pathType: PathType.cosinus, amplitude: 180, cycles: 7, amplMultiplier: 0.9991,
  );
  f2.addWeapon(50, 230);
  s.fleets.add(f2);
  s.fleets.add(Fleet.create(
    id: 3, enterTime: 32, caption: '',
    hostType: HostType.falcon2, count: 18, bonus: CollType.generatorUpgrade,
    triggerSteps: 12, durationSec: 11,
    srcX: -50, srcY: 520 * hs, dstX: w + 50, dstY: 620 * hs,
    pathType: PathType.sinus, amplitude: 45 * hs, cycles: 8,
  ));
}

/// III — sinus mirrors over the hunter debut (fallAndFollow's first outing).
/// Dominant falconx2 / sinus.
void _l5p3(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 1, caption: '',
    hostType: HostType.falcon2, count: 18, bonus: CollType.shieldUpgrade,
    triggerSteps: 20, durationSec: 14,
    srcX: -60, srcY: 200 * hs, dstX: w + 60, dstY: 340 * hs,
    pathType: PathType.sinus, amplitude: 75 * hs, cycles: 9,
  );
  f0.addWeapon(30, 350);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 9, caption: '',
    hostType: HostType.falcon2, count: 18, bonus: CollType.bonusCredit,
    triggerSteps: 20, durationSec: 14, bonusMoney: 3000,
    srcX: w + 60, srcY: 420 * hs, dstX: -60, dstY: 280 * hs,
    pathType: PathType.sinus, amplitude: 75 * hs, cycles: 9,
  );
  f1.addWeapon(30, 350);
  s.fleets.add(f1);

  _addHunters(s, 12, 3);

  final f2 = Fleet.create(
    id: 2, enterTime: 22, caption: '',
    hostType: HostType.falconx2, count: 3, bonus: CollType.rightWepUpgrade,
    triggerSteps: 70, durationSec: 18, bonusMoney: 4000,
    srcX: w / 2, srcY: -100 * hs, dstX: w / 2, dstY: h + 100,
    pathType: PathType.cosinus, amplitude: 160, cycles: 6,
  );
  f2.addWeapon(45, 230);
  s.fleets.add(f2);
  final f3 = Fleet.create(
    id: 3, enterTime: 32, caption: '',
    hostType: HostType.falcon4, count: 14, bonus: CollType.generatorUpgrade,
    triggerSteps: 24, durationSec: 13,
    srcX: 80, srcY: -45 * hs, dstX: w - 220, dstY: h + 5,
  );
  f3.addWeapon(35, 300);
  s.fleets.add(f3);
}

// ═══════════════════ Level 6 — Industry Zone ═══════════════════
// Theme: heavy industry, X-IIIs everywhere. HP total 112,600 (VB6 97,120).

/// I — the expanding spiral (VB6 sector-5 homage). Dominant falconx3 / cosinus.
void _l6p1(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 2, caption: '',
    hostType: HostType.falconx3, count: 10, bonus: CollType.frontWepUpgrade,
    triggerSteps: 80, durationSec: 24, bonusMoney: 6000,
    srcX: w / 2, srcY: -55 * hs, dstX: w / 2, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 14, cycles: 9, amplMultiplier: 1.0025,
  );
  f0.addWeapon(45, 250);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 12, caption: '',
    hostType: HostType.falcon1, count: 20, bonus: CollType.generatorUpgrade,
    triggerSteps: 12, durationSec: 11,
    srcX: 100, srcY: -150 * hs, dstX: w - 100, dstY: h + 150,
    pathType: PathType.sinCos, amplitude: 150 * hs, cycles: 8,
  );
  f1.addWeapon(15, 300);
  s.fleets.add(f1);
  final f2 = Fleet.create(
    id: 2, enterTime: 24, caption: '',
    hostType: HostType.falcon2, count: 16, bonus: CollType.bonusCredit,
    triggerSteps: 18, durationSec: 12, bonusMoney: 3000,
    srcX: w - 160, srcY: -45 * hs, dstX: 160, dstY: h + 5,
  );
  f2.addWeapon(15, 280);
  s.fleets.add(f2);
  final f3 = Fleet.create(
    id: 3, enterTime: 32, caption: '',
    hostType: HostType.falconx3, count: 4, bonus: CollType.shieldUpgrade,
    triggerSteps: 60, durationSec: 17, bonusMoney: 5000,
    srcX: -70, srcY: 500 * hs, dstX: w + 70, dstY: 380 * hs,
    pathType: PathType.sinus, amplitude: 45 * hs, cycles: 5,
  );
  f3.addWeapon(48, 240);
  s.fleets.add(f3);
}

/// II — parallel crossing lanes into a pincer funnel. Dominant falconx2 /
/// linear.
void _l6p2(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 1, caption: '',
    hostType: HostType.falcon3, count: 14, bonus: CollType.generatorUpgrade,
    triggerSteps: 22, durationSec: 12,
    srcX: 200, srcY: -45 * hs, dstX: w - 200, dstY: h + 5,
  );
  f0.addWeapon(15, 275);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 1, caption: '',
    hostType: HostType.falcon3, count: 14, bonus: CollType.bonusCredit,
    triggerSteps: 22, durationSec: 12, bonusMoney: 4000,
    srcX: w - 200, srcY: -45 * hs, dstX: 200, dstY: h + 5,
  );
  f1.addWeapon(15, 275);
  s.fleets.add(f1);
  final f2 = Fleet.create(
    id: 2, enterTime: 16, caption: '',
    hostType: HostType.falcon6, count: 14, bonus: CollType.healthUpgrade,
    triggerSteps: 24, durationSec: 14,
    srcX: w - 90, srcY: -150 * hs, dstX: 90, dstY: h + 150,
    pathType: PathType.sinCos, amplitude: 170 * hs, cycles: 8,
  );
  f2.addWeapon(40, 280);
  s.fleets.add(f2);
  final f3 = Fleet.create(
    id: 3, enterTime: 28, caption: '',
    hostType: HostType.falconx2, count: 4, bonus: CollType.shieldUpgrade,
    triggerSteps: 50, durationSec: 16, bonusMoney: 5000,
    srcX: w / 2, srcY: -80 * hs, dstX: w / 2, dstY: h + 80,
    pathType: PathType.cosinus, amplitude: 150, cycles: 6, amplMultiplier: 0.9991,
  );
  f3.addWeapon(45, 220);
  s.fleets.add(f3);
  final f4 = Fleet.create(
    id: 4, enterTime: 34, caption: '',
    hostType: HostType.falcon3, count: 14, bonus: CollType.leftWepUpgrade,
    triggerSteps: 20, durationSec: 12,
    srcX: -50, srcY: 240 * hs, dstX: w + 50, dstY: 360 * hs,
    pathType: PathType.sinus, amplitude: 60 * hs, cycles: 8,
  );
  f4.addWeapon(20, 300);
  s.fleets.add(f4);
}

/// III — corkscrew heavies into a frozen elite blockade. Dominant
/// falconx3 / sinCos.
void _l6p3(Sector s) {
  final w = config.gameWidth;
  final h = config.gameHeight;
  final hs = config.gameHeight / config.scrHeight;

  final f0 = Fleet.create(
    id: 0, enterTime: 2, caption: '',
    hostType: HostType.falconx3, count: 7, bonus: CollType.frontWepUpgrade,
    triggerSteps: 55, durationSec: 20, bonusMoney: 8000,
    srcX: w + 80, srcY: -150 * hs, dstX: -80, dstY: h + 150,
    pathType: PathType.sinCos, amplitude: 220 * hs, cycles: 7,
  );
  f0.addWeapon(50, 220);
  s.fleets.add(f0);
  final f1 = Fleet.create(
    id: 1, enterTime: 12, caption: '',
    hostType: HostType.falcon5, count: 16, bonus: CollType.bonusCredit,
    triggerSteps: 18, durationSec: 13, bonusMoney: 5000,
    srcX: 70, srcY: -45 * hs, dstX: w - 70, dstY: h + 5,
    pathType: PathType.cosinus, amplitude: 130, cycles: 8,
  );
  f1.addWeapon(40, 300);
  s.fleets.add(f1);
  final f2 = Fleet.create(
    id: 2, enterTime: 24, caption: '',
    hostType: HostType.falconx2, count: 5, bonus: CollType.shieldUpgrade,
    triggerSteps: 40, durationSec: 8, bonusMoney: 5000,
    srcX: -60, srcY: 110 * hs, dstX: w - 70, dstY: 110 * hs,
    defaultPathAction: PathAction.freezeFleet,
  );
  f2.addWeapon(45, 200);
  s.fleets.add(f2);
  final f3 = Fleet.create(
    id: 3, enterTime: 32, caption: '',
    hostType: HostType.falconx3, count: 5, bonus: CollType.bonusCredit,
    triggerSteps: 40, durationSec: 17, bonusMoney: 8000,
    srcX: -80, srcY: -150 * hs, dstX: w + 80, dstY: h + 150,
    pathType: PathType.sinCos, amplitude: 200 * hs, cycles: 8,
  );
  f3.addWeapon(50, 210);
  s.fleets.add(f3);
}

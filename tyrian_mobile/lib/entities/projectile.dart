import 'dart:math' show cos, pi;

import 'package:flame/components.dart';
import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../systems/dev_type.dart';
import '../systems/device.dart';
import '../services/asset_library.dart';
import '../systems/mods/shot_plan.dart';
import 'hostile.dart';

/// Ported from Projectile.cls — a bullet/missile in flight.
/// Uses object pooling: deactivated projectiles are returned to Device._pool.
class Projectile extends PositionComponent with HasGameReference {
  String imgName;
  double speed; // negative = moving up (player), positive = down (enemy)
  double vx; // horizontal speed (boss aimed/spread shots); 0 = straight
  double damage;
  double projScale;
  Device? parentDevice;
  bool active = true;

  /// Set on a co-op client's mirrored player shots, which have no device.
  double? drawScaleOverride;

  /// Enemy shots run on the enemies' clock, which TIMEWARP slows.
  bool isEnemy = false;

  // ── Mod state, reset on every activation ──
  /// The plan that fired this shot; null for enemy shots.
  ShotPlan? plan;

  /// Hostiles still to pass through: 0 = consumed by the first hit, -1 = never.
  int hitsLeft = 0;

  /// Hostiles already hit by a piercing shot, so it does not hit one twice.
  final Set<Hostile> pierced = {};
  int bounces = 0;
  bool bounceTop = false;

  /// Generation of a FORK/CHAIN shot (0 = fired by the gun).
  int forkDepth = 0;

  /// Split shards and fork shots do not split again.
  bool canSplit = true;
  double orbitAmp = 0;
  double _orbitT = 0;
  double drawScaleAdd = 0;

  /// Homing strength that replaces the device's own (reflected MIRROR shots).
  double? guideOverride;

  /// Render-only enlargement of player shots; [size] stays the hitbox.
  double get drawScale {
    if (drawScaleOverride != null) return drawScaleOverride!;
    final d = parentDevice;
    if (d == null) return 1.0;
    return (d.slot == WeaponSlot.frontGun
            ? config.frontShotDrawScale
            : config.sideShotDrawScale) +
        drawScaleAdd;
  }

  /// Arm the mod behaviour of [p] on this shot. A null plan clears it.
  void applyPlan(ShotPlan? p, {int depth = 0}) {
    plan = p;
    forkDepth = depth;
    pierced.clear();
    _orbitT = 0;
    guideOverride = null;
    if (p == null) {
      hitsLeft = 0;
      bounces = 0;
      bounceTop = false;
      canSplit = false;
      orbitAmp = 0;
      drawScaleAdd = 0;
      return;
    }
    hitsLeft = p.fx.pierce;
    bounces = p.fx.bounces;
    bounceTop = p.fx.bounceTop;
    canSplit = depth == 0 && p.fx.split;
    orbitAmp = p.fx.orbit ? config.modOrbitAmplitude : 0;
    drawScaleAdd = p.drawScaleAdd;
  }

  // Bounds for collision
  double get x2 => position.x + size.x;
  double get y2 => position.y + size.y;

  Projectile({
    required this.imgName,
    required Vector2 position,
    required this.speed,
    required this.damage,
    this.vx = 0,
    double scale = 1.0,
    this.parentDevice,
  })  : projScale = scale,
        super(position: position);

  Sprite? _sprite;
  Sprite? get sprite => _sprite;

  @override
  Future<void> onLoad() async {
    _loadSprite();
    // Center horizontally on spawn position (once)
    position.x -= size.x / 2;
  }

  /// Load sprite and update size — no side effects on position or hitbox.
  void _loadSprite() {
    _sprite = AssetLibrary.instance.getSprite(imgName);
    if (_sprite != null) {
      size = _sprite!.srcSize * projScale * config.spriteScale;
    } else {
      size = Vector2(6, 12) * projScale * config.spriteScale;
    }
  }

  /// Public API for skin changes — reloads sprite/size only.
  void refreshSprite() {
    _loadSprite();
  }

  @override
  void update(double dt) {
    if (!active) return;

    var scaledDt = dt * config.originalFps;
    if (isEnemy) {
      final g = game;
      if (g is TyrianGame) scaledDt *= g.enemyTimeScale;
    }
    position.y += speed * scaledDt;
    position.x += vx * scaledDt;
    if (orbitAmp > 0) {
      // ORBIT: weave around the straight line. Velocity form of A·sin(ωt),
      // so the weave rides on top of any fan or bounce.
      _orbitT += dt;
      const w = 2 * pi / config.modOrbitPeriod;
      position.x += orbitAmp * w * cos(w * _orbitT) * dt;
    }
    if (bounces > 0) _bounce();

    // Remove if off screen
    if (position.y < -size.y ||
        position.y > config.gameHeight + size.y ||
        position.x < -size.x ||
        position.x > config.gameWidth + size.x) {
      returnToPool();
    }
  }

  /// BOUNCE off the side walls; PINBALL off the top and back off the bottom.
  void _bounce() {
    if ((position.x < 0 && vx < 0) ||
        (position.x + size.x > config.gameWidth && vx > 0)) {
      vx = -vx;
      bounces--;
    } else if (bounceTop &&
        ((position.y < 0 && speed < 0) ||
            (position.y + size.y > config.gameHeight && speed > 0))) {
      speed = -speed;
      bounces--;
    }
  }

  // Rendering is handled by ProjectileBatchRenderer — this is intentionally empty.
  @override
  void render(canvas) {}

  void activate(double x, double y, double spd, double dmg, double scale) {
    speed = spd;
    vx = 0;
    damage = dmg;
    projScale = scale;
    active = true;
    _loadSprite();
    position.setValues(x - size.x / 2, y);
  }

  void deactivate() {
    active = false;
    position.setValues(-1000, -1000);
  }

  void returnToPool() {
    if (parentDevice != null) {
      parentDevice!.returnToPool(this);
    } else {
      removeFromParent();
    }
  }
}

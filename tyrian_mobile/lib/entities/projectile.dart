import 'package:flame/components.dart';
import '../game/game_config.dart' as config;
import '../systems/device.dart';
import '../services/asset_library.dart';

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

    final scaledDt = dt * config.originalFps;
    position.y += speed * scaledDt;
    position.x += vx * scaledDt;

    // Remove if off screen
    if (position.y < -size.y ||
        position.y > config.gameHeight + size.y ||
        position.x < -size.x ||
        position.x > config.gameWidth + size.x) {
      returnToPool();
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

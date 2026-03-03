import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../systems/path_system.dart';
import 'vessel.dart';

/// Collectable types from VBA CollType enum
enum CollType {
  none,
  frontWepUpgrade,
  leftWepUpgrade,
  rightWepUpgrade,
  healthUpgrade,
  shieldUpgrade,
  generatorUpgrade,
  bonusCredit,
}

/// Ported from Collectable.cls — pickup items/bonuses.
class Collectable extends PositionComponent
    with HasGameReference<TyrianGame>, CollisionCallbacks {
  String caption;
  CollType cType;
  int value;
  PathSystem? trace;

  Collectable({
    required this.caption,
    required this.cType,
    this.value = 0,
    this.trace,
    Vector2? position,
  }) : super(
          position: position ?? Vector2.zero(),
          size: Vector2(config.iconWidth, config.iconHeight),
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    // Follow path (falling toward player)
    if (trace != null && trace!.current != null) {
      position.setValues(trace!.current!.x, trace!.current!.y);
      if (!trace!.advance()) {
        // Path ended — remove
        game.removeCollectable(this);
      }
    } else {
      // Simple fall
      position.y += 2.0 * dt * config.originalFps;
      if (position.y > config.gameHeight + size.y) {
        game.removeCollectable(this);
      }
    }
  }

  /// Apply the collectable's effect to the vessel
  void applyEffect(Vessel vessel, TyrianGame game) {
    switch (cType) {
      case CollType.frontWepUpgrade:
        final d = vessel.devices.where((d) => d.slot.index == 0).firstOrNull;
        if (d != null) d.upgrade();
      case CollType.leftWepUpgrade:
        final d = vessel.devices.where((d) => d.slot.index == 2).firstOrNull;
        if (d != null) d.upgrade();
      case CollType.rightWepUpgrade:
        final d = vessel.devices.where((d) => d.slot.index == 4).firstOrNull;
        if (d != null) d.upgrade();
      case CollType.healthUpgrade:
        vessel.hp = (vessel.hp + 25).clamp(0, vessel.hpMax);
      case CollType.shieldUpgrade:
        vessel.shield =
            (vessel.shield + 10).clamp(0, vessel.shieldMax).toDouble();
      case CollType.generatorUpgrade:
        vessel.genPower *= 1.1;
      case CollType.bonusCredit:
        vessel.credit += value;
      case CollType.none:
        break;
    }

    game.removeCollectable(this);
  }

  @override
  void render(Canvas canvas) {
    // Colored icon based on type
    final color = _colorForType();
    final paint = Paint()..color = color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(4),
      ),
      paint,
    );

    // Icon letter
    final textPainter = TextPainter(
      text: TextSpan(
        text: _labelForType(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.x - textPainter.width) / 2,
        (size.y - textPainter.height) / 2,
      ),
    );
  }

  Color _colorForType() {
    switch (cType) {
      case CollType.frontWepUpgrade:
        return const Color(0xFFFF6600);
      case CollType.leftWepUpgrade:
        return const Color(0xFF0066FF);
      case CollType.rightWepUpgrade:
        return const Color(0xFF0066FF);
      case CollType.healthUpgrade:
        return const Color(0xFFFF0000);
      case CollType.shieldUpgrade:
        return const Color(0xFF00CCFF);
      case CollType.generatorUpgrade:
        return const Color(0xFFFFFF00);
      case CollType.bonusCredit:
        return const Color(0xFF00FF00);
      case CollType.none:
        return const Color(0xFF888888);
    }
  }

  String _labelForType() {
    switch (cType) {
      case CollType.frontWepUpgrade: return 'W';
      case CollType.leftWepUpgrade: return 'L';
      case CollType.rightWepUpgrade: return 'R';
      case CollType.healthUpgrade: return 'H';
      case CollType.shieldUpgrade: return 'S';
      case CollType.generatorUpgrade: return 'G';
      case CollType.bonusCredit: return '\$';
      case CollType.none: return '?';
    }
  }
}

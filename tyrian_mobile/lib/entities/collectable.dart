import 'dart:math' show pi;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/game_config.dart' as config;
import '../game/platform_config.dart' as platform;
import '../game/tyrian_game.dart';
import '../services/asset_library.dart';
import '../services/sound_service.dart';
import '../systems/path_system.dart';
import '../systems/dev_type.dart';
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
    with HasGameReference<TyrianGame> {
  String caption;
  CollType cType;
  int value;
  PathSystem? trace;
  Sprite? _sprite;

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
    refreshSprite();
  }

  /// Re-fetch the icon. Called on load and again after a skin change: the
  /// switch disposes every cached image, and a pickup still on screen would
  /// otherwise draw from a dead one — which throws, and one throwing
  /// component blacks out the whole world render.
  void refreshSprite() {
    _sprite = AssetLibrary.instance.getIcon(_iconNameForType());
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
        // VB6: creates Bubble Gun if slot empty
        var d = vessel.devices.where((d) => d.slot == WeaponSlot.frontGun).firstOrNull;
        d ??= vessel.equipWeapon(DevType.bubbleGun, WeaponSlot.frontGun);
        d.upgrade();
      case CollType.leftWepUpgrade:
        // VB6: creates Small Bubble if slot empty
        var d = vessel.devices.where((d) => d.slot == WeaponSlot.leftGun).firstOrNull;
        d ??= vessel.equipWeapon(DevType.smallBubble, WeaponSlot.leftGun);
        d.upgrade();
      case CollType.rightWepUpgrade:
        // VB6: creates Small Bubble if slot empty
        var d = vessel.devices.where((d) => d.slot == WeaponSlot.rightGun).firstOrNull;
        d ??= vessel.equipWeapon(DevType.smallBubble, WeaponSlot.rightGun);
        d.upgrade();
      case CollType.healthUpgrade:
        // VB6: if HP > 50% max: +25% HP, hpMax +5% (linear +50 above 2000)
        if (vessel.hp > vessel.hpMax * 0.5) {
          vessel.hp = (vessel.hp + (vessel.hpMax * 0.25).round()).clamp(0, vessel.hpMax * 2);
          if (vessel.hpMax < 2000) {
            vessel.hpMax = (vessel.hpMax * 1.05).round();
          } else {
            vessel.hpMax += 50;
          }
        } else {
          vessel.hp = (vessel.hp + (vessel.hpMax * 0.50).round()).clamp(0, vessel.hpMax);
        }
      case CollType.shieldUpgrade:
        // VB6: <1500: +30% shield, shieldMax ×1.10, regen ×1.1
        // VB6: >=1500: +35% shield, shieldMax rounded to nearest 25, regen ×1.025
        if (vessel.shieldMax < 1500) {
          vessel.shield = (vessel.shield + vessel.shieldMax * 0.30).clamp(0, vessel.shieldMax * 2);
          vessel.shieldMax *= 1.10;
          vessel.shieldRegen *= 1.1;
        } else {
          vessel.shield = (vessel.shield + vessel.shieldMax * 0.35).clamp(0, vessel.shieldMax * 2);
          vessel.shieldMax = ((vessel.shieldMax + 25) / 25).roundToDouble() * 25;
          vessel.shieldRegen *= 1.025;
        }
      case CollType.generatorUpgrade:
        // Must go through the device (VB6 Collectable.cls:292 calls d.Upgrade).
        // Raising vessel.genPower directly leaves device.pwrGen behind, and
        // Device.upgrade *assigns* genPower from it — so the next shop purchase
        // silently erased every pickup ever collected, while genMax kept
        // compounding. The result was a huge tank refilling at the un-upgraded
        // rate, i.e. a generator that cannot keep up.
        final gen = vessel.getDevice(WeaponSlot.generator);
        if (gen != null) {
          gen.upgrade();
        } else {
          vessel.genPower *= config.upgPwrGenMultiplier;
          vessel.genMax *= config.upgGenMaxMultiplier;
        }
      case CollType.bonusCredit:
        vessel.credit += value;
      case CollType.none:
        break;
    }

    SoundService.instance.play(SfxEvent.pickup);
    game.removeCollectable(this);
  }

  @override
  void render(Canvas canvas) {
    // Banking world shift — render-only; pickup AABB uses logic positions
    canvas.translate(game.worldShiftX, 0);

    // Counter the landscape camera rotation so the icon and its label read
    // upright; rotate about the sprite centre so the pickup stays in place.
    if (platform.isLandscape) {
      canvas.translate(size.x / 2, size.y / 2);
      canvas.rotate(-pi / 2);
      canvas.translate(-size.x / 2, -size.y / 2);
    }

    if (_sprite != null) {
      _sprite!.render(canvas, size: size);
      return;
    }

    // Fallback: colored rect with letter (skins without icon assets)
    final paint = Paint()..color = _colorForType();
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(4),
      ),
      paint,
    );
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

  String _iconNameForType() {
    switch (cType) {
      case CollType.healthUpgrade: return 'icon_life';
      case CollType.shieldUpgrade: return 'icon_shield';
      case CollType.frontWepUpgrade:
      case CollType.leftWepUpgrade:
      case CollType.rightWepUpgrade: return 'icon_bomb';
      case CollType.generatorUpgrade: return 'icon_gen';
      case CollType.bonusCredit: return 'icon_credit';
      default: return '';
    }
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

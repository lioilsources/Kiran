import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../services/asset_library.dart';
import '../systems/dev_type.dart';
import '../systems/device.dart';
import 'sigil_caster.dart';

/// What a WING sigil summoned (Prompts/28 §5.3).
enum CompanionRole {
  /// Flies a flank and fires with you.
  wingman,

  /// Flies ahead and hunts the nearest enemy.
  hunter,

  /// Flies just ahead and takes shots meant for you. Never fires.
  warden,
}

/// A summoned drone. Lives [config.companionLife] seconds or until it has
/// taken its hits; fires the ship's side gun (or front gun) at
/// [config.companionDmg], free of the generator, through the ship's plan.
class Companion extends PositionComponent with HasGameReference<TyrianGame> {
  Companion({required this.caster, required this.role, this.side = 1})
      : hits = role == CompanionRole.warden
            ? config.wardenHits
            : config.companionHits,
        super(
            anchor: Anchor.center,
            size: Vector2.all(config.companionSize));

  final SigilCaster caster;
  final CompanionRole role;
  int side;
  int hits;
  double life = config.companionLife;
  bool gone = false;
  Device? gun;
  double _flash = 0;
  double _t = 0;

  bool _diving = false;
  Vector2? _diveTo;

  /// Takes enemy shots on its body: the warden always, the rest in a WHIRL.
  bool get absorbs => role == CompanionRole.warden || caster.whirl;

  @override
  Future<void> onLoad() async {
    final v = caster.vessel;
    position = v.position + _slot();
    if (role == CompanionRole.warden) return;
    final src = v.getDevice(WeaponSlot.leftGun) ?? v.getDevice(WeaponSlot.frontGun);
    var type = src == null ? DevType.smallBubble : DevType.byName(src.name);
    if (type == null || type.beam > 0) type = DevType.smallBubble;
    gun = Device.fromType(type, WeaponSlot.satellite)
      ..level = src?.level ?? 0
      ..damage = math.max(1, ((src?.damage ?? type.damage) * config.companionDmg).round())
      ..cooldown = src?.cooldown ?? type.cooldownSeconds
      ..pwrNeed = 0
      ..parentVessel = v;
  }

  /// Where this companion wants to be, relative to the ship.
  Vector2 _slot() {
    final wide = caster.wideFormation;
    return switch (role) {
      CompanionRole.wingman =>
        wide ? Vector2(side * 72.0, 12) : Vector2(side * 44.0, 46),
      CompanionRole.hunter => Vector2(0, -150),
      CompanionRole.warden => Vector2(0, -64),
    };
  }

  /// SACRIFICE: dive at the nearest enemy and go off.
  void sacrifice() {
    if (_diving) return;
    _diving = true;
    Vector2? best;
    var bestD = double.infinity;
    for (final f in game.activeFleets) {
      for (final h in f.hostiles) {
        if (h.isDead || h.y2 < 0) continue;
        final d = h.hostCenter.distanceToSquared(position);
        if (d < bestD) {
          bestD = d;
          best = h.hostCenter.clone();
        }
      }
    }
    _diveTo = best ?? position + Vector2(0, -300);
  }

  /// An enemy shot landed on it.
  void takeHit() {
    hits--;
    _flash = 0.15;
    if (hits <= 0) _expire(explode: true);
  }

  void _expire({bool explode = false}) {
    if (gone) return;
    gone = true;
    if (explode) game.addExplosion(position.x, position.y, 1);
    gun?.clearProjectiles();
    removeFromParent();
  }

  @override
  void update(double dt) {
    _t += dt;
    if (_flash > 0) _flash -= dt;
    life -= dt;
    if (life <= 0) {
      _expire();
      return;
    }
    if (_diving) {
      final to = _diveTo!;
      final step = 900 * dt;
      final d = to - position;
      if (d.length <= step) {
        caster.blastAt(to.x, to.y, config.sacrificeRadius, config.sacrificeDmg.round());
        caster.meter.add(config.sacrificeRefund);
        _expire();
      } else {
        position += d.normalized() * step;
      }
      return;
    }

    final v = caster.vessel;
    Vector2 target;
    if (caster.whirl) {
      final i = caster.companions.indexOf(this);
      final a = _t * 2 * math.pi + i * math.pi;
      target = v.position + Vector2(math.cos(a), math.sin(a)) * 70;
    } else {
      target = v.position + _slot();
      if (role == CompanionRole.hunter) {
        final h = _nearestAhead();
        if (h != null) {
          target.x = v.position.x +
              (h.x - v.position.x).clamp(-160.0, 160.0).toDouble();
        }
      }
    }
    final k = 1 - math.exp(-10 * dt);
    position += (target - position) * k;
    position.x = position.x.clamp(0, config.gameWidth).toDouble();
    position.y = position.y.clamp(0, config.gameHeight).toDouble();

    _fire();
  }

  Vector2? _nearestAhead() {
    Vector2? best;
    var bestD = double.infinity;
    for (final f in game.activeFleets) {
      for (final h in f.hostiles) {
        if (h.isDead || h.y2 < 0) continue;
        final c = h.hostCenter;
        if (c.y > position.y) continue;
        final d = (c.x - position.x).abs();
        if (d < bestD) {
          bestD = d;
          best = c.clone();
        }
      }
    }
    return best;
  }

  void _fire() {
    final g = gun;
    if (g == null || g.cd > 0) return;
    final v = caster.vessel;
    final firing = v.fire || caster.pinging || role == CompanionRole.hunter;
    if (!firing) return;
    final plan = v.planFor(g);
    final ux = caster.pinging ? caster.pingX : 0.0;
    final uy = caster.pinging ? caster.pingY : -1.0;
    g.spawnShot(position.x, position.y - size.y / 2,
        vx: plan.speed * ux,
        speed: plan.speed * uy,
        damage: plan.damage.toDouble(),
        scale: 1.0,
        plan: plan,
        world: game.world);
    g.cd = plan.cooldown;
  }

  static final _tints = {
    CompanionRole.wingman: const Color(0xFF7CFFB2),
    CompanionRole.hunter: const Color(0xFFFFB84D),
    CompanionRole.warden: const Color(0xFF8AB8FF),
  };

  @override
  void render(Canvas canvas) {
    final tint = _flash > 0 ? Colors.white : _tints[role]!;
    final fade = life < 2 ? (life / 2).clamp(0.3, 1.0) : 1.0;
    final art = AssetLibrary.instance.getSprite('drone') ??
        AssetLibrary.instance.getSprite('boss_turret');
    final paint = Paint()
      ..colorFilter = ColorFilter.mode(
          tint.withValues(alpha: fade), BlendMode.modulate);
    if (art != null) {
      art.render(canvas, size: size, overridePaint: paint);
    } else {
      canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x * 0.35,
          Paint()..color = tint.withValues(alpha: fade));
    }
    if (absorbs) {
      canvas.drawCircle(
          Offset(size.x / 2, size.y / 2),
          size.x * 0.7,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = tint.withValues(alpha: 0.5 * fade));
    }
  }
}

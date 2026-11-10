import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../systems/dev_type.dart';
import '../systems/device.dart';
import 'sigil_caster.dart';

/// The MEGA BLAST beam, drawn for a moment after it fired. The damage was
/// dealt the instant it went off (SigilCaster._hitAlong); this is the light.
class MegaBeam extends Component {
  MegaBeam({
    required this.x,
    required this.y,
    required this.dirX,
    required this.dirY,
    required this.width,
  });

  final double x, y, dirX, dirY, width;
  double _t = 0;

  @override
  void update(double dt) {
    _t += dt;
    if (_t >= config.megaFlash) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final fade = (1 - _t / config.megaFlash).clamp(0.0, 1.0);
    const len = 2400.0;
    final end = Offset(x + dirX * len, y + dirY * len);
    final start = Offset(x, y);
    canvas.drawLine(
        start,
        end,
        Paint()
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF66E0FF).withValues(alpha: 0.35 * fade)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18));
    canvas.drawLine(
        start,
        end,
        Paint()
          ..strokeWidth = width * 0.45
          ..strokeCap = StrokeCap.round
          ..color = Colors.white.withValues(alpha: 0.9 * fade));
  }
}

/// CALTROP: a mine left where the ship was. Goes off when an enemy comes
/// close or when its time runs out, and swallows enemy shots that touch it.
class Caltrop extends PositionComponent with HasGameReference<TyrianGame> {
  Caltrop({required this.caster, required Vector2 position})
      : super(position: position, anchor: Anchor.center, size: Vector2.all(28));

  final SigilCaster caster;
  double _life = config.caltropLife;
  bool _spent = false;

  @override
  void update(double dt) {
    _life -= dt;
    if (_life <= 0) return _blow();
    final trigger = config.caltropRadius * 0.6;
    for (final f in game.activeFleets) {
      for (final h in f.hostiles) {
        if (h.isDead) continue;
        if (h.hostCenter.distanceTo(position) <= trigger) return _blow();
      }
    }
    for (final p in [...game.enemyProjectiles]) {
      final c = Vector2(p.position.x + p.size.x / 2, p.position.y + p.size.y / 2);
      if (c.distanceTo(position) <= size.x) {
        p.removeFromParent();
        game.enemyProjectiles.remove(p);
      }
    }
  }

  void _blow() {
    if (_spent) return;
    _spent = true;
    caster.blastAt(position.x, position.y, config.caltropRadius,
        config.caltropDmg.round());
    removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final pulse = 0.6 + 0.4 * math.sin(_life * 10);
    final c = Offset(size.x / 2, size.y / 2);
    canvas.drawCircle(c, size.x * 0.32,
        Paint()..color = const Color(0xFFFF5A5A).withValues(alpha: pulse));
    canvas.drawCircle(
        c,
        config.caltropRadius * 0.6,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = const Color(0xFFFF5A5A).withValues(alpha: 0.25));
  }
}

/// The ship's last seconds of flight, for ECHO to replay.
class EchoTrail {
  final List<(double t, double x, double y, bool fire)> _s = [];
  double _now = 0;
  static const keep = 2.5;

  void clear() {
    _s.clear();
    _now = 0;
  }

  void record(double x, double y, bool fire, double dt) {
    _now += dt;
    _s.add((_now, x, y, fire));
    while (_s.isNotEmpty && _s.first.$1 < _now - keep) {
      _s.removeAt(0);
    }
  }

  /// Where the ship was [ago] seconds back (the oldest sample if the trail
  /// is shorter), or null before anything was recorded.
  (double x, double y, bool fire)? at(double ago) {
    if (_s.isEmpty) return null;
    final want = _now - ago;
    for (final s in _s) {
      if (s.$1 >= want) return (s.$2, s.$3, s.$4);
    }
    final l = _s.last;
    return (l.$2, l.$3, l.$4);
  }
}

/// ECHO: a shadow of the ship two seconds behind it, flying and firing what
/// the ship flew and fired then, at half damage.
class EchoGhost extends PositionComponent with HasGameReference<TyrianGame> {
  EchoGhost({required this.caster, Device? front})
      : super(anchor: Anchor.center) {
    final v = caster.vessel;
    size = v.size.clone();
    position = v.position.clone();
    if (front != null) {
      var type = DevType.byName(front.name) ?? DevType.bubbleGun;
      if (type.beam > 0) type = DevType.bubbleGun;
      gun = Device.fromType(type, WeaponSlot.satellite)
        ..level = front.level
        ..damage = math.max(1, (front.damage * 0.5).round())
        ..cooldown = front.cooldown
        ..pwrNeed = 0
        ..parentVessel = v;
    }
  }

  static const delay = 2.0;
  final SigilCaster caster;
  Device? gun;

  @override
  void update(double dt) {
    final s = caster.echoTrail.at(delay);
    if (s == null) return;
    position.setValues(s.$1, s.$2);
    final g = gun;
    if (g != null && s.$3 && g.cd <= 0) {
      final plan = caster.vessel.planFor(g);
      g.fire(position.x - size.x / 2, position.y - size.y / 2, position.x,
          size.x, game.world,
          plan: plan);
    }
  }

  @override
  void render(Canvas canvas) {
    final sprite = caster.vessel.currentSprite;
    if (sprite == null) return;
    sprite.render(canvas,
        size: size,
        overridePaint: Paint()
          ..colorFilter = const ColorFilter.mode(
              Color(0x669A7CFF), BlendMode.modulate));
  }
}

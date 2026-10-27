import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flame/components.dart';

import '../game/death_effect_config.dart';
import '../game/tyrian_game.dart';
import '../systems/weapon_family.dart';

/// Particle kinds — selects both motion handling and draw style.
enum _PKind { droplet, glint, flame, ember, spark, plasma }

class _ParticleData {
  double x = 0, y = 0, vx = 0, vy = 0;
  double gravity = 0;
  double damp = 0; // exponential velocity damping per second
  double life = 0, totalLife = 0;
  double size = 0;
  double delay = 0;
  double phase = 0; // per-particle twinkle/flicker offset
  _PKind kind = _PKind.droplet;
  ui.Color colorA = const ui.Color(0xFFFFFFFF);
  ui.Color colorB = const ui.Color(0xFFFFFFFF);
  bool active = false;
}

/// Expanding circle: splash ring (water) or nova ring (plasma).
class _RingData {
  double x = 0, y = 0, r0 = 0, r1 = 0;
  double life = 0, totalLife = 0;
  double strokeW = 0;
  double delay = 0;
  ui.Color color = const ui.Color(0xFFFFFFFF);
  bool fill = false;
  bool active = false;
}

/// Jagged lightning polyline radiating from the death center. Points are
/// reseeded on a timer for the crackle; draw is skipped on alternating
/// reseeds for a hard flicker.
class _ArcData {
  final Float32List pts = Float32List(_deathArcPoints * 2);
  double x = 0, y = 0, len = 0, angle = 0, jitter = 0;
  double life = 0, totalLife = 0, reseedT = 0;
  bool visible = true;
  bool active = false;
}

class _FlashData {
  double x = 0, y = 0, radius = 0;
  double life = 0, totalLife = 0;
  double delay = 0;
  ui.Color color = const ui.Color(0xFFFFFFFF);
  bool active = false;
}

const int _deathArcPoints = 7; // 6 segments
const double _arcReseedInterval = 0.04;

/// Fire color ramp: white → yellow → orange → dark red over particle life.
const _flameRamp = [
  ui.Color(0xFFFFFFFF),
  ui.Color(0xFFFFE082),
  ui.Color(0xFFFF9800),
  ui.Color(0xFF8B1A00),
];

/// Weapon-specific death effects, Diablo-elemental style. One pooled renderer
/// in the ExplosionRenderer idiom: plain-data pools, a single Component,
/// silent skip on pool exhaustion, worldShiftX translate. Two draw passes —
/// srcOver for opaque matter (water droplets), BlendMode.plus for everything
/// that should glow (fire, sparks, arcs, rings, flashes).
class DeathEffectRenderer extends Component with HasGameReference<TyrianGame> {
  static const int particlePoolSize = 320;
  static const int ringPoolSize = 16;
  static const int arcPoolSize = 16;
  static const int flashPoolSize = 16;

  static final _rng = Random();

  final List<_ParticleData> _particles =
      List.generate(particlePoolSize, (_) => _ParticleData());
  final List<_RingData> _rings = List.generate(ringPoolSize, (_) => _RingData());
  final List<_ArcData> _arcs = List.generate(arcPoolSize, (_) => _ArcData());
  final List<_FlashData> _flashes =
      List.generate(flashPoolSize, (_) => _FlashData());

  final ui.Paint _alphaPaint = ui.Paint();
  final ui.Paint _addPaint = ui.Paint()..blendMode = ui.BlendMode.plus;

  double _time = 0;

  int get activeParticleCount => _particles.where((p) => p.active).length;
  int get activeRingCount => _rings.where((r) => r.active).length;
  int get activeArcCount => _arcs.where((a) => a.active).length;
  int get activeFlashCount => _flashes.where((f) => f.active).length;

  /// Spawn the full effect for one death. [w]/[h] is the dying hostile's
  /// rendered size (already carries spriteScale); all geometry derives from it.
  void spawn(WeaponFamily family, double cx, double cy, double w, double h,
      {double hitX = 0, double hitY = 0}) {
    final spec = deathEffectSpecs[family]!;
    final s = max(w, h) * deathEffectScale;
    // Small enemies keep readable effects, big ones scale up.
    final k = (s / 40.0).clamp(0.75, 2.0);

    switch (family) {
      case WeaponFamily.bubble:
        _spawnWater(spec, cx, cy, s, k);
      case WeaponFamily.vulcan:
        _spawnIce(spec, cx, cy, s, k);
      case WeaponFamily.starg:
        _spawnFire(spec, cx, cy, s, k);
      case WeaponFamily.laser:
        _spawnElectric(spec, cx, cy, s, k);
      case WeaponFamily.blaster:
        _spawnPlasma(spec, cx, cy, s, k);
    }

    final flash = _acquireFlash();
    if (flash != null) {
      flash
        ..x = cx
        ..y = cy
        ..radius = s * 0.9
        ..life = spec.flashDuration
        ..totalLife = spec.flashDuration
        ..delay = spec.flashDelay
        ..color = spec.flashColor
        ..active = true;
    }
  }

  // ---- per-family spawners ----

  void _spawnWater(DeathEffectSpec spec, double cx, double cy, double s, double k) {
    for (int i = 0; i < spec.particleCount; i++) {
      final p = _acquireParticle();
      if (p == null) break;
      final angle = _rng.nextDouble() * 2 * pi;
      final speed = 60.0 + _rng.nextDouble() * 100.0;
      final life = 0.45 + _rng.nextDouble() * 0.25;
      p
        ..x = cx
        ..y = cy
        ..vx = cos(angle) * speed
        ..vy = sin(angle) * speed - 60.0 // upward bias, then gravity pulls down
        ..gravity = 350
        ..damp = 0
        ..life = life
        ..totalLife = life
        ..size = (1.5 + _rng.nextDouble() * 2.0) * k
        ..delay = 0
        ..phase = _rng.nextDouble() * 2 * pi
        ..kind = _PKind.droplet
        ..colorA = _rng.nextDouble() < 0.5 ? spec.primary : spec.secondary
        ..active = true;
    }
    // A few additive white glint cores riding the splash.
    for (int i = 0; i < 5; i++) {
      final p = _acquireParticle();
      if (p == null) break;
      final angle = _rng.nextDouble() * 2 * pi;
      final speed = 40.0 + _rng.nextDouble() * 80.0;
      final life = 0.3 + _rng.nextDouble() * 0.2;
      p
        ..x = cx
        ..y = cy
        ..vx = cos(angle) * speed
        ..vy = sin(angle) * speed - 50.0
        ..gravity = 350
        ..damp = 0
        ..life = life
        ..totalLife = life
        ..size = 1.2 * k
        ..delay = 0
        ..phase = _rng.nextDouble() * 2 * pi
        ..kind = _PKind.glint
        ..colorA = const ui.Color(0xFFFFFFFF)
        ..active = true;
    }
    final ring = _acquireRing();
    if (ring != null) {
      ring
        ..x = cx
        ..y = cy
        ..r0 = s * 0.2
        ..r1 = s * 1.1
        ..life = 0.35
        ..totalLife = 0.35
        ..strokeW = 3.0 * k
        ..delay = 0
        ..color = spec.primary
        ..fill = false
        ..active = true;
    }
  }

  void _spawnIce(DeathEffectSpec spec, double cx, double cy, double s, double k) {
    // The shatter itself is carried by the shard preset (heavy falling
    // chunks); here just near-static twinkling glints around the break point.
    for (int i = 0; i < spec.particleCount; i++) {
      final p = _acquireParticle();
      if (p == null) break;
      final angle = _rng.nextDouble() * 2 * pi;
      final dist = _rng.nextDouble() * s * 0.5;
      final life = 0.25 + _rng.nextDouble() * 0.2;
      p
        ..x = cx + cos(angle) * dist
        ..y = cy + sin(angle) * dist
        ..vx = (_rng.nextDouble() - 0.5) * 30
        ..vy = (_rng.nextDouble() - 0.5) * 30
        ..gravity = 0
        ..damp = 0
        ..life = life
        ..totalLife = life
        ..size = (2.0 + _rng.nextDouble() * 2.0) * k
        ..delay = 0
        ..phase = _rng.nextDouble() * 2 * pi
        ..kind = _PKind.glint
        ..colorA = _rng.nextDouble() < 0.5 ? spec.primary : spec.secondary
        ..active = true;
    }
  }

  void _spawnFire(DeathEffectSpec spec, double cx, double cy, double s, double k) {
    for (int i = 0; i < spec.particleCount; i++) {
      final p = _acquireParticle();
      if (p == null) break;
      final angle = _rng.nextDouble() * 2 * pi;
      final speed = 30.0 + _rng.nextDouble() * 60.0;
      final life = 0.4 + _rng.nextDouble() * 0.3;
      p
        ..x = cx + (_rng.nextDouble() - 0.5) * s * 0.4
        ..y = cy + (_rng.nextDouble() - 0.5) * s * 0.4
        ..vx = cos(angle) * speed
        ..vy = sin(angle) * speed
        ..gravity = -120 // buoyancy: flames rise
        ..damp = 2.0
        ..life = life
        ..totalLife = life
        ..size = 3.5 * k
        ..delay = 0
        ..phase = _rng.nextDouble() * 2 * pi
        ..kind = _PKind.flame
        ..active = true;
    }
    for (int i = 0; i < 7; i++) {
      final p = _acquireParticle();
      if (p == null) break;
      final angle = _rng.nextDouble() * 2 * pi;
      final speed = 20.0 + _rng.nextDouble() * 50.0;
      final life = 1.0 + _rng.nextDouble() * 0.4;
      p
        ..x = cx
        ..y = cy
        ..vx = cos(angle) * speed
        ..vy = sin(angle) * speed
        ..gravity = 40
        ..damp = 0
        ..life = life
        ..totalLife = life
        ..size = (1.0 + _rng.nextDouble()) * k
        ..delay = 0
        ..phase = _rng.nextDouble() * 2 * pi
        ..kind = _PKind.ember
        ..colorA = spec.primary
        ..active = true;
    }
  }

  void _spawnElectric(DeathEffectSpec spec, double cx, double cy, double s, double k) {
    for (int i = 0; i < spec.particleCount; i++) {
      final p = _acquireParticle();
      if (p == null) break;
      final angle = _rng.nextDouble() * 2 * pi;
      final speed = 200.0 + _rng.nextDouble() * 150.0;
      final life = 0.15 + _rng.nextDouble() * 0.15;
      p
        ..x = cx
        ..y = cy
        ..vx = cos(angle) * speed
        ..vy = sin(angle) * speed
        ..gravity = 0
        ..damp = 0
        ..life = life
        ..totalLife = life
        ..size = 1.5 * k
        ..delay = 0
        ..phase = _rng.nextDouble() * 2 * pi
        ..kind = _PKind.spark
        ..colorA = spec.primary
        ..active = true;
    }
    final arcCount = 3 + _rng.nextInt(2);
    for (int i = 0; i < arcCount; i++) {
      final arc = _acquireArc();
      if (arc == null) break;
      final life = 0.25 + _rng.nextDouble() * 0.1;
      arc
        ..x = cx
        ..y = cy
        ..len = s * 1.2
        ..angle = _rng.nextDouble() * 2 * pi
        ..jitter = max(4.0, s * 0.12)
        ..life = life
        ..totalLife = life
        ..reseedT = 0
        ..visible = true
        ..active = true;
      _reseedArc(arc);
    }
  }

  void _spawnPlasma(DeathEffectSpec spec, double cx, double cy, double s, double k) {
    // Phase 1: particles converge from a ring onto the center (implosion),
    // timed to arrive at the flashDelay beat.
    final implodeTime = spec.flashDelay;
    for (int i = 0; i < spec.particleCount; i++) {
      final p = _acquireParticle();
      if (p == null) break;
      final angle = (i / spec.particleCount) * 2 * pi +
          (_rng.nextDouble() - 0.5) * 0.4;
      final r = s * 1.2;
      p
        ..x = cx + cos(angle) * r
        ..y = cy + sin(angle) * r
        ..vx = -cos(angle) * (r / implodeTime)
        ..vy = -sin(angle) * (r / implodeTime)
        ..gravity = 0
        ..damp = 0
        ..life = implodeTime
        ..totalLife = implodeTime
        ..size = (1.5 + _rng.nextDouble()) * k
        ..delay = 0
        ..phase = _rng.nextDouble() * 2 * pi
        ..kind = _PKind.plasma
        ..colorA = spec.primary
        ..active = true;
    }
    // Phase 2: outward burst after the beat.
    for (int i = 0; i < 8; i++) {
      final p = _acquireParticle();
      if (p == null) break;
      final angle = _rng.nextDouble() * 2 * pi;
      final speed = 120.0 + _rng.nextDouble() * 120.0;
      final life = 0.3 + _rng.nextDouble() * 0.2;
      p
        ..x = cx
        ..y = cy
        ..vx = cos(angle) * speed
        ..vy = sin(angle) * speed
        ..gravity = 0
        ..damp = 1.5
        ..life = life
        ..totalLife = life
        ..size = (1.5 + _rng.nextDouble()) * k
        ..delay = implodeTime
        ..phase = _rng.nextDouble() * 2 * pi
        ..kind = _PKind.plasma
        ..colorA = spec.secondary
        ..active = true;
    }
    final ring = _acquireRing();
    if (ring != null) {
      ring
        ..x = cx
        ..y = cy
        ..r0 = 0
        ..r1 = s * 1.6
        ..life = 0.4
        ..totalLife = 0.4
        ..strokeW = 2.5 * k
        ..delay = implodeTime
        ..color = spec.primary
        ..fill = false
        ..active = true;
    }
    final fillRing = _acquireRing();
    if (fillRing != null) {
      fillRing
        ..x = cx
        ..y = cy
        ..r0 = 0
        ..r1 = s * 1.3
        ..life = 0.3
        ..totalLife = 0.3
        ..strokeW = 0
        ..delay = implodeTime
        ..color = spec.secondary
        ..fill = true
        ..active = true;
    }
  }

  // ---- pool plumbing ----

  _ParticleData? _acquireParticle() {
    for (final p in _particles) {
      if (!p.active) return p;
    }
    return null; // pool exhausted — skip, same as ExplosionRenderer
  }

  _RingData? _acquireRing() {
    for (final r in _rings) {
      if (!r.active) return r;
    }
    return null;
  }

  _ArcData? _acquireArc() {
    for (final a in _arcs) {
      if (!a.active) return a;
    }
    return null;
  }

  _FlashData? _acquireFlash() {
    for (final f in _flashes) {
      if (!f.active) return f;
    }
    return null;
  }

  void _reseedArc(_ArcData arc) {
    final dx = cos(arc.angle);
    final dy = sin(arc.angle);
    final step = arc.len / (_deathArcPoints - 1);
    for (int i = 0; i < _deathArcPoints; i++) {
      // Root stays anchored at the death center; jitter grows along the bolt.
      final j = i == 0 ? 0.0 : (_rng.nextDouble() - 0.5) * 2 * arc.jitter;
      arc.pts[i * 2] = arc.x + dx * step * i + (-dy) * j;
      arc.pts[i * 2 + 1] = arc.y + dy * step * i + dx * j;
    }
  }

  @override
  void update(double dt) {
    _time += dt;

    for (final p in _particles) {
      if (!p.active) continue;
      if (p.delay > 0) {
        p.delay -= dt;
        continue;
      }
      if (p.damp > 0) {
        final f = exp(-p.damp * dt);
        p.vx *= f;
        p.vy *= f;
      }
      p.vy += p.gravity * dt;
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.life -= dt;
      if (p.life <= 0) p.active = false;
    }

    for (final r in _rings) {
      if (!r.active) continue;
      if (r.delay > 0) {
        r.delay -= dt;
        continue;
      }
      r.life -= dt;
      if (r.life <= 0) r.active = false;
    }

    for (final a in _arcs) {
      if (!a.active) continue;
      a.life -= dt;
      if (a.life <= 0) {
        a.active = false;
        continue;
      }
      a.reseedT += dt;
      if (a.reseedT >= _arcReseedInterval) {
        a.reseedT = 0;
        a.visible = !a.visible; // hard flicker
        if (a.visible) _reseedArc(a);
      }
    }

    for (final f in _flashes) {
      if (!f.active) continue;
      if (f.delay > 0) {
        f.delay -= dt;
        continue;
      }
      f.life -= dt;
      if (f.life <= 0) f.active = false;
    }
  }

  @override
  void render(ui.Canvas canvas) {
    final shift = game.worldShiftX;
    if (shift != 0) {
      canvas.save();
      canvas.translate(shift, 0);
    }

    // Pass 1 — srcOver: opaque matter (water droplets).
    _alphaPaint.style = ui.PaintingStyle.fill;
    for (final p in _particles) {
      if (!p.active || p.delay > 0 || p.kind != _PKind.droplet) continue;
      final t = (p.life / p.totalLife).clamp(0.0, 1.0);
      _alphaPaint.color = p.colorA.withAlpha((t * 255).round().clamp(0, 255));
      canvas.drawCircle(ui.Offset(p.x, p.y), p.size, _alphaPaint);
    }

    // Pass 2 — additive: everything that glows.
    for (final p in _particles) {
      if (!p.active || p.delay > 0) continue;
      final t = (p.life / p.totalLife).clamp(0.0, 1.0);
      switch (p.kind) {
        case _PKind.droplet:
          break; // drawn in pass 1
        case _PKind.glint:
          // Crossed twinkling sparkle.
          final tw = 0.5 + 0.5 * sin(p.phase + _time * 40);
          final a = (t * tw * 0.6 * 255).round().clamp(0, 255);
          _addPaint
            ..style = ui.PaintingStyle.stroke
            ..strokeWidth = 1.2
            ..color = p.colorA.withAlpha(a);
          canvas.drawLine(ui.Offset(p.x - p.size, p.y),
              ui.Offset(p.x + p.size, p.y), _addPaint);
          canvas.drawLine(ui.Offset(p.x, p.y - p.size),
              ui.Offset(p.x, p.y + p.size), _addPaint);
        case _PKind.flame:
          final progress = 1.0 - t;
          final a = (t * 0.6 * 255).round().clamp(0, 255);
          _addPaint
            ..style = ui.PaintingStyle.fill
            ..color = _flameColor(progress).withAlpha(a);
          canvas.drawCircle(
              ui.Offset(p.x, p.y), p.size * (0.15 + 0.85 * t), _addPaint);
        case _PKind.ember:
          final flicker = 0.6 + 0.4 * sin(p.phase + _time * 30);
          final a = (t * flicker * 0.6 * 255).round().clamp(0, 255);
          _addPaint
            ..style = ui.PaintingStyle.fill
            ..color = p.colorA.withAlpha(a);
          canvas.drawCircle(ui.Offset(p.x, p.y), p.size, _addPaint);
        case _PKind.spark:
          // Streak along the velocity vector.
          final a = (t * 0.6 * 255).round().clamp(0, 255);
          _addPaint
            ..style = ui.PaintingStyle.stroke
            ..strokeWidth = p.size
            ..color = p.colorA.withAlpha(a);
          canvas.drawLine(ui.Offset(p.x, p.y),
              ui.Offset(p.x - p.vx * 0.03, p.y - p.vy * 0.03), _addPaint);
        case _PKind.plasma:
          final a = (t * 0.6 * 255).round().clamp(0, 255);
          _addPaint
            ..style = ui.PaintingStyle.fill
            ..color = p.colorA.withAlpha(a);
          canvas.drawCircle(ui.Offset(p.x, p.y), p.size, _addPaint);
      }
    }

    for (final r in _rings) {
      if (!r.active || r.delay > 0) continue;
      final t = 1.0 - (r.life / r.totalLife).clamp(0.0, 1.0);
      final radius = r.r0 + (r.r1 - r.r0) * t;
      final a = ((1.0 - t) * (r.fill ? 0.25 : 0.6) * 255).round().clamp(0, 255);
      if (r.fill) {
        _addPaint
          ..style = ui.PaintingStyle.fill
          ..color = r.color.withAlpha(a);
      } else {
        _addPaint
          ..style = ui.PaintingStyle.stroke
          ..strokeWidth = r.strokeW * (1.0 - 0.66 * t)
          ..color = r.color.withAlpha(a);
      }
      canvas.drawCircle(ui.Offset(r.x, r.y), radius, _addPaint);
    }

    for (final arc in _arcs) {
      if (!arc.active || !arc.visible) continue;
      final t = (arc.life / arc.totalLife).clamp(0.0, 1.0);
      final haloA = (t * 0.45 * 255).round().clamp(0, 255);
      final coreA = (t * 0.6 * 255).round().clamp(0, 255);
      _addPaint
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = const ui.Color(0xFF82B1FF).withAlpha(haloA);
      _drawPolyline(canvas, arc.pts, _addPaint);
      _addPaint
        ..strokeWidth = 1.5
        ..color = const ui.Color(0xFFFFFFFF).withAlpha(coreA);
      _drawPolyline(canvas, arc.pts, _addPaint);
    }

    for (final f in _flashes) {
      if (!f.active || f.delay > 0) continue;
      final t = (f.life / f.totalLife).clamp(0.0, 1.0);
      _addPaint.style = ui.PaintingStyle.fill;
      _addPaint.color =
          const ui.Color(0xFFFFFFFF).withAlpha((t * 0.55 * 255).round());
      canvas.drawCircle(ui.Offset(f.x, f.y), f.radius * 0.35, _addPaint);
      _addPaint.color = f.color.withAlpha((t * 0.35 * 255).round());
      canvas.drawCircle(ui.Offset(f.x, f.y), f.radius * 0.7, _addPaint);
      _addPaint.color = f.color.withAlpha((t * 0.18 * 255).round());
      canvas.drawCircle(ui.Offset(f.x, f.y), f.radius, _addPaint);
    }

    if (shift != 0) canvas.restore();
  }

  void _drawPolyline(ui.Canvas canvas, Float32List pts, ui.Paint paint) {
    for (int i = 0; i < _deathArcPoints - 1; i++) {
      canvas.drawLine(ui.Offset(pts[i * 2], pts[i * 2 + 1]),
          ui.Offset(pts[i * 2 + 2], pts[i * 2 + 3]), paint);
    }
  }

  ui.Color _flameColor(double progress) {
    final scaled = progress.clamp(0.0, 1.0) * (_flameRamp.length - 1);
    final i = scaled.floor().clamp(0, _flameRamp.length - 2);
    return ui.Color.lerp(_flameRamp[i], _flameRamp[i + 1], scaled - i)!;
  }

  /// Deactivate everything (used on sector clear).
  void clearAll() {
    for (final p in _particles) {
      p.active = false;
    }
    for (final r in _rings) {
      r.active = false;
    }
    for (final a in _arcs) {
      a.active = false;
    }
    for (final f in _flashes) {
      f.active = false;
    }
  }
}

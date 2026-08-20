import 'dart:math' show pi;
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/game_config.dart' as config;
import '../game/tyrian_game.dart';
import '../entities/hostile.dart';
import '../entities/projectile.dart';
import '../entities/structure.dart';
import '../systems/fleet.dart';
/// Renders all entities of a given type in batched draw calls using
/// [Canvas.drawAtlas]. Each unique source [ui.Image] becomes one draw call.
///
/// Entities keep their PositionComponent for update/collision logic, but their
/// render() is a no-op. This renderer reads positions from the game's active
/// entity lists and draws everything in bulk.

/// Shared paint for all gameplay sprite batches. Its [Paint.filterQuality]
/// follows the active skin via [config.spriteFilterQuality], refreshed on each
/// access so a skin switch takes effect immediately.
final Paint _spriteBatchPaint = Paint();

// ---------------------------------------------------------------------------
// Internal: per-image atlas batch
// ---------------------------------------------------------------------------
class _AtlasBatch {
  _AtlasBatch(this.image);

  final ui.Image image;
  final List<ui.RSTransform> transforms = [];
  final List<ui.Rect> sources = [];
  final List<ui.Color> colors = [];

  void clear() {
    transforms.length = 0;
    sources.length = 0;
    colors.length = 0;
  }

  void add(ui.Rect src, double x, double y, double scaleX, double scaleY,
      [ui.Color? color]) {
    // RSTransform: scos, ssin, tx, ty. No rotation, uniform scale (scos = scaleX,
    // ssin = 0). drawAtlas maps the source rect's *top-left* to (tx, ty) — it does
    // NOT anchor at the center — so for top-left placement tx = x, ty = y with no
    // half-size compensation. (The previous +src.width/2 shift pushed every sprite
    // down-right by half its size, off its hitbox; the glow then looked off-center.)
    transforms.add(ui.RSTransform(
      scaleX,
      0,
      x,
      y,
    ));
    sources.add(src);
    colors.add(color ?? _white);
  }

  void addRotated(ui.Rect src, double centerX, double centerY,
      double scale, double rotation, [ui.Color? color]) {
    transforms.add(ui.RSTransform.fromComponents(
      rotation: rotation,
      scale: scale,
      anchorX: src.width / 2,
      anchorY: src.height / 2,
      translateX: centerX,
      translateY: centerY,
    ));
    sources.add(src);
    colors.add(color ?? _white);
  }

  static const _white = ui.Color(0xFFFFFFFF);

  bool get isEmpty => transforms.isEmpty;

  void render(Canvas canvas, Paint paint) {
    if (isEmpty) return;
    canvas.drawAtlas(
      image,
      transforms,
      sources,
      colors,
      BlendMode.modulate,
      null, // cullRect
      paint,
    );
  }
}

// ---------------------------------------------------------------------------
// Hostile batch renderer
// ---------------------------------------------------------------------------
class HostileBatchRenderer extends Component
    with HasGameReference<TyrianGame> {
  final Map<ui.Image, _AtlasBatch> _batches = {};
  Paint get _paint => _spriteBatchPaint..filterQuality = config.spriteFilterQuality;
  final Paint _hpBgPaint = Paint()..color = const Color(0x80000000);

  static const _hitColor = Color(0xFFFF8888);
  static const _normalColor = Color(0xFFFFFFFF);

  @override
  void render(Canvas canvas) {
    // Banking world shift — render-only, entity/collision positions untouched
    final shift = game.worldShiftX;
    if (shift != 0) {
      canvas.save();
      canvas.translate(shift, 0);
    }

    // Clear batches
    for (final b in _batches.values) {
      b.clear();
    }

    // Collect from fleets (host mode / solo)
    for (final fleet in game.activeFleets) {
      for (final h in fleet.hostiles) {
        _addHostile(h);
      }
    }

    // Collect from client cache (client mode)
    for (final h in game.clientHostiles.values) {
      _addHostile(h);
    }

    // Draw all batches
    for (final b in _batches.values) {
      b.render(canvas, _paint);
    }

    // Second pass: HP bars for damaged hostiles
    _renderHpBars(canvas, game.activeFleets);
    for (final h in game.clientHostiles.values) {
      if (!h.isDead && h.hp < h.hpMax) {
        _drawHpBar(canvas, h);
      }
    }

    if (shift != 0) canvas.restore();
  }

  void _addHostile(Hostile h) {
    if (h.isDead) return;
    final sprite = h.sprite;
    if (sprite == null) return;

    final image = sprite.image;
    final batch = _batches.putIfAbsent(image, () => _AtlasBatch(image));
    // Generator produces sprites nose-up; rotate 180° so enemies face the player.
    batch.addRotated(
      sprite.src,
      h.position.x + h.size.x / 2,
      h.position.y + h.size.y / 2,
      // Visual depth pulse: scales about the sprite centre, so the hitbox
      // (h.size / h.position) is unaffected.
      h.size.x / sprite.srcSize.x * h.visualScale,
      pi,
      h.hit > 0 ? _hitColor : _normalColor,
    );
  }

  void _renderHpBars(Canvas canvas, List<Fleet> fleets) {
    for (final fleet in fleets) {
      for (final h in fleet.hostiles) {
        if (h.isDead || h.hp >= h.hpMax) continue;
        _drawHpBar(canvas, h);
      }
    }
  }

  void _drawHpBar(Canvas canvas, Hostile h) {
    const barHeight = 3.0;
    const barOffset = 4.0;
    final barWidth = h.size.x;
    final hpRatio = h.hp / h.hpMax;

    final left = h.position.x;
    final top = h.position.y - barOffset - barHeight;

    // Background
    canvas.drawRect(
      Rect.fromLTWH(left, top, barWidth, barHeight),
      _hpBgPaint,
    );

    // HP fill
    final color = hpRatio > 0.5
        ? const Color(0xFF00FF00)
        : hpRatio > 0.25
            ? const Color(0xFFFFFF00)
            : const Color(0xFFFF0000);
    canvas.drawRect(
      Rect.fromLTWH(left, top, barWidth * hpRatio, barHeight),
      Paint()..color = color,
    );
  }
}

// ---------------------------------------------------------------------------
// Projectile batch renderer
// ---------------------------------------------------------------------------
class ProjectileBatchRenderer extends Component
    with HasGameReference<TyrianGame> {
  final Map<ui.Image, _AtlasBatch> _batches = {};
  Paint get _paint => _spriteBatchPaint..filterQuality = config.spriteFilterQuality;

  @override
  void render(Canvas canvas) {
    final shift = game.worldShiftX;
    if (shift != 0) {
      canvas.save();
      canvas.translate(shift, 0);
    }

    for (final b in _batches.values) {
      b.clear();
    }

    // Player projectiles (from vessel devices)
    for (final v in game.allVessels) {
      for (final d in v.devices) {
        for (final p in d.projectiles) {
          _addProjectile(p);
        }
      }
    }

    // Enemy projectiles
    for (final p in game.enemyProjectiles) {
      _addProjectile(p);
    }

    // Client-side player projectiles
    for (final p in game.clientPlayerProjectiles) {
      _addProjectile(p);
    }

    for (final b in _batches.values) {
      b.render(canvas, _paint);
    }

    if (shift != 0) canvas.restore();
  }

  void _addProjectile(Projectile p) {
    if (!p.active) return;
    final sprite = p.sprite;
    if (sprite == null) return;

    final image = sprite.image;
    final batch = _batches.putIfAbsent(image, () => _AtlasBatch(image));
    batch.add(
      sprite.src,
      p.position.x,
      p.position.y,
      p.size.x / sprite.srcSize.x,
      p.size.y / sprite.srcSize.y,
    );
  }
}

// ---------------------------------------------------------------------------
// Structure batch renderer
// ---------------------------------------------------------------------------
class StructureBatchRenderer extends Component
    with HasGameReference<TyrianGame> {
  final Map<ui.Image, _AtlasBatch> _batches = {};
  Paint get _paint => _spriteBatchPaint..filterQuality = config.spriteFilterQuality;

  @override
  void render(Canvas canvas) {
    final shift = game.worldShiftX;
    if (shift != 0) {
      canvas.save();
      canvas.translate(shift, 0);
    }

    for (final b in _batches.values) {
      b.clear();
    }

    for (final s in game.activeStructures) {
      _addStructure(s);
    }

    for (final s in game.clientStructures.values) {
      _addStructure(s);
    }

    for (final b in _batches.values) {
      b.render(canvas, _paint);
    }

    if (shift != 0) canvas.restore();
  }

  void _addStructure(Structure s) {
    if (s.isDead) return;
    final sprite = s.sprite;
    if (sprite == null) return;

    final image = sprite.image;
    final batch = _batches.putIfAbsent(image, () => _AtlasBatch(image));
    batch.add(
      sprite.src,
      s.position.x,
      s.position.y,
      s.size.x / sprite.srcSize.x,
      s.size.y / sprite.srcSize.y,
    );
  }
}

// ---------------------------------------------------------------------------
// Shard batch renderer — sprite shatter destruction effect
// ---------------------------------------------------------------------------
class ShardBatchRenderer extends Component
    with HasGameReference<TyrianGame> {
  final Map<ui.Image, _AtlasBatch> _batches = {};
  Paint get _paint => _spriteBatchPaint..filterQuality = config.spriteFilterQuality;

  @override
  void render(Canvas canvas) {
    final shift = game.worldShiftX;
    if (shift != 0) {
      canvas.save();
      canvas.translate(shift, 0);
    }

    for (final b in _batches.values) {
      b.clear();
    }

    for (final shard in game.shardPool.shards) {
      if (!shard.active || shard.image == null) continue;

      final image = shard.image!;
      final batch = _batches.putIfAbsent(image, () => _AtlasBatch(image));

      final cx = shard.x + shard.sourceRect.width * shard.scale / 2;
      final cy = shard.y + shard.sourceRect.height * shard.scale / 2;

      batch.addRotated(
        shard.sourceRect,
        cx,
        cy,
        shard.scale,
        shard.rotation,
        shard.tint.withAlpha((shard.alpha * 255).round().clamp(0, 255)),
      );
    }

    for (final b in _batches.values) {
      b.render(canvas, _paint);
    }

    if (shift != 0) canvas.restore();
  }
}

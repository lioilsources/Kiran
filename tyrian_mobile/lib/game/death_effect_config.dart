import 'dart:ui';

import '../systems/weapon_family.dart';

/// Per-family corpse behavior: tint and physics applied to the dying enemy's
/// sprite shards (Voronoi fragments / quad slices).
class ShardPreset {
  final Color tint;
  final double gravity;
  final double speedMult;
  final double lifeMult;
  final double spinMult;

  /// Ice chunks keep their size while fading; everything else shrinks.
  final bool shrink;

  const ShardPreset({
    this.tint = const Color(0xFFFFFFFF),
    this.gravity = 10,
    this.speedMult = 1.0,
    this.lifeMult = 1.0,
    this.spinMult = 1.0,
    this.shrink = true,
  });
}

/// Palette and tuning for one weapon family's death effect. All effect
/// geometry derives from the dying hostile's size, so specs carry no absolute
/// pixel values tied to sprites.
class DeathEffectSpec {
  final Color primary;
  final Color secondary;
  final Color flashColor;
  final int particleCount;
  final double flashDuration;

  /// Blaster's implosion beat: the flash (and nova ring) fire this many
  /// seconds after the death, once the inward particles converge.
  final double flashDelay;
  final ShardPreset shardPreset;

  const DeathEffectSpec({
    required this.primary,
    required this.secondary,
    required this.flashColor,
    required this.particleCount,
    this.flashDuration = 0.12,
    this.flashDelay = 0,
    this.shardPreset = const ShardPreset(),
  });
}

/// Exact current shard behavior — generic (non-weapon) deaths stay
/// pixel-identical to before.
const ShardPreset defaultShardPreset = ShardPreset();

/// Global size knob for all weapon-death effects.
const double deathEffectScale = 1.0;

const Map<WeaponFamily, DeathEffectSpec> deathEffectSpecs = {
  // Water splash: blue droplets arcing under heavy gravity + splash ring.
  WeaponFamily.bubble: DeathEffectSpec(
    primary: Color(0xFF4FC3F7),
    secondary: Color(0xFF0288D1),
    flashColor: Color(0xFF81D4FA),
    particleCount: 16,
    flashDuration: 0.10,
    shardPreset: ShardPreset(
      tint: Color(0xFF9FD8FF),
      gravity: 300,
      lifeMult: 0.8,
    ),
  ),
  // Ice shatter: the corpse itself carries the effect — heavy crystalline
  // chunks that fall without shrinking, plus a few sparkle glints.
  WeaponFamily.vulcan: DeathEffectSpec(
    primary: Color(0xFFBFE8FF),
    secondary: Color(0xFFFFFFFF),
    flashColor: Color(0xFFE0F7FF),
    particleCount: 8,
    flashDuration: 0.10,
    shardPreset: ShardPreset(
      tint: Color(0xFFCFEFFF),
      gravity: 500,
      spinMult: 0.4,
      lifeMult: 1.2,
      shrink: false,
    ),
  ),
  // Fire: rising additive flames + slow flickering embers.
  WeaponFamily.starg: DeathEffectSpec(
    primary: Color(0xFFFFB300),
    secondary: Color(0xFFFF5722),
    flashColor: Color(0xFFFFA726),
    particleCount: 20,
    flashDuration: 0.12,
    shardPreset: ShardPreset(
      tint: Color(0xFFFF9966),
      gravity: -60,
      speedMult: 0.7,
    ),
  ),
  // Electric impulse: jagged flickering arcs + fast spark streaks.
  WeaponFamily.laser: DeathEffectSpec(
    primary: Color(0xFFCFE0FF),
    secondary: Color(0xFF82B1FF),
    flashColor: Color(0xFFB3CCFF),
    particleCount: 9,
    flashDuration: 0.08,
    shardPreset: ShardPreset(
      tint: Color(0xFFDDE8FF),
      speedMult: 1.3,
      lifeMult: 0.6,
      spinMult: 2.0,
    ),
  ),
  // Plasma: implosion beat, then burst + nova ring.
  WeaponFamily.blaster: DeathEffectSpec(
    primary: Color(0xFFE040FB),
    secondary: Color(0xFF7C4DFF),
    flashColor: Color(0xFFEA80FC),
    particleCount: 11,
    flashDuration: 0.14,
    flashDelay: 0.12,
    shardPreset: ShardPreset(
      tint: Color(0xFFDDA0FF),
      speedMult: 1.1,
    ),
  ),
};

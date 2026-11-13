import 'package:flame/components.dart';

import 'game_config.dart' as config;
import 'platform_config.dart' as platform;

/// The duel's directions in game space (Prompts/30 §3).
///
/// A duel never moves the camera or reframes the field: the screen shows the
/// same 600 × gameHeight rectangle it always does, turned by the camera.
/// What changes is only what counts as forward. Every screen direction of
/// the arena is derived here from [platform.screenToGame], so no other file
/// writes one as a literal.

/// The angle that stands nose-up art upright on screen; also the duel's
/// default heading. Text and pickups already rotate their canvas by it.
double get uprightAngle =>
    platform.isLandscape ? platform.landscapeCameraAngle : 0;

/// Screen-normalised duel coordinates, u 0..1 left to right and v 0..1 top
/// to bottom, as a point of the field.
Vector2 duelToGame(double u, double v) {
  if (!platform.isLandscape) {
    return Vector2(u * config.gameWidth, v * config.gameHeight);
  }
  return Vector2((1 - v) * config.gameWidth, u * config.gameHeight);
}

/// The inverse of [duelToGame].
(double u, double v) gameToDuel(double gx, double gy) {
  if (!platform.isLandscape) {
    return (gx / config.gameWidth, gy / config.gameHeight);
  }
  return (gy / config.gameHeight, 1 - gx / config.gameWidth);
}

Vector2 _dir(double sx, double sy) {
  final (gx, gy) = platform.screenToGame(sx, sy);
  return Vector2(gx, gy);
}

/// Unit directions on screen, in game space.
Vector2 get duelUp => _dir(0, -1);
Vector2 get duelDown => _dir(0, 1);
Vector2 get duelRight => _dir(1, 0);
Vector2 get duelLeft => _dir(-1, 0);

/// Width and height of the arena as the player sees it.
double get duelWidth =>
    platform.isLandscape ? config.gameHeight : config.gameWidth;
double get duelHeight =>
    platform.isLandscape ? config.gameWidth : config.gameHeight;

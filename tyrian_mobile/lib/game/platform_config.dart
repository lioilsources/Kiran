import 'dart:io';
import 'dart:math' show pi;

/// Platform detection — resolved once at startup.
final bool isDesktop =
    Platform.isMacOS || Platform.isWindows || Platform.isLinux;

/// Desktop always runs landscape; mobile always portrait.
final bool isLandscape = isDesktop;

/// Camera angle in landscape. The camera shows the portrait field turned a
/// quarter counter-clockwise, so game UP (the way the ship flies) renders as
/// screen LEFT: the ship sits on the right and flies right to left, enemies
/// come in from the left edge. Components drawing upright text or icons in
/// the world rotate their canvas by this angle to cancel it.
const double landscapeCameraAngle = pi / 2;

/// A screen-space direction (x right, y down — stick, keys) in game space,
/// for a camera turned [landscape]. The camera renders the world turned by
/// -[landscapeCameraAngle], so screen LEFT is game UP and screen DOWN is game
/// LEFT: a stick pushed left flies the ship forward.
(double, double) screenToGame(double sx, double sy, {bool? landscape}) {
  if (!(landscape ?? isLandscape)) return (sx, sy);
  return (-sy, sx);
}

/// The inverse of [screenToGame]: where a game-space direction points on
/// screen. The sigil pad uses it to draw ship-space strokes where the thumb
/// made them.
(double, double) gameToScreen(double gx, double gy, {bool? landscape}) {
  if (!(landscape ?? isLandscape)) return (gx, gy);
  return (gy, -gx);
}

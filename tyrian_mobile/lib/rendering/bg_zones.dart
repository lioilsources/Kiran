import 'dart:ui' as ui;

/// Per-zone parallax art selection and the late-game escalation tint.
///
/// Zones 0..6 map 1:1 onto the seven hand-scripted sectors in
/// lib/systems/sector.dart (System Perimeter .. Sector 7 — Unknown Space).
/// Sector 7 and beyond are procedurally generated, reuse zone 6's art, and keep
/// escalating through [tintFor] instead of through new art.
///
/// This is presentation only — nothing here feeds gameplay. It sits next to
/// [ShaderConfig] and [UiTheme], the other two skin/level-keyed style tables.
abstract final class BgZones {
  /// Number of authored art zones. Must match `backgroundZones` in
  /// pipeline/internal/generator/assets.go.
  static const int count = 7;

  /// Art zone for a sector index, clamped past the last authored zone.
  static int forSector(int sectorIndex) {
    if (sectorIndex <= 0) return 0;
    return sectorIndex >= count ? count - 1 : sectorIndex;
  }

  /// Art zone for a 1-based difficulty level. This is the mapping callers
  /// should use — sector *index* stopped being a proxy for level once levels
  /// could be split into several shorter sectors.
  static int forLevel(int level) => forSector(level - 1);

  /// Multiplicative tint for the parallax layers at [level] (1-based, so
  /// `level == sectorIndex + 1`). Returns null for levels 1..7, whose mood is
  /// baked into the art — the colour filter is cleared entirely there.
  ///
  /// From level 8 the tint becomes the progression signal: green and blue are
  /// pulled down while red is held, so the sky runs progressively hotter and
  /// darker, saturating at level 19 (RGB 255,140,89 — ember red, still readable
  /// behind sprites). Because this is a paint filter rather than art, every
  /// skin gets the escalation, including those still on flat single-zone art.
  ///
  /// This composes multiplicatively with the per-skin [ShaderConfig] tint, which
  /// is applied much later over the whole frame in the post-process pass. Do NOT
  /// feed level into ShaderPipeline.configure() — that would apply the
  /// escalation twice and drag the sprites and HUD along with it.
  static ui.Color? tintFor(int level) {
    if (level <= count) return null;
    final t = ((level - count) / 12.0).clamp(0.0, 1.0);
    return ui.Color.fromARGB(
      255,
      255,
      (255 * (1.0 - 0.45 * t)).round(),
      (255 * (1.0 - 0.65 * t)).round(),
    );
  }
}

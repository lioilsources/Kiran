import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Per-skin visual theme for ComCenter UI.
/// Colors are derived from each skin's art direction / shader tint.
/// [cornerRadius] is 0 for pixel-art skins, 6 for smooth/modern skins.
/// [applyFont] wraps a TextStyle with the skin's Google Font (nullable = system font).
class UiTheme {
  final Color accent;
  final Color accentDim;
  final Color surfaceDark;
  final Color surfaceMid;
  final Color surfaceLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color danger;
  final Color success;
  final Color upgrade;
  final double cornerRadius;
  final TextStyle Function(TextStyle)? applyFont;

  /// Rendered-size compensation for the skin's font. Nominal font sizes are
  /// tuned for a "normal" face; VT323 is condensed and reads a third smaller
  /// at the same size, while Press Start 2P is enormous and wide. Scaling here
  /// fixes every styled() call site at once instead of chasing them one by one.
  final double fontScale;

  const UiTheme({
    required this.accent,
    required this.accentDim,
    required this.surfaceDark,
    required this.surfaceMid,
    required this.surfaceLight,
    this.textPrimary = Colors.white,
    this.textSecondary = const Color(0xFFAAAAAA),
    required this.danger,
    required this.success,
    required this.upgrade,
    required this.cornerRadius,
    this.applyFont,
    this.fontScale = 1.0,
  });

  /// Returns a TextStyle optionally wrapped in the skin's Google Font, with
  /// the size compensated for how large that font actually renders.
  TextStyle styled(TextStyle base) {
    final scaled = base.fontSize == null
        ? base
        : base.copyWith(fontSize: base.fontSize! * fontScale);
    return applyFont?.call(scaled) ?? scaled;
  }

  static UiTheme forSkin(String skinId) =>
      _themes[skinId] ?? _themes['default']!;

  static final Map<String, UiTheme> _themes = {
    'space_invaders': UiTheme(
      accent:       const Color(0xFF00FF44),
      accentDim:    const Color(0xFF004411),
      surfaceDark:  const Color(0xFF000800),
      surfaceMid:   const Color(0xFF001505),
      surfaceLight: const Color(0xFF002A0A),
      danger:   const Color(0xFFFF3300),
      success:  const Color(0xFF00FF44),
      upgrade:  const Color(0xFF44FF88),
      cornerRadius: 0.0,
      applyFont: (s) => GoogleFonts.pressStart2p(textStyle: s),
      fontScale: 0.8,
    ),
    'asteroids': UiTheme(
      accent:       const Color(0xFF44FF44),
      accentDim:    const Color(0xFF1A441A),
      surfaceDark:  const Color(0xFF020A02),
      surfaceMid:   const Color(0xFF041504),
      surfaceLight: const Color(0xFF082808),
      danger:   const Color(0xFFFF4400),
      success:  const Color(0xFF44FF44),
      upgrade:  const Color(0xFF88FF88),
      cornerRadius: 0.0,
      applyFont: (s) => GoogleFonts.shareTechMono(textStyle: s),
    ),
    'galaga': UiTheme(
      accent:       const Color(0xFF4488FF),
      accentDim:    const Color(0xFF112244),
      surfaceDark:  const Color(0xFF000010),
      surfaceMid:   const Color(0xFF050520),
      surfaceLight: const Color(0xFF0A0A38),
      danger:   const Color(0xFFFF4444),
      success:  const Color(0xFF44FF88),
      upgrade:  const Color(0xFFFFEE44),
      cornerRadius: 0.0,
      applyFont: (s) => GoogleFonts.vt323(textStyle: s),
      fontScale: 1.35,
    ),
    'rtype': UiTheme(
      accent:       const Color(0xFF44FFCC),
      accentDim:    const Color(0xFF114433),
      surfaceDark:  const Color(0xFF001010),
      surfaceMid:   const Color(0xFF001E1E),
      surfaceLight: const Color(0xFF003333),
      danger:   const Color(0xFFFF4422),
      success:  const Color(0xFF44FFCC),
      upgrade:  const Color(0xFF88FFEE),
      cornerRadius: 6.0,
      applyFont: (s) => GoogleFonts.shareTechMono(textStyle: s),
    ),
    'blazing_lazers': UiTheme(
      accent:       const Color(0xFFFF6633),
      accentDim:    const Color(0xFF441A0A),
      surfaceDark:  const Color(0xFF080200),
      surfaceMid:   const Color(0xFF160500),
      surfaceLight: const Color(0xFF280A00),
      danger:   const Color(0xFFFF2200),
      success:  const Color(0xFF44FF88),
      upgrade:  const Color(0xFFFFCC44),
      cornerRadius: 6.0,
      applyFont: (s) => GoogleFonts.shareTechMono(textStyle: s),
    ),
    'tyrian_dos': UiTheme(
      accent:       const Color(0xFFFFCC44),
      accentDim:    const Color(0xFF443311),
      surfaceDark:  const Color(0xFF0F0A02),
      surfaceMid:   const Color(0xFF1A1204),
      surfaceLight: const Color(0xFF2A1E08),
      danger:   const Color(0xFFFF4422),
      success:  const Color(0xFF88FF44),
      upgrade:  const Color(0xFFFFCC44),
      cornerRadius: 0.0,
      applyFont: (s) => GoogleFonts.vt323(textStyle: s),
      fontScale: 1.35,
    ),
    'ikaruga': UiTheme(
      accent:       const Color(0xFF8888FF),
      accentDim:    const Color(0xFF222244),
      surfaceDark:  const Color(0xFF02040A),
      surfaceMid:   const Color(0xFF080A18),
      surfaceLight: const Color(0xFF10142C),
      danger:   const Color(0xFFFF4466),
      success:  const Color(0xFF88FFCC),
      upgrade:  const Color(0xFF8888FF),
      cornerRadius: 6.0,
      applyFont: (s) => GoogleFonts.shareTechMono(textStyle: s),
    ),
    'geometry_wars': UiTheme(
      accent:       const Color(0xFF00FFFF),
      accentDim:    const Color(0xFF004444),
      surfaceDark:  const Color(0xFF000A10),
      surfaceMid:   const Color(0xFF00141E),
      surfaceLight: const Color(0xFF002030),
      danger:   const Color(0xFFFF2266),
      success:  const Color(0xFF44FF88),
      upgrade:  const Color(0xFF00FFFF),
      cornerRadius: 6.0,
      applyFont: (s) => GoogleFonts.shareTechMono(textStyle: s),
    ),
    'gradius_v': UiTheme(
      accent:       const Color(0xFF44AAFF),
      accentDim:    const Color(0xFF112233),
      surfaceDark:  const Color(0xFF000410),
      surfaceMid:   const Color(0xFF040A1E),
      surfaceLight: const Color(0xFF081430),
      danger:   const Color(0xFFFF4422),
      success:  const Color(0xFF44FF88),
      upgrade:  const Color(0xFF44AAFF),
      cornerRadius: 6.0,
      applyFont: (s) => GoogleFonts.shareTechMono(textStyle: s),
    ),
    // ---- v3.0 skins ----------------------------------------------------
    // accent/danger/success/upgrade come straight from each skin's
    // PaletteDescription in pipeline/internal/skin/definitions.go, so the
    // ComCenter matches the art it is framing. cornerRadius 0 for the
    // pixel-art eras, 6 for the illustrated ones.
    'tempest': UiTheme(
      accent:       const Color(0xFF40E0FF),
      accentDim:    const Color(0xFF0A3844),
      surfaceDark:  const Color(0xFF000000),
      surfaceMid:   const Color(0xFF060A0C),
      surfaceLight: const Color(0xFF0C1418),
      danger:   const Color(0xFFFF2040),
      success:  const Color(0xFF80FF40),
      upgrade:  const Color(0xFFFFE500),
      cornerRadius: 0.0,
      applyFont: (s) => GoogleFonts.shareTechMono(textStyle: s),
    ),
    'zaxxon': UiTheme(
      accent:       const Color(0xFFF0D040),
      accentDim:    const Color(0xFF3A3410),
      surfaceDark:  const Color(0xFF101820),
      surfaceMid:   const Color(0xFF1A2430),
      surfaceLight: const Color(0xFF2A3644),
      danger:   const Color(0xFFB03030),
      success:  const Color(0xFF60A060),
      upgrade:  const Color(0xFF4060A0),
      cornerRadius: 0.0,
      applyFont: (s) => GoogleFonts.pressStart2p(textStyle: s),
      fontScale: 0.8,
    ),
    'twinbee': UiTheme(
      accent:       const Color(0xFF40A0FF),
      accentDim:    const Color(0xFF10304C),
      surfaceDark:  const Color(0xFF0A1826),
      surfaceMid:   const Color(0xFF12283E),
      surfaceLight: const Color(0xFF1C3A58),
      danger:   const Color(0xFFFF3040),
      success:  const Color(0xFF60E0A0),
      upgrade:  const Color(0xFFFFE040),
      cornerRadius: 6.0,
      applyFont: (s) => GoogleFonts.bungee(textStyle: s),
    ),
    'fantasy_zone': UiTheme(
      accent:       const Color(0xFFFF9AD0),
      accentDim:    const Color(0xFF4A2C3C),
      surfaceDark:  const Color(0xFF201824),
      surfaceMid:   const Color(0xFF302438),
      surfaceLight: const Color(0xFF44344E),
      danger:   const Color(0xFFFF6080),
      success:  const Color(0xFFA0F0D0),
      upgrade:  const Color(0xFFFFF0A0),
      cornerRadius: 6.0,
      applyFont: (s) => GoogleFonts.fredoka(textStyle: s),
    ),
    'abadox': UiTheme(
      accent:       const Color(0xFFA02020),
      accentDim:    const Color(0xFF340A0A),
      surfaceDark:  const Color(0xFF080404),
      surfaceMid:   const Color(0xFF160808),
      surfaceLight: const Color(0xFF260E0E),
      danger:   const Color(0xFFE04040),
      success:  const Color(0xFF80A030),
      upgrade:  const Color(0xFFE8D8C0),
      cornerRadius: 0.0,
      applyFont: (s) => GoogleFonts.vt323(textStyle: s),
      fontScale: 1.35,
    ),
    'solar_striker': UiTheme(
      accent:       const Color(0xFF8BAC0F),
      accentDim:    const Color(0xFF1E3A1E),
      surfaceDark:  const Color(0xFF0F380F),
      surfaceMid:   const Color(0xFF164716),
      surfaceLight: const Color(0xFF306230),
      danger:   const Color(0xFF9BBC0F),
      success:  const Color(0xFF9BBC0F),
      upgrade:  const Color(0xFF8BAC0F),
      textPrimary:   const Color(0xFF9BBC0F),
      textSecondary: const Color(0xFF8BAC0F),
      cornerRadius: 0.0,
      applyFont: (s) => GoogleFonts.pressStart2p(textStyle: s),
      fontScale: 0.8,
    ),
    'axelay': UiTheme(
      accent:       const Color(0xFF3060A0),
      accentDim:    const Color(0xFF0E1C30),
      surfaceDark:  const Color(0xFF06080C),
      surfaceMid:   const Color(0xFF12181F),
      surfaceLight: const Color(0xFF232C36),
      danger:   const Color(0xFFFF7020),
      success:  const Color(0xFF9AA4B0),
      upgrade:  const Color(0xFFFF7020),
      cornerRadius: 0.0,
      applyFont: (s) => GoogleFonts.rajdhani(textStyle: s),
    ),
    'thunder_force': UiTheme(
      accent:       const Color(0xFFA0D0FF),
      accentDim:    const Color(0xFF10203C),
      surfaceDark:  const Color(0xFF040A20),
      surfaceMid:   const Color(0xFF0A1436),
      surfaceLight: const Color(0xFF16224E),
      danger:   const Color(0xFFE040A0),
      success:  const Color(0xFF2050C0),
      upgrade:  const Color(0xFFFF8000),
      cornerRadius: 0.0,
      applyFont: (s) => GoogleFonts.orbitron(textStyle: s),
    ),
    'star_fox': UiTheme(
      accent:       const Color(0xFF3050D0),
      accentDim:    const Color(0xFF101838),
      surfaceDark:  const Color(0xFF000000),
      surfaceMid:   const Color(0xFF0C0C12),
      surfaceLight: const Color(0xFF1A1A24),
      danger:   const Color(0xFFD03030),
      success:  const Color(0xFF30A050),
      upgrade:  const Color(0xFFE0C030),
      cornerRadius: 6.0,
      applyFont: (s) => GoogleFonts.exo2(textStyle: s),
    ),
    'lords_of_thunder': UiTheme(
      accent:       const Color(0xFFD8A030),
      accentDim:    const Color(0xFF3C2C0C),
      surfaceDark:  const Color(0xFF1A1A22),
      surfaceMid:   const Color(0xFF242430),
      surfaceLight: const Color(0xFF343442),
      danger:   const Color(0xFFB01020),
      success:  const Color(0xFF60C0FF),
      upgrade:  const Color(0xFFFF6010),
      cornerRadius: 6.0,
      applyFont: (s) => GoogleFonts.cinzel(textStyle: s),
    ),
    'luftrausers': UiTheme(
      accent:       const Color(0xFFFF9944),
      accentDim:    const Color(0xFF442211),
      surfaceDark:  const Color(0xFF0A0600),
      surfaceMid:   const Color(0xFF180E00),
      surfaceLight: const Color(0xFF281800),
      danger:   const Color(0xFFFF3300),
      success:  const Color(0xFF88FF44),
      upgrade:  const Color(0xFFFFCC44),
      cornerRadius: 6.0,
      applyFont: (s) => GoogleFonts.shareTechMono(textStyle: s),
    ),
    'nuclear_throne': UiTheme(
      accent:       const Color(0xFFFF8800),
      accentDim:    const Color(0xFF442200),
      surfaceDark:  const Color(0xFF0A0600),
      surfaceMid:   const Color(0xFF160900),
      surfaceLight: const Color(0xFF241200),
      danger:   const Color(0xFFFF2200),
      success:  const Color(0xFF88FF44),
      upgrade:  const Color(0xFFFF8800),
      cornerRadius: 0.0,
      applyFont: (s) => GoogleFonts.shareTechMono(textStyle: s),
    ),
    'nex_machina': UiTheme(
      accent:       const Color(0xFFFF4444),
      accentDim:    const Color(0xFF441111),
      surfaceDark:  const Color(0xFF050005),
      surfaceMid:   const Color(0xFF0E000E),
      surfaceLight: const Color(0xFF1A001A),
      danger:   const Color(0xFFFF2200),
      success:  const Color(0xFF44FF88),
      upgrade:  const Color(0xFFFF8844),
      cornerRadius: 6.0,
      applyFont: (s) => GoogleFonts.shareTechMono(textStyle: s),
    ),
    'river_raid': UiTheme(
      accent:       const Color(0xFFFF4422),
      accentDim:    const Color(0xFF441108),
      surfaceDark:  const Color(0xFF050000),
      surfaceMid:   const Color(0xFF100000),
      surfaceLight: const Color(0xFF1C0000),
      danger:   const Color(0xFFFF2200),
      success:  const Color(0xFF44FF44),
      upgrade:  const Color(0xFFFFCC44),
      cornerRadius: 0.0,
      applyFont: (s) => GoogleFonts.pressStart2p(textStyle: s),
      fontScale: 0.8,
    ),
    'default': UiTheme(
      accent:       const Color(0xFF00FFEE),
      accentDim:    const Color(0xFF004440),
      surfaceDark:  const Color(0xFF0a0a1e),
      surfaceMid:   const Color(0xFF0F0F28),
      surfaceLight: const Color(0xFF1a1a4e),
      danger:   const Color(0xFFFF3300),
      success:  Colors.greenAccent,
      upgrade:  Colors.yellowAccent,
      cornerRadius: 6.0,
      applyFont: (s) => GoogleFonts.shareTechMono(textStyle: s),
    ),
  };
}

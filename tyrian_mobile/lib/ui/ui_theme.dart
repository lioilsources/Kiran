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
  });

  /// Returns a TextStyle optionally wrapped in the skin's Google Font.
  TextStyle styled(TextStyle base) => applyFont?.call(base) ?? base;

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
      applyFont: (s) => GoogleFonts.exo2(textStyle: s),
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
      applyFont: (s) => GoogleFonts.rajdhani(textStyle: s),
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
      applyFont: (s) => GoogleFonts.orbitron(textStyle: s),
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
      applyFont: (s) => GoogleFonts.rajdhani(textStyle: s),
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
      applyFont: (s) => GoogleFonts.exo2(textStyle: s),
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
      applyFont: (s) => GoogleFonts.oswald(textStyle: s),
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
      applyFont: (s) => GoogleFonts.exo2(textStyle: s),
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
      applyFont: (s) => GoogleFonts.orbitron(textStyle: s),
    ),
  };
}

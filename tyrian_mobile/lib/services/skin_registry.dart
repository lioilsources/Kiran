import '../rendering/shader_config.dart';

/// Defines available skins and their asset paths.
class SkinInfo {
  final String id;
  final String name;

  /// True for retro / pixel-art / vector skins whose sprites are meant to look
  /// hard-edged. These keep nearest-neighbour filtering even when supersampling
  /// is active; detailed (AI-illustrated) skins use smooth filtering instead.
  final bool pixelArt;

  const SkinInfo(this.id, this.name, {this.pixelArt = false});

  String get previewPath => 'skins/$id/ui/preview.png';
  String spritePath(String name) => 'skins/$id/sprites/$name.png';

  ShaderConfig get shaderConfig =>
      ShaderConfig.defaults[id] ?? const ShaderConfig();
}

const kSkins = [
  SkinInfo('space_invaders', 'Space Invaders (1978)', pixelArt: true),
  SkinInfo('asteroids', 'Asteroids (1979)', pixelArt: true),
  SkinInfo('galaga', 'Galaga (1981)', pixelArt: true),
  SkinInfo('rtype', 'R-Type (1987)'),
  SkinInfo('blazing_lazers', 'Blazing Lazers (1989)'),
  SkinInfo('tyrian_dos', 'Tyrian DOS (1995)', pixelArt: true),
  SkinInfo('ikaruga', 'Ikaruga (2001)'),
  SkinInfo('geometry_wars', 'Geometry Wars (2003)'),
  SkinInfo('gradius_v', 'Gradius V (2004)'),
  SkinInfo('luftrausers', 'Luftrausers (2014)'),
  SkinInfo('nuclear_throne', 'Nuclear Throne (2015)', pixelArt: true),
  SkinInfo('nex_machina', 'Nex Machina (2017)'),
  SkinInfo('river_raid', 'River Raid (1982)', pixelArt: true),
  // flux2pony img2img restyle — repainted variants of an existing skin's art.
  // Not pixel-art (soft painterly look → smooth filtering).
  SkinInfo('galaga_watercolor', 'Galaga · Watercolor', pixelArt: false),
  SkinInfo('default', 'Kiran (2026)', pixelArt: true),
];

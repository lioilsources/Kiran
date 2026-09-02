import '../rendering/shader_config.dart';

/// Defines available skins and their asset paths.
class SkinInfo {
  final String id;
  final String name;

  /// True for retro / pixel-art / vector skins whose sprites are meant to look
  /// hard-edged. These keep nearest-neighbour filtering even when supersampling
  /// is active; detailed (AI-illustrated) skins use smooth filtering instead.
  final bool pixelArt;

  /// Non-consumable IAP product ID for paid skins — the same ID is configured
  /// on both App Store Connect and Play Console. Null means the skin ships
  /// free with the app. Always [_iapPrefix]-qualified: App Store product IDs
  /// share one namespace across the whole store, so a bare `skin_rtype` is
  /// likely already taken by someone else.
  final String? productId;

  const SkinInfo(this.id, this.name, {this.pixelArt = false, this.productId});

  String get previewPath => 'skins/$id/ui/preview.png';

  ShaderConfig get shaderConfig =>
      ShaderConfig.defaults[id] ?? const ShaderConfig();
}

/// Bundle ID of the app, prefixed onto every IAP product ID.
const _iapPrefix = 'com.ol1n.kiran';

// Free tier: default + the two skins most visually distinct from it
// (galaga — 80s pixel-art, geometry_wars — 2000s neon vector). Everything
// else is a per-skin non-consumable purchase.
const kSkins = [
  SkinInfo('space_invaders', 'Monochrome Invader (1978)',
      pixelArt: true, productId: '$_iapPrefix.skin_space_invaders'),
  SkinInfo('asteroids', 'Vector Wireframe (1979)',
      pixelArt: true, productId: '$_iapPrefix.skin_asteroids'),
  SkinInfo('galaga', 'Arcade Formation (1981)', pixelArt: true),
  SkinInfo('river_raid', '8-Bit Canyon (1982)',
      pixelArt: true, productId: '$_iapPrefix.skin_river_raid'),
  SkinInfo('rtype', 'Biomech Cruiser (1987)', productId: '$_iapPrefix.skin_rtype'),
  SkinInfo('blazing_lazers', '16-Bit Laser (1989)',
      productId: '$_iapPrefix.skin_blazing_lazers'),
  SkinInfo('tyrian_dos', 'Retro PC Pixel (1995)',
      pixelArt: true, productId: '$_iapPrefix.skin_tyrian_dos'),
  SkinInfo('ikaruga', 'Dual-Polarity (2001)', productId: '$_iapPrefix.skin_ikaruga'),
  SkinInfo('geometry_wars', 'Neon Grid (2003)'),
  SkinInfo('gradius_v', 'Chrome Fleet (2004)',
      productId: '$_iapPrefix.skin_gradius_v'),
  SkinInfo('luftrausers', 'Sepia Dogfight (2014)',
      productId: '$_iapPrefix.skin_luftrausers'),
  SkinInfo('nuclear_throne', 'Wasteland Pixel (2015)',
      pixelArt: true, productId: '$_iapPrefix.skin_nuclear_throne'),
  SkinInfo('nex_machina', 'Neon Voxel (2017)',
      productId: '$_iapPrefix.skin_nex_machina'),
  SkinInfo('default', 'Kiran (2026)', pixelArt: true),
];

SkinInfo? skinById(String id) {
  for (final s in kSkins) {
    if (s.id == id) return s;
  }
  return null;
}

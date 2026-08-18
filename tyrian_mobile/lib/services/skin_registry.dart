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
  String spritePath(String name) => 'skins/$id/sprites/$name.png';

  ShaderConfig get shaderConfig =>
      ShaderConfig.defaults[id] ?? const ShaderConfig();
}

/// Bundle ID of the app, prefixed onto every IAP product ID.
const _iapPrefix = 'com.ol1n.kiran';

// Free tier: default + the two skins most visually distinct from it
// (galaga — 80s pixel-art, geometry_wars — 2000s neon vector). Everything
// else is a per-skin non-consumable purchase.
const kSkins = [
  SkinInfo('space_invaders', 'Space Invaders (1978)',
      pixelArt: true, productId: '$_iapPrefix.skin_space_invaders'),
  SkinInfo('asteroids', 'Asteroids (1979)',
      pixelArt: true, productId: '$_iapPrefix.skin_asteroids'),
  SkinInfo('galaga', 'Galaga (1981)', pixelArt: true),
  SkinInfo('river_raid', 'River Raid (1982)',
      pixelArt: true, productId: '$_iapPrefix.skin_river_raid'),
  SkinInfo('rtype', 'R-Type (1987)', productId: '$_iapPrefix.skin_rtype'),
  SkinInfo('blazing_lazers', 'Blazing Lazers (1989)',
      productId: '$_iapPrefix.skin_blazing_lazers'),
  SkinInfo('tyrian_dos', 'Tyrian DOS (1995)',
      pixelArt: true, productId: '$_iapPrefix.skin_tyrian_dos'),
  SkinInfo('ikaruga', 'Ikaruga (2001)', productId: '$_iapPrefix.skin_ikaruga'),
  SkinInfo('geometry_wars', 'Geometry Wars (2003)'),
  SkinInfo('gradius_v', 'Gradius V (2004)',
      productId: '$_iapPrefix.skin_gradius_v'),
  SkinInfo('luftrausers', 'Luftrausers (2014)',
      productId: '$_iapPrefix.skin_luftrausers'),
  SkinInfo('nuclear_throne', 'Nuclear Throne (2015)',
      pixelArt: true, productId: '$_iapPrefix.skin_nuclear_throne'),
  SkinInfo('nex_machina', 'Nex Machina (2017)',
      productId: '$_iapPrefix.skin_nex_machina'),
  SkinInfo('default', 'Kiran (2026)', pixelArt: true),
];

SkinInfo? skinById(String id) {
  for (final s in kSkins) {
    if (s.id == id) return s;
  }
  return null;
}

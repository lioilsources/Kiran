/// Per-skin shader effect configuration.
class ShaderConfig {
  final double vignetteRadius;
  final double vignetteSoft;
  final double tintR;
  final double tintG;
  final double tintB;
  final double saturation;
  final bool bloomEnabled;
  final double bloomStrength;
  final double bloomThreshold;
  final bool crtEnabled;
  final double scanlineIntensity;
  final double crtCurvature;

  const ShaderConfig({
    this.vignetteRadius = 0.95,
    this.vignetteSoft = 0.15,
    this.tintR = 1.0,
    this.tintG = 1.0,
    this.tintB = 1.0,
    this.saturation = 1.0,
    this.bloomEnabled = false,
    this.bloomStrength = 0.0,
    this.bloomThreshold = 0.8,
    this.crtEnabled = false,
    this.scanlineIntensity = 0.0,
    this.crtCurvature = 0.0,
  });

  static const defaults = <String, ShaderConfig>{
    'default': ShaderConfig(),
    'geometry_wars': ShaderConfig(
      vignetteRadius: 0.85, vignetteSoft: 0.2,
      tintR: 0.8, tintG: 1.0, tintB: 1.0,
      bloomEnabled: true, bloomStrength: 1.5, bloomThreshold: 0.6,
    ),
    'tyrian_dos': ShaderConfig(
      vignetteRadius: 0.90, vignetteSoft: 0.2,
      tintR: 1.0, tintG: 0.95, tintB: 0.85,
      crtEnabled: true, scanlineIntensity: 0.7, crtCurvature: 0.02,
    ),
    'space_invaders': ShaderConfig(
      vignetteRadius: 0.92, vignetteSoft: 0.15,
      crtEnabled: true, scanlineIntensity: 0.4, crtCurvature: 0.01,
    ),
    'ikaruga': ShaderConfig(
      vignetteRadius: 0.90, vignetteSoft: 0.15,
      tintR: 0.9, tintG: 0.95, tintB: 1.0,
      bloomEnabled: true, bloomStrength: 0.8, bloomThreshold: 0.75,
    ),
    'nuclear_throne': ShaderConfig(
      vignetteRadius: 0.85, vignetteSoft: 0.2,
      tintR: 1.0, tintG: 0.9, tintB: 0.75,
      saturation: 0.85,
    ),
    // river_raid had no entry and silently took the bare default. Spelled out
    // rather than invented: this reproduces exactly what it has always
    // rendered, so the skin does not change, while
    // skin_registry_consistency_test can now demand an entry for every skin.
    // ---- v3.0 skins ----------------------------------------------------
    // Each preset follows its palette: bloom for anything that glows, CRT
    // scanlines for the 8-bit and handheld eras, tint to push the dominant
    // hue the art was generated around.
    'tempest': ShaderConfig(
      vignetteRadius: 0.85, vignetteSoft: 0.2,
      tintR: 1.0, tintG: 0.95, tintB: 1.0,
      bloomEnabled: true, bloomStrength: 1.3, bloomThreshold: 0.6,
    ),
    'zaxxon': ShaderConfig(
      tintR: 0.95, tintG: 0.95, tintB: 1.0,
      crtEnabled: true, scanlineIntensity: 0.4, crtCurvature: 0.01,
    ),
    'twinbee': ShaderConfig(
      vignetteRadius: 0.95,
      bloomEnabled: true, bloomStrength: 0.4, bloomThreshold: 0.8,
    ),
    'fantasy_zone': ShaderConfig(
      tintR: 1.0, tintG: 0.97, tintB: 1.0,
      // Above 1.0 the shader extrapolates past the source colour; the uniform
      // is documented for 0.8-1.2, and pastels need the push to stay candy.
      saturation: 1.1,
    ),
    'abadox': ShaderConfig(
      vignetteRadius: 0.85, vignetteSoft: 0.25,
      tintR: 1.0, tintG: 0.85, tintB: 0.85,
      crtEnabled: true, scanlineIntensity: 0.5, crtCurvature: 0.015,
    ),
    'solar_striker': ShaderConfig(
      tintR: 0.9, tintG: 1.0, tintB: 0.85,
      saturation: 0.9,
      // Flat handheld LCD: scanlines without curvature, the screen was flat.
      crtEnabled: true, scanlineIntensity: 0.6, crtCurvature: 0.0,
    ),
    'axelay': ShaderConfig(
      tintR: 0.92, tintG: 0.95, tintB: 1.0,
      bloomEnabled: true, bloomStrength: 0.5, bloomThreshold: 0.8,
    ),
    'thunder_force': ShaderConfig(
      tintR: 0.9, tintG: 0.95, tintB: 1.0,
      bloomEnabled: true, bloomStrength: 0.7, bloomThreshold: 0.75,
    ),
    'star_fox': ShaderConfig(
      vignetteRadius: 0.95, vignetteSoft: 0.1,
    ),
    'lords_of_thunder': ShaderConfig(
      vignetteRadius: 0.88, vignetteSoft: 0.2,
      tintR: 1.0, tintG: 0.92, tintB: 0.85,
      bloomEnabled: true, bloomStrength: 0.8, bloomThreshold: 0.7,
    ),
    'river_raid': ShaderConfig(),
    'galaga': ShaderConfig(
      vignetteRadius: 0.92, vignetteSoft: 0.15,
      bloomEnabled: true, bloomStrength: 0.5, bloomThreshold: 0.8,
    ),
    'asteroids': ShaderConfig(
      vignetteRadius: 0.90, vignetteSoft: 0.15,
      tintR: 0.85, tintG: 1.0, tintB: 0.85,
      bloomEnabled: true, bloomStrength: 0.6, bloomThreshold: 0.7,
    ),
    'luftrausers': ShaderConfig(
      vignetteRadius: 0.85, vignetteSoft: 0.2,
      tintR: 1.0, tintG: 0.9, tintB: 0.7,
    ),
    'nex_machina': ShaderConfig(
      vignetteRadius: 0.90, vignetteSoft: 0.15,
      bloomEnabled: true, bloomStrength: 1.0, bloomThreshold: 0.65,
    ),
    'gradius_v': ShaderConfig(
      vignetteRadius: 0.92, vignetteSoft: 0.15,
      tintR: 0.9, tintG: 0.95, tintB: 1.0,
      bloomEnabled: true, bloomStrength: 0.6, bloomThreshold: 0.8,
    ),
    'rtype': ShaderConfig(
      vignetteRadius: 0.90, vignetteSoft: 0.15,
      bloomEnabled: true, bloomStrength: 0.7, bloomThreshold: 0.75,
    ),
    'blazing_lazers': ShaderConfig(
      vignetteRadius: 0.90, vignetteSoft: 0.15,
      tintR: 1.0, tintG: 0.95, tintB: 0.9,
      bloomEnabled: true, bloomStrength: 0.8, bloomThreshold: 0.7,
    ),
  };
}

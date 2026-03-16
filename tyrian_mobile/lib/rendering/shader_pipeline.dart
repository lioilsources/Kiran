import 'package:flame/post_process.dart';
import 'shader_config.dart';
import 'passes/vignette_color_pass.dart';
import 'passes/bloom_pass.dart';
import 'passes/crt_pass.dart';
import 'passes/chromatic_aberration_pass.dart';

class ShaderPipeline {
  final vignetteColor = VignetteColorPass();
  final bloom = BloomPass();
  final crt = CrtPass();
  final chromaticAberration = ChromaticAberrationPass();

  PostProcess build() => PostProcessSequentialGroup(postProcesses: [
        vignetteColor,
        bloom,
        crt,
        chromaticAberration,
      ]);

  void configure(ShaderConfig config) {
    vignetteColor
      ..vignetteRadius = config.vignetteRadius
      ..vignetteSoft = config.vignetteSoft
      ..tintR = config.tintR
      ..tintG = config.tintG
      ..tintB = config.tintB
      ..saturation = config.saturation;

    bloom
      ..enabled = config.bloomEnabled
      ..strength = config.bloomStrength
      ..threshold = config.bloomThreshold;

    crt
      ..enabled = config.crtEnabled
      ..scanlineIntensity = config.scanlineIntensity
      ..curvature = config.crtCurvature;
  }

  void setDamageFlash(double intensity) {
    vignetteColor.damageFlash = intensity;
  }

  void triggerAberration() {
    chromaticAberration.intensity = 1.0;
  }
}

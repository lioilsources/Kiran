import 'dart:ui' as ui;
import 'package:flame/extensions.dart';
import 'package:flame/post_process.dart';
import 'package:flutter/painting.dart';

class VignetteColorPass extends PostProcess {
  late ui.FragmentShader _shader;

  double vignetteRadius = 0.7;
  double vignetteSoft = 0.3;
  double tintR = 1.0;
  double tintG = 1.0;
  double tintB = 1.0;
  double saturation = 1.0;
  double damageFlash = 0.0;

  VignetteColorPass() : super(pixelRatio: 1.0);

  @override
  Future<void> onLoad() async {
    final program =
        await ui.FragmentProgram.fromAsset('shaders/vignette_color.frag');
    _shader = program.fragmentShader();
  }

  @override
  void postProcess(Vector2 size, Canvas canvas) {
    final image = rasterizeSubtree();
    _shader.setFloatUniforms((s) {
      s.setSize(Size(size.x, size.y));
      s.setFloat(vignetteRadius);
      s.setFloat(vignetteSoft);
      s.setFloat(tintR);
      s.setFloat(tintG);
      s.setFloat(tintB);
      s.setFloat(saturation);
      s.setFloat(damageFlash);
    });
    _shader.setImageSampler(0, image);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..shader = _shader,
    );
  }
}

import 'dart:ui' as ui;
import 'package:flame/extensions.dart';
import 'package:flame/post_process.dart';
import 'package:flutter/painting.dart';

class ChromaticAberrationPass extends PostProcess {
  late ui.FragmentShader _shader;

  double intensity = 0.0;
  static const _decayDuration = 0.3; // seconds

  ChromaticAberrationPass() : super(pixelRatio: 1.0);

  @override
  Future<void> onLoad() async {
    final program =
        await ui.FragmentProgram.fromAsset('shaders/chromatic_aberration.frag');
    _shader = program.fragmentShader();
  }

  @override
  void update(double dt) {
    if (intensity > 0) {
      intensity -= dt / _decayDuration;
      if (intensity < 0) intensity = 0;
    }
  }

  @override
  void postProcess(Vector2 size, Canvas canvas) {
    if (intensity < 0.001) {
      renderSubtree(canvas);
      return;
    }

    final image = rasterizeSubtree();
    _shader.setFloatUniforms((s) {
      s.setSize(Size(size.x, size.y));
      s.setFloat(intensity);
    });
    _shader.setImageSampler(0, image);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..shader = _shader,
    );
    image.dispose();
  }
}

import 'dart:ui' as ui;
import 'package:flame/extensions.dart';
import 'package:flame/post_process.dart';
import 'package:flutter/painting.dart';

class CrtPass extends PostProcess {
  late ui.FragmentShader _shader;

  bool enabled = false;
  double scanlineIntensity = 0.0;
  double curvature = 0.0;
  double _time = 0;

  CrtPass() : super(pixelRatio: 1.0);

  @override
  Future<void> onLoad() async {
    final program = await ui.FragmentProgram.fromAsset('shaders/crt.frag');
    _shader = program.fragmentShader();
  }

  @override
  void update(double dt) {
    _time += dt;
  }

  @override
  void postProcess(Vector2 size, Canvas canvas) {
    if (!enabled) {
      renderSubtree(canvas);
      return;
    }

    final image = rasterizeSubtree();
    _shader.setFloatUniforms((s) {
      s.setSize(Size(size.x, size.y));
      s.setFloat(_time);
      s.setFloat(scanlineIntensity);
      s.setFloat(curvature);
    });
    _shader.setImageSampler(0, image);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..shader = _shader,
    );
  }
}

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uIntensity;  // 0.0–1.0 (decays after damage)
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  vec2 fc = FlutterFragCoord();

  if (uIntensity < 0.001) {
    fragColor = texture(uTexture, fc);
    return;
  }

  vec2 uv = fc / uSize;
  vec2 offset = (uv - 0.5) * uIntensity * 8.0;  // pixel offset from center

  float r = texture(uTexture, fc + offset).r;
  float g = texture(uTexture, fc).g;
  float b = texture(uTexture, fc - offset).b;
  float a = texture(uTexture, fc).a;

  fragColor = vec4(r, g, b, a);
}

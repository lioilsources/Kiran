#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uIntensity;  // 0.0–1.0 (decays after damage)
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord() / uSize;

  if (uIntensity < 0.001) {
    fragColor = texture(uTexture, uv);
    return;
  }

  vec2 offset = (uv - 0.5) * uIntensity * 0.02;  // normalized offset from center

  float r = texture(uTexture, uv + offset).r;
  float g = texture(uTexture, uv).g;
  float b = texture(uTexture, uv - offset).b;
  float a = texture(uTexture, uv).a;

  fragColor = vec4(r, g, b, a);
}

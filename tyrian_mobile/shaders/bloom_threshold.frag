#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uThreshold;   // 0.5–0.9
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  vec4 color = texture(uTexture, FlutterFragCoord());
  float lum = dot(color.rgb, vec3(0.299, 0.587, 0.114));
  float brightness = max(0.0, lum - uThreshold) / max(1.0 - uThreshold, 0.001);
  fragColor = vec4(color.rgb * brightness, color.a);
}

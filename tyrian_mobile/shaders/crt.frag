#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform float uScanlineIntensity;  // 0.0–1.0
uniform float uCurvature;          // 0.0–0.05
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord() / uSize;

  // Barrel distortion
  vec2 centered = uv - 0.5;
  float r2 = dot(centered, centered);
  vec2 distorted = uv + centered * r2 * uCurvature * 10.0;

  // Clamp to bounds — black outside
  if (distorted.x < 0.0 || distorted.x > 1.0 ||
      distorted.y < 0.0 || distorted.y > 1.0) {
    fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    return;
  }

  vec4 color = texture(uTexture, distorted);

  // Scanlines
  float scanline = sin(distorted.y * uSize.y * 3.14159265) * 0.5 + 0.5;
  scanline = mix(1.0, scanline, uScanlineIntensity);
  color.rgb *= scanline;

  fragColor = color;
}

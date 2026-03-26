#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uAmount;       // 0.0 (fully visible) → 1.0 (fully dissolved)
uniform float uEdgeWidth;    // glow edge band width (0.03–0.08)
uniform float uEdgeR;        // edge glow color
uniform float uEdgeG;
uniform float uEdgeB;
uniform sampler2D uTexture;

out vec4 fragColor;

// Simple hash-based noise — avoids needing a separate noise texture
float hash(vec2 p) {
  vec3 p3 = fract(vec3(p.xyx) * 0.1031);
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.x + p3.y) * p3.z);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  f = f * f * (3.0 - 2.0 * f); // smoothstep

  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));

  return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Multi-octave noise for more organic dissolve pattern
float fbm(vec2 p) {
  float v = 0.0;
  float a = 0.5;
  for (int i = 0; i < 4; i++) {
    v += a * noise(p);
    p *= 2.0;
    a *= 0.5;
  }
  return v;
}

void main() {
  vec2 fc = FlutterFragCoord();
  vec2 uv = fc / uSize;
  vec4 color = texture(uTexture, uv);

  // Skip fully transparent pixels
  if (color.a < 0.01) {
    fragColor = color;
    return;
  }

  // Generate noise at sprite UV scale (8x8 cells gives good detail on small sprites)
  float n = fbm(uv * 8.0);

  // Dissolve: discard pixels where noise < dissolve amount
  if (n < uAmount) {
    fragColor = vec4(0.0);
    return;
  }

  // Glowing edge band
  float edge = smoothstep(uAmount, uAmount + uEdgeWidth, n);
  vec3 edgeColor = vec3(uEdgeR, uEdgeG, uEdgeB);
  color.rgb = mix(edgeColor, color.rgb, edge);

  // Boost alpha at edge for extra glow visibility
  color.a = mix(color.a, min(color.a + 0.3, 1.0), 1.0 - edge);

  fragColor = color;
}

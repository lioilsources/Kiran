#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;         // 0.0 → 1.0 (animation progress)
uniform float uHitX;         // hit point X in UV space (0–1)
uniform float uHitY;         // hit point Y in UV space (0–1)
uniform float uSpread;       // explosion spread multiplier (1.0–3.0)
uniform sampler2D uTexture;

out vec4 fragColor;

// Per-pixel deterministic "random" offset for variation
float hash(vec2 p) {
  vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.x + p3.y) * p3.z);
}

void main() {
  vec2 fc = FlutterFragCoord();
  vec2 uv = fc / uSize;

  vec2 hitPoint = vec2(uHitX, uHitY);

  // Direction from hit point to this pixel
  vec2 dir = uv - hitPoint;
  float dist = length(dir);

  // Per-pixel random offset for organic feel
  float rng = hash(uv * 127.0);

  // Speed: pixels closer to hit point move faster (inverse distance)
  float speed = (1.5 - dist * 0.8) * uSpread;
  speed = max(speed, 0.2); // minimum speed so everything moves

  // Parabolic trajectory with gravity
  float t = uTime * uTime; // ease-in for acceleration feel
  vec2 offset = dir * speed * t;
  offset.y -= 0.3 * t; // gravity pulls down

  // Add per-pixel random spread
  offset += (vec2(rng, hash(uv * 63.0)) - 0.5) * 0.15 * uTime;

  // Sample from the original position (reverse the offset)
  vec2 sampleUV = uv - offset;

  // Out of bounds → transparent
  if (sampleUV.x < 0.0 || sampleUV.x > 1.0 ||
      sampleUV.y < 0.0 || sampleUV.y > 1.0) {
    fragColor = vec4(0.0);
    return;
  }

  vec4 color = texture(uTexture, sampleUV);

  // Fade out over time
  color.a *= 1.0 - uTime;

  // Hot tint at start → cold at end
  float heat = max(0.0, 1.0 - uTime * 2.0);
  color.rgb += vec3(heat * 0.4, heat * 0.15, 0.0); // orange-ish glow
  color.rgb = min(color.rgb, vec3(1.0));

  fragColor = color;
}

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uVignetteRadius;   // 0.3–0.9
uniform float uVignetteSoft;     // 0.1–0.5
uniform float uTintR;
uniform float uTintG;
uniform float uTintB;
uniform float uSaturation;       // 0.8–1.2
uniform float uDamageFlash;      // 0.0–1.0
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  vec2 fc = FlutterFragCoord();
  vec2 uv = fc / uSize;
  vec4 color = texture(uTexture, uv);

  // Saturation adjustment
  float lum = dot(color.rgb, vec3(0.299, 0.587, 0.114));
  color.rgb = mix(vec3(lum), color.rgb, uSaturation);

  // Color tint
  color.rgb *= vec3(uTintR, uTintG, uTintB);

  // Vignette darkening — aspect-corrected ellipse
  vec2 center = uv - 0.5;
  float aspect = uSize.x / uSize.y;
  // Stretch shorter axis so vignette follows screen edges, not a circle
  vec2 scaled = center * vec2(min(aspect, 1.0), min(1.0 / aspect, 1.0));
  float dist = length(scaled) * 2.0;
  float vignette = smoothstep(uVignetteRadius, uVignetteRadius + uVignetteSoft, dist);
  color.rgb *= 1.0 - vignette;

  // Damage flash — mix toward red
  color.rgb = mix(color.rgb, vec3(1.0, 0.0, 0.0), uDamageFlash * 0.4);

  fragColor = color;
}

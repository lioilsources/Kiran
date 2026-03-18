#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec2 uDirection;  // (1,0) for H, (0,1) for V
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  // 9-tap Gaussian (sigma ~2.5) — unrolled, SkSL has no array init
  float w0 = 0.2270270270;
  float w1 = 0.1945945946;
  float w2 = 0.1216216216;
  float w3 = 0.0540540541;
  float w4 = 0.0162162162;

  vec2 uv = FlutterFragCoord() / uSize;
  vec2 texel = uDirection / uSize;  // normalized offset per pixel

  vec4 result = texture(uTexture, uv) * w0;

  result += texture(uTexture, uv + texel * 2.0) * w1;
  result += texture(uTexture, uv - texel * 2.0) * w1;

  result += texture(uTexture, uv + texel * 4.0) * w2;
  result += texture(uTexture, uv - texel * 4.0) * w2;

  result += texture(uTexture, uv + texel * 6.0) * w3;
  result += texture(uTexture, uv - texel * 6.0) * w3;

  result += texture(uTexture, uv + texel * 8.0) * w4;
  result += texture(uTexture, uv - texel * 8.0) * w4;

  fragColor = result;
}

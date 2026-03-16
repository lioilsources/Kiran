#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec2 uDirection;  // (1,0) for H, (0,1) for V
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  // 9-tap Gaussian (sigma ~2.5)
  float weights[5] = float[5](
    0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162
  );

  vec2 fc = FlutterFragCoord();
  vec4 result = texture(uTexture, fc) * weights[0];

  for (int i = 1; i < 5; i++) {
    float offset = float(i) * 2.0;
    result += texture(uTexture, fc + uDirection * offset) * weights[i];
    result += texture(uTexture, fc - uDirection * offset) * weights[i];
  }

  fragColor = result;
}

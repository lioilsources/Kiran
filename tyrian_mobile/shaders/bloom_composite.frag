#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uStrength;   // 0.0–2.0
uniform sampler2D uScene;  // sampler 0: original scene
uniform sampler2D uBloom;  // sampler 1: blurred bright pixels

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord() / uSize;
  vec4 scene = texture(uScene, uv);
  vec4 bloom = texture(uBloom, uv);
  fragColor = scene + bloom * uStrength;
}

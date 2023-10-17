#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

const vec3 backgroundColor = vec3(1.0, 1.0, 1.0);
const vec3 colors[6] = vec3[6](
    vec3(0.372, 0.192, 0.549), // 95, 49, 140
    vec3(0.000, 0.650, 0.854), // 0, 166, 218
    vec3(0.580, 0.737, 0.345), // 148, 188, 88
    vec3(0.992, 0.909, 0.329), // 253, 232, 84
    vec3(0.941, 0.501, 0.243), // 240, 128, 62
    vec3(0.913, 0.200, 0.250) // 233, 51, 64
);

void main() {
    vec2 st = FlutterFragCoord().xy / uSize;

    float startRadius = uSize.x / 5.0;
    float endRadius = uSize.x / (2.0 - uTime * 1.5);

    vec2 center = vec2(uSize.x / 2.0, uSize.y);

    float distance = length(FlutterFragCoord().xy - center);
    float mixValue = distance >= startRadius && distance <= endRadius ? 1.0 : 0.0;

    vec3 color = vec3(0.0);
    if (mixValue > 0.0) {
        float bandStep = (endRadius - startRadius) / colors.length();
        float index = (distance - startRadius) / bandStep;

        color = colors[int(index)];
    }

    fragColor = vec4(color, mixValue);
}

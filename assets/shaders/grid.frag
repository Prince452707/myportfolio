#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

// A simple, futuristic animated grid shader.
void main() {
    vec2 coord = FlutterFragCoord().xy / uSize;
    vec3 color = vec3(0.0);

    // Animate grid lines by offsetting with time
    vec2 grid = abs(fract(coord * 20.0 - vec2(0.0, uTime * 0.2)) - 0.5);
    float d = 0.01 / (grid.x + grid.y);

    // Add a subtle cyan glow
    vec3 glow = vec3(0.1, 0.7, 1.0) * d;

    color += glow;

    fragColor = vec4(color, 1.0);
}
#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;
// https://www.shadertoy.com/view/MslGWN
uniform vec2 resolution;
uniform vec4 mouse; // Mouse input
out vec4 fragColor;

// Field function
float field(vec3 p, float s) {
    float accum = s / 4.0;
    float prev = 0.0;
    float tw = 0.0;
    for (int i = 0; i < 26; ++i) {
        float mag = dot(p, p);
        p = abs(p) / mag + vec3(-0.5, -0.4, -1.5);
        float w = exp(-float(i) / 7.0);
        accum += w * exp(-9.025 * pow(abs(mag - prev), 2.2));
        tw += w;
        prev = mag;
    }
    return max(0.0, 5.0 * accum / tw - 0.7);
}

// Field function with fewer iterations
float field2(vec3 p, float s) {
    float accum = s / 4.0;
    float prev = 0.0;
    float tw = 0.0;
    for (int i = 0; i < 18; ++i) {
        float mag = dot(p, p);
        p = abs(p) / mag + vec3(-0.5, -0.4, -1.5);
        float w = exp(-float(i) / 7.0);
        accum += w * exp(-9.025 * pow(abs(mag - prev), 2.2));
        tw += w;
        prev = mag;
    }
    return max(0.0, 5.0 * accum / tw - 0.7);
}

// Random vector function
vec3 nrand3(vec2 co) {
    vec3 a = fract(cos(co.x * 8.3e-3 + co.y) * vec3(1.3e5, 4.7e5, 2.9e5));
    vec3 b = fract(sin(co.x * 0.3e-3 + co.y) * vec3(8.1e5, 1.0e5, 0.1e5));
    vec3 c = mix(a, b, 0.5);
    return c;
}

// Main shader function
void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = 2.0 * fragCoord / resolution - 1.0;
    vec2 uvs = uv * resolution / max(resolution.x, resolution.y);
    vec3 p = vec3(uvs / 4.0, 0.0) + vec3(1.0, -1.3, 0.0);
    // adjust first layer position based on mouse movement
	p.x += mix(-0.05, 0.05, (mouse.x / resolution.x));
	p.y += mix(-0.05, 0.05, (mouse.y / resolution.y));

    float freqs[4];

    float t = field(p, freqs[2]);
    float v = (1.0 - exp((abs(uv.x) - 1.0) * 6.0)) * (1.0 - exp((abs(uv.y) - 1.0) * 6.0));

    vec3 p2 = vec3(uvs / 4.6, 1.5) + vec3(2.0, -1.3, -1.0);
    // adjust second layer position based on mouse movement
	p2.x += mix(-0.02, 0.02, (mouse.x / resolution.x));
	p2.y += mix(-0.02, 0.02, (mouse.y / resolution.y));

    float t2 = field2(p2, freqs[3]);
    vec4 c2 = mix(0.4, 1.0, v) * vec4(1.3 * t2 * t2 * t2, 1.8 * t2 * t2, t2 * freqs[0], t2);

    vec2 seed = p.xy * 2.0;
    seed = floor(seed * resolution.x);
    vec3 rnd = nrand3(seed);
    vec4 starcolor = vec4(pow(rnd.y, 40.0));

    vec2 seed2 = p2.xy * 2.0;
    seed2 = floor(seed2 * resolution.x);
    vec3 rnd2 = nrand3(seed2);
    starcolor += vec4(pow(rnd2.y, 40.0));

    fragColor = mix(freqs[3] - 0.3, 1.0, v) * vec4(1.5 * freqs[2] * t * t * t, 1.2 * freqs[1] * t * t, freqs[3] * t, 1.0) + c2 + starcolor;
}

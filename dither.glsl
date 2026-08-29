#version 300 es
precision highp float;

in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;

uniform sampler2D tex;

// 4x4 Ordered Bayer Matrix for prominent, crunchy retro crosshatching
const float bayer4x4[16] = float[16](
     0.0/16.0,  8.0/16.0,  2.0/16.0, 10.0/16.0,
    12.0/16.0,  4.0/16.0, 14.0/16.0,  6.0/16.0,
     3.0/16.0, 11.0/16.0,  1.0/16.0,  9.0/16.0,
    15.0/16.0,  7.0/16.0, 13.0/16.0,  5.0/16.0
);

// 5 levels per RGB channel = 125 vibrant retro palette colors
const float COLOR_LEVELS = 5.0;

void main() {
    vec4 src = texture(tex, v_texcoord);

    // Pixel coordinates for Bayer lookup
    int x = int(gl_FragCoord.x) % 4;
    int y = int(gl_FragCoord.y) % 4;
    float bayer = bayer4x4[y * 4 + x] - 0.5;

    // Luminance & saturation detection
    float luma = dot(src.rgb, vec3(0.2126, 0.7152, 0.0722));
    float maxC = max(src.r, max(src.g, src.b));
    float minC = min(src.r, min(src.g, src.b));
    float delta = maxC - minC;

    // 1. TEXT CLARITY: Solid white for bright text glyphs
    if (luma > 0.90 && delta < 0.10) {
        fragColor = vec4(1.0, 1.0, 1.0, src.a);
        return;
    }
    // Deep black for pure dark backgrounds
    if (luma < 0.03 && delta < 0.05) {
        fragColor = vec4(0.0, 0.0, 0.0, src.a);
        return;
    }

    // 2. STRONG COLOR DITHERING (Prominent Crosshatch Texture on Everything)
    float stepSize = 1.0 / (COLOR_LEVELS - 1.0);
    float ditherSpread = stepSize * 1.0; // Full-strength dither amplitude

    // Apply RGB Bayer dither to each color channel
    vec3 dithered = src.rgb + vec3(bayer * ditherSpread);

    // Quantize into crisp retro color steps
    vec3 quantized = floor(dithered * (COLOR_LEVELS - 1.0) + 0.5) / (COLOR_LEVELS - 1.0);
    quantized = clamp(quantized, 0.0, 1.0);

    fragColor = vec4(quantized, src.a);
}

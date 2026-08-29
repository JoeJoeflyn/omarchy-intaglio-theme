#version 300 es
precision highp float;

in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;

uniform sampler2D tex;

// 4x4 Ordered Bayer Matrix for authentic retro crosshatching
const float bayer4x4[16] = float[16](
     0.0/16.0,  8.0/16.0,  2.0/16.0, 10.0/16.0,
    12.0/16.0,  4.0/16.0, 14.0/16.0,  6.0/16.0,
     3.0/16.0, 11.0/16.0,  1.0/16.0,  9.0/16.0,
    15.0/16.0,  7.0/16.0, 13.0/16.0,  5.0/16.0
);

// 6 levels per channel = 216 rich retro color steps
const float COLOR_LEVELS = 6.0;

void main() {
    vec4 src = texture(tex, v_texcoord);

    // Pixel coordinates for Bayer lookup
    int x = int(gl_FragCoord.x) % 4;
    int y = int(gl_FragCoord.y) % 4;
    float bayer = bayer4x4[y * 4 + x] - 0.5;

    float stepSize = 1.0 / (COLOR_LEVELS - 1.0);
    float ditherSpread = stepSize * 0.75;

    // Apply authentic Bayer dither everywhere (terminal, windows, wallpapers, text)
    vec3 dithered = src.rgb + vec3(bayer * ditherSpread);

    // Quantize into crisp retro color palette
    vec3 quantized = floor(dithered * (COLOR_LEVELS - 1.0) + 0.5) / (COLOR_LEVELS - 1.0);
    quantized = clamp(quantized, 0.0, 1.0);

    fragColor = vec4(quantized, src.a);
}

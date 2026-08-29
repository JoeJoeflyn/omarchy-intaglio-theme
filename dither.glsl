#version 300 es
precision highp float;

in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;

uniform sampler2D tex;

// 4x4 Ordered Bayer Matrix for authentic retro dithering
const float bayer4x4[16] = float[16](
     0.0/16.0,  8.0/16.0,  2.0/16.0, 10.0/16.0,
    12.0/16.0,  4.0/16.0, 14.0/16.0,  6.0/16.0,
     3.0/16.0, 11.0/16.0,  1.0/16.0,  9.0/16.0,
    15.0/16.0,  7.0/16.0, 13.0/16.0,  5.0/16.0
);

// 6 quantized levels per channel = 216 crisp retro palette colors
const float COLOR_LEVELS = 6.0;

void main() {
    vec4 src = texture(tex, v_texcoord);

    // Calculate luminance
    float luma = dot(src.rgb, vec3(0.2126, 0.7152, 0.0722));
    float maxC = max(src.r, max(src.g, src.b));
    float minC = min(src.r, min(src.g, src.b));
    float delta = maxC - minC;

    // 1. TERMINAL & UI TEXT CLARITY PROTECTION:
    // Pure dark backgrounds & dark text stay 100% solid (0 noise in terminal background)
    if (luma < 0.12 && delta < 0.08) {
        fragColor = vec4(src.rgb, src.a);
        return;
    }
    // High-contrast bright text (white, cream, terminal foreground) stays 100% sharp
    if (luma > 0.75 && delta < 0.15) {
        fragColor = vec4(src.rgb, src.a);
        return;
    }

    // 2. RETRO DITHERING ON MIDTONES, WALLPAPERS, AND IMAGES
    int x = int(gl_FragCoord.x) % 4;
    int y = int(gl_FragCoord.y) % 4;
    float bayer = bayer4x4[y * 4 + x] - 0.5;

    float stepSize = 1.0 / (COLOR_LEVELS - 1.0);
    // Smooth dither amplitude so syntax highlighting text is readable while gradients crosshatch
    float ditherSpread = stepSize * 0.45;

    vec3 dithered = src.rgb + vec3(bayer * ditherSpread);
    vec3 quantized = floor(dithered * (COLOR_LEVELS - 1.0) + 0.5) / (COLOR_LEVELS - 1.0);
    quantized = clamp(quantized, 0.0, 1.0);

    fragColor = vec4(quantized, src.a);
}

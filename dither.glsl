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

// 8 quantized palette steps for smooth retro gradients without color banding noise
const float LEVELS = 8.0;

void main() {
    vec4 src = texture(tex, v_texcoord);

    // 1. Calculate luminance (perceived brightness) & chroma (color saturation)
    float luma = dot(src.rgb, vec3(0.2126, 0.7152, 0.0722));
    float maxC = max(src.r, max(src.g, src.b));
    float minC = min(src.r, min(src.g, src.b));
    float chroma = maxC - minC;

    // 2. 4x4 Bayer Matrix lookup
    int x = int(gl_FragCoord.x) % 4;
    int y = int(gl_FragCoord.y) % 4;
    float bayer = bayer4x4[y * 4 + x] - 0.5;

    // 3. Luminance-Coordinated Dithering (Prevents rainbow chromatic noise on dark apps like Discord/Vesktop)
    float stepSize = 1.0 / (LEVELS - 1.0);
    float ditherSpread = stepSize * 0.65;

    float ditheredLuma = luma + bayer * ditherSpread;
    float qLuma = floor(ditheredLuma * (LEVELS - 1.0) + 0.5) / (LEVELS - 1.0);
    qLuma = clamp(qLuma, 0.0, 1.0);

    // 4. Output color:
    // If neutral gray / monochrome (like Discord dark background, text, UI panels):
    // Output pure neutral quantized grayscale to eliminate color fringing
    if (chroma < 0.06) {
        fragColor = vec4(vec3(qLuma), src.a);
    } else {
        // For colored graphics, avatars, and UI badges:
        // Scale RGB proportionally by quantized luminance to preserve true hue
        vec3 colorDither = src.rgb * (qLuma / max(luma, 0.001));
        fragColor = vec4(clamp(colorDither, 0.0, 1.0), src.a);
    }
}

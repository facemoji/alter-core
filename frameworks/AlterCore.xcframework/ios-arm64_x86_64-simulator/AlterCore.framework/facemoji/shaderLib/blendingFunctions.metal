

float componentLinearToSRGB(float c) {
    if (c > 1.0) {
        return 1.0;
    }
    if (c < 0.0) {
        return 0.0;
    }
    if (c < 0.0031308) {
        return 12.92 * c;
    }
    return 1.055 * pow(c, 1.0/2.4) - 0.055;
}

float3 linearToSRGB(float3 c) {
    return float3(componentLinearToSRGB(c.r), componentLinearToSRGB(c.g), componentLinearToSRGB(c.b));
}


float componentSrgbToLinear(float c) {
    if (c <= 0.04045) {
        return c / 12.92;
    } else {
        return pow((c + 0.055) / 1.055, 2.4);
    }
}

float3 srgbToLinear(float3 c) {
    return float3(componentSrgbToLinear(c.r), componentSrgbToLinear(c.g), componentSrgbToLinear(c.b));
}

float4 computeForeground(float4 baseValue, float4 value, float valueMask) {
    return float4(baseValue.xyz * value.xyz * valueMask, valueMask);
}

float4 computeForegroundInverse(float4 baseValue, float4 value, float valueMask) {
    return float4((1.0 - baseValue.xyz * value.xyz) * valueMask, valueMask);
}

float3 blendResidual(float4 bg, float4 fg) {
    return fg.rgb * (1.0 - bg.a) + bg.rgb * (1.0 - fg.a);
}

float blendAlpha(float4 bg, float4 fg) {
    return bg.a + fg.a - bg.a * fg.a;
}

float3 rgb2hsv(float3 c)
{
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 p = mix(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
    float4 q = mix(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

float3 hsv2rgb(float3 c)
{
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// Blending modes:

float4 SrcOver(float4 bg, float4 fg) {
    return float4(bg.rgb * (1.0 - fg.a) + fg.rgb, blendAlpha(bg, fg));
}

float4 Multiply(float4 bg, float4 fg) {
    return float4(bg.rgb * fg.rgb + blendResidual(bg, fg), blendAlpha(bg, fg));
}

float4 Plus(float4 bg, float4 fg) {
    return bg + fg;
}

float4 Screen(float4 bg, float4 fg) {
    return float4(bg.rgb + fg.rgb - bg.rgb * fg.rgb, blendAlpha(bg, fg));
}

float4 LinearBurn(float4 bg, float4 fg) {
    return float4(bg.rgb + fg.rgb - bg.a * fg.a, blendAlpha(bg, fg));
}

float4 Overlay(float4 bg, float4 fg) {
    float3 multiplied = 2.0 * bg.rgb * fg.rgb + blendResidual(bg, fg);
    float3 screen = fg.rgb * (1.0 + bg.a) + bg.rgb * (1.0 + fg.a) - 2.0 * fg.rgb * bg.rgb - fg.a * bg.a;
    return float4(float3(bg.rgb < 0.5) * multiplied + float3(bg.rgb >= 0.5) * screen, blendAlpha(bg, fg));
}

float4 Darken(float4 bg, float4 fg) {
    return float4(min(fg.rgb * bg.a, bg.rgb * fg.a) + blendResidual(bg, fg), blendAlpha(bg, fg));
}

float4 Lighten(float4 bg, float4 fg) {
    return float4(max(fg.rgb * bg.a, bg.rgb * fg.a) + blendResidual(bg, fg), blendAlpha(bg, fg));
}

float4 LinearLight(float4 bg, float4 fg) {
    return float4(bg.rgb + 2.0 * fg.rgb - bg.a * fg.a + blendResidual(bg, fg), blendAlpha(bg, fg));
}

float4 SoftLight(float4 bg, float4 fg) {
    return float4((1.0 - 2.0 * fg.rgb) * bg.rgb * bg.rgb + 2.0 * bg.rgb * fg.rgb + blendResidual(bg, fg), blendAlpha(bg, fg));
}

float4 LightDodge(float4 bg, float4 fg) {
    float bgIntensity = (bg.r + bg.g + bg.b) * 0.33333;
    float3 multiply = bg.rgb * fg.rgb + blendResidual(bg, fg);
    float3 screen = bg.rgb + fg.rgb - bg.rgb * fg.rgb;
    return float4(mix(mix(screen * screen, screen, 0.1), multiply, bgIntensity), blendAlpha(bg, fg));
}

float4 HsvLighten(float4 bg, float4 fg) {
    float3 fgHsv = rgb2hsv(fg.rgb);
    float3 fgDark = hsv2rgb(float3(fgHsv.r, fgHsv.g, fgHsv.b * 0.35));
    float3 fgLight = hsv2rgb(float3(fgHsv.r, min(1.0, fgHsv.g * 1.1), min(1.0, fgHsv.b * 1.1)));
    float bgIntensity = (bg.r + bg.g + bg.b) * 0.33333;
    return float4(mix(bg.rgb, mix(fgDark, fgLight, bgIntensity), fg.a), blendAlpha(bg, fg));
}

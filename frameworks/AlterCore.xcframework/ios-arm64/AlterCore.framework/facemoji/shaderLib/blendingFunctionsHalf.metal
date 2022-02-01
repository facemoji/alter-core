

half componentLinearToSRGB(half c) {
    if (c > 1.0h) {
        return 1.0h;
    }
    if (c < 0.0h) {
        return 0.0h;
    }
    if (c < 0.0031308h) {
        return 12.92h * c;
    }
    return 1.055h * pow(c, 1.0h/2.4h) - 0.055h;
}

half3 linearToSRGB(half3 c) {
    return half3(componentLinearToSRGB(c.r), componentLinearToSRGB(c.g), componentLinearToSRGB(c.b));
}


half componentSrgbToLinear(half c) {
    if (c <= 0.04045h) {
        return c / 12.92h;
    } else {
        return pow((c + 0.055h) / 1.055h, 2.4h);
    }
}

half3 srgbToLinear(half3 c) {
    return half3(componentSrgbToLinear(c.r), componentSrgbToLinear(c.g), componentSrgbToLinear(c.b));
}

half4 computeForeground(half4 baseValue, half4 value, half valueMask) {
    return half4(baseValue.xyz * value.xyz * valueMask, valueMask);
}

half4 computeForegroundInverse(half4 baseValue, half4 value, half valueMask) {
    return half4((1.0h - baseValue.xyz * value.xyz) * valueMask, valueMask);
}

half3 blendResidual(half4 bg, half4 fg) {
    return fg.rgb * (1.0h - bg.a) + bg.rgb * (1.0h - fg.a);
}

half blendAlpha(half4 bg, half4 fg) {
    return bg.a + fg.a - bg.a * fg.a;
}

half3 rgb2hsv(half3 c)
{
    half4 K = half4(0.0h, -1.0h / 3.0h, 2.0h / 3.0h, -1.0h);
    half4 p = mix(half4(c.bg, K.wz), half4(c.gb, K.xy), step(c.b, c.g));
    half4 q = mix(half4(p.xyw, c.r), half4(c.r, p.yzx), step(p.x, c.r));

    half d = q.x - min(q.w, q.y);
    half e = 1.0e-5h;
    return half3(abs(q.z + (q.w - q.y) / (6.0h * d + e)), d / (q.x + e), q.x);
}

half3 hsv2rgb(half3 c)
{
    half4 K = half4(1.0h, 2.0h / 3.0h, 1.0h / 3.0h, 3.0h);
    half3 p = abs(fract(c.xxx + K.xyz) * 6.0h - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0h, 1.0h), c.y);
}

// Blending modes:

half4 SrcOver(half4 bg, half4 fg) {
    return half4(bg.rgb * (1.0h - fg.a) + fg.rgb, blendAlpha(bg, fg));
}

half4 Multiply(half4 bg, half4 fg) {
    return half4(bg.rgb * fg.rgb + blendResidual(bg, fg), blendAlpha(bg, fg));
}

half4 Plus(half4 bg, half4 fg) {
    return bg + fg;
}

half4 Screen(half4 bg, half4 fg) {
    return half4(bg.rgb + fg.rgb - bg.rgb * fg.rgb, blendAlpha(bg, fg));
}

half4 LinearBurn(half4 bg, half4 fg) {
    return half4(bg.rgb + fg.rgb - bg.a * fg.a, blendAlpha(bg, fg));
}

half4 Overlay(half4 bg, half4 fg) {
    half3 multiplied = 2.0h * bg.rgb * fg.rgb + blendResidual(bg, fg);
    half3 screen = fg.rgb * (1.0h + bg.a) + bg.rgb * (1.0h + fg.a) - 2.0h * fg.rgb * bg.rgb - fg.a * bg.a;
    return half4(half3(bg.rgb < 0.5h) * multiplied + half3(bg.rgb >= 0.5h) * screen, blendAlpha(bg, fg));
}

half4 Darken(half4 bg, half4 fg) {
    return half4(min(fg.rgb * bg.a, bg.rgb * fg.a) + blendResidual(bg, fg), blendAlpha(bg, fg));
}

half4 Lighten(half4 bg, half4 fg) {
    return half4(max(fg.rgb * bg.a, bg.rgb * fg.a) + blendResidual(bg, fg), blendAlpha(bg, fg));
}

half4 LinearLight(half4 bg, half4 fg) {
    return half4(bg.rgb + 2.0h * fg.rgb - bg.a * fg.a + blendResidual(bg, fg), blendAlpha(bg, fg));
}

half4 SoftLight(half4 bg, half4 fg) {
    return half4((1.0h - 2.0h * fg.rgb) * bg.rgb * bg.rgb + 2.0h * bg.rgb * fg.rgb + blendResidual(bg, fg), blendAlpha(bg, fg));
}

half4 LightDodge(half4 bg, half4 fg) {
    half bgIntensity = (bg.r + bg.g + bg.b) * 0.33333h;
    half3 multiply = bg.rgb * fg.rgb + blendResidual(bg, fg);
    half3 screen = bg.rgb + fg.rgb - bg.rgb * fg.rgb;
    return half4(mix(mix(screen * screen, screen, 0.1h), multiply, bgIntensity), blendAlpha(bg, fg));
}

half4 HsvLighten(half4 bg, half4 fg) {
    half3 fgHsv = rgb2hsv(fg.rgb);
    half3 fgDark = hsv2rgb(half3(fgHsv.r, fgHsv.g, fgHsv.b * 0.35h));
    half3 fgLight = hsv2rgb(half3(fgHsv.r, min(1.0h, fgHsv.g * 1.1h), min(1.0h, fgHsv.b * 1.1h)));
    half bgIntensity = (bg.r + bg.g + bg.b) * 0.33333h;
    return half4(mix(bg.rgb, mix(fgDark, fgLight, bgIntensity), fg.a), blendAlpha(bg, fg));
}

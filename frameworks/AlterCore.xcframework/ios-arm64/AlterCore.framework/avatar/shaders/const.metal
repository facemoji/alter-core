#include <fragment.defines>

struct FragmentUniforms {
    #ifndef COLOUR_TEXTURE
        float4 colour;
    #endif
    #ifdef TRANSPARENCY
        #ifndef TRANSPARENCY_TEXTURE
            float transparency;
        #endif
    #endif
    float brightness;
};

struct FragmentOut {
    half4 fragmentColour [[ color(0) ]];
};

fragment FragmentOut fragmentMain(
    Interpolate interpolate [[ stage_in ]],
    constant FragmentUniforms& uniforms [[ buffer(0) ]]

    #ifdef COLOUR_TEXTURE
        ,texture2d<half> colourTexture,
        sampler colourTextureSampler
    #endif

    #ifdef TRANSPARENCY_TEXTURE
        ,texture2d<half> transparencyTexture,
        sampler transparencyTextureSampler
    #endif
) {
    FragmentOut result;

    #ifdef COLOUR_TEXTURE
    half4 colour =  colourTexture.sample(colourTextureSampler, interpolate.colourCoord);
    #else
    half4 colour = half4(uniforms.colour);
    #endif

    #ifdef TRANSPARENCY
        #ifdef TRANSPARENCY_TEXTURE
        half transparency = transparencyTexture.sample(transparencyTextureSampler, interpolate.colourCoord).r;
        #else
        half transparency = half(uniforms.transparency);
        #endif
    #endif

    half3 col = colour.rgb * (1.0 + half(uniforms.brightness));

    half alpha = 1.0;
    #ifdef TRANSPARENCY
    alpha = 1.0 - transparency;
    #endif

    result.fragmentColour = half4(col.rgb, alpha);
    return result;
}

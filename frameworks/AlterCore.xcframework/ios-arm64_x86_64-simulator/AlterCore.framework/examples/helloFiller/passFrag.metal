// This shader is used only in HelloFiller, other use of FillFactory will have the version in the FillFactory companion object
#include <fragment.defines>

struct FragmentUniforms {
#ifdef OUTPUT0
    float3x3 textureMat0;
#endif
#ifdef OUTPUT1
    float3x3 textureMat1;
#endif
#ifdef OUTPUT2
    float3x3 textureMat2;
#endif
#ifdef OUTPUT3
    float3x3 textureMat3;
#endif
#ifdef OUTPUT4
    float3x3 textureMat4;
#endif
#ifdef OUTPUT5
    float3x3 textureMat5;
#endif
#ifdef OUTPUT6
    float3x3 textureMat6;
#endif
#ifdef OUTPUT7
    float3x3 textureMat7;
#endif
#ifdef OUTPUT_DEPTH
    float3x3 textureMatDepth;
#endif
};

struct FragmentOut {
#ifdef OUTPUT0
    float4 color0 [[ color(0) ]];
#endif
#ifdef OUTPUT1
    float4 color1 [[ color(1) ]];
#endif
#ifdef OUTPUT2
    float4 color2 [[ color(2) ]];
#endif
#ifdef OUTPUT3
    float4 color3 [[ color(3) ]];
#endif
#ifdef OUTPUT4
    float4 color4 [[ color(4) ]];
#endif
#ifdef OUTPUT5
    float4 color5 [[ color(5) ]];
#endif
#ifdef OUTPUT6
    float4 color6 [[ color(6) ]];
#endif
#ifdef OUTPUT7
    float4 color7 [[ color(7) ]];
#endif
#ifdef OUTPUT_DEPTH
    float depth [[ depth(any) ]];
#endif
};

fragment FragmentOut fragmentMain(
    Interpolate interpolate [[ stage_in ]],
    constant FragmentUniforms& uniforms [[ buffer(0) ]]
#ifdef OUTPUT0
    ,texture2d<float> texColor0,
    sampler texColor0Sampler
#endif
#ifdef OUTPUT1
    ,texture2d<float> texColor1,
    sampler texColor1Sampler
#endif
#ifdef OUTPUT2
    ,texture2d<float> texColor2,
    sampler texColor2Sampler
#endif
#ifdef OUTPUT3
    ,texture2d<float> texColor3,
    sampler texColor3Sampler
#endif
#ifdef OUTPUT4
    ,texture2d<float> texColor4,
    sampler texColor4Sampler
#endif
#ifdef OUTPUT5
    ,texture2d<float> texColor5,
    sampler texColor5Sampler
#endif
#ifdef OUTPUT6
    ,texture2d<float> texColor6,
    sampler texColor6Sampler
#endif
#ifdef OUTPUT7
    ,texture2d<float> texColor7,
    sampler texColor7Sampler
#endif
#ifdef OUTPUT_DEPTH
    ,texture2d<float> texDepth,
    sampler texDepthSampler
#endif
) {
    FragmentOut result;
#if defined(OUTPUT0) || defined(OUTPUT1) || defined(OUTPUT2) || defined(OUTPUT3) || defined(OUTPUT4) || defined(OUTPUT5) || defined(OUTPUT6) || defined(OUTPUT7) || defined(OUTPUT_DEPTH)
    float3 texc = float3(interpolate.texCoord, 1.0);
#endif

#ifdef OUTPUT0
    float2 tc0 = (uniforms.textureMat0 * texc).xy;
    result.color0 = texColor0.sample(texColor0Sampler, tc0);
#endif
#ifdef OUTPUT1
    float2 tc1 = (uniforms.textureMat1 * texc).xy;
    result.color1 = texColor1.sample(texColor1Sampler, tc1);
#endif
#ifdef OUTPUT2
    float2 tc2 = (uniforms.textureMat2 * texc).xy;
    result.color2 = texColor2.sample(texColor2Sampler, tc2);
#endif
#ifdef OUTPUT3
    float2 tc3 = (uniforms.textureMat3 * texc).xy;
    result.color3 = texColor3.sample(texColor3Sampler, tc3);
#endif
#ifdef OUTPUT4
    float2 tc4 = (uniforms.textureMat4 * texc).xy;
    result.color4 = texColor4.sample(texColor4Sampler, tc4);
#endif
#ifdef OUTPUT5
    float2 tc5 = (uniforms.textureMat5 * texc).xy;
    result.color5 = texColor5.sample(texColor5Sampler, tc5);
#endif
#ifdef OUTPUT6
    float2 tc6 = (uniforms.textureMat6 * texc).xy;
    result.color6 = texColor6.sample(texColor6Sampler, tc6);
#endif
#ifdef OUTPUT7
    float2 tc7 = (uniforms.textureMat7 * texc).xy;
    result.color7 = texColor7.sample(texColor7Sampler, tc7);
#endif

#ifdef OUTPUT_DEPTH
    float2 tcDepth = (uniforms.textureMatDepth * texc).xy;
    result.depth = texDepth.sample(texDepthSampler, tcDepth).r;
#endif

    return result;
}


#include <fragment.defines>

#include <blendingFunctions.metal>

struct FragmentUniforms {
    #ifndef STARTVALUE_TEXTURE
        float4 startValue;
    #endif

    #ifdef LAYER0
        #ifndef BASEVALUE0_TEXTURE
            float4 baseValue0;
        #endif
        #ifndef VALUE0_TEXTURE
            float4 value0;
        #endif
        #ifndef VALUEMASK0_TEXTURE
            float valueMask0;
        #endif
    #endif

    #ifdef LAYER1
        #ifndef BASEVALUE1_TEXTURE
            float4 baseValue1;
        #endif
        #ifndef VALUE1_TEXTURE
            float4 value1;
        #endif
        #ifndef VALUEMASK1_TEXTURE
            float valueMask1;
        #endif
    #endif

    #ifdef LAYER2
        #ifndef BASEVALUE2_TEXTURE
            float4 baseValue2;
        #endif
        #ifndef VALUE2_TEXTURE
            float4 value2;
        #endif
        #ifndef VALUEMASK2_TEXTURE
            float valueMask2;
        #endif
    #endif

    #ifdef LAYER3
        #ifndef BASEVALUE3_TEXTURE
            float4 baseValue3;
        #endif
        #ifndef VALUE3_TEXTURE
            float4 value3;
        #endif
        #ifndef VALUEMASK3_TEXTURE
            float valueMask3;
        #endif
    #endif

    #ifdef LAYER4
        #ifndef BASEVALUE4_TEXTURE
            float4 baseValue4;
        #endif
        #ifndef VALUE4_TEXTURE
            float4 value4;
        #endif
        #ifndef VALUEMASK4_TEXTURE
            float valueMask4;
        #endif
    #endif

    #ifdef LAYER5
        #ifndef BASEVALUE5_TEXTURE
            float4 baseValue5;
        #endif
        #ifndef VALUE5_TEXTURE
            float4 value5;
        #endif
        #ifndef VALUEMASK5_TEXTURE
            float valueMask5;
        #endif
    #endif

    #ifdef LAYER6
        #ifndef BASEVALUE6_TEXTURE
            float4 baseValue6;
        #endif
        #ifndef VALUE6_TEXTURE
            float4 value6;
        #endif
        #ifndef VALUEMASK6_TEXTURE
            float valueMask6;
        #endif
    #endif

    #ifdef LAYER7
        #ifndef BASEVALUE7_TEXTURE
            float4 baseValue7;
        #endif
        #ifndef VALUE7_TEXTURE
            float4 value7;
        #endif
        #ifndef VALUEMASK7_TEXTURE
            float valueMask7;
        #endif
    #endif

};


struct FragmentOut {
    float4 fragmentColour [[ color(0) ]];
};


fragment FragmentOut fragmentMain(
    Interpolate interpolate [[ stage_in ]],
    constant FragmentUniforms& uniforms [[ buffer(0) ]]

    #ifdef STARTVALUE_TEXTURE
        ,texture2d<float> startValueTexture,
        sampler startValueSampler
    #endif

    #ifdef BASEVALUE0_TEXTURE
        ,texture2d<float> baseValue0Texture,
        sampler baseValue0Sampler
    #endif
    #ifdef VALUE0_TEXTURE
        ,texture2d<float> value0Texture,
        sampler value0Sampler
    #endif
    #ifdef VALUEMASK0_TEXTURE
        ,texture2d<float> valueMask0Texture,
        sampler valueMask0Sampler
    #endif
                                  
    #ifdef BASEVALUE1_TEXTURE
        ,texture2d<float> baseValue1Texture,
        sampler baseValue1Sampler
    #endif
    #ifdef VALUE1_TEXTURE
        ,texture2d<float> value1Texture,
        sampler value1Sampler
    #endif
    #ifdef VALUEMASK1_TEXTURE
        ,texture2d<float> valueMask1Texture,
        sampler valueMask1Sampler
    #endif
                                  
    #ifdef BASEVALUE2_TEXTURE
        ,texture2d<float> baseValue2Texture,
        sampler baseValue2Sampler
    #endif
    #ifdef VALUE2_TEXTURE
        ,texture2d<float> value2Texture,
        sampler value2Sampler
    #endif
    #ifdef VALUEMASK2_TEXTURE
        ,texture2d<float> valueMask2Texture,
        sampler valueMask2Sampler
    #endif
                                  
    #ifdef BASEVALUE3_TEXTURE
        ,texture2d<float> baseValue3Texture,
        sampler baseValue3Sampler
    #endif
    #ifdef VALUE3_TEXTURE
        ,texture2d<float> value3Texture,
        sampler value3Sampler
    #endif
    #ifdef VALUEMASK3_TEXTURE
        ,texture2d<float> valueMask3Texture,
        sampler valueMask3Sampler
    #endif
                                  
    #ifdef BASEVALUE4_TEXTURE
        ,texture2d<float> baseValue4Texture,
        sampler baseValue4Sampler
    #endif
    #ifdef VALUE4_TEXTURE
        ,texture2d<float> value4Texture,
        sampler value4Sampler
    #endif
    #ifdef VALUEMASK4_TEXTURE
        ,texture2d<float> valueMask4Texture,
        sampler valueMask4Sampler
    #endif
                                  
    #ifdef BASEVALUE5_TEXTURE
        ,texture2d<float> baseValue5Texture,
        sampler baseValue5Sampler
    #endif
    #ifdef VALUE5_TEXTURE
        ,texture2d<float> value5Texture,
        sampler value5Sampler
    #endif
    #ifdef VALUEMASK5_TEXTURE
        ,texture2d<float> valueMask5Texture,
        sampler valueMask5Sampler
    #endif
                                  
    #ifdef BASEVALUE6_TEXTURE
        ,texture2d<float> baseValue6Texture,
        sampler baseValue6Sampler
    #endif
    #ifdef VALUE6_TEXTURE
        ,texture2d<float> value6Texture,
        sampler value6Sampler
    #endif
    #ifdef VALUEMASK6_TEXTURE
        ,texture2d<float> valueMask6Texture,
        sampler valueMask6Sampler
    #endif
                                  
    #ifdef BASEVALUE7_TEXTURE
        ,texture2d<float> baseValue7Texture,
        sampler baseValue7Sampler
    #endif
    #ifdef VALUE7_TEXTURE
        ,texture2d<float> value7Texture,
        sampler value7Sampler
    #endif
    #ifdef VALUEMASK7_TEXTURE
        ,texture2d<float> valueMask7Texture,
        sampler valueMask7Sampler
    #endif
                                  
) {
    FragmentOut result;

    #ifdef STARTVALUE_TEXTURE
        float4 startValue =  startValueTexture.sample(startValueSampler, interpolate.texCoord);
        #ifdef STARTVALUE_TEXTURE_INVERT
            startValue = 1.0 - startValue;
        #endif
    #else
        float4 startValue = uniforms.startValue;
    #endif

    float4 foreground;
    float4 background = startValue;

    #ifdef LAYER0
        #ifdef BASEVALUE0_TEXTURE
            float4 baseValue0 =  baseValue0Texture.sample(baseValue0Sampler, interpolate.texCoord);
            #ifdef BASEVALUE0_TEXTURE_INVERT
                baseValue0 = 1.0 - baseValue0;
            #endif
        #else
            float4 baseValue0 = uniforms.baseValue0;
        #endif
        #ifdef VALUE0_TEXTURE
            float4 value0 =  value0Texture.sample(value0Sampler, interpolate.texCoord);
            #ifdef VALUE0_TEXTURE_INVERT
                value0 = 1.0 - value0;
            #endif
        #else
            float4 value0 = uniforms.value0;
        #endif
        #ifdef VALUEMASK0_TEXTURE
            float valueMask0 =  valueMask0Texture.sample(valueMask0Sampler, interpolate.texCoord).r;
            #ifdef VALUEMASK0_TEXTURE_INVERT
                valueMask0 = 1.0 - valueMask0;
            #endif
        #else
            float valueMask0 = uniforms.valueMask0;
        #endif
        #ifdef INVERT0
            foreground = computeForegroundInverse(baseValue0, value0, valueMask0);
        #else
            foreground = computeForeground(baseValue0, value0, valueMask0);
        #endif
            background = BLEND0(background, foreground);
    #endif

    #ifdef LAYER1
        #ifdef BASEVALUE1_TEXTURE
            float4 baseValue1 =  baseValue1Texture.sample(baseValue1Sampler, interpolate.texCoord);
            #ifdef BASEVALUE1_TEXTURE_INVERT
                baseValue1 = 1.0 - baseValue1;
            #endif
        #else
            float4 baseValue1 = uniforms.baseValue1;
        #endif
        #ifdef VALUE1_TEXTURE
            float4 value1 =  value1Texture.sample(value1Sampler, interpolate.texCoord);
            #ifdef VALUE1_TEXTURE_INVERT
                value1 = 1.0 - value1;
            #endif
        #else
            float4 value1 = uniforms.value1;
        #endif
        #ifdef VALUEMASK1_TEXTURE
            float valueMask1 =  valueMask1Texture.sample(valueMask1Sampler, interpolate.texCoord).r;
            #ifdef VALUEMASK1_TEXTURE_INVERT
                valueMask1 = 1.0 - valueMask1;
            #endif
        #else
            float valueMask1 = uniforms.valueMask1;
        #endif
        #ifdef INVERT1
            foreground = computeForegroundInverse(baseValue1, value1, valueMask1);
        #else
            foreground = computeForeground(baseValue1, value1, valueMask1);
        #endif
            background = BLEND1(background, foreground);
    #endif
    
    #ifdef LAYER2
        #ifdef BASEVALUE2_TEXTURE
            float4 baseValue2 =  baseValue2Texture.sample(baseValue2Sampler, interpolate.texCoord);
            #ifdef BASEVALUE2_TEXTURE_INVERT
                baseValue2 = 1.0 - baseValue2;
            #endif
        #else
            float4 baseValue2 = uniforms.baseValue2;
        #endif
        #ifdef VALUE2_TEXTURE
            float4 value2 =  value2Texture.sample(value2Sampler, interpolate.texCoord);
            #ifdef VALUE2_TEXTURE_INVERT
                value2 = 1.0 - value2;
            #endif
        #else
            float4 value2 = uniforms.value2;
        #endif
        #ifdef VALUEMASK2_TEXTURE
            float valueMask2 =  valueMask2Texture.sample(valueMask2Sampler, interpolate.texCoord).r;
            #ifdef VALUEMASK2_TEXTURE_INVERT
                valueMask2 = 1.0 - valueMask2;
            #endif
        #else
            float valueMask2 = uniforms.valueMask2;
        #endif
        #ifdef INVERT2
            foreground = computeForegroundInverse(baseValue2, value2, valueMask2);
        #else
            foreground = computeForeground(baseValue2, value2, valueMask2);
        #endif
            background = BLEND2(background, foreground);
    #endif

    #ifdef LAYER3
        #ifdef BASEVALUE3_TEXTURE
            float4 baseValue3 =  baseValue3Texture.sample(baseValue3Sampler, interpolate.texCoord);
            #ifdef BASEVALUE3_TEXTURE_INVERT
                baseValue3 = 1.0 - baseValue3;
            #endif
        #else
            float4 baseValue3 = uniforms.baseValue3;
        #endif
        #ifdef VALUE3_TEXTURE
            float4 value3 =  value3Texture.sample(value3Sampler, interpolate.texCoord);
            #ifdef VALUE3_TEXTURE_INVERT
                value3 = 1.0 - value3;
            #endif
        #else
            float4 value3 = uniforms.value3;
        #endif
        #ifdef VALUEMASK3_TEXTURE
            float valueMask3 =  valueMask3Texture.sample(valueMask3Sampler, interpolate.texCoord).r;
            #ifdef VALUEMASK3_TEXTURE_INVERT
                valueMask3 = 1.0 - valueMask3;
            #endif
        #else
            float valueMask3 = uniforms.valueMask3;
        #endif
        #ifdef INVERT3
            foreground = computeForegroundInverse(baseValue3, value3, valueMask3);
        #else
            foreground = computeForeground(baseValue3, value3, valueMask3);
        #endif
            background = BLEND3(background, foreground);
    #endif

    #ifdef LAYER4
        #ifdef BASEVALUE4_TEXTURE
            float4 baseValue4 =  baseValue4Texture.sample(baseValue4Sampler, interpolate.texCoord);
            #ifdef BASEVALUE4_TEXTURE_INVERT
                baseValue4 = 1.0 - baseValue4;
            #endif
        #else
            float4 baseValue4 = uniforms.baseValue4;
        #endif
        #ifdef VALUE4_TEXTURE
            float4 value4 =  value4Texture.sample(value4Sampler, interpolate.texCoord);
            #ifdef VALUE4_TEXTURE_INVERT
                value4 = 1.0 - value4;
            #endif
        #else
            float4 value4 = uniforms.value4;
        #endif
        #ifdef VALUEMASK4_TEXTURE
            float valueMask4 =  valueMask4Texture.sample(valueMask4Sampler, interpolate.texCoord).r;
            #ifdef VALUEMASK4_TEXTURE_INVERT
                valueMask4 = 1.0 - valueMask4;
            #endif
        #else
            float valueMask4 = uniforms.valueMask4;
        #endif
        #ifdef INVERT4
            foreground = computeForegroundInverse(baseValue4, value4, valueMask4);
        #else
            foreground = computeForeground(baseValue4, value4, valueMask4);
        #endif
            background = BLEND4(background, foreground);
    #endif

    #ifdef LAYER5
        #ifdef BASEVALUE5_TEXTURE
            float4 baseValue5 =  baseValue5Texture.sample(baseValue5Sampler, interpolate.texCoord);
            #ifdef BASEVALUE5_TEXTURE_INVERT
                baseValue5 = 1.0 - baseValue5;
            #endif
        #else
            float4 baseValue5 = uniforms.baseValue5;
        #endif
        #ifdef VALUE5_TEXTURE
            float4 value5 =  value5Texture.sample(value5Sampler, interpolate.texCoord);
            #ifdef VALUE5_TEXTURE_INVERT
                value5 = 1.0 - value5;
            #endif
        #else
            float4 value5 = uniforms.value5;
        #endif
        #ifdef VALUEMASK5_TEXTURE
            float valueMask5 =  valueMask5Texture.sample(valueMask5Sampler, interpolate.texCoord).r;
            #ifdef VALUEMASK5_TEXTURE_INVERT
                valueMask5 = 1.0 - valueMask5;
            #endif
        #else
            float valueMask5 = uniforms.valueMask5;
        #endif
        #ifdef INVERT5
            foreground = computeForegroundInverse(baseValue5, value5, valueMask5);
        #else
            foreground = computeForeground(baseValue5, value5, valueMask5);
        #endif
            background = BLEND5(background, foreground);
    #endif

    #ifdef LAYER6
        #ifdef BASEVALUE6_TEXTURE
            float4 baseValue6 =  baseValue6Texture.sample(baseValue6Sampler, interpolate.texCoord);
            #ifdef BASEVALUE6_TEXTURE_INVERT
                baseValue6 = 1.0 - baseValue6;
            #endif
        #else
            float4 baseValue6 = uniforms.baseValue6;
        #endif
        #ifdef VALUE6_TEXTURE
            float4 value6 =  value6Texture.sample(value6Sampler, interpolate.texCoord);
            #ifdef VALUE6_TEXTURE_INVERT
                value6 = 1.0 - value6;
            #endif
        #else
            float4 value6 = uniforms.value6;
        #endif
        #ifdef VALUEMASK6_TEXTURE
            float valueMask6 =  valueMask6Texture.sample(valueMask6Sampler, interpolate.texCoord).r;
            #ifdef VALUEMASK6_TEXTURE_INVERT
                valueMask6 = 1.0 - valueMask6;
            #endif
        #else
            float valueMask6 = uniforms.valueMask6;
        #endif
        #ifdef INVERT6
            foreground = computeForegroundInverse(baseValue6, value6, valueMask6);
        #else
            foreground = computeForeground(baseValue6, value6, valueMask6);
        #endif
            background = BLEND6(background, foreground);
    #endif

    #ifdef LAYER7
        #ifdef BASEVALUE7_TEXTURE
            float4 baseValue7 =  baseValue7Texture.sample(baseValue7Sampler, interpolate.texCoord);
            #ifdef BASEVALUE7_TEXTURE_INVERT
                baseValue7 = 1.0 - baseValue7;
            #endif
        #else
            float4 baseValue7 = uniforms.baseValue7;
        #endif
        #ifdef VALUE7_TEXTURE
            float4 value7 =  value7Texture.sample(value7Sampler, interpolate.texCoord);
            #ifdef VALUE7_TEXTURE_INVERT
                value7 = 1.0 - value7;
            #endif
        #else
            float4 value7 = uniforms.value7;
        #endif
        #ifdef VALUEMASK7_TEXTURE
            float valueMask7 =  valueMask7Texture.sample(valueMask7Sampler, interpolate.texCoord).r;
            #ifdef VALUEMASK7_TEXTURE_INVERT
                valueMask7 = 1.0 - valueMask7;
            #endif
        #else
            float valueMask7 = uniforms.valueMask7;
        #endif
        #ifdef INVERT7
            foreground = computeForegroundInverse(baseValue7, value7, valueMask7);
        #else
            foreground = computeForeground(baseValue7, value7, valueMask7);
        #endif
            background = BLEND7(background, foreground);
    #endif

    result.fragmentColour = background;
    return result;
}

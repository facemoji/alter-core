
struct FragmentUniforms {
    float slice;
};

constant float PI = 3.141593;

fragment half4 fragmentMain(
    Interpolate interpolate [[ stage_in ]],
    constant FragmentUniforms& uniforms [[ buffer(0) ]],
    texturecube<half> texColor [[ texture(0) ]],
    sampler texColorSampler[[ sampler(0) ]]
) {
    return texColor.sample(texColorSampler,
        float3(
                cos(interpolate.tc.x * PI * 2.0) * sin(interpolate.tc.y * PI),
                sin(interpolate.tc.x * PI * 2.0) * sin(interpolate.tc.y * PI),
                cos(interpolate.tc.y * PI)
               ));
}


struct FragmentUniforms {
    float slice;
};

fragment half4 fragmentMain(
    Interpolate interpolate [[ stage_in ]],
    constant FragmentUniforms& uniforms [[ buffer(0) ]],
    texture2d_array<half> texColor [[ texture(0) ]],
    sampler texColorSampler[[ sampler(0) ]]
) {
    return texColor.sample(texColorSampler, interpolate.tc, uniforms.slice);
}

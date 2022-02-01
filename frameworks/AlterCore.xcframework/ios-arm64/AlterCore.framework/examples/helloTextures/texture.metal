
fragment half4 fragmentMain(
    Interpolate interpolate [[ stage_in ]],
    texture2d<half> texColor [[ texture(0) ]],
    sampler texColorSampler[[ sampler(0) ]]
) {
    return texColor.sample(texColorSampler, interpolate.tc);
}

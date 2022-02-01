struct FragmentOut {
    float4 color [[ color(0) ]]; 
    float4 viewPosition [[ color(1) ]]; 
    float4 viewNormal [[ color(2) ]]; 
};
fragment FragmentOut fragmentMain(
    Interpolate interpolate [[ stage_in ]],
    texture2d<float> texColor [[ texture(0) ]],
    sampler texColorSampler [[ sampler(0) ]]
) {
    FragmentOut result;
//    result.color = float4(interpolate.tc, 1.0 - max(interpolate.tc.x, interpolate.tc.y), 1.0);
    result.color = texColor.sample(texColorSampler, interpolate.tc);
    result.viewPosition = interpolate.viewPos;
    result.viewNormal = float4(normalize(interpolate.viewNorm), 1.0);
    return result;
}

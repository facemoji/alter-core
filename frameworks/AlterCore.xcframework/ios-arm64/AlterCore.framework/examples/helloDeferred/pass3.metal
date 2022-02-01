using namespace metal;
struct Interpolate {
    float4 position [[ position ]];
    float2 tc;
};
vertex Interpolate vertexMain(
    const device packed_float2* vertex_array0 [[ buffer(0) ]],
    unsigned int vid [[ vertex_id ]]
) {
    float2 position = vertex_array0[vid];
    Interpolate result;
    result.position = float4(position, 0.0, 1.0);
    result.tc = position * 0.5 + 0.5;
    result.tc.y = 1.0 - result.tc.y;
    return result;
}

fragment half4 fragmentMain(
    Interpolate interpolate [[ stage_in ]],
    texture2d<half> texColor [[ texture(0) ]],
    sampler texColorSampler[[ sampler(0) ]],
    texture2d<half> texDiffuse [[ texture(1) ]],
    sampler texDiffuseSampler[[ sampler(1) ]],
    texture2d<half> texSpecular [[ texture(2) ]],
    sampler texSpecularSampler[[ sampler(2) ]]
) {
    half4 color = texColor.sample(texColorSampler, interpolate.tc);
    half4 diffuse = texDiffuse.sample(texDiffuseSampler, interpolate.tc);
    half4 specular = texSpecular.sample(texSpecularSampler, interpolate.tc);
    return color * diffuse + specular;
}

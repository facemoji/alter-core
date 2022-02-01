using namespace metal;
struct VertexUniforms {
    float2 nSize;
    float4x4 modelView;
    float4x4 projection;
};
struct Interpolate {
    float4 position [[ position ]];
    float3 lightPos;
    float2 tc;
    float scale;
};
vertex Interpolate vertexMain(
    const device packed_float2* vertex_array0 [[ buffer(0) ]],
    unsigned int vid [[ vertex_id ]],
    constant VertexUniforms& uniforms [[ buffer(1) ]]
) {
    float2 position = vertex_array0[vid];
    Interpolate result;
    result.scale = 1.3 * uniforms.nSize.y / uniforms.nSize.x;
    float4 pos = uniforms.modelView * float4(result.scale / 8.0, 0.0, 1.5, 1.0); 
    result.lightPos = pos.xyz;
    pos.xy = pos.xy + position * result.scale;
    result.position = uniforms.projection * pos;
    result.tc = result.position.xy / result.position.w * 0.5 + 0.5;
    result.tc.y = 1.0 - result.tc.y;
    return result;
}

struct FragmentUniforms {
    float4 color;
};
struct FragmentOut {
    float4 diffuse [[ color(0) ]]; 
    float4 specular [[ color(1) ]]; 
};
fragment FragmentOut fragmentMain(
    Interpolate interpolate [[ stage_in ]],
    constant FragmentUniforms& uniforms [[ buffer(0) ]],
    texture2d<float> texPosition [[ texture(0) ]],
    sampler texPositionSampler[[ sampler(0) ]],
    texture2d<float> texNormal [[ texture(1) ]],
    sampler texNormalSampler[[ sampler(1) ]]
) {
    FragmentOut result;
    float4 pos = texPosition.sample(texPositionSampler, interpolate.tc);
    if (abs(pos.w) < 0.001) discard_fragment();
    float4 norm = texNormal.sample(texNormalSampler, interpolate.tc);
    if (norm.w < 0.1) discard_fragment();
    float3 position = pos.xyz;
    float3 normal = norm.xyz;
    float3 lightVec = interpolate.lightPos - position;
    float dist = length(lightVec);
    float atten = max(0.0, 1.0 - pow(dist / interpolate.scale, 2.0)); 
    float d = atten * max(0.0, dot(lightVec / dist, normal)); 
    result.diffuse = float4(uniforms.color.rgb * d, 1.0);
    float3 h = lightVec - position;
    float s = atten * pow(max(0.0, dot(normalize(h), normal)), 30.0);
    result.specular = float4(uniforms.color.rgb * s, 1.0);
    return result;
}

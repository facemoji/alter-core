using namespace metal;
struct VertexUniforms {
    float2 size;
    float2 offset;
};
struct Interpolate {
    float4 position [[ position ]];
    float2 tc;
};
vertex Interpolate vertexMain(
    const device packed_float2* vertex_array0 [[ buffer(0) ]],
    unsigned int vid [[ vertex_id ]],
    constant VertexUniforms& uniforms [[ buffer(1) ]]
) {
    float2 position = vertex_array0[vid];
    Interpolate result;
    result.position = float4(position * uniforms.size + uniforms.offset, 0.0, 1.0);
    result.tc = position * 0.5 + 0.5;
//    result.tc.y = 1.0 - result.tc.y;
    return result;
}

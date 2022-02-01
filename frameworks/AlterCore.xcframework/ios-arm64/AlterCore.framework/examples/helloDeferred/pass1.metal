using namespace metal;
struct VertexUniforms {
    float4x4 modelView;
    float4x4 projection;
};
struct VertexIn {
    packed_float3 position;
    packed_float3 normal;
    packed_float2 texcoord;
};
struct Interpolate {
    float4 position [[ position ]];
    float4 viewPos;
    float3 viewNorm;
    float2 tc;
};
float3x3 subMat(float4x4 m) {
    return float3x3(m[0].xyz, m[1].xyz, m[2].xyz);
}
vertex Interpolate vertexMain(
    const device VertexIn* vertex_array0 [[ buffer(0) ]],
    unsigned int vid [[ vertex_id ]],
    constant VertexUniforms& uniforms [[ buffer(1) ]]
) {
    VertexIn vert = vertex_array0[vid];
    Interpolate result;
    result.viewPos = uniforms.modelView * float4(vert.position, 1.0);
    result.position = uniforms.projection * result.viewPos;
    result.viewNorm = normalize(subMat(uniforms.modelView) * float3(vert.normal));
    result.tc = vert.texcoord;
    return result;
}

#include "pass1Frag.metal"

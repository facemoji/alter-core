using namespace metal;
struct Interpolate {
    float4 position [[ position ]];
    float2 texCoord;
};
vertex Interpolate vertexMain(
    const device packed_float2* vertex_array0 [[ buffer(0) ]],
    unsigned int vid [[ vertex_id ]]
) {
    float2 position = vertex_array0[vid];
    Interpolate result;
    result.position = float4(position.x, -position.y, 0.0, 1.0);
    result.texCoord = position * 0.5 + 0.5;
    return result;
}

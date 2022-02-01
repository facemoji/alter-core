using namespace metal;

#include <vertex.defines>

#include <quaternion.metal>

float3x3 subMat(float4x4 m) {
    return float3x3(m[0].xyz, m[1].xyz, m[2].xyz);
}


struct VertexUniforms {
    #if !defined(USE_BONES) || defined(INSTANCED)
    float4x4 modelView;
    #endif
    float4x4 projection;
    #ifdef USE_BLENDSHAPES
        float bsWeights[BLENDSHAPES_COUNT];
        #ifdef TEXCOORD_BLENDSHAPES
            float bsTexcoordWeights[TEXCOORD_BLENDSHAPES_COUNT];
        #endif
    #endif
    #ifdef USE_BONES
        float4x4 bones[BONE_COUNT];
    #endif
    #if defined INSTANCED && defined USE_BONES
        float4x4 modelViewInverse;
    #endif
};


struct Interpolate {
    float4 position [[ position ]];
    float3 viewPos;
    float3 viewNorm;
    float2 colourCoord;
    #ifdef INST_COLOUR_TEXTURE
        float4 instColour;
    #endif
};


vertex Interpolate vertexMain(
    const device packed_float3* vertex_positions,
    const device packed_float3* vertex_normals,
    const device packed_float2* vertex_texcoords,
    #ifdef USE_BLENDSHAPES
        const device packed_float2* vertex_bsTexcoords,
    #endif
    #ifdef USE_BONES
        const device float* vertex_bonesTexcoords,
    #endif
    constant VertexUniforms& uniforms,
    unsigned int vid [[ vertex_id ]]

    #ifdef USE_BLENDSHAPES
        ,texture2d_array<float> bsVerticesTexture,
        sampler bsVerticesTextureSampler,
        texture2d_array<float> bsNormalsTexture,
        sampler bsNormalsTextureSampler
        #ifdef TEXCOORD_BLENDSHAPES
            ,texture2d_array<float> bsTexcoordsTexture,
            sampler bsTexcoordsTextureSampler
        #endif
    #endif

    #ifdef USE_BONES
        ,texture2d<float> bonesTexture,
        sampler bonesTextureSampler
    #endif

    #ifdef INSTANCED
        ,unsigned int instanceID [[instance_id]]
        ,texture2d<float> instPositionScaleTexture,
        sampler instPositionScaleTextureSampler
        ,texture2d<float> instRotationTexture,
        sampler instRotationTextureSampler
        #ifdef INST_COLOUR_TEXTURE
            ,texture2d<float> instColourTexture,
            sampler instColourTextureSampler
        #endif
    #endif
) {
    Interpolate result;
    float3 pos = vertex_positions[vid];
    float3 norm = vertex_normals[vid];
    float2 texc = vertex_texcoords[vid];
    #ifdef USE_BLENDSHAPES
    uint2 bsTexcoord = uint2(vertex_bsTexcoords[vid]);
    #endif
    #ifdef USE_BONES
    float bonesTexcoord = vertex_bonesTexcoords[vid];
    #endif

    #if !defined(USE_BONES) || defined(INSTANCED)
    float4x4 modelView = uniforms.modelView;
    #endif
    #if !defined(USE_BONES) || defined(INST_BILLBOARD)
    float3x3 modelView3 = subMat(modelView);
    #endif

    #ifdef INSTANCED
    uint instTexWidth = instPositionScaleTexture.get_width();
    uint2 instCoord = uint2(instanceID % instTexWidth, instanceID / instTexWidth);
    float4 instPositionScale = instPositionScaleTexture.read(instCoord);
    float4 instRotation = instRotationTexture.read(instCoord);
    #ifdef INST_COLOUR_TEXTURE
    result.instColour = instColourTexture.read(instCoord);
    #endif
    #endif

    #ifdef USE_BLENDSHAPES
    for (uint i = 0; i < BLENDSHAPES_COUNT; i = i + 1) {
        if (uniforms.bsWeights[i] > 0.005) {
            pos = pos + bsVerticesTexture.read(bsTexcoord, i).xyz * uniforms.bsWeights[i];
            norm = norm + bsNormalsTexture.read(bsTexcoord, i).xyz * uniforms.bsWeights[i];
        }
    }
    #ifdef TEXCOORD_BLENDSHAPES
    for (uint i = 0; i < TEXCOORD_BLENDSHAPES_COUNT; i = i + 1) {
        if (uniforms.bsTexcoordWeights[i] > 0.005) {
            texc = texc + bsTexcoordsTexture.read(bsTexcoord, i).xy * uniforms.bsTexcoordWeights[i];
        }
    }
    #endif
    #endif

    float4 hPos = float4(pos, 1.0);

    #ifdef USE_BONES
    uint bonesTexIndex = uint(bonesTexcoord);
    uint boneTexWidth = bonesTexture.get_width();
    float3 posSum = float3(0.0);
    float3 normSum = float3(0.0);
    for (uint i = 0; i < BONE_COUNT; i = i + 1) {
        float2 boneIndexWeight = bonesTexture.read(uint2(bonesTexIndex % boneTexWidth, bonesTexIndex / boneTexWidth)).xy;
        int boneIndex = int(boneIndexWeight.x);
        if (boneIndex < 0) break;
        float4x4 boneMatrix = uniforms.bones[boneIndex];
        posSum += (boneMatrix * hPos).xyz * boneIndexWeight.y;
        normSum += normalize(subMat(boneMatrix) * norm) * boneIndexWeight.y;
        bonesTexIndex = bonesTexIndex + 1;
    }

    float4 hViewPos = float4(posSum, 1.0);
    result.viewNorm = normalize(normSum);

    #ifdef INSTANCED
    pos = (uniforms.modelViewInverse * hViewPos).xyz;
    pos = mulqv(instRotation, pos) * instPositionScale.w;
    #ifdef INST_BILLBOARD
    pos = pos * float3(length(modelView3[0]), length(modelView3[1]), length(modelView3[2]));
    pos = pos + (modelView * float4(instPositionScale.xyz, 1.0)).xyz;
    hViewPos = float4(pos, 1.0);
    #else
    pos = pos + instPositionScale.xyz;
    hViewPos = modelView * float4(pos, 1.0);
    #endif
    result.viewNorm = mulqv(instRotation, result.viewNorm);
    #endif

    #else // USE_BONES

    #ifdef INSTANCED
    pos = mulqv(instRotation, pos) * instPositionScale.w;
    #ifdef INST_BILLBOARD
    pos = pos + (modelView * float4(instPositionScale.xyz, 1.0)).xyz;
    float4 hViewPos = float4(pos, 1.0);
    #else
    pos = pos + instPositionScale.xyz;
    float4 hViewPos = modelView * float4(pos, 1.0);
    #endif
    norm = mulqv(instRotation, norm);
    #else // INSTANCED
    float4 hViewPos = modelView * hPos;
    #endif

    result.viewNorm = normalize(modelView3 * norm);

    #endif // USE_BONES

    result.position = uniforms.projection * hViewPos;
    result.viewPos = hViewPos.xyz;
    result.colourCoord = texc;

    return result;
}

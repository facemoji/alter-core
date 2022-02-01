float4 quat(float angle, float3 axis) { // axis must be normalized
    float s = sin(angle * 0.5);
    float c = cos(angle * 0.5);
    return float4(axis * s, c);
}

float4 mulqq(float4 q1, float4 q2) {
    return float4(q2.xyz * q1.w + q1.xyz * q2.w + cross(q1.xyz, q2.xyz), q1.w * q2.w - dot(q1.xyz, q2.xyz));
}

float3 mulqv(float4 q, float3 v) {
    float3 t = cross(2.0 * q.xyz, v);
    return v + q.w * t + cross(q.xyz, t);
}

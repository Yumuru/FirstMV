float lighting(float3 p, float3 n) {
    float3 dir = UnityWorldSpaceLightDir(mul(unity_ObjectToWorld, float4(p, 1)));
    return dot(n, dir);
}

float3 getDDCrossNormal(float3 p) {
    float3 x = normalize(ddx(p));
    float3 y = normalize(ddy(p));
    return cross(y, x);
}

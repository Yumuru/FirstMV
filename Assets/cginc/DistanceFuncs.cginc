#include "./Vector.cginc"

#ifndef DistanceFuncs
#define DistanceFuncs
float sdSphere(float3 p, float s) {
    return length(p)-s;
}

float sdBox(float3 p, float3 b) {
    float3 q = abs(p) - b;
    return length(max(q,0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float sdTorus(float3 p, float2 t) {
    float2 q = float2(length(p.xz) - t.x, p.y);
    return length(q)-t.y;
}

// This can only use on ConstantDistanceRaymarching
float sdLineBox(float3 p, float3 b, float w) {
    p = abs(p);
    float lenx = length(p.yz - b.yz);
    float leny = length(p.zx - b.zx);
    float lenz = length(p.xy - b.xy);
    float mn = min(lenx, min(leny, lenz));
    float3 n = normalize(float3(step(lenx, mn), step(leny, mn), step(lenz, mn)));
    float3 pos = min(project(p, n), b);
    pos = pos + step(n, 0.5) * b;
    return sdSphere(p - pos, w);
}
#endif

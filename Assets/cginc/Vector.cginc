#ifndef Vector
#define Vector

const float PI = 3.141592653589793;

float3 rotate(float3 p, float angle, float3 axis) {
    float3 a = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float r = 1.0 - c;
    float3x3 m = float3x3(
        a.x * a.x * r + c,
        a.y * a.x * r + a.z * s,
        a.z * a.x * r - a.y * s,
        a.x * a.y * r - a.z * s,
        a.y * a.y * r + c,
        a.z * a.y * r + a.x * s,
        a.x * a.z * r + a.y * s,
        a.y * a.z * r - a.x * s,
        a.z * a.z * r + c
    );
    return mul(m, p);
}

float3 makeVertical(float3 v) {
	return normalize(cross(v, rotate(rotate(v, PI * 0.1, float3(0,1,0)), PI*0.1, float3(0,0,1))));
}

float3 project(float3 p, float3 d) {
    d = normalize(d);
    return dot(p, d) * d;
}

float3 projectOnPlane(float3 p, float3 n) {
    n = normalize(n);
    return cross(n, cross(p, n));
}
#endif

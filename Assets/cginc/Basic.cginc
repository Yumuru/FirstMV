float lighting(float3 p, float3 n) {
    float3 dir = UnityWorldSpaceLightDir(mul(unity_ObjectToWorld, float4(p, 1)));
    return dot(n, dir);
}

float3 getDDCrossNormal(float3 p) {
    float3 x = normalize(ddx(p));
    float3 y = normalize(ddy(p));
    return cross(y, x);
}

inline float EncodeDepth(float4 pos) {
	float z = pos.z / pos.w;
#if defined(SHADER_API_GLCORE) || \
	defined(SHADER_API_OPENGL) || \
	defined(SHADER_API_GLES) || \
	defined(SHADER_API_GLES3)
	return z * 0.5 + 0.5;
#else 
	return z;
#endif 
}

inline float GetCameraDepth(float3 pos) {
	float4 vpPos = mul(UNITY_MATRIX_VP, float4(pos, 1.0));
	return EncodeDepth(vpPos);
}

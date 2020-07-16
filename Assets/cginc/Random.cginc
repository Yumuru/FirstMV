float rand(float3 v, float seed)
{
	return frac(sin(dot(v.xyz, float3(12.9898, 78.233, 56.787) * seed)) * 43758.5453);
}

float3 rand3(float3 v, float seed) {
	return float3(rand(v.yxy, seed), rand(v.yzx, seed-23.33 * 324.22), rand(v.zxy, (seed+342.2345) * 332.34));
}

static float3 zero3 = float3(0, 0, 0);
static float3 zero3beat[4] = { zero3, zero3, zero3, zero3 };
static float3 zero3bar[4][4] = { zero3beat, zero3beat, zero3beat, zero3beat };

static float4 zero4 = float4(0, 0, 0, 0);
static float4 zero4beat[4] = { zero4, zero4, zero4, zero4 };
static float4 zero4bar[4][4] = { zero4beat, zero4beat, zero4beat, zero4beat };

#define dfau4(elem) { elem, elem, elem, elem, }

static float3 valueToMusic(float value) {
	float bar = value;
	float beat = frac(value) * 4;
	float unit = frac(beat) * 4;
	bar = floor(bar);
	beat = floor(beat);
	return float3(bar, beat, unit);
}

static float musicToValue(float3 m) {
	return m.x + 
		   m.y / 4 +
		   m.z / 16;
}

static float3 musicBefore(float3 current, int num) {
	current.z -= num;
	float nmusic = musicToValue(current);
	nmusic = lerp(nmusic, 0, step(nmusic, 0));
	return valueToMusic(nmusic);
}

#define getVal(arr, m) arr[m.x][m.y][m.z]

static float toRateEasy(float3 mus, float3 from, float backU) {
	float valt = musicToValue(mus);
	float valf = musicToValue(from);
	float valb = musicToValue(float3(0, 0, backU));
	return saturate((valt - valf) / valb);
}
	

#define toRate(arr, mus, backU, ind, rate) \
	rate = 0.; \
	for (int _i = 0; _i < backU; _i++) { \
		float3 m = musicBefore(mus, _i); \
		float r = 1 - (_i + frac(mus.z)) / backU; \
		r = lerp(0, r, arr[m.x][m.y][m.z][ind]); \
		rate = max(rate, r); \
	} \
	rate = (1 - rate) 


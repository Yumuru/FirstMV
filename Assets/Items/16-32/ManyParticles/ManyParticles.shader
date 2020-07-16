Shader "Items/16_32/ManyParticles" {
    Properties {
		_Value("Value", Float) = 0
		_Radius("Radius", Float) = 10
    }
    SubShader {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100

		Blend SrcAlpha OneMinusSrcAlpha

		Pass {
			CGPROGRAM

            #include "UnityCG.cginc"
			#include "Assets/cginc/Vector.cginc"
			#include "Assets/cginc/Random.cginc"

			#pragma vertex vert
			#pragma geometry geo
			#pragma fragment frag

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct fin {
                float4 vertex : SV_POSITION;
				float3 center : TEXCOORD0;
				float3 pos : TEXCOORD1;
				float3 col : TEXCOORD2;
            };

            appdata vert (appdata v) {
				return v;
            }

			float _Value;
			float _Radius;

			#include "Poses.cginc"
#define BLUE_GREEN fixed4(.2, 1, .6, 1)
#define DARK_ORANGE fixed4(255,140,0,255) / 255
#define PURPLE fixed4(0.5,0,0.5,1)
#define MAGENTA fixed4(1, 0, 1, 1)
#define LEMON_CHIFFON fixed4(255,250,205,255)/255
#define LIME fixed4(0, 1, 0, 1)
#define MEDIUM_SEA_GREEN fixed4(60, 179, 113, 255) / 255
			static fixed4 cols[7] = {
				BLUE_GREEN,
				DARK_ORANGE,
				PURPLE,
				MAGENTA,
				LEMON_CHIFFON,
				LIME,
				MEDIUM_SEA_GREEN,
			};

			[maxvertexcount(30)]
			void geo(triangle appdata inp[3], inout TriangleStream<fin> strm) {
				if (_Value < 0 || _Value >= 16) return;
				float beat = frac(_Value) * 4;
				float unit = frac(beat) * 4;
				float3 lposes[3] = posroute[_Value][beat][unit];
				fin o;
				float3 cPos = mul(unity_WorldToObject,	float4(_WorldSpaceCameraPos, 1));
				float3 center = (inp[0].vertex + inp[1].vertex + inp[2].vertex) / 3;
				for (int j = 0; j < 10; j++) {
					center = (rand3(inp[0].vertex * j, 120)-0.5) * 100;
					bool isL = false;
					for (int k = 0; k < 3; k++) {
						isL = isL || length(lposes[k] - center) < _Radius;
					}
					if (!isL) continue;
					float3 cDir = normalize(center - cPos);
					center += sin(rand3(center, j)*_Time.y) * 2.;
					o.center = center;
					float bar = floor(_Value);
					float ran = rand(float3(bar, bar*300, bar / 20), 30);
					o.col = cols[ran*7];
					float3 p0 = normalize(cross(cDir, float3(0,1,0.2342)));
					float3 p1 = rotate(p0, radians(120), cDir);
					float3 p2 = rotate(p0, radians(240), cDir);
					float3 p[3] = { p0, p1, p2 };
					for (int i = 0; i < 3; i++) {
						float3 pos = p[i] * 3 + center;
						o.pos = pos;
						o.vertex = UnityObjectToClipPos(o.pos);
						strm.Append(o);
					}
					strm.RestartStrip();
				}
			}

			fixed4 frag (fin i) : SV_Target {
				float3 cPos = mul(unity_WorldToObject,	float4(_WorldSpaceCameraPos, 1));
				float3 cDir = normalize(i.pos - cPos);
				float d = length(i.pos - i.center);
				fixed4 col = fixed4(i.col, (1 - d));
				if (d > 0.2) discard;
				float a = (0.3-d)/0.3;
				col = fixed4(i.col*3, a);
				return col;
			}
			ENDCG
		}
    }
}

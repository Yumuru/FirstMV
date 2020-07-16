Shader "Item/16_32/RandomLaser" {
    Properties
    {
        _Value ("Value", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma geometry geo

            #include "UnityCG.cginc"
			#include "Assets/cginc/Random.cginc"
			#include "Assets/cginc/Music.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct fin {
                float4 vertex : SV_POSITION;
				float3 n : NORMAL;
				float3 pos : TEXCOORD0;
				fixed4 col : TEXCOORD1;
				float3 val : TEXCOORD2;
            };

			float _Value;

            appdata vert (appdata v) {
				return v;
            }

			#include "Values.cginc"
			#define DEEP_PINK fixed4(255,20,147,255)/255

			[maxvertexcount(3)]
			void geo(triangle appdata inp[3], inout TriangleStream<fin> str) {
				if (_Value < 0 || _Value >= 8) return;
				fin o;
				o.n = normalize(cross(inp[1].vertex - inp[0].vertex, inp[2].vertex - inp[0].vertex));
				float bar = _Value;
				float unit = frac(bar) * 16;
				float val = inp[0].uv.x;
				float lightind = rand(float3(val, frac(val*val), floor(val/2+val*13)), 223.35) * 6;
				float lightv = 0.f;
				for (int i = 0; i < 4; i++) {
					float val = (frac(unit) + i) / 4;
					float valb = lerp(bar, bar-1, step(val, 0));
					val = lerp(val, val+16, step(val, 0));
					val = lerp(0, val, light[valb][unit-i][lightind]);
					lightv = max(lightv, val);
				}
				o.val = float3(lightv, 0, 0);
				for (int i = 0; i < 3; i++) {
					o.pos = inp[i].vertex;
					o.vertex = UnityObjectToClipPos(o.pos);
					o.col = col[bar];
					str.Append(o);
				}
				str.RestartStrip();
			}

            fixed4 frag (fin i) : SV_Target {
				float3 cPos = mul(unity_WorldToObject,	float4(_WorldSpaceCameraPos, 1));
				if (length(cPos - i.pos) < 20) discard;
				float3 cDir = normalize(i.pos - cPos);
				if (i.val.x < 0.01) discard;
                return i.col * i.val.x * pow(dot(i.n, -cDir), 10-i.val.x*10) * 2.0;
            }
            ENDCG
        }
    }
}

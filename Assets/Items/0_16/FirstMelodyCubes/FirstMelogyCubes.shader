Shader "Items/0_16/FirstMelodyCubes" {
    Properties {
		_Value ("Value", Float) = 0
		_Value2 ("Value2", Float) = 0
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma geometry geo
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
			#include "Assets/cginc/Random.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float3 n : NORMAL;
            };

            struct fin {
                float4 vertex : SV_POSITION;
				float3 n : NORMAL;
				fixed4 col : TEXCOORD0;
				float4 pos : TEXCOORD1;
            };

            appdata vert (appdata v) {
				return v;
            }

			#include "Colors.cginc"

			float _Value = 0.;
			float _Value2 = 0.;

			[maxvertexcount(3)]
			void geo(triangle appdata inp[3], inout TriangleStream<fin> strm) {
				if (_Value < 0 || _Value >= 8) return;
				fin o;
				float2 vals = inp[0].uv;
				o.n = normalize(cross(inp[1].vertex - inp[0].vertex, inp[2].vertex - inp[0].vertex));
				float routed = route[_Value][fmod(_Value*16, 16)];
				o.col = cols[_Value][routed][vals.x * 3][vals.y];
				float3 cpos = (rand3(float3(vals.x, vals.x*2, vals.x+3), seed[_Value] + seed2[_Value2])-0.5) * 50;
				for (int i = 0; i < 3; i++) {
					float4 pos = inp[i].vertex;
					o.pos = float4(cpos + (pos - inp[i].n), 1);
					o.vertex = UnityObjectToClipPos(o.pos);
					strm.Append(o);
				}
				strm.RestartStrip();
			}

            fixed4 frag (fin i) : SV_Target
            {
				float3 cPos = mul(unity_WorldToObject,	float4(_WorldSpaceCameraPos, 1));
				float3 cDir = normalize(i.pos - cPos);
                // sample the texture
                fixed4 col = lerp(1, i.col, dot(i.n, -cDir));
                return col;
            }
            ENDCG
        }
    }
}

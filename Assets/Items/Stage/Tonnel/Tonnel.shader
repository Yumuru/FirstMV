Shader "Item/Stage/Tonnel"
{
    Properties {
        _Value ("Value", Float) = 0
		_Length("Length", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
			Cull off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma geometry geo
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
			#include "Assets/cginc/Music.cginc"
			#include "Assets/cginc/Vector.cginc"
			#include "Assets/cginc/Random.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float3 n : NORMAL;
                float3 uv : TEXCOORD0;
            };

            struct fin {
                float4 vertex : SV_POSITION;
				float3 n : NORMAL;
				float3 pos : TEXCOORD0;
            };

			float _Value;
			float _Length;

			#include "Values.cginc"

            appdata vert (appdata v) {
				return v;
            }

#define LIGHT_SKY_BLUE fixed4(135,206,250,255)/255
#define BLUE_GREEN fixed4(.2, 1, .6, 1)
			[maxvertexcount(3)]
			void geo(triangle appdata inp[3], inout TriangleStream<fin> strm) {
				if (_Value < 0) return;
				if (inp[0].uv.x < 0) return;
				fin o;
				float3 cur = valueToMusic(_Value);
				float rate;
				//toRate(val, cur, 448, 0, rate);
				rate = toRateEasy(cur, float3(0, 0, 0), 144);
				int num = inp[0].uv.x * 144;
				rate *= 144;
				if (num > rate) return;
				rate = saturate((rate - num) / 16);
				float size = rate;
				float angle = rate * 720. - _Time.y * 30 + num * 14;
				float3 center = float3(0, 0, inp[0].uv.x * _Length);
				for (int i = 0; i < 3; i++) {
					o.pos = inp[i].vertex * size + center;
					o.pos = rotate(o.pos, radians(angle), float3(0, 0, 1));
					o.vertex = UnityObjectToClipPos(o.pos);
					o.n = inp[i].n;
					strm.Append(o);
				}
				strm.RestartStrip();
			}

            fixed4 frag (fin i) : SV_Target {
				return BLUE_GREEN * 3;
            }
            ENDCG
        }
    }
}

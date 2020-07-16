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
			float _Rate;

			#include "Values.cginc"

            appdata vert (appdata v) {
				return v;
            }

#define SPRING_GREEN fixed4(0,255,127,255)/255

			[maxvertexcount(3)]
			void geo(triangle appdata inp[3], inout TriangleStream<fin> strm) {
				if (_Value < 0) return;
				fin o;
				o.n = normalize(cross(inp[1].vertex - inp[0].vertex, inp[2].vertex - inp[0].vertex));
				for (int i = 0; i < 3; i++) {
					o.pos = inp[i].vertex;
					o.vertex = UnityObjectToClipPos(o.pos);
					o.n = inp[i].n;
					strm.Append(o);
				}
				strm.RestartStrip();
			}

            fixed4 frag (fin i) : SV_Target {
				float3 cPos = mul(unity_WorldToObject,	float4(_WorldSpaceCameraPos, 1));
				float3 cDir = normalize(i.pos - cPos);
				float posRate = i.pos.z / _Length;
				if (posRate > _Value) discard;
				float r = saturate((r - posRate) / _Rate);
                return SPRING_GREEN * dot(i.n, float3(0, 1, 0));
            }
            ENDCG
        }
    }
}

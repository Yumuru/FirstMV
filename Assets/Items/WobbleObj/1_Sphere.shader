Shader "Item/Wobble/1_Sphere"
{
    Properties {
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
				fixed4 col : TEXCOORD1;
            };

			float _Value;
			#include "Values.cginc"

            appdata vert (appdata v) {
				return v;
            }

			[maxvertexcount(3)]
			void geo(triangle appdata inp[3], inout TriangleStream<fin> strm) {
				if (_Value < 0 ) return;
				fin o;
				float3 pos[3];
				for(int i = 0; i < 3; i++) {
					pos[i] = inp[i].vertex;
					pos[i] = rotate(pos[i], radians(_Time.y * 30), float3(0, 1, 0));
				}
				o.n = normalize(cross(pos[1] - pos[0], pos[2] - pos[0]));
				float3 cur = valueToMusic(_Value);
				if (inp[0].uv.x != getVal(val1, cur)[0]) return;
				float3 center = float3(inp[1].uv.x, inp[1].uv.y, inp[2].uv.x);
				o.col = fixed4(rand3(inp[0].uv.x+1, -843.2), 1);
				for (int i = 0; i < 3; i++) {
					o.pos = pos[i];
					o.vertex = UnityObjectToClipPos(o.pos);
					strm.Append(o);
				}
				strm.RestartStrip();
			}

            fixed4 frag (fin i) : SV_Target {
				float3 cPos = mul(unity_WorldToObject,	float4(_WorldSpaceCameraPos, 1));
				float3 cDir = normalize(i.pos - cPos);
                return i.col * dot(i.n, -cDir) * 3.0;
            }
            ENDCG
        }
    }
}

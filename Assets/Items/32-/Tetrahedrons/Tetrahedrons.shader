Shader "Items/32_/Tetrahedrons"
{
    Properties {
        _Value ("Value", Float) = 0
		_Widthx ("Widthx", Float) = 0
		_Widthy ("Widthy", Float) = 0
		_Widthz ("Widthz", Float) = 0
		_Thre ("Thre", Float) = 0
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
			#include "Assets/cginc/Random.cginc"
			#include "Assets/cginc/Music.cginc"
			#include "Assets/cginc/Vector.cginc"

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
			float _Widthx;
			float _Widthy;
			float _Widthz;
			float _Thre;
			#include "Values.cginc"

            appdata vert (appdata v) {
				return v;
            }

			[maxvertexcount(3)]
			void geo(triangle appdata inp[3], inout TriangleStream<fin> strm) {
				fin o;
				if (_Value < 0) return;
				o.n = normalize(cross(inp[1].vertex - inp[0].vertex, inp[2].vertex - inp[0].vertex));
				float3 cur = valueToMusic(_Value);
				o.col = fixed4(rand3(inp[0].n, 103), 1);
				float3 center = inp[0].n * 9;
				float3 nCenter = center;
				nCenter = rotate(center, radians(_Time.y * 30), float3(0, 1, 0));
				float3 axis = float3(
					sin(center.x * _Time.y * 0.5),
					sin(center.y * _Time.y + 3),
					sin(center.z * _Time.y * -0.5)
				);
				float angle = sin(center.x * _Time.y * 0.23) - sin(center.y * (_Time.y*0.1 + 30)) +
					cos(center.z * _Time.y * 0.13);
				float3 diff = nCenter - center;
				for (int i = 0; i < 3; i++) {
					float3 pos = inp[i].vertex - center;
					pos = rotate(pos, angle, axis);
					o.pos = pos + center + diff;
					o.vertex = UnityObjectToClipPos(o.pos);
					strm.Append(o);
				}
				strm.RestartStrip();
			}

            fixed4 frag (fin i) : SV_Target {
				float3 cPos = mul(unity_WorldToObject,	float4(_WorldSpaceCameraPos, 1));
				float3 cDir = normalize(i.pos - cPos);
                return i.col * dot(i.n, -cDir) * 1.5;
            }
            ENDCG
        }
    }
}

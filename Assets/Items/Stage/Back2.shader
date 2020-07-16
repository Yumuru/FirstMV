Shader "Items/Stage/Back2"
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
                float3 uv : TEXCOORD0;
            };

            struct fin {
                float4 vertex : SV_POSITION;
				float3 pos : TEXCOORD0;
            };

			float _Value;

            appdata vert (appdata v) {
				return v;
            }

			[maxvertexcount(3)]
			void geo(triangle appdata inp[3], inout TriangleStream<fin> strm) {
				fin o;
				for (int i = 0; i < 3; i++) {
					o.pos = inp[i].vertex;
					o.vertex = UnityObjectToClipPos(o.pos);
					strm.Append(o);
				}
				strm.RestartStrip();
			}

            fixed4 frag (fin i) : SV_Target {
				float3 axis = rotate(i.pos, 3*sin(_Time.y)*cos(_Time.x*2), float3(cos(_Time.x + 2), sin(_Time.y * 0.4), cos(_Time.y * 1.3)));
				float3 pos = rotate(i.pos, radians(i.pos.x*30-i.pos.y*20+i.pos.z*50)*10, axis);
				pos = normalize(pos + float3(0,1,1) * 0.3);
				return 0;
                return _Value * fixed4(pos, 1);
            }
            ENDCG
        }
    }
}

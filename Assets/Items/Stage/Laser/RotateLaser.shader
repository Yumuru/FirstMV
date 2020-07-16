Shader "Items/Stage/RotateLaser"
{
    Properties {
        _Value ("Value", Float) = 0
        _Value2 ("Value2", Float) = 0
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
                float3 uv : TEXCOORD0;
            };

            struct fin {
                float4 vertex : SV_POSITION;
				float3 pos : TEXCOORD0;
				fixed4 col : TEXCOORD1;
            };

			float _Value;
			float _Value2;

            appdata vert (appdata v) {
				return v;
            }

			#include "RotateLaserValue.cginc"

			[maxvertexcount(3)]
			void geo(triangle appdata inp[3], inout TriangleStream<fin> strm) {
				fin o;
				float v = val[_Value][inp[0].uv.x];
				if (v < 0) return; 
				o.col = col[v];
				for (int i = 0; i < 3; i++) {
					o.pos = inp[i].vertex;
					o.pos = rotate(o.pos, radians(_Value2 * 360), float3(1, 0, 0));
					o.vertex = UnityObjectToClipPos(o.pos);
					strm.Append(o);
				}
				strm.RestartStrip();
			}

            fixed4 frag (fin i) : SV_Target {
                return i.col;
            }
            ENDCG
        }
    }
}

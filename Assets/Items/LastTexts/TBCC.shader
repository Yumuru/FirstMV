Shader "Items/LastText/ToBeContinuedCube" {
    Properties {
        _Value ("Value", Float) = 0
		_Color ("Color", Color) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry+1" }
        LOD 100

        Pass {
			Stencil {
				Ref 1
				Comp Always
				Pass replace
			}

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
			fixed4 _Color;

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
				return _Color * step(frac(_Value*16), (1-0.5));
            }
            ENDCG
        }
    }
}


Shader "Wire/Grid" {
    Properties {
		_Radius("Radius", Float) = 10
		_Size("Size", Vector) = (1, 1, 0, 0)
		_Threshold("Threshold", Float) = 0.9
    }
    SubShader {

        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

			float2 _Size;
			float _Threshold;
			float _Radius;

			struct appdata {
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};

            struct fin {
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float3 pos : TEXCOORD0;
				fixed4 col : TEXCOORD1;
            };

            fin vert(appdata v) {
				fin o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.pos = v.vertex;
				o.col = fixed4(0, 1, 1, 1) * 10;
                return o;
            }

			float lighting(float3 n) {
				return dot(normalize(n), mul(UNITY_MATRIX_M, _WorldSpaceLightPos0));
			}

            fixed4 frag (fin i) : SV_Target {
				float2 pos = abs(i.pos.xz - 500 - _Size/2);
				float2 uv = fmod(pos, _Size) / _Size;
				uv = abs((uv-0.5)*2);
				float v = max(uv.x, uv.y);
				fixed4 col = lerp(i.col, fixed4(0,0,0,1), step(v, _Threshold));
                col = col * max(lighting(float3(0, 1, 0)), 0.2) * 1.2;
				UNITY_APPLY_FOG(i.fogCoord, col);
                return lerp(0, col, step(length(i.pos), _Radius));
            }
            ENDCG
        }
    }
}

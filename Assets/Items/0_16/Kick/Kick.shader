Shader "Items/0_16/Kick" {
    Properties {
        _Iteration ("Iteration", Range(0, 256)) = 128
		_Interval("Interval", Float) = 30
		_Size("Size", Float) = 1
		_Edge("Edge", Float) = 200
		_Value("Value", Float) = 0
    }
    SubShader {
		Cull front

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
			#include "Assets/cginc/Basic.cginc"
			#include "Assets/cginc/DistanceFuncs.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct fin {
                float4 vertex : SV_POSITION;
				float4 pos : TEXCOORD1;
            };

            appdata vert (appdata v) {
				return v;
            }

			uint _Iteration;
			float _Interval;
			float _Size;
			float _Edge;
			float _Value;

			[maxvertexcount(3)]
			void geo(triangle appdata inp[3], inout TriangleStream<fin> strm) {
				fin o;
				for (int i = 0; i < 3; i++) {
					float4 pos = inp[i].vertex;
					o.pos = pos;
					o.vertex = UnityObjectToClipPos(o.pos);
					strm.Append(o);
				}
				strm.RestartStrip();
			}

			float map(float3 p, float rate) {
				rate = 1 - rate;
				return sdSphere(p, max(_Size, _Size * rate * 1.5));
			}

			#include "Colors.cginc"

			float distray(float3 p, out fixed4 col) {
				p += _Interval * 0.5;
				float3 c = floor((p+_Interval*0.5) / _Interval) * _Interval;
				float val = fmod(_Value * 16, 16) + ((c.y/_Edge));
				float chkv = _Value + val / 16;
				if (chkv < 0 || chkv >= 5) return 100;
				col = cols[route[_Value][val]];
				p.y -= (frac(_Time.y * 1.5) * _Interval);
				float rate = frac(val / 2);
				float3 q = (frac((p +_Interval*0.5)/_Interval)-0.5) * _Interval;
				return map(q, rate);
			}

			float distray(float3 p) {
				fixed4 c;
				return distray(p, c);
			}

            float3 GetNormal(float3 p) {
                float ep = 0.0001;
                float x = distray(p + float3(ep, 0, 0))
                        - distray(p - float3(ep, 0, 0));
                float y = distray(p + float3(0, ep, 0))
                        - distray(p - float3(0, ep, 0));
                float z = distray(p + float3(0, 0, ep))
                        - distray(p - float3(0, 0, ep));
                return normalize(float3(x, y, z));
            }

            fixed4 frag (fin i, out float depth : SV_Depth) : SV_Target
            {
				float3 cPos = mul(unity_WorldToObject,	float4(_WorldSpaceCameraPos, 1));
				float3 cDir = normalize(i.pos - cPos);
				float d;
				bool isColl = false;
				float3 pos = cPos;
				fixed4 col;
				for (uint i = 0; i < _Iteration; i++) {
					d = distray(pos, col);
					pos += cDir * d;
					isColl = d <= 0.00001;
					if (isColl) break;
				}
				if (!isColl) discard;
				depth = GetCameraDepth(pos);
				float3 n = GetNormal(pos);
				col = lerp(col, 1, dot(n, -cDir) * 0.8);
                return col;
            }
            ENDCG
        }
    }
}

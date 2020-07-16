Shader "Item/HexagonalObj" {
    Properties
    {
        _Value ("Value", Float) = 0
		_Height1("Height1", Float) = 0
		_Height2("Height2", Float) = 0
		_Size("Size", Float) = 0
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

            #include "UnityCG.cginc"
			#include "Assets/cginc/Random.cginc"
			#include "Assets/cginc/Music.cginc"
			#include "Assets/cginc/Vector.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float3 center : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct fin {
                float4 vertex : SV_POSITION;
				float3 n : NORMAL;
				float3 pos : TEXCOORD0;
				fixed4 col : TEXCOORD1;
				float3 vals : TEXCOORD2;
            };

			float _Value;
			float _Height1;
			float _Height2;
			float _Size;

            appdata vert (appdata v) {
				return v;
            }


#define DARK_ORANGE fixed4(255,140,0,255) / 255
#define CRIMSON fixed4(220,20,60,255)/255
#define SPRING_GREEN fixed4(0,255,127,255)/255
			static fixed4 col[4] = {
				SPRING_GREEN,
				fixed4(1, 1, 0, 1),
				CRIMSON,
				fixed4(0, 0.3, 1, 1),
			};
			
			#include "Values.cginc"
			[maxvertexcount(3)]
			void geo(triangle appdata inp[3], inout TriangleStream<fin> str) {
				if (_Value < 0) return;
				fin o;
				float3 center = inp[0].center * 20;
				float3 cur = valueToMusic(_Value);
				o.col = col[inp[0].uv.x];
				o.n = normalize(cross(inp[1].vertex - inp[0].vertex, inp[2].vertex - inp[0].vertex));
				o.vals = float3(0, 0, 0);
				//o.col = fixed4(center, 1);
				for (int i = 0; i < 3; i++) {
					o.pos = inp[i].vertex;
					float3 posFc = (o.pos - center) * 1.5;
					posFc = rotate(posFc, radians(_Time.y * 30), float3(0, 1, 0));
					o.n = rotate(o.n, radians(_Time.y * 30), float3(0, 1, 0));
					o.pos = posFc + center;
					float rate;
					switch(inp[0].uv.x) {
						case 0 : 
							toRate(con0_0, cur, 4, 1, rate);
							o.pos = center + posFc * rate;
							o.vals.x = get(con0_0, cur)[0];
							break;
						case 1 : 
							toRate(con1_0, cur, 4, 1, rate);
							o.pos.y -= _Height1 * (1 - rate) * dist[inp[0].uv.y];
							toRate(con1_0, cur, 8, 3, rate);
							float pos2 = o.pos.y + _Height2 * rate * dist[inp[0].uv.y];
							o.pos.y = lerp(o.pos.y, pos2, get(con1_0, cur)[2]);
							float3 pos = o.pos - center;
							pos = rotate(pos, radians(720 * rate * dist[inp[0].uv.y]), float3(0, 1, 0));
							o.pos = pos + center;
							o.vals.x = o.pos.y * dist[inp[0].uv.y] * get(con1_0, cur)[0];
							break;
						case 2 : 
							o.vals.x = lerp(0, 1, get(con2_0, cur)[0]);
							break;
						case 3 : 
							float type = get(con3_0, cur)[0];
							o.pos = inp[i].vertex;
							o.vals.x = get(con3_0, cur)[0];
							break;
						default : break;
					}
					o.vertex = UnityObjectToClipPos(o.pos);
					str.Append(o);
				}
				str.RestartStrip();
			}

            fixed4 frag (fin i) : SV_Target {
				float3 cPos = mul(unity_WorldToObject,	float4(_WorldSpaceCameraPos, 1));
				float3 cDir = normalize(i.pos - cPos);
				if (i.vals.x <= 0) discard;
                return i.col * dot(i.n, -cDir) * 1.5;
            }
            ENDCG
        }
    }
}

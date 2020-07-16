Shader "Item/32_/GroundSphere" {
    Properties
    {
		_Height("Height", Float) = 0
		_AniHeight1("AH1", Float) = 0
		_AniHeight2("AH2", Float) = 0
		_Value("Value", Float) = 0
		_Speed("Speed", Float) = 0
		_Light("Light", Float) = 0
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

			static float PI2 = PI * 2.;

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct fin {
                float4 vertex : SV_POSITION;
				float3 pos : TEXCOORD0;
            };

			float _Value;
			float _Height;
			float _AniHeight1;
			float _AniHeight2;
			float _Speed;
			float _Light;

			#include "Values.cginc"

            appdata vert (appdata v) { 
				return v;
            }

			[maxvertexcount(3)]
			void geo(triangle appdata inp[3], inout TriangleStream<fin> strm) {
				if (_Value < 0) return;
				float num = inp[0].uv.x;
				float3 cur = valueToMusic(_Value);
				float rate;
				toRate(val, cur, 32, 0, rate);
				if (1-num > rate) return;
				float movey1 = -fmod(_AniHeight1 * _Time.y, _AniHeight1 / 10);
				float movey2 = fmod(_AniHeight2 * _Time.y, _AniHeight2 / 10);
				float angle = _Time.y * _Speed * getVal(val, cur)[6];
				fin o;
				for (int i = 0; i < 3; i++) {
					o.pos = inp[i].vertex;
					o.pos.y += movey1 * getVal(val, cur)[4];
					o.pos.y += movey2 * getVal(val, cur)[5];
					o.pos = rotate(o.pos, angle, float3(0,1,0));
					o.vertex = UnityObjectToClipPos(o.pos);
					strm.Append(o);
				}
				strm.RestartStrip();
			}


            fixed4 frag (fin i) : SV_Target {
				return fixed4(0, 1, 0, 1) * 3 * _Light;
            }
            ENDCG
        }
    }
}

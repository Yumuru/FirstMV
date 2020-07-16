Shader "Item/32_/CircleVertical" {
    Properties
    {
		_Height("Height", Float) = 0
		_Value("Value", Float) = 0
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
			#include "Assets/cginc/Music.cginc"

			static float PI = 3.141592653589793;
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

			#include "Values.cginc"

            fin vert (appdata v)
            {
				if (_Value >= 2) _Value = 1.9999;
                fin o;
				float rate;
				float3 cur = valueToMusic(_Value);
				toRate(val, cur, 8, 2, rate);
				o.pos = v.vertex;
				o.pos.y = lerp(o.pos.y, o.pos.y * (1-rate), getVal(val, cur)[1]);
                o.vertex = UnityObjectToClipPos(o.pos);
                return o;
            }

            fixed4 frag (fin i) : SV_Target {
				if (_Value < 0) discard;
				float3 cur = valueToMusic(_Value);
				float rate;
				toRate(val, cur, 28, 0, rate);
				if (i.pos.y > _Height * rate) discard;
				return fixed4(0, 1, 1, 1) * 3;
            }
            ENDCG
        }
    }
}

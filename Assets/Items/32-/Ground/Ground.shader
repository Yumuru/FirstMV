Shader "Unlit/Ground"
{
    Properties
    {
		_Value("Value", Float) = 0
		_Size("Size", Float) = 20
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

			float _Size;
			float _Value;

            fin vert (appdata v)
            {
                fin o;
				o.pos = v.vertex;
                o.vertex = UnityObjectToClipPos(o.pos);
                return o;
            }

			#include "Values.cginc"

            fixed4 frag (fin i) : SV_Target {
				if (_Value < 0) discard;
				if (_Value >= 4) _Value = 3.999;
				float len = length(i.pos);
				float rate;
				float3 cur = valueToMusic(_Value);
				toRate(cont, cur, 24., 0., rate);
				float size = lerp(_Size, _Size / 2, rate);
				if (len > size) discard;
				float a = 0;
				a = lerp(0, 1, step(len, size));
				a = lerp(0, a, step(size - 0.02, len));
				fixed4 col1 = fixed4(0, 1, 1, a);
				toRate(cont, cur, 32, 4, rate);
				rate = rate - 0.5;
				rate = rate * 2;
				size = _Size / 2;
				fixed4 col = lerp(col1, col1, getVal(cont, cur)[3]);
				if (col.a < 0.1) discard;
				return col;
            }
            ENDCG
        }
    }
}

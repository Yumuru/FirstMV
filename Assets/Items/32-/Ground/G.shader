Shader "Unlit/G"
{
    Properties
    {
		_Value("Value", Float) = 0
		_Size("Size", Float) = 20
		_Color("Color", Color) = (0,1,.7,1)
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
			#include "Assets/cginc/Vector.cginc"

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
			fixed4 _Color;

            fin vert (appdata v)
            {
                fin o;
				o.pos = v.vertex;
				o.pos = rotate(o.pos, radians(_Time.y * 15), float3(0, 0, 1)) * _Value;
                o.vertex = UnityObjectToClipPos(o.pos);
                return o;
            }

            fixed4 frag (fin i) : SV_Target {
				return _Color;
            }
            ENDCG
        }
    }
}

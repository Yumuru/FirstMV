Shader "Item/16_32/StarParticle" {
    Properties
    {
        _Value ("Value", Float) = 0
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct fin
            {
                float4 vertex : SV_POSITION;
            };

			float _Value;

            appdata vert (appdata v) {
				return v;
            }

			[maxvertexcount(3)]
			void geo(triangle appdata inp[3], inout TriangleStream<fin> str) {
				if (_Value < 0) return;
			}

            fixed4 frag (fin i) : SV_Target
            {
                return 0;
            }
            ENDCG
        }
    }
}

Shader "Items/Spheres" {
    Properties {
        [IntRange] _Iteration ("Marching Iteration", Range(0, 256)) = 128
        _Size("Size", Float) = 0.1
        _Width("Width", Range(0, 2)) = 0.5
        _Value("Value", Range(0, 5)) = 0.0
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            Cull off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "/Assets/cginc/Basic.cginc"
            #include "/Assets/cginc/DistanceFuncs.cginc"

            uint _Iteration;
            float _Size;
            float _Width;
            float _Value;

            struct appdata {
                float4 vertex : POSITION;
            };
            
            struct fin {
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 pos : TEXCOORD0;
            };

            fin vert (appdata v) {
                fin o;
                o.pos = v.vertex;
                o.vertex = UnityObjectToClipPos(o.pos);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float distray(float3 p) {
                float wSize = 1 - saturate(_Value - 4.);
                float size = saturate(_Value) * wSize;
                float c = sdSphere(p, size * _Size);
                float t = saturate(_Value - 1.);
                float px0 = sdSphere(p + float3(t * _Width, 0, 0) * wSize, _Size * size);
                float px1 = sdSphere(p - float3(t * _Width, 0, 0) * wSize, _Size * size);
                t = saturate(_Value - 2.);
                float py0 = sdSphere(p + float3(0, t * _Width, 0) * wSize, _Size * size);
                float py1 = sdSphere(p - float3(0, t * _Width, 0) * wSize, _Size * size);
                t = saturate(_Value - 3.);
                float pz0 = sdSphere(p + float3(0, 0, t * _Width) * wSize, _Size * size);
                float pz1 = sdSphere(p - float3(0, 0, t * _Width) * wSize, _Size * size);
                float px = min(px0, px1);
                float py = min(py0, py1);
                float pz = min(pz0, pz1);
                float pv = min(px, min(py, pz));
                return min(c, pv);
            }


            float3 getNormal(float3 p) {
                float ep = 0.000001;
                float x = distray(p + float3(ep, 0, 0))
                        - distray(p - float3(ep, 0, 0));
                float y = distray(p + float3(0, ep, 0))
                        - distray(p - float3(0, ep, 0));
                float z = distray(p + float3(0, 0, ep))
                        - distray(p - float3(0, 0, ep));
                return normalize(float3(x, y, z));
            }

            fixed4 frag (fin i, out float depth : SV_Depth) : SV_Target {
                float3 cPos = mul(unity_WorldToObject,
                                float4(_WorldSpaceCameraPos, 1));
                float3 cDir = normalize(i.pos - cPos);
                float3 pos = cPos;
                float d;
                bool isColl = false;
                for (uint i = 0; i < _Iteration; i++) {
                    d = distray(pos);
                    pos += cDir * d;
                    isColl = d <= 0.000001;
                    if (isColl) break;
                }
                if (!isColl) discard;
                float3 n = UnityObjectToWorldNormal(getNormal(pos));
                fixed4 c1 = 1;
                fixed4 c2 = fixed4(0, 1, 1, 0);
                fixed4 col = lerp(c1, c2, (1-dot(n, -cDir)));
                UNITY_APPLY_FOG(i.fogCoord, col);
				depth = GetCameraDepth(pos);
                return col;
            }
            ENDCG
        }
    }
}

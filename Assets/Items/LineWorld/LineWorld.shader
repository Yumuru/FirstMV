
Shader "Items/LineWorld" {
    Properties {
        [IntRange] _Iteration ("Marching Iteration", Range(0, 256)) = 128
        _Size("Size", Range(0, 2)) = 1
		_BoxColor("BoxColor", Color) = (0, 0, 1, 1)
        _WSize("WSize", Range(0, 10)) = 2
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
			fixed4 _BoxColor;
            float _WSize;
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

            float map(float3 p, out fixed4 col) {
                float ax = sdBox(p, float3(_WSize/2, _Width, _Width));
                float ay = sdBox(p, float3(_Width, _WSize/2, _Width));
                float az = sdBox(p, float3(_Width, _Width, _WSize/2));
                float box = sdBox(p, _Size);
                float a = min(ax, min(ay, az));
                fixed4 ca = fixed4(0, 1, 0, 1);
                fixed4 cb = _BoxColor;
                col = lerp(ca, cb, step(box, a));
                return min(a, box);
            }

            float distray(float3 p, out fixed4 col) {
				p += 100 * _WSize + _WSize * 0.5;
                float3 c = _WSize;
                float3 q = fmod(p+0.5*c,c)-0.5*c;
                return map(q, col);
            }

            float distray(float3 p) {
                fixed4 c;
                return distray(p, c);
            }

            float3 getNormal(float3 p) {
                float ep = 0.0001;
                float x = distray(p + float3(ep, 0, 0))
                        - distray(p - float3(ep, 0, 0));
                float y = distray(p + float3(0, ep, 0))
                        - distray(p - float3(0, ep, 0));
                float z = distray(p + float3(0, 0, ep))
                        - distray(p - float3(0, 0, ep));
                return normalize(float3(x, y, z));
            }

            fixed4 frag (fin i) : SV_Target {
                float3 cPos = mul(unity_WorldToObject,
                                float4(_WorldSpaceCameraPos, 1));
                float3 cDir = normalize(i.pos - cPos);
                float3 pos = cPos;
                float d;
                bool isColl = false;
                fixed4 c2;
                for (uint i = 0; i < _Iteration; i++) {
                    d = distray(pos, c2);
                    pos += cDir * d;
                    isColl = d <= 0.000001;
                    if (isColl) break;
                }
                if (!isColl) discard;
                float3 n = UnityObjectToWorldNormal(getNormal(pos));
                fixed4 c1 = 1;
                fixed4 col = lerp(c1, c2, (1-dot(n, -cDir)));
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}

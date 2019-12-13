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

// 繰り返し
opRep {
    float3 c = _WSize;
    float3 q = fmod(p+0.5*c,c)-0.5*c;
    return map(q);
}

//
//  AGBrightnessFilter.metal
//  AGPosterSnap
//
//  Created by Michael Liptuga on 06.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void AGBrightnessFilter(
                             texture2d<float, access::write> outTexture [[texture(0)]],
                             texture2d<float, access::read> inTexture [[texture(1)]],
                             const device float *brightness [[buffer(0)]],
                             uint2 gid [[thread_position_in_grid]])
{
    const float4 inColor = inTexture.read(gid);
    const float4 outColor = float4(inColor.rgb + float3(*brightness), inColor.a);
    outTexture.write(outColor, gid);
}

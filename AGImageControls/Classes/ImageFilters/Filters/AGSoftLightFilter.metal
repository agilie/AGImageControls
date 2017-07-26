//
//  AGSoftLightFilter.metal
//  AGPosterSnap
//
//  Created by Michael Liptuga on 05.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void AGSoftLightFilter(
                            texture2d<float, access::write> outTexture [[texture(0)]],
                            texture2d<float, access::read> inTexture [[texture(1)]],
                            const device float *colorRed [[buffer(0)]],
                            const device float *colorGreen [[buffer(1)]],
                            const device float *colorBlue [[buffer(2)]],
                            const device float *colorAlpha [[buffer(3)]],
                            uint2 gid [[thread_position_in_grid]])
{
    const float4 inColor = inTexture.read(gid);
    const float4 adjustColor = float4(*colorRed, *colorGreen, *colorBlue, *colorAlpha);
    
    const float alphaDivisor = inColor.a + step(inColor.a, 0.0);
    const float4 outColor = float4(inColor * (adjustColor.a * (inColor / alphaDivisor) + (2.0 * adjustColor * (1.0 - (inColor / alphaDivisor)))) + adjustColor * (1.0 - inColor.a) + inColor * (1.0 - adjustColor.a));
    outTexture.write(outColor, gid);
}

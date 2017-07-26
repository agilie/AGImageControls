//
//  AGSharpenFilter.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 05.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Metal
#if !(arch(i386) || arch(x86_64)) && os(iOS)
    import MetalPerformanceShaders
#endif
import Accelerate

internal class AGSharpenFilter: AGImageFilter {
    
    internal var radius: Float = 0.0
    
    private var weightTexture: AnyObject?
    
    var weights: [Float] = [
        -6,  0,  0,
        0,  1,  0,
        0,  0,  6
    ]

    internal override func processMetal(_ device: AGImageMetalDevice, _ commandBuffer: MTLCommandBuffer, _ commandEncoder: MTLComputeCommandEncoder) -> Bool {
        
        commandEncoder.endEncoding()
        
        weights[0] = -radius
        weights[8] = radius
        #if !(arch(i386) || arch(x86_64)) && os(iOS)
            let sharpen = MPSImageConvolution(device: device.device,
                                              kernelWidth: 3,
                                              kernelHeight: 3,
                                              weights: weights)
            
            sharpen.encode(commandBuffer: commandBuffer, sourceTexture: device.texture!, destinationTexture: device.outputTexture!)
        #endif

        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        return true
    }
    
}


//
//  AGBlurFilter.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 06.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Metal

#if !(arch(i386) || arch(x86_64)) && os(iOS)
    import MetalPerformanceShaders
#endif

import Accelerate

internal class AGBlurFilter: AGImageFilter {
    
    internal var radius: Float = 0.0

    internal override func processMetal(_ device: AGImageMetalDevice, _ commandBuffer: MTLCommandBuffer, _ commandEncoder: MTLComputeCommandEncoder) -> Bool {
        commandEncoder.endEncoding()
        
        #if !(arch(i386) || arch(x86_64)) && os(iOS)
            let blur = MPSImageGaussianBlur(device: device.device, sigma: self.radius / 2)
            blur.encode(commandBuffer: commandBuffer, sourceTexture: device.texture!, destinationTexture: device.outputTexture!)
        #endif
        
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        return true
    }
}

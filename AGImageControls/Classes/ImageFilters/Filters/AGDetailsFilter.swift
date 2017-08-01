//
//  AGDetailsFilter.swift
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

internal class AGDetailsFilter: AGImageFilter {
    
    internal var radius: Float = 0.0
    
    private var weightTexture: AnyObject?
        
    var weights: [Float] = [
        0.0, 0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0, 0.0
    ]
    
    var weightsMatrix: [Float] = [
        -0.5, -0.75,  -1.0, -0.75, -0.5,
        -0.75, 1.2,   2.0, 1.20, -0.75,
        -1.0,  2.0,   7.0, 2.0, -1.0,
        -0.75, 1.20,  2.0, 1.20, -0.75,
        -0.5, -0.75,  -1.0, -0.75, -0.5
    ]
    
    internal override func processMetal(_ device: AGImageMetalDevice, _ commandBuffer: MTLCommandBuffer, _ commandEncoder: MTLComputeCommandEncoder) -> Bool {
        
        commandEncoder.endEncoding()
        
        for i in 0..<weights.count
        {
            if (weightsMatrix[i] > 0){
                weights[i] = 1.0 / 3.0  + weightsMatrix[i] * radius
            } else {
                weights[i] = weightsMatrix[i] * radius
            }
        }
        
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

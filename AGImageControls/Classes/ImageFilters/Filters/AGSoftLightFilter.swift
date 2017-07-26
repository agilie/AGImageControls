//
//  AGSoftLightFilter.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 05.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import Metal

internal class AGSoftLightFilter: AGImageFilter {
    
    internal override var metalName: String {
        get {
            return "AGSoftLightFilter"
        }
    }
    
    internal var color: ColorType = (1.0, 1.0, 1.0, 1.0)
    
    internal override func processMetal(_ device: AGImageMetalDevice, _ commandBuffer: MTLCommandBuffer, _ commandEncoder: MTLComputeCommandEncoder) -> Bool {
        let factors: [Float] = [color.r, color.g, color.b, color.a]
        
        for i in 0..<factors.count {
            var factor = factors[i]
            let size = max(MemoryLayout<Float>.size, 16)
            
            let options: MTLResourceOptions
                options = [.storageModeShared]
            
            let buffer = device.device.makeBuffer(
                bytes: &factor,
                length: size,
                options: options
            )
            commandEncoder.setBuffer(buffer, offset: 0, at: i)
        }
        
        return super.processMetal(device, commandBuffer, commandEncoder)
    }
}


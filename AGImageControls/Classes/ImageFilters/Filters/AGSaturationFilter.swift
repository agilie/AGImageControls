//
//  AGSaturationFilter.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 06.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Metal

internal class AGSaturationFilter: AGImageFilter {
        
    internal override var metalName: String {
        get {
            return "AGSaturationFilter"
        }
    }
    
    internal var saturation : Float = 1.0
    
    internal override func processMetal(_ device: AGImageMetalDevice, _ commandBuffer: MTLCommandBuffer, _ commandEncoder: MTLComputeCommandEncoder) -> Bool {
        let factors2: [Float] = [saturation]
        
        for i in 0..<factors2.count {
            var factor = factors2[i]
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

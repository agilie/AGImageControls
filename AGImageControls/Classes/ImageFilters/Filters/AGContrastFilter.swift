//
//  AGContrastFilter.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 06.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

#if !os(watchOS)
    import Metal
#endif

internal class AGContrastFilter: AGImageFilter {
    
    internal override var metalName: String {
        get {
            return "AGContrastFilter"
        }
    }
    
    internal var threshold: Float = 0.5
    
    internal override func processMetal(_ device: AGImageMetalDevice, _ commandBuffer: MTLCommandBuffer, _ commandEncoder: MTLComputeCommandEncoder) -> Bool {
        let factors: [Float] = [self.threshold]
        
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

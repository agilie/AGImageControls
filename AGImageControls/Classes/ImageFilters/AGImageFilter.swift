//
//  AGImageFilter.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 25.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Metal

internal class AGImageFilter {
    
    internal var metalName: String {
        get {
            return ""
        }
    }
    
    internal var metalPipeline: AnyObject?
    
    internal init(device: AGImageDevice) {
        let metalDevice = device as! AGImageMetalDevice
        self.metalPipeline = self.loadMetalPipeline(device: metalDevice.device)
    }
    
    internal func process(device: AGImageDevice) -> Bool {
        guard let device = device as? AGImageMetalDevice else { return false }
        
        let commandBuffer = device.commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer.makeComputeCommandEncoder()
        
        if let pipeline = self.metalPipeline as? MTLComputePipelineState {
            commandEncoder.setComputePipelineState(pipeline)
            
            commandEncoder.setTexture(device.outputTexture!, at: 0)
            commandEncoder.setTexture(device.texture!, at: 1)
        }
        
        let retValue = self.processMetal(device, commandBuffer, commandEncoder)
        device.swapBuffer()
        
        return retValue
    }
    
    @available(iOS 8, *)
    internal func processMetal(_ device: AGImageMetalDevice, _ commandBuffer: MTLCommandBuffer, _ commandEncoder: MTLComputeCommandEncoder) -> Bool {
        // Draw
        guard let pipeline = self.metalPipeline as? MTLComputePipelineState else {
            commandEncoder.endEncoding()
            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
            return false
        }
        
        let width = pipeline.threadExecutionWidth
        let height = pipeline.maxTotalThreadsPerThreadgroup / width
        
        commandEncoder.dispatchThreadgroups(
            MTLSizeMake(Int(ceil(Float(device.drawRect!.width) / Float(width))), Int(ceil(Float (device.drawRect!.height) / Float(height))), 1),
            threadsPerThreadgroup: MTLSizeMake(width, height, 1)
        )
        commandEncoder.endEncoding()
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        return true
    }
}

extension AGImageFilter
{
    fileprivate func loadMetalPipeline(device: MTLDevice) -> MTLComputePipelineState? {
        guard let bundle = Bundle(identifier: "com.AGImageControls") ?? Bundle(identifier: "org.cocoapods.AGImageControls") else { return nil }
        guard let filePath = bundle.path(forResource: "default", ofType: "metallib") else { return nil }
        guard self.metalName.lengthOfBytes(using: .ascii) > 0 else { return nil }
        
        do {
            let library = try device.makeLibrary(filepath: filePath)
            guard let function = library.makeFunction(name: self.metalName) else { return nil }
            
            return try device.makeComputePipelineState(function: function)
        } catch let error {
            print(error)
            return nil
        }
    }
}

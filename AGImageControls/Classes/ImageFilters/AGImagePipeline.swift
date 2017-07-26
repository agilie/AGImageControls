//
//  AGImagePipeline.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 25.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

open class AGImagePipeline: AGImageChain {
        
    public init() {
        super.init(image: nil)
    }
    
    public func image(_ image: UIImage) -> UIImage? {
        
        self.device.image = image
        return super.image()
    }
    
    public func image(_ image: CGImage) -> CGImage? {
        
        self.device.cgImage = image
        self.device.imageScale = 1.0
        self.device.spaceSize = CGSize(
            width: image.width,
            height: image.height
        )
        
        self.device.beginGenerate(self.isAlphaProcess)
        self.filterList.forEach { filter in
            _ = filter.process(device: self.device)
        }
        return self.device.endGenerate()
    }
    
    public func image(_ buffer: CVImageBuffer) -> CGImage? {
        let width = CVPixelBufferGetWidth(buffer)
        let height = CVPixelBufferGetHeight(buffer)
        
        let ciImage: CIImage
        if #available(iOS 9.0, *) {
            ciImage = CIImage(cvImageBuffer: buffer)
        } else {
            ciImage = CIImage(cvPixelBuffer: buffer)
        }
        let ciContext: CIContext
            if #available(OSX 10.11, iOS 9, tvOS 9, *) {
                if let device = self.device as? AGImageMetalDevice {
                    ciContext = CIContext(mtlDevice: device.device)
                } else {
                    ciContext = CIContext()
                }
            } else {
                ciContext = CIContext()
            }
        
        let cgMakeImage = ciContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: width, height: height))
        guard let cgImage = cgMakeImage else { return nil }
        
        return self.image(cgImage)
    }
}

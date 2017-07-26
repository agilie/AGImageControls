//
//  AGImageChain.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 25.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

open class AGImageChain {
        
    var device: AGImageDevice
    
    var isAlphaProcess: Bool = false
    
    var filterList: [AGImageFilter] = []

    fileprivate var saveSize: CGSize?

    public func image() -> UIImage? {
        let scale = self.device.imageScale
        
        self.device.beginGenerate(self.isAlphaProcess)
        
        self.filterList.forEach { filter in
            _ = filter.process(device: self.device)
        }
        
        if let cgImage = self.device.endGenerate() {
            return UIImage.init(cgImage: cgImage, scale: scale, orientation: .up)
        }
        return nil
    }
    
    public init(image: UIImage?) {
        self.device = AGImageMetalDevice()
        
        guard let image = image else { return }
        
        self.device.image = image
        self.saveSize = CGSize(
            width: image.size.width,
            height: image.size.height
        )
    }
    
    open class func isMetalAvailable () -> Bool
    {
        #if !(arch(i386) || arch(x86_64)) && os(iOS)
            return (MTLCreateSystemDefaultDevice() != nil) ? true : false
        #endif
        return false
    }
    
    // MARK: - Filters
    
    public func alphaProcess(_ isAlphaProcess: Bool) -> Self {
        self.isAlphaProcess = isAlphaProcess
        return self
    }
    
    public func brightness(_ brightness: Float = 0.0) -> Self {
        let filter = AGBrightnessFilter(device: self.device)
        filter.brightness = brightness
        self.filterList.append(filter)
        return self
    }
    
    public func contrast(_ threshold: Float = 0.0) -> Self {
        let filter = AGContrastFilter(device: self.device)
        filter.threshold = threshold
        self.filterList.append(filter)
        return self
    }
    
    public func saturation(color: Float) -> Self {
        let filter = AGSaturationFilter(device: self.device)
        filter.saturation = color
        self.filterList.append(filter)
        return self
    }
    
    public func blur(_ blurRadius: Float = 0.0) -> Self {
        let filter = AGBlurFilter(device: self.device)
        filter.radius = blurRadius
        
        self.filterList.append(filter)
        return self
    }
    
    public func sharpen(_ radius: Float = 0.0) -> Self {
        let filter = AGSharpenFilter(device: self.device)
        filter.radius = radius
        
        self.filterList.append(filter)
        return self
    }
    
    public func details(_ radius: Float = 0.0) -> Self {
        let filter = AGDetailsFilter(device: self.device)
        filter.radius = radius
        
        self.filterList.append(filter)
        return self
    }
    
    public func softLightFilter (_ value: Int = 0) -> Self {
        
        let filter = AGSoftLightFilter(device: self.device)
            filter.color =  UIColor.colorWith(redColor: CGFloat(value), greenColor: 0.0, blueColor: CGFloat(-value), alpha: CGFloat(abs(value / 3)) / 100.0).imageColor
        self.filterList.append(filter)
        
        return self
    }
}

extension UIImage {
    private class func screenScale() -> CGFloat {
        return UIScreen.main.scale
    }
    
}

public typealias ColorType = (r: Float, g: Float, b: Float, a: Float)

extension UIColor
{
    internal var imageColor: ColorType {
        get {
            var r = CGFloat(0)
            var g = CGFloat(0)
            var b = CGFloat(0)
            var a = CGFloat(0)
            self.getRed(&r, green: &g, blue: &b, alpha: &a)
            return ColorType(Float(r), Float(g), Float(b), Float(a))
        }
    }
}

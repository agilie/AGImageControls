//
//  AGImageDevice.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 25.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

internal class AGImageDevice {
    
    internal var image: UIImage? {
        didSet {
            if let image = self.image {
                self.cgImage = image.cgImage
                self.imageScale = image.scale
                
                self.imageOrientation = image.imageOrientation
                
                self.spaceSize = CGSize(
                    width: image.size.width,
                    height: image.size.height
                )
            } else {
                self.cgImage = nil
                self.imageScale = 1.0
                
                self.imageOrientation = .up
                
                self.spaceSize = .zero
            }
        }
    }
    internal var cgImage: CGImage?
    
    internal var imageOrientation: UIImageOrientation = .up
    
    internal var imageScale: CGFloat = 1.0
    
    internal var offset: CGPoint = .zero
    internal var scale: CGSize?
    internal var rotate: CGFloat?
    internal var opacity: CGFloat = 1.0
    
    internal var spaceSize: CGSize = .zero
    
    // MARK: - Public
    
    internal func beginGenerate(_ isAlphaProcess: Bool) { return }
    internal func endGenerate() -> CGImage? { return nil }
    
    internal func draw(_ cgImage: CGImage, in rect: CGRect, on context: CGContext) {
        context.saveGState()
        context.draw(cgImage, in: rect)
        context.restoreGState()
    }    
}

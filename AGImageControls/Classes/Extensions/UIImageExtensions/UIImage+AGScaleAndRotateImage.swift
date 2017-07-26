//
//  UIImage+AGScaleAndRotateImage.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 06.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

extension UIImage
{
    
    struct RotationOptions: OptionSet {
        let rawValue: Int
        
        static let flipOnVerticalAxis = RotationOptions(rawValue: 1)
        static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
    }
    
    func rotated(by rotationAngle: Int, options: RotationOptions = []) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat.pi
        }
        
        let rotationInRadians = degreesToRadians(CGFloat(rotationAngle))

        let transform = CGAffineTransform(rotationAngle: rotationInRadians)
        var rect = CGRect(origin: .zero, size: self.size).applying(transform)
        rect.origin = .zero
        
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: rect.size)
            return renderer.image { renderContext in
                renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
                renderContext.cgContext.rotate(by: rotationInRadians)
                
                let x = options.contains(.flipOnVerticalAxis) ? -1.0 : 1.0
                let y = options.contains(.flipOnHorizontalAxis) ? 1.0 : -1.0
                renderContext.cgContext.scaleBy(x: CGFloat(x), y: CGFloat(y))
                
                let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
                renderContext.cgContext.draw(cgImage, in: drawRect)
            }
        } else {
            return nil
        }
    }
}

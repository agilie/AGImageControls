//
//  UIImage+AGCombineImages.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 11.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func combineImages (images: [UIImage]) -> UIImage {
        var contextSize = CGSize.zero
        
        for image in images {
            contextSize.width = max(contextSize.width, image.size.width)
            contextSize.height = max(contextSize.height, image.size.height)
        }
        
        UIGraphicsBeginImageContextWithOptions(contextSize, false, UIScreen.main.scale)
        
        for image in images {
            let deltaWidth = contextSize.width / image.size.width
            let deltaHeight = contextSize.height / image.size.height
            
            let maxDelta = max(deltaWidth, deltaHeight)
            
            let originX = (contextSize.width - image.size.width * maxDelta) / 2
            let originY = (contextSize.height - image.size.height * maxDelta) / 2
            
            image.draw(in: CGRect(x : originX, y : originY, width : image.size.width * maxDelta, height : image.size.height * maxDelta))
        }
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return combinedImage!
    }
    
}

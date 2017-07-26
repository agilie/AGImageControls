//
//  UIImage+AGCropImage.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 23.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    class func cropToSize(image: UIImage, rect : CGRect) -> UIImage {
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        return image
    }
    
    func cropToSize(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        
        // Create a copy of the image without the imageOrientation property so it is in its native orientation (landscape)
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        // Get the size of the contextImage
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cropWidth: CGFloat = 200.0
        var cropHeight: CGFloat = 200.0
        
        // Check to see which length is the longest and create the offset based on that length, then set the width and height of our rect
        if contextSize.width > width && contextSize.height > height {
            posX = contextSize.width / 2 - width / 2
            posY = contextSize.height / 2 - height / 2
            cropWidth = contextSize.width - posX * 2
            cropHeight = contextSize.height - posY * 2
        } else if contextSize.width > contextSize.height {
            posX = contextSize.width / 2 - width / 2
            cropWidth = contextSize.width - posX * 2
            posY = contextSize.height / 2 - ((cropWidth / contextSize.width) * contextSize.height) / 2
            cropHeight = (cropWidth / contextSize.width) * contextSize.height
        } else if contextSize.height > contextSize.width {
            posY = contextSize.height / 2 - height / 2
            cropHeight = contextSize.height - posY * 2
            if (contextSize.width != width) {
                posX = contextSize.width / 2 - ((cropHeight / contextSize.height) * contextSize.width) / 2
                cropWidth = (cropHeight / contextSize.height) * contextSize.width
            }
        } else {
            cropWidth = contextSize.width
            cropHeight = contextSize.height
        }
        
        let rect: CGRect = CGRect(x : posX, y : posY, width : cropWidth, height : cropHeight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
}


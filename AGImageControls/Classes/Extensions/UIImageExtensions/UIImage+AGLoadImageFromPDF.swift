//
//  UIImage+AGLoadImageFromPDF.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 19.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static func fromPDF(filename: String, size: CGSize, scale : CGFloat, color : UIColor = .white, colorAlpha : CGFloat = 1.0) -> UIImage? {
        guard let page = AGAppResourcesService.getPDFFile(filename) else { return nil }
        
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: size.width * scale, height: size.height * scale))
            let img = renderer.image { ctx in
               UIColor.white.withAlphaComponent(0).set()
                ctx.fill(imageRect)
                ctx.cgContext.scaleBy(x: scale, y: scale)
                ctx.cgContext.concatenate(page.getDrawingTransform(.artBox, rect: imageRect, rotate: 180, preserveAspectRatio: true))
                ctx.cgContext.drawPDFPage(page);
            }
            return img
        } else {
            // Fallback on earlier versions
            UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width * scale, height: size.height * scale), false, 1.0)
            if let context = UIGraphicsGetCurrentContext() {
                context.interpolationQuality = .high
                context.setAllowsAntialiasing(true)
                context.setShouldAntialias(true)
                context.setFillColor(red: 1, green: 1, blue: 1, alpha: 0)
                context.fill(imageRect)
                context.saveGState()
                context.translateBy(x: 0.0, y: size.height * scale)
                context.scaleBy(x: scale, y: -scale)
                context.concatenate(page.getDrawingTransform(.cropBox, rect: imageRect, rotate: 0, preserveAspectRatio: true))
                context.drawPDFPage(page)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return image
            }
            return nil
        }
    }
}

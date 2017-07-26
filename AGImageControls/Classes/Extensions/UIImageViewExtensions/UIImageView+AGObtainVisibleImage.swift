//
//  UIImageView+AGObtainVisibleImage.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 23.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation

import UIKit

extension UIImageView
{
    func obtainItsVisibleImage () -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: self.frame.minX, y: -self.frame.minX)
            
            self.layer.render(in: context)
            
            if let visibleImageView = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return visibleImageView
            }
        }
        
        UIGraphicsEndImageContext()
        
        return nil
    }
}

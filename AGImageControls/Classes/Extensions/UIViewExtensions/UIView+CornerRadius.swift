//
//  UIView+CornerRadius.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 21.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundView ()
    {
        self.withCornerRadius(radius: min(self.frame.height, self.frame.width) / 2)
    }
    
    func withCornerRadius (radius : CGFloat )
    {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func viewWithRadiusAndBorder (radius : CGFloat,
                                  borderWidth : CGFloat,
                                  borderColor : UIColor)
    {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.withCornerRadius(radius: radius)
    }
    
    func roundTopView (radius : CGFloat) {
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            let leftMaskPath = UIBezierPath(roundedRect: self.bounds,
                                            byRoundingCorners: [UIRectCorner.topRight, .topLeft],
                                            cornerRadii: CGSize(width: radius, height: radius))
            self.layer.masksToBounds = true
            
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = leftMaskPath.cgPath
            
            self.layer.mask = maskLayer
        }
    }
    
    
}

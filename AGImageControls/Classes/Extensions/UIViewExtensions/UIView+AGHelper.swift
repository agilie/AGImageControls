//
//  UIView+AGHelper.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 07.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

extension UIView {
    
    func originalFrame () -> CGRect {
        
        let currentTransform = self.transform
        self.transform = CGAffineTransform.identity
        let originalFrame = self.frame
        self.transform = currentTransform
       
        return originalFrame
    }
    
    func centerOffset (point : CGPoint) -> CGPoint
    {
        return CGPoint (x : point.x - self.center.x,
                        y : point.y - self.center.y)
    }
    
    func pointRelativeToCenter (point : CGPoint) -> CGPoint
    {
        return CGPoint (x : point.x + self.center.x,
                        y : point.y + self.center.y)
    }
    
    func newPointInView (point : CGPoint) -> CGPoint
    {
        let offset = self.centerOffset(point: point)
        let transformedPoint = offset.applying(self.transform)
        return self.pointRelativeToCenter(point: transformedPoint)
    }
    
    func newTopLeft () -> CGPoint
    {
        return self.newPointInView(point: self.originalFrame().origin)
    }
    
    func newTopRight () -> CGPoint
    {
        var point = self.originalFrame().origin
            point.x += self.originalFrame().size.width
        return self.newPointInView(point: point)
    }

    func newBottomLeft () -> CGPoint
    {
        var point = self.originalFrame().origin
            point.y += self.originalFrame().size.height
        return self.newPointInView(point: point)
    }

    
    func newBottomRight () -> CGPoint
    {
        var point = self.originalFrame().origin
            point.x += self.originalFrame().size.width
            point.y += self.originalFrame().size.height
        
        return self.newPointInView(point: point)
    }
    
    
    func topLeft () -> CGPoint
    {
        return self.frame.origin
    }
    
    func topRight () -> CGPoint
    {
        var point = self.frame.origin
            point.x += self.frame.size.width
        return point
    }
    
    func bottomLeft () -> CGPoint
    {
        var point = self.frame.origin
            point.y += self.frame.size.height
        return point
    }
    
    
    func bottomRight () -> CGPoint
    {
        var point = self.frame.origin
            point.x += self.frame.size.width
            point.y += self.frame.size.height
        
        return point
    }
}

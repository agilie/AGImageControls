//
//  AGMathHelper.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 07.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

internal struct AGTriangleStruct{
    var fisrtPoint : CGPoint
    var secondPoint : CGPoint
    var thirdPoint : CGPoint
    
    init(point1: CGPoint, point2: CGPoint, point3 : CGPoint) {
        self.fisrtPoint = point1
        self.secondPoint = point2
        self.thirdPoint = point3
    }
}

class AGMathHelper
{
    internal static func degrees(fromRadians value: CGFloat) -> CGFloat {
        return value * 180.0 / CGFloat(Double.pi)
    }
    
    internal static func rad(fromDegrees value: CGFloat) -> CGFloat {
        return value /  180 * 3.14
    }
    
    internal class func isTriangleContainsPoint (triangle : AGTriangleStruct, point : CGPoint) -> Bool
    {
        return ((point.x - triangle.fisrtPoint.x) * (triangle.fisrtPoint.y - triangle.secondPoint.y) -
            (point.y - triangle.fisrtPoint.y) * (triangle.fisrtPoint.x - triangle.secondPoint.x)) >= 0 &&
            
            ((point.x - triangle.secondPoint.x) * (triangle.secondPoint.y - triangle.thirdPoint.y) -
                (point.y - triangle.secondPoint.y) * (triangle.secondPoint.x - triangle.thirdPoint.x)) >= 0 &&
            
            ((point.x - triangle.thirdPoint.x) * (triangle.thirdPoint.y - triangle.fisrtPoint.y) -
                (point.y - triangle.thirdPoint.y) * (triangle.thirdPoint.x - triangle.fisrtPoint.x)) >= 0
    }
}

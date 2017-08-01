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
        return value / 180 * CGFloat(Double.pi)
    }
}

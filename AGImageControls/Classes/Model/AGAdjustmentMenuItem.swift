//
//  AGAdjustmentMenuItem.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 26.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

class AGAdjustmentMenuItem : AGMenuItemModel {
    
    var type  : AGAdjustmentMenuItemTypes = .adjustmentDefault

    class func adjustmentDefaultItem () -> AGAdjustmentMenuItem  {
        let newItem = AGAdjustmentMenuItem()
            newItem.type = .adjustmentDefault
            newItem.iconName = "origin_icon"
            newItem.name = "Origin"
        return newItem
    }
    
    class func saturationItem () -> AGAdjustmentMenuItem  {
        let newItem = AGAdjustmentMenuItem()
            newItem.type = .saturationType
            newItem.iconName = "saturation_icon"
            newItem.name = "saturation"
        return newItem
    }
    
    class func brightnessItem () -> AGAdjustmentMenuItem  {
        let newItem = AGAdjustmentMenuItem()
            newItem.type = .brightnessType
            newItem.iconName = "brightness_icon"
            newItem.name = "brightness"
        return newItem
    }
    
    class func contrastItem () -> AGAdjustmentMenuItem  {
        let newItem = AGAdjustmentMenuItem()
            newItem.type = .contrastType
            newItem.iconName = "contrast_icon"
            newItem.name = "contrast"
        return newItem
    }
    
    class func adjustItem () -> AGAdjustmentMenuItem  {
        let newItem = AGAdjustmentMenuItem()
            newItem.type = .adjustType
            newItem.minValue = -45
            newItem.maxValue = 45
            newItem.iconName = "adjust_icon"
            newItem.name = "adjust"
        return newItem
    }

    class func structureItem () -> AGAdjustmentMenuItem  {
        let newItem = AGAdjustmentMenuItem()
            newItem.type = .structureType
            newItem.minValue = 0.0
            newItem.iconName = "structure_icon"
            newItem.name = "structure"
        return newItem
    }

    class func imageMaskAdjustmentMenuItem () -> AGAdjustmentMenuItem  {
        let newItem = AGAdjustmentMenuItem()
            newItem.type = .tiltShiftType
            newItem.minValue = 0.0
            newItem.iconName = "tiltShift_icon"
            newItem.name = "Blur"
        return newItem
    }

    class func sharpenItem () -> AGAdjustmentMenuItem  {
        let newItem = AGAdjustmentMenuItem()
            newItem.type = .sharpenType
            newItem.minValue = 0.0
            newItem.iconName = "sharpen_icon"
            newItem.name = "sharpen"
        return newItem
    }

    class func warmthItem () -> AGAdjustmentMenuItem  {
        let newItem = AGAdjustmentMenuItem()
            newItem.type = .warmthType
            newItem.iconName = "warmth_icon"
            newItem.name = "warmth"
        return newItem
    }
    
    func reset ()
    {
        self.currentValue = self.defaultValue
    }

}

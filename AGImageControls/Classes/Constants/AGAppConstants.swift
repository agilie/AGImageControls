//
//  AGAppConstants.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 26.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation

enum AGSettingMenuItemTypes : Int {
    
    case imageAdjustment = 0
    case imageFilterMaskAdjustment
    case shapesMaskAdjustment
    case iconsAdjustment
    case textAdjustment

    
}

enum AGAdjustmentMenuItemTypes : Int {
    
    case adjustmentDefault = 0
    case saturationType
    case brightnessType
    case contrastType
    case adjustType
    case structureType
    case tiltShiftType
    case sharpenType //резкость
    case warmthType
    
}

enum AGGradientFilterItemTypes : Int {
   
    case gradientDefault = 0
    case gradientMask
    
}

enum AGEditorMainMenuTypes : Int
{
    
    case size = 0
    case font
    case color
    
}

enum AGImageEditorTypes : Int {
    
    case captionText = 0
    case detailsText
    case shapes
    case icons
    
}



//
//  AGSettingMenuItemModel.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 26.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation

class AGSettingMenuItemModel : AGMenuItemModel {
    
    var type  : AGSettingMenuItemTypes = .imageAdjustment
    
    class func imageAdjustmentMenuItem () -> AGSettingMenuItemModel  {
        let newItem = AGSettingMenuItemModel()
            newItem.type = .imageAdjustment
            newItem.iconName = "imageAdjustmentMenuItem_icon"
        return newItem
    }
    
    class func imageFilterMaskAdjustmentMenuItem () -> AGSettingMenuItemModel  {
        let newItem = AGSettingMenuItemModel()
            newItem.type = .imageFilterMaskAdjustment
            newItem.iconName = "filterMenuItem_icon"
        return newItem
    }
    
    class func textAdjustmentMenuItem () -> AGSettingMenuItemModel  {
        let newItem = AGSettingMenuItemModel()
            newItem.type = .textAdjustment
            newItem.iconName = "textMenuItem_icon"
        return newItem
    }
    
    class func shapesMaskAdjustmentMenuItem () -> AGSettingMenuItemModel  {
        let newItem = AGSettingMenuItemModel()
            newItem.type = .shapesMaskAdjustment
            newItem.iconName = "shapeMenuItem_icon"
        return newItem
    }
    
    class func imageMaskAdjustmentMenuItem () -> AGSettingMenuItemModel  {
        let newItem = AGSettingMenuItemModel()
            newItem.type = .iconsAdjustment
            newItem.iconName = "imageMaskMenuItem_icon"
        return newItem
    }
}

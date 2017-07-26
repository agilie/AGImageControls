//
//  AGGradientFilterItemModel.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 11.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation

class AGGradientFilterItemModel : AGMenuItemModel {

    var type  : AGGradientFilterItemTypes = .gradientMask
    
    var imageName : String = ""
    
    class func defaultGradientItem () -> AGGradientFilterItemModel  {
        let newItem = AGGradientFilterItemModel()
        
            newItem.type = .gradientDefault
            newItem.iconName = "default_filter_icon"
            newItem.minValue = 0
                
        return newItem
    }

    class func createWithName (name : String) -> AGGradientFilterItemModel  {
        let newItem = AGGradientFilterItemModel()
        
            newItem.type = .gradientMask
        
            newItem.iconName = name + "_icon"
            newItem.imageName = name
        
            newItem.minValue = 0
        
        return newItem
    }
}

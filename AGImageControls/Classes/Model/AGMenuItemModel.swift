//
//  AGMenuItemModel.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 11.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation

class AGMenuItemModel : NSObject {

    var name        : String = ""

    var iconName    : String = ""
    
    var defaultValue : Float = 0
    var currentValue : Float = 0
    
    var minValue     : Float = -100
    var maxValue     : Float = 100
    
    var lastValue    : Float = 0.0

}

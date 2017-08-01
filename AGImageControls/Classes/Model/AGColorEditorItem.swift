//
//  AGColorEditorItem.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 13.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

class AGColorEditorItem : AGMenuItemModel {

    var color : UIColor = .white
    
    class func createWithColor (color : UIColor) -> AGColorEditorItem
    {
        let newItem = AGColorEditorItem()
            newItem.color = color
            newItem.minValue = 0
            newItem.currentValue = 100
        
        return newItem
    }
    
    func copyItem () -> AGColorEditorItem {
        let newItem = AGColorEditorItem()
            newItem.color = self.color
            newItem.minValue = self.minValue
            newItem.currentValue = self.currentValue

        return newItem
    }
    
}

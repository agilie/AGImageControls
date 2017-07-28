//
//  AGImageChangesItem.swift
//  Pods
//
//  Created by Michael Liptuga on 27.07.17.
//
//

import UIKit

class AGImageChangesItem : NSObject {

    var tag      : Int = 0
    var position : AGPositionStruct? = nil
    var mask     : AGColorEditorItem? = nil
    var type     : AGSettingMenuItemTypes = .textAdjustment
    
    class func createWith (imageView : AGEditableImageView) -> AGImageChangesItem {
        let item = AGImageChangesItem()
            item.tag = imageView.tag
            item.position = imageView.lastPosition
            item.mask = imageView.lastMaskColor
            item.type = imageView.settingsType

        return item
    }    
}

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
    var font     : AGFontEditorItem? = nil
    var text     : String? = nil
    
    class func createWith (imageView : AGEditableImageView) -> AGImageChangesItem {
        let item = AGImageChangesItem()
            item.tag = imageView.tag
            item.position = imageView.lastPosition
            item.mask = imageView.lastMaskColor
            item.type = imageView.settingsType
            item.font = imageView.lastFont
            item.text = imageView.lastText
        
        return item
    }    
}

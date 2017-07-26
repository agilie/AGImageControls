//
//  AGImageEditorService.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 13.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

class AGImageEditorService : NSObject
{
    lazy var captionFontEditorItems : [AGFontEditorItem] =
    {
        let type : AGImageEditorTypes  = .captionText
        return [AGFontEditorItem.patuaOneRegularItem(type : type),
                AGFontEditorItem.montserratBoldItem(type : type),
                AGFontEditorItem.crimsonBoldItem(type : type),
                AGFontEditorItem.titilliumBoldItem(type : type),
                AGFontEditorItem.mavenProBoldItem(type : type),
                AGFontEditorItem.antonRegularItem(type : type),
                AGFontEditorItem.poppinsRegularItem(type : type)]
        }()
    
    lazy var detailsFontEditorItems : [AGFontEditorItem] =
        {
            let type : AGImageEditorTypes  = .detailsText
            return [AGFontEditorItem.helveticaRegularItem(type : type),
                    AGFontEditorItem.montserratBoldItem(type : type),
                    AGFontEditorItem.ralewayBoldItem(type : type),
                    AGFontEditorItem.titilliumRegularItem(type : type),
                    AGFontEditorItem.rubikRegularItem(type : type),
                    AGFontEditorItem.openSansBoldtem(type : type),
                    AGFontEditorItem.poppinsBoldItem(type : type)]
    }()

    lazy var imageEditorItemList :  [AGImageEditorMainMenuItem] =
        {[unowned self] in
            return [AGImageEditorMainMenuItem.createSizeItem(),
                    AGImageEditorMainMenuItem.createFontItem(),
                    AGImageEditorMainMenuItem.createColorItem()]
    }()
    
    
    lazy var editorColorItems :  [AGColorEditorItem] =
        {[unowned self] in
            return [AGColorEditorItem.createWithColor(color : UIColor.init(hexString : "#FFFFFF")),
                    AGColorEditorItem.createWithColor(color : UIColor.init(hexString : "#A200FF")),
                    AGColorEditorItem.createWithColor(color : UIColor.init(hexString : "#F86D1C")),
                    AGColorEditorItem.createWithColor(color : UIColor.init(hexString : "#01FF93")),
                    AGColorEditorItem.createWithColor(color : UIColor.init(hexString : "#00FFFF")),
                    AGColorEditorItem.createWithColor(color : UIColor.init(hexString : "#000000")),
                    AGColorEditorItem.createWithColor(color : UIColor.init(hexString : "#0000FF")),
                    AGColorEditorItem.createWithColor(color : UIColor.init(hexString : "#FF00FF")),
                    AGColorEditorItem.createWithColor(color : UIColor.init(hexString : "#008000")),
                    AGColorEditorItem.createWithColor(color : UIColor.init(hexString : "#FF0000")),
                    AGColorEditorItem.createWithColor(color : UIColor.init(hexString : "#FFFF00"))]
            }()

    
    var imageEditorItems : [AGImageEditorMainMenuItem]
        {
        get {
            self.imageEditorItemList[1].isHidden = !self.isTextEditorAvailable
            return self.imageEditorItemList
        }
    }

    var currentType : AGImageEditorTypes = .captionText
    
    var isTextEditorAvailable : Bool
    {
        get {
            return (self.currentType == .captionText || self.currentType == .detailsText)
        }
    }
    
    func unselectAllImageEditorItems ()
    {
        for item in self.imageEditorItemList
        {
            item.isSelected = false
        }
    }
    
    func resetEditorColorItems () {
        editorColorItems.forEach {
            $0.currentValue = $0.maxValue
        }
    }
}

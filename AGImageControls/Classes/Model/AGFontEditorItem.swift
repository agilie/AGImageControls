//
//  AGFontEditorItem.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 13.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

class AGFontEditorItem : NSObject {
    
    var fullName : String = ""
    var shortName : String = ""
    
    var currentSize : CGFloat = 16.0
    
    var minFontSize : CGFloat
    {
        get {
            switch self.type {
            case .captionText:
                return 50.0
            default:
                return 28.0
            }
        }
    }
    
    var maxFontSize : CGFloat
    {
        get {
            switch self.type {
            case .captionText:
                return 200.0
            default:
                return 100.0
            }
        }
    }
    
    var fontSize : CGFloat
    {
        get {
            return self.isSelected ? 52.0 : 28.0
        }
    }

    var type : AGImageEditorTypes = .captionText
    
    var isSelected  : Bool    = false
    
    lazy var font : UIFont =
        {
            return UIFont.ubuntuMediumFontWithSize(size: self.currentSize)
    }()
    
    class func createWithType (type : AGImageEditorTypes) -> AGFontEditorItem {
        return AGFontEditorItem.patuaOneRegularItem(type: type)
    }
    
    class func antonRegularItem (type : AGImageEditorTypes) -> AGFontEditorItem  {
        let newItem = AGFontEditorItem()
        
        newItem.fullName = "Anton"
        newItem.shortName = "An"
        
        newItem.type = type
        newItem.currentSize = newItem.minFontSize
        
        newItem.font = UIFont.init(name: "Anton-Regular", size: newItem.currentSize) ?? UIFont.ubuntuMediumFontWithSize(size: newItem.currentSize)
        
        return newItem
    }

    class func crimsonBoldItem (type : AGImageEditorTypes) -> AGFontEditorItem  {
        let newItem = AGFontEditorItem()
        
        newItem.fullName = "Crimson"
        newItem.shortName = "Cr"
        
        newItem.type = type
        newItem.currentSize = newItem.minFontSize
        
        newItem.font = UIFont.init(name: "CrimsonText-Bold", size: newItem.currentSize) ?? UIFont.ubuntuMediumFontWithSize(size: newItem.currentSize)
        
        return newItem
    }

    class func helveticaRegularItem (type : AGImageEditorTypes) -> AGFontEditorItem  {
        let newItem = AGFontEditorItem()
        
        newItem.fullName = "Helvetica"
        newItem.shortName = "He"
        
        newItem.type = type
        newItem.currentSize = newItem.minFontSize
        
        newItem.font = UIFont.init(name: "HelveticaNeue", size: newItem.currentSize) ?? UIFont.ubuntuMediumFontWithSize(size: newItem.currentSize)
        
        return newItem
    }

    class func mavenProBoldItem (type : AGImageEditorTypes) -> AGFontEditorItem  {
        let newItem = AGFontEditorItem()
        
        newItem.fullName = "MavenPro"
        newItem.shortName = "Ma"
        
        newItem.type = type
        newItem.currentSize = newItem.minFontSize
        
        newItem.font = UIFont.init(name: "MavenPro-Bold", size: newItem.currentSize) ?? UIFont.ubuntuMediumFontWithSize(size: newItem.currentSize)
        
        return newItem
    }

    class func montserratBoldItem (type : AGImageEditorTypes) -> AGFontEditorItem  {
        let newItem = AGFontEditorItem()
        
        newItem.fullName = "Montserrat"
        newItem.shortName = "Mo"
        
        newItem.type = type
        newItem.currentSize = newItem.minFontSize
        
        newItem.font = UIFont.init(name: "Montserrat-Bold", size: newItem.currentSize) ?? UIFont.ubuntuMediumFontWithSize(size: newItem.currentSize)
        
        return newItem
    }

    class func openSansBoldtem (type : AGImageEditorTypes) -> AGFontEditorItem  {
        let newItem = AGFontEditorItem()
        
        newItem.fullName = "Open Sans"
        newItem.shortName = "Op"
        
        newItem.type = type
        newItem.currentSize = newItem.minFontSize
        
        newItem.font = UIFont.init(name: "OpenSans-Bold", size: newItem.currentSize) ?? UIFont.ubuntuMediumFontWithSize(size: newItem.currentSize)
        
        return newItem
    }

    class func patuaOneRegularItem (type : AGImageEditorTypes) -> AGFontEditorItem  {
        let newItem = AGFontEditorItem()
        
        newItem.fullName = "Patua one"
        newItem.shortName = "Pa"
        
        newItem.type = type
        newItem.currentSize = newItem.minFontSize
        
        newItem.font = UIFont.init(name: "PatuaOne-Regular", size: newItem.currentSize) ?? UIFont.ubuntuMediumFontWithSize(size: newItem.currentSize)
        
        return newItem
    }
    
    class func poppinsBoldItem (type : AGImageEditorTypes) -> AGFontEditorItem  {
        let newItem = AGFontEditorItem()
        
        newItem.fullName = "Poppins"
        newItem.shortName = "Po"
        
        newItem.type = type
        newItem.currentSize = newItem.minFontSize
        
        newItem.font = UIFont.init(name: "Poppins-Bold", size: newItem.currentSize) ?? UIFont.ubuntuMediumFontWithSize(size: newItem.currentSize)
        
        return newItem
    }

    class func poppinsRegularItem (type : AGImageEditorTypes) -> AGFontEditorItem  {
        let newItem = AGFontEditorItem()
        
        newItem.fullName = "Poppins"
        newItem.shortName = "Po"
        
        newItem.type = type
        newItem.currentSize = newItem.minFontSize
        
        newItem.font = UIFont.init(name: "Poppins-Regular", size: newItem.currentSize) ?? UIFont.ubuntuMediumFontWithSize(size: newItem.currentSize)
        
        return newItem
    }

    class func ralewayBoldItem (type : AGImageEditorTypes) -> AGFontEditorItem  {
        let newItem = AGFontEditorItem()
        
        newItem.fullName = "Raleway"
        newItem.shortName = "Ra"
        
        newItem.type = type
        newItem.currentSize = newItem.minFontSize
        
        newItem.font = UIFont.init(name: "Raleway-Bold", size: newItem.currentSize) ?? UIFont.ubuntuMediumFontWithSize(size: newItem.currentSize)
        
        return newItem
    }

    class func rubikRegularItem (type : AGImageEditorTypes) -> AGFontEditorItem  {
        let newItem = AGFontEditorItem()
        
        newItem.fullName = "Rubik"
        newItem.shortName = "Ru"
        
        newItem.type = type
        newItem.currentSize = newItem.minFontSize
        
        newItem.font = UIFont.init(name: "Rubik-Regular", size: newItem.currentSize) ?? UIFont.ubuntuMediumFontWithSize(size: newItem.currentSize)
        
        return newItem
    }

    class func titilliumRegularItem (type : AGImageEditorTypes) -> AGFontEditorItem  {
        let newItem = AGFontEditorItem()
        
        newItem.fullName = "Titillium"
        newItem.shortName = "Ti"
        
        newItem.type = type
        newItem.currentSize = newItem.minFontSize
        
        newItem.font = UIFont.init(name: "TitilliumWeb-Regular", size: newItem.currentSize) ?? UIFont.ubuntuMediumFontWithSize(size: newItem.currentSize)
        
        return newItem
    }

    class func titilliumBoldItem (type : AGImageEditorTypes) -> AGFontEditorItem  {
        let newItem = AGFontEditorItem()
        
        newItem.fullName = "Titillium"
        newItem.shortName = "Ti"
        
        newItem.type = type
        newItem.currentSize = newItem.minFontSize
        
        newItem.font = UIFont.init(name: "TitilliumWeb-Bold", size: newItem.currentSize) ?? UIFont.ubuntuMediumFontWithSize(size: newItem.currentSize)
        
        return newItem
    }
    
    func copyItem () -> AGFontEditorItem {
        let item = AGFontEditorItem()
            item.fullName = self.fullName
            item.shortName = self.shortName
            item.type = self.type
            item.currentSize = self.currentSize
            item.font = self.font
        
        return item
    }

}


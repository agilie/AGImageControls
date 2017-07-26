//
//  AGImageEditorMainMenuItem.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 13.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

class AGImageEditorMainMenuItem : NSObject
{
    var type : AGEditorMainMenuTypes = .size
    
    var name : String = ""
    
    var isSelected : Bool = false
    var isHidden : Bool = false
    
    var backgroundColor : UIColor = .white
    var textColor : UIColor = .white

    var selectedBackgroundColor : UIColor = .white
    var selectedTextColor : UIColor = .white

    class func createSizeItem () -> AGImageEditorMainMenuItem
    {
        let newItem = AGImageEditorMainMenuItem()
        newItem.type = .size
        newItem.name = "Size"
        
        newItem.selectedBackgroundColor = UIColor.colorWith(redColor: 126,
                                                            greenColor: 121,
                                                            blueColor: 129,
                                                            alpha: 0.9)
        
        newItem.backgroundColor = UIColor.colorWith(redColor: 158,
                                                    greenColor: 153,
                                                    blueColor: 161,
                                                    alpha: 0.45)
        
        newItem.textColor = .init(white: 1, alpha: 0.45)
        
        return newItem
    }
 
    class func createFontItem () -> AGImageEditorMainMenuItem
    {
        let newItem = AGImageEditorMainMenuItem()
            newItem.type = .font
            newItem.name = "Font"
        
            newItem.selectedBackgroundColor = UIColor.colorWith(redColor: 126,
                                                                greenColor: 121,
                                                                blueColor: 129,
                                                                alpha: 0.9)
        
            newItem.backgroundColor = UIColor.colorWith(redColor: 158,
                                                        greenColor: 153,
                                                        blueColor: 161,
                                                        alpha: 0.45)
        
            newItem.textColor = .init(white: 1, alpha: 0.45)
        
        return newItem
    }

    class func createColorItem () -> AGImageEditorMainMenuItem
    {
        let newItem = AGImageEditorMainMenuItem()
            newItem.type = .color
            newItem.name = "Color"

            newItem.backgroundColor = .init(white: 1, alpha: 0.45)

            newItem.selectedTextColor = UIColor.colorWith(redColor: 58,
                                                          greenColor: 48,
                                                          blueColor: 63,
                                                          alpha: 1)

            newItem.textColor = UIColor.colorWith(redColor: 58,
                                                  greenColor: 48,
                                                  blueColor: 63,
                                                  alpha: 0.45)
        return newItem
    }

}

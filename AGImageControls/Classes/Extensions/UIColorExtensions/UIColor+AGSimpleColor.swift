//
//  UIColor+AGSimpleColor.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 21.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    class func colorWith (redColor : CGFloat,
                          greenColor: CGFloat,
                          blueColor : CGFloat,
                          alpha : CGFloat) -> UIColor
    {
        return UIColor.init(red: redColor / 255.0,
                            green: greenColor / 255.0,
                            blue: blueColor / 255.0,
                            alpha: alpha)
    }
    
    
    public convenience init (hexString: String) {
        let r, g, b : CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
        }
        self.init(white: 1, alpha: 1)
        return
    }

}

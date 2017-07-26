//
//  UIFont+AGAppFonts.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 21.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

extension UIFont
{
    fileprivate static let ubuntuMediumFont = "Ubuntu-Medium"
    
    class func adjustmentTitleFont () -> UIFont
    {
        return UIFont.ubuntuMediumFontWithSize(size: 12)
    }

    class func adjustmentSliderValueFont () -> UIFont
    {
        return UIFont.ubuntuMediumFontWithSize(size: 16)
    }
    
    class func ubuntuMediumFontWithSize (size : CGFloat) -> UIFont {
        return UIFont.init(name: ubuntuMediumFont, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
}


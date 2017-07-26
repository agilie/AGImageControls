//
//  UIButton+AGAppButtons.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 18.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

extension UIButton
{    
    class func createButtonWith (title : String, font : UIFont, backgroundColor: UIColor, radius : CGFloat) -> UIButton
    {
        let button = UIButton()
        
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = font
            button.withCornerRadius(radius: radius)
            button.backgroundColor = backgroundColor
            button.contentHorizontalAlignment = .center
        
        return button
    }

    
}

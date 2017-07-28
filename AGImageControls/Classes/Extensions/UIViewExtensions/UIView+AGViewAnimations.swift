//
//  UIView+AGViewAnimations.swift
//  Pods
//
//  Created by Michael Liptuga on 27.07.17.
//
//

import Foundation
import UIKit

extension UIView {
    
    func showWithAnimation (isShown : Bool, animated : Bool) {
        if (isShown) { self.isHidden = !isShown }
        UIView.animate(withDuration: animated ? 0.245 : 0.0, animations: {
            self.alpha = isShown ? 1.0 : 0.0
        }) { (isFinished) in
            if (!isShown) {
                self.isHidden = !isShown
            }
        }
    }
    
}

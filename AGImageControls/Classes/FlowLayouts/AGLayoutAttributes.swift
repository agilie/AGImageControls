//
//  AGLayoutAttributes.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 14.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

class AGLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // Additional attribute to test our custom layout
    var moveRatio: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! AGLayoutAttributes
        copy.moveRatio = self.moveRatio
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let objectToCompare = object as? AGLayoutAttributes {
            if moveRatio != objectToCompare.moveRatio {
                return false
            }
            return super.isEqual(object)
        }
        return false
    }
    
}

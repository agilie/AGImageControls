//
//  AGAssetsService.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 22.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

open class AGAssetsService {
   
    open static func getImage(_ name: String) -> UIImage {
        let traitCollection = UITraitCollection(displayScale: 3)
        var bundle = Bundle(for: AGAssetsService.self)
        
        if let resource = bundle.resourcePath, let resourceBundle = Bundle(path: resource + "/AGImageControls.bundle") {
            bundle = resourceBundle
        }
        return UIImage(named: name, in: bundle, compatibleWith: traitCollection) ?? UIImage()
    }
}

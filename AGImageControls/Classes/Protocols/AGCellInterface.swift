//
//  AGCellInterface.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 22.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

protocol AGCellInterface {
    
    static var id: String { get }
    static var cellNib: UINib { get }
    
}

extension AGCellInterface {
    
    static var id: String {
        return String.init(describing: self)
    }
    
    static var cellNib: UINib {
        return UINib(nibName: id, bundle: nil)
    }
    
}

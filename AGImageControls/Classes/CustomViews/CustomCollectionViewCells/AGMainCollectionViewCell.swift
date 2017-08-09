//
//  AGMainCollectionViewCell.swift
//  Pods
//
//  Created by Michael Liptuga on 07.08.17.
//
//

import UIKit

class AGMainCollectionViewCell: UICollectionViewCell, AGCellInterface {
    
    open class func cellSize () -> CGSize {
        return CGSize(width: 45.0, height : 45.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        self.setupCollectionViewCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureForObject (object : Any?) {
        
    }
}

extension AGMainCollectionViewCell {

    func setupCollectionViewCell() {
    }

}

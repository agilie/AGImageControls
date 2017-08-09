//
//  AGColorEditorCollectionViewCell.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 17.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGColorEditorCollectionViewCell: AGMainCollectionViewCell {
    
    lazy var colorView : UIView = { [unowned self] in
        let view = UIView()
            view.backgroundColor = .white
            view.withCornerRadius(radius : 4)
        return view
        }()
    
    open override class func cellSize () -> CGSize {
        return CGSize(width: 78, height : 54)
    }
    
    override func configureForObject (object : Any?) {
        guard let colorItem = object as? AGColorEditorItem else { return }
        
        self.colorView.backgroundColor = colorItem.color
    }
}

extension AGColorEditorCollectionViewCell {
   
    override func setupCollectionViewCell() {
        self.contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
}

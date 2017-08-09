//
//  AGFontEditorCollectionViewCell.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 14.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGFontEditorCollectionViewCell: AGMainCollectionViewCell{
    
    lazy var fontNameLabel : UILabel = { [unowned self] in
        let label = UILabel()
            label.textAlignment = .center
            label.font = label.font.withSize(52.0)
            label.textColor = .white
            label.backgroundColor = UIColor.colorWith(redColor: 49, greenColor: 40, blueColor: 54, alpha: 0.85)
            label.withCornerRadius(radius : 4)
        return label
        }()
    
    open override class func cellSize () -> CGSize {
        return CGSize(width: 110, height : 110)
    }
    
    override func configureForObject (object : Any?) {
        guard let fontItem = object as? AGFontEditorItem else { return }

        self.fontNameLabel.font = fontItem.font.withSize(self.fontNameLabel.font.pointSize)
        self.fontNameLabel.text = fontItem.shortName
    }
}

extension AGFontEditorCollectionViewCell {
    
    override func setupCollectionViewCell() {
        self.contentView.addSubview(fontNameLabel)
        fontNameLabel.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
}

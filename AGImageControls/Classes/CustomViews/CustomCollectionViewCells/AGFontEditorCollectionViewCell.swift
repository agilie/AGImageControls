//
//  AGFontEditorCollectionViewCell.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 14.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGFontEditorCollectionViewCell: UICollectionViewCell, AGCellInterface {
    
    lazy var fontNameLabel : UILabel = { [unowned self] in
        let label = UILabel()
            label.textAlignment = .center
            label.font = label.font.withSize(52.0)
            label.textColor = .white
            label.backgroundColor = UIColor.colorWith(redColor: 49, greenColor: 40, blueColor: 54, alpha: 0.85)
            label.withCornerRadius(radius : 4)
        return label
        }()
    
    open class func cellSize () -> CGSize {
        return CGSize(width: 110, height : 110)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear

        self.contentView.addSubview(fontNameLabel)
        fontNameLabel.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureForMenuItem (menuItem: AGFontEditorItem) {
        self.fontNameLabel.font = menuItem.font?.withSize(self.fontNameLabel.font.pointSize)
        self.fontNameLabel.text = menuItem.shortName
    }
}


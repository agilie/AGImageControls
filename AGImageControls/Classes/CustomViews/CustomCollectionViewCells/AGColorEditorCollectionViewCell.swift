//
//  AGColorEditorCollectionViewCell.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 17.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGColorEditorCollectionViewCell: UICollectionViewCell, AGCellInterface {
    
    lazy var colorView : UIView = { [unowned self] in
        let view = UIView()
            view.backgroundColor = .white
            view.withCornerRadius(radius : 4)
        return view
        }()
    
    open class func cellSize () -> CGSize {
        return CGSize(width: 78, height : 54)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        self.contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureForMenuItem (menuItem: AGColorEditorItem) {
        self.colorView.backgroundColor = menuItem.color
    }
}

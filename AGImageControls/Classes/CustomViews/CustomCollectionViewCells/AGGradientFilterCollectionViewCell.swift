//
//  AGGradientFilterCollectionViewCell.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 11.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGGradientFilterCollectionViewCell: AGMainCollectionViewCell {
    
    struct ViewSizes {
        static let imageViewSize : CGSize = AGGradientFilterCollectionViewCell.cellSize()
        static let imageTopOffset: CGFloat = 8.0
        static let imageLeftOffset: CGFloat = 8.0
    }
    
    lazy var imageView : UIImageView = { [unowned self] in
        let imageView = UIImageView()
        
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    static let maxScreenSize : CGFloat = 414.0
    
    open override class func cellSize () -> CGSize {
        let maxSize = screenSize.width / ((screenSize.width < maxScreenSize) ? 5 : 6)
        return CGSize(width: maxSize, height : maxSize)
    }
    
    override func configureForObject (object :  Any?) {
        guard let gradientItem = object as? AGGradientFilterItemModel else { return }

        self.imageView.image = AGAppResourcesService.getImage(gradientItem.iconName)
    }
}

extension AGGradientFilterCollectionViewCell {
    
    override func setupCollectionViewCell() {
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
}

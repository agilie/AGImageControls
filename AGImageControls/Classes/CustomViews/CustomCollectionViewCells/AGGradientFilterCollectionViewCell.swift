//
//  AGGradientFilterCollectionViewCell.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 11.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGGradientFilterCollectionViewCell: UICollectionViewCell, AGCellInterface {
    
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
    
    open class func cellSize () -> CGSize {
        let maxSize = UIScreen.main.bounds.width / ((UIScreen.main.bounds.width < maxScreenSize) ? 5 : 6)
        return CGSize(width: maxSize, height : maxSize)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureForMenuItem (menuItem: AGGradientFilterItemModel) {
        self.imageView.image = AGAppResourcesService.getImage(menuItem.iconName)
    }
}

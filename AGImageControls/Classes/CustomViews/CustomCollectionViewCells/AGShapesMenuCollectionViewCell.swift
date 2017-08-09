//
//  AGShapesMenuCollectionViewCell.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 19.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGShapesMenuCollectionViewCell: AGMainCollectionViewCell {
    
    lazy var shapeImageView : UIImageView = { [unowned self] in
        let shapeImageView = UIImageView()
            shapeImageView.backgroundColor = .clear
            shapeImageView.contentMode = .scaleAspectFit
            shapeImageView.clipsToBounds = true
        
        return shapeImageView
        }()

    struct ViewSizes {
        static let shapeImageViewSize : CGSize = CGSize(width : 62, height : 72)
    }
    
    open override class func cellSize () -> CGSize {
        return CGSize(width: 81, height : 81)
    }
    
    override func configureForObject (object: Any?) {
        guard let imageName = object as? String else { return }

        self.shapeImageView.image = AGAppResourcesService.getImage(imageName)
    }
}

extension AGShapesMenuCollectionViewCell {
    
    override func setupCollectionViewCell() {        
        self.contentView.addSubview(shapeImageView)
        shapeImageView.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
}

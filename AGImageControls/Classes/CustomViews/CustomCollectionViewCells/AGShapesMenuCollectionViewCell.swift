//
//  AGShapesMenuCollectionViewCell.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 19.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGShapesMenuCollectionViewCell: UICollectionViewCell, AGCellInterface {
    
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
    
    open class func cellSize () -> CGSize {
        return CGSize(width: 81, height : 81)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        for subview in [shapeImageView] as [UIView]
        {
            self.contentView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith (imageName: String) {
        self.shapeImageView.image = AGAppResourcesService.getImage(imageName)
    }

}

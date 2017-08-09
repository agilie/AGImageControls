//
//  AGPhotoGalleryCollectionViewCell.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 22.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit
import Photos

class AGPhotoGalleryCollectionViewCell: AGMainCollectionViewCell
{
    lazy var imageView : UIImageView = { [unowned self] in
        let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = .lightGray
        return imageView
        }()
    
    open class func cellSize (atIndexPath indexPath : IndexPath) -> CGSize {
       return (indexPath.row == 0) ?
        CGSize(width: screenSize.width, height : screenSize.height * 0.6) :
        CGSize(width: screenSize.width / 3, height : screenSize.width / 3)
    }
    
    override func configureForObject (object: Any?) {
        guard let image = object as? UIImage else {
            return
        }
        self.imageView.image = image
    }
}

extension AGPhotoGalleryCollectionViewCell {
    
    override func setupCollectionViewCell() {
        setupConstraints()
    }
    
}

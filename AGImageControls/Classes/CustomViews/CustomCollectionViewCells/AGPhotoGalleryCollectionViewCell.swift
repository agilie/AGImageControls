//
//  AGPhotoGalleryCollectionViewCell.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 22.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit
import Photos

class AGPhotoGalleryCollectionViewCell: UICollectionViewCell, AGCellInterface
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
        CGSize(width: UIScreen.main.bounds.width, height : UIScreen.main.bounds.height * 0.6) :
        CGSize(width: UIScreen.main.bounds.width / 3, height : UIScreen.main.bounds.width / 3)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureForImageObject(photo: UIImage)
    {
        self.imageView.image = photo
    }
}

//
//  AGPhotoGalleryCollectionView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 22.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit
import Photos

protocol AGPhotoGalleryCollectionViewDataSource : class {
    func numberOfItemsInSection (section : Int) -> Int
    func photoAtIndexPath (indexPath : IndexPath) -> UIImage
}

protocol AGPhotoGalleryCollectionViewDelegate: class {
    func selectedPhoto (atIndexPath indexPath: IndexPath)
}

class AGPhotoGalleryCollectionView: AGMainCollectionView {
    
    weak var photoGalleryDataSource : AGPhotoGalleryCollectionViewDataSource?
    weak var photoGalleryDelegate : AGPhotoGalleryCollectionViewDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout?) {
        super.init(frame: frame, collectionViewLayout: AGPhotoGalleryCollectionView.flowLayout())
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override class func flowLayout () -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
        return flowLayout
    }
}

extension AGPhotoGalleryCollectionView {
    
    override func registerCollectionViewCells() {
        self.register(AGPhotoGalleryCollectionViewCell.self, forCellWithReuseIdentifier: AGPhotoGalleryCollectionViewCell.id)
    }
    
    override func cellSize(atIndexPath : IndexPath) -> CGSize {
        return AGPhotoGalleryCollectionViewCell.cellSize(atIndexPath: atIndexPath)
    }
    
    override func numberOfItems (section : Int) -> Int {
        return self.photoGalleryDataSource?.numberOfItemsInSection(section: section) ?? 0
    }
    
    override func cellIdentifierAt (indexPath : IndexPath) -> String {
        return AGPhotoGalleryCollectionViewCell.id
    }
    
    override func objectAt (indexPath : IndexPath) -> Any? {
        return self.photoGalleryDataSource?.photoAtIndexPath(indexPath: indexPath)
    }
    
    override func didSelectItemAtIndexPath (indexPath : IndexPath) {
        self.photoGalleryDelegate?.selectedPhoto(atIndexPath: indexPath)
    }
}

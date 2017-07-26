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

class AGPhotoGalleryCollectionView: UICollectionView {

    weak var photoGalleryDataSource : AGPhotoGalleryCollectionViewDataSource?
    weak var photoGalleryDelegate : AGPhotoGalleryCollectionViewDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout? = nil) {
        let flowLayout = UICollectionViewFlowLayout()
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0

        super.init(frame: frame, collectionViewLayout: flowLayout)
        self.setupCollectionView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}

extension AGPhotoGalleryCollectionView {
    fileprivate func setupCollectionView () {
        self.backgroundColor = .clear
        self.dataSource = self
        self.delegate = self
        self.register(AGPhotoGalleryCollectionViewCell.self, forCellWithReuseIdentifier: AGPhotoGalleryCollectionViewCell.id)
    }
}

extension AGPhotoGalleryCollectionView : UICollectionViewDataSource {    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoGalleryDataSource?.numberOfItemsInSection(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = AGPhotoGalleryCollectionViewCell.id

        guard let currentCurrentPhoto = self.photoGalleryDataSource?.photoAtIndexPath(indexPath: indexPath) else {
            return UICollectionViewCell()

        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AGPhotoGalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureForImageObject(photo: currentCurrentPhoto)
        return cell
    }
}

extension AGPhotoGalleryCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.photoGalleryDelegate?.selectedPhoto(atIndexPath: indexPath)
    }
}

extension AGPhotoGalleryCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return AGPhotoGalleryCollectionViewCell.cellSize(atIndexPath: indexPath)
    }
}

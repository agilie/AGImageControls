//
//  AGPhotoGalleryViewController.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 22.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

public protocol AGPhotoGalleryViewControllerDelegate : class {
    func posterImage (photoGalleryViewController : AGPhotoGalleryViewController, image : UIImage)
}

public class AGPhotoGalleryViewController: AGMainViewController {

    public weak var delegate : AGPhotoGalleryViewControllerDelegate?
    
    lazy var photoGalleryCollectionView: AGPhotoGalleryCollectionView = { [unowned self] in
        let collectionView = AGPhotoGalleryCollectionView(frame: self.view.bounds, collectionViewLayout: nil)
            collectionView.photoGalleryDataSource = self
            collectionView.photoGalleryDelegate = self
        return collectionView
    }()
    
    var images : [UIImage] = []
    {
        didSet {
            self.photoGalleryCollectionView.reloadData()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.configurePhotoGalleryViewController()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadPhotos()
    }
}

extension AGPhotoGalleryViewController
{
    fileprivate func configurePhotoGalleryViewController () {
        self.view.backgroundColor = self.configurator.mainColor
        self.navigationView.doneButton.isHidden = true
        [photoGalleryCollectionView, navigationView].forEach {
            ($0 as! UIView).translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0 as! UIView)
        }
        self.setupConstraints()
    }
    
    fileprivate func loadPhotos () {
        AGPhotoGalleryService.sharedInstance.fetchWithCompletion() {[weak self] (assets, isSuccess) in
            guard let `self` = self else { return }
            isSuccess ? self.obtainImagesFromPhotoGallery() : self.loadPhotos()
        }
    }
    
    fileprivate func obtainImagesFromPhotoGallery () {
        self.view.isUserInteractionEnabled = false
        AGPhotoGalleryService.sharedInstance.imagesFromPhotoGallery() {[weak self] (images) in
            guard let `self` = self else { return }
            self.images = images
        }
    }
}

extension AGPhotoGalleryViewController : AGPhotoGalleryCollectionViewDataSource
{
    func numberOfItemsInSection (section : Int) -> Int {
        return self.images.count
    }
        
    func photoAtIndexPath (indexPath : IndexPath) -> UIImage {
        return self.images[indexPath.row]
    }
}

extension AGPhotoGalleryViewController : AGPhotoGalleryCollectionViewDelegate
{
    func selectedPhoto (atIndexPath indexPath : IndexPath) {
        let photoResizeVC = AGPhotoResizeViewController.createWithAsset(atIndex: indexPath.row)
            photoResizeVC.delegate = self
        self.present(photoResizeVC, animated: true, completion: nil)
    }
}

extension AGPhotoGalleryViewController : AGPhotoResizeViewControllerDelegate
{
    func posterImage (photoResizeViewController : AGPhotoResizeViewController, image : UIImage) {
        self.dismiss(animated: false) { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.posterImage(photoGalleryViewController : self, image: image)
        }
    }
}

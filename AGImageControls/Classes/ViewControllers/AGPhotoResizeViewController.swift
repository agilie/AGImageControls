//
//  AGPhotoResizeViewController.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 23.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGPhotoResizeViewControllerDelegate : class {
    func posterImage (photoResizeViewController : AGPhotoResizeViewController, image : UIImage)
}

class AGPhotoResizeViewController: AGMainViewController {

    weak var delegate : AGPhotoResizeViewControllerDelegate?
    
    open class func createWithAsset (atIndex index : Int) -> AGPhotoResizeViewController
    {
        let controller = AGPhotoResizeViewController()
            controller.loadImage(atIndex: index)
        return controller
    }
    
    lazy var imageView: UIImageView = { [unowned self] in
        let imageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .clear
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView()
        return scrollView
    }()
        
    var imageScale : CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurePhotoEditorViewController()
    }
    
}

extension AGPhotoResizeViewController
{
    override func navigationViewDoneButtonDidTouch (view : AGNavigationView) {
        self.cropImageToVisibleRect()
        self.cropToMaxScaleSize()
        self.showImageEditingViewController()
    }
    
    fileprivate func loadImage(atIndex index : Int) {
        self.activityViewAnimated(isAnimated: true)
        AGPhotoGalleryService.sharedInstance.resolveAsset(AGPhotoGalleryService.sharedInstance.assets[index]) {[weak self] (image) in
            guard let `self` = self else { return }
            self.activityViewAnimated(isAnimated: false)
            guard let photoImage = image else { return }
            self.configureScrollView(image: photoImage)
        }
    }
    
    fileprivate func configurePhotoEditorViewController () {
        self.view.backgroundColor = self.configurator.mainColor
        
        [scrollView, navigationView, activityView].forEach {
            ($0 as! UIView).translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0 as! UIView)
        }
        self.setupConstraints()
    }
        
    fileprivate func configureScrollView (image : UIImage) {
        for subview in scrollView.subviews
        {
            subview.removeFromSuperview()
        }
        self.scrollView.contentSize = self.scrollViewContentSize(image : image)
        self.imageView.frame.size = self.scrollView.contentSize
        
        self.scrollView.addSubview(self.imageView)
        self.imageView.image = image
        self.scrollView.scrollRectToVisible(CGRect (x: (self.scrollView.contentSize.width - screenSize.width) / 2,
                                                    y: (self.scrollView.contentSize.height - screenSize.height) / 2,
                                                    width: screenSize.width,
                                                    height: screenSize.height), animated: false)
    }
    
    fileprivate func scrollViewContentSize (image : UIImage) -> CGSize {
        var height = screenSize.height
        var width = screenSize.width
        
        if (image.size.width > height) {
            self.imageScale = 1 / (height / image.size.height)
            width = image.size.width * (height / image.size.height)
        }
        else if (image.size.width < height)
        {
            self.imageScale = 1 / (width / image.size.width)
            height = image.size.height * (width / image.size.width)
        }
        return CGSize(width: width, height: height)
    }
    
    fileprivate func cropImageToVisibleRect () {
        guard let image = self.imageView.image else {
            return
        }
        let size =  CGSize(width  : screenSize.width * self.imageScale,
                           height : screenSize.height * self.imageScale)
        
        var visibleRect : CGRect = CGRect.zero
        visibleRect.origin.x = scrollView.contentOffset.x * imageScale
        visibleRect.origin.y = scrollView.contentOffset.y * imageScale
        
        visibleRect.size = size
        
        self.configureScrollView(image: UIImage.cropToSize(image: image, rect: visibleRect))
    }

    fileprivate func cropToMaxScaleSize () {
        guard let image = self.imageView.image else {
            return
        }
        let size =  CGSize(width  : screenSize.width * min(self.imageScale, 3),
                           height : screenSize.height * min(self.imageScale, 3))
        
        self.configureScrollView(image: UIImage.resizeImage(image: image, targetSize: size))
    }

    fileprivate func showImageEditingViewController () {
        guard let image = self.imageView.image else { return }
        let imageEditingViewController = AGImageEditingViewController.createWithImage(image: image)
            imageEditingViewController.delegate = self
        self.present(imageEditingViewController, animated: true, completion: nil)
    }
}

extension AGPhotoResizeViewController : AGImageEditingViewControllerDelegate
{
    func posterImage (imageEditingViewController : AGImageEditingViewController, image : UIImage) {
        self.imageView.image = image
        self.dismiss(animated: false) { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.posterImage(photoResizeViewController : self, image: image)
        }
    }
}


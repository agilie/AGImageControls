//
//  AGPhotoGalleryButton.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 20.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGPhotoGalleryButtonDelegate : class {
    func photoGalleryButtonDidTouch (photoGalleryButton : AGPhotoGalleryButton)
}


class AGPhotoGalleryButton: UIView {
    
    weak var delegate : AGPhotoGalleryButtonDelegate?

    lazy var activityView: UIActivityIndicatorView = { [unowned self] in
        let view = UIActivityIndicatorView()
            view.alpha = 0.0
        return view
    }()
    
    lazy var configurator : AGAppConfigurator = {
        return  AGAppConfigurator.sharedInstance
    }()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
        let tapGesture = UITapGestureRecognizer()
            tapGesture.addTarget(self, action: #selector(handleTapGestureRecognizer(_:)))
        return tapGesture
    }()
    
    var isLoading : Bool = false {
        didSet {
            isLoading ? activityView.startAnimating() : activityView.stopAnimating()
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let `self` = self else { return }
                self.activityView.alpha = self.isLoading ? 1.0 : 0.0
            })

        }
    }

    open lazy var imageView : UIImageView = { [unowned self] in
            let imageView = UIImageView()
                imageView.frame = CGRect(x: 0, y: 0,
                                         width: 28.0, height: 28.0)
            
                imageView.center = self.center
                imageView.contentMode = .scaleAspectFill
                imageView.backgroundColor = self.configurator.mainColor
                imageView.withCornerRadius(radius: 3.0)
            return imageView
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configurePhotoGalleryButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleTapGestureRecognizer (_ gestureRecognizer : UITapGestureRecognizer) {
        self.delegate?.photoGalleryButtonDidTouch(photoGalleryButton: self)
    }
}

extension AGPhotoGalleryButton {
    func configurePhotoGalleryButton () {
        self.backgroundColor = .clear
        self.addSubview(imageView)
        self.addGestureRecognizer(self.tapGestureRecognizer)
        self.addAndPin(view : self.activityView)
    }
}

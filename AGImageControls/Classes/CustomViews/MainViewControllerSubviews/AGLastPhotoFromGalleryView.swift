//
//  AGLastPhotoFromGalleryView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 20.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGLastPhotoFromGalleryView: UIView {

    lazy var activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
            view.alpha = 0.0
        return view
    }()
    
    lazy var configurator : AGAppConfigurator =
        {
            return  AGAppConfigurator.sharedInstance
    }()

    open lazy var imageView : UIImageView =
        { [unowned self] in
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
        
        self.backgroundColor = .clear
        addSubview(imageView)
        self.imageView.addSubview(activityView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startLoader() {
        activityView.center = CGPoint(x : self.imageView.frame.width / 2,
                                      y : self.imageView.frame.height / 2)
        activityView.startAnimating()
        UIView.animate(withDuration: 0.3, animations: {
            self.activityView.alpha = 1.0
        })
    }

    func finishLoader()
    {
        activityView.stopAnimating()
        UIView.animate(withDuration: 0.3, animations: {
            self.activityView.alpha = 0.0
        })
    }
    
    
}

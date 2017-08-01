//
//  AGCameraBottomView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 20.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit
import Photos.PHAsset

protocol AGCameraBottomViewDelegate: class {
    
    func cameraBottomViewPhotoGalleryDidTouch(view : AGCameraBottomView)
    func cameraBottomViewSnapButtonDidTouch (view : AGCameraBottomView)
    func cameraBottomViewRotateCameraButtonDidTouch (view : AGCameraBottomView)
}

protocol AGCameraBottomViewDataSource: class {
    func lastPhotoFromGallery () -> PHAsset?
}

open class AGCameraBottomView: UIView {
    
    weak var delegate: AGCameraBottomViewDelegate?
    weak var dataSource: AGCameraBottomViewDataSource?
    
    struct ViewSizes {
        static let height: CGFloat = 130
    }
    
    lazy var configurator : AGAppConfigurator =
        {
            return  AGAppConfigurator()
    }()
    
    lazy var snapButton: UIButton = { [unowned self] in
        let snapButton = UIButton()
            snapButton.frame.size = CGSize(width: 72, height: 72)
            snapButton.backgroundColor = .clear
            snapButton.setImage(AGAppResourcesService.getImage(self.configurator.snapButtonIcon), for: .normal)
            snapButton.imageView?.contentMode = .scaleAspectFill
            snapButton.addTarget(self, action: #selector(snapButtonDidPress(_:)), for: .touchUpInside)

        return snapButton
    }()
    
    open lazy var rotateCameraButton: UIButton = { [unowned self] in
        let button = UIButton(type: .custom)
            button.frame.size = CGSize(width: 64, height: 64)
            button.setImage(AGAppResourcesService.getImage(self.configurator.rotateCameraButtonIcon), for: .normal)
            button.addTarget(self, action: #selector(rotateCameraButtonDidPress(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var photoGalleryView = AGLastPhotoFromGalleryView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
        let gesture = UITapGestureRecognizer()
            gesture.addTarget(self, action: #selector(handleTapGestureRecognizer(_:)))
        return gesture
        }()
    
    
    // MARK: Initializers
    
    public init() {
        super.init(frame: .zero)
        self.configureCameraBottomView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action methods
    func snapButtonDidPress (_ button : UIButton)
    {
        self.delegate?.cameraBottomViewSnapButtonDidTouch(view:self)
    }
    
    func rotateCameraButtonDidPress(_ button: UIButton)
    {
        self.delegate?.cameraBottomViewRotateCameraButtonDidTouch(view: self)
    }
    
    func handleTapGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
        self.delegate?.cameraBottomViewPhotoGalleryDidTouch(view: self)
    }
    
    func update()
    {
        if let asset = self.dataSource?.lastPhotoFromGallery()
        {
            AGPhotoGalleryService.sharedInstance.resolveAsset(asset,
                                                              size: CGSize(width: self.photoGalleryView.frame.size.width * UIScreen.main.scale,
                                                                           height: self.photoGalleryView.frame.size.height * UIScreen.main.scale),
                                                              completion:
                { [weak self] (image) in
                guard let `self` = self else { return }
                if let newImage = image {
                    self.photoGalleryView.imageView.image = newImage
                    self.snapButton.isEnabled = true
                    self.photoGalleryView.finishLoader()
                }
            })
        }
    }
}

extension AGCameraBottomView
{
    func configureCameraBottomView () {
        [snapButton, rotateCameraButton, photoGalleryView].forEach {
            addSubview($0 as! UIView)
            ($0 as! UIView).translatesAutoresizingMaskIntoConstraints = false
        }
        backgroundColor = .clear
        photoGalleryView.addGestureRecognizer(tapGestureRecognizer)
        setupConstraints()
    }
}

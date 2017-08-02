
//  AGCameraSnapViewController.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 20.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit
import MediaPlayer
import Photos

public protocol AGCameraSnapViewControllerDelegate : class {
    func fetchImage (cameraSnapViewController : AGCameraSnapViewController, image : UIImage)
}

public class AGCameraSnapViewController: AGMainViewController {
    
    public weak var delegate : AGCameraSnapViewControllerDelegate?
    
    open lazy var bottomContainer: AGCameraBottomView = { [unowned self] in
        let view = AGCameraBottomView()
            view.delegate = self
            view.dataSource = self
        return view
    }()
    
    lazy var topView: AGCameraTopView = { [unowned self] in
        let view = AGCameraTopView()
        view.delegate = self
        return view
    }()
    
    lazy var cameraController: AGCameraViewController = { [unowned self] in
        let controller : AGCameraViewController = AGCameraViewController()
            controller.delegate = self
            controller.startOnFrontCamera = self.startOnFrontCamera
        return controller
        }()
    
    open var startOnFrontCamera = false
    
    open class func create (isMetalAvailable : Bool = false) -> AGCameraSnapViewController {
        let viewController = AGCameraSnapViewController()
            viewController.configurator.isMetalAvailable = isMetalAvailable
        return viewController
    }
    
   open override func viewDidLoad() {
        super.viewDidLoad()
        [cameraController.view, bottomContainer, topView].forEach {
            view.addSubview($0!)
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        view.backgroundColor = .clear
        setupConstraints()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = try? AVAudioSession.sharedInstance().setActive(true)
        self.obtainPhotosFromGallery(toShowPhotoEditor : false)
    }
    
    deinit {
        _ = try? AVAudioSession.sharedInstance().setActive(false)
    }
}

extension AGCameraSnapViewController
{
    func obtainPhotosFromGallery (toShowPhotoEditor : Bool)
    {
        AGPhotoGalleryService.sharedInstance.fetchWithCompletion() {[weak self] (assets, isSuccess) in
            guard let `self` = self else { return }
            isSuccess ? self.updateBottomContainer(assests: assets) : self.obtainPhotosFromGallery(toShowPhotoEditor : false)
            if toShowPhotoEditor {self.showPhotoEditorViewController()}
        }
    }
    
    func updateBottomContainer (assests : [PHAsset]) {
        self.bottomContainer.update()
    }
    
    func showPhotoEditorViewController () {
        let photoResizeVC = AGPhotoResizeViewController.createWithAsset(atIndex: 0)
            photoResizeVC.delegate = self
        self.present(photoResizeVC, animated: true, completion: nil)
    }
    
    fileprivate func takePicture() {
        bottomContainer.snapButton.isEnabled = false
        bottomContainer.photoGalleryView.startLoader()
        
        let action: (Void) -> Void = { [unowned self] in
            self.cameraController.takePicture {
            }
        }
        action()
    }
}

extension AGCameraSnapViewController: AGCameraBottomViewDelegate {

    func cameraBottomViewPhotoGalleryDidTouch (view : AGCameraBottomView) {
        let photoGalleryVC = AGPhotoGalleryViewController()
            photoGalleryVC.delegate = self
        self.present(photoGalleryVC, animated: true, completion: nil)
    }
    
    func cameraBottomViewSnapButtonDidTouch (view : AGCameraBottomView) {
        self.takePicture()
    }

    func cameraBottomViewRotateCameraButtonDidTouch (view : AGCameraBottomView) {
        self.cameraController.rotateCamera()
    }
}

extension AGCameraSnapViewController : AGCameraBottomViewDataSource
{
    func lastPhotoFromGallery () -> PHAsset? {
        return AGPhotoGalleryService.sharedInstance.assets.first
    }
}

extension AGCameraSnapViewController: AGCameraViewControllerDelegate {
    
    func setFlashButtonHidden(_ hidden: Bool) {
        topView.hideAllButtons(isHidden: hidden)
    }
    
    func imageToLibrary() {
        self.obtainPhotosFromGallery(toShowPhotoEditor: true)
    }
    
    func cameraNotAvailable() {
        topView.hideAllButtons(isHidden: true)
        bottomContainer.snapButton.isEnabled = false
    }
}

extension AGCameraSnapViewController: AGCameraTopViewDelegate
{
    func cameraTopView (view : AGCameraTopView, flashButtonDidPress title: String) {
        cameraController.flashCamera(title)
    }
}

extension AGCameraSnapViewController : AGPhotoResizeViewControllerDelegate
{
    func posterImage (photoResizeViewController : AGPhotoResizeViewController, image : UIImage) {
        self.dismiss(animated: true) { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.fetchImage(cameraSnapViewController: self, image: image)
        }
    }
}

extension AGCameraSnapViewController : AGPhotoGalleryViewControllerDelegate
{
    func posterImage (photoGalleryViewController : AGPhotoGalleryViewController, image : UIImage) {
        self.dismiss(animated: true) { [weak self] in
            guard let `self` = self else { return }
            self.delegate?.fetchImage(cameraSnapViewController: self, image: image)
        }
    }
}



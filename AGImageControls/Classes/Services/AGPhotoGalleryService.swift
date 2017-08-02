//
//  AGPhotoGalleryService.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 21.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit
import Photos


private let shared = AGPhotoGalleryService()

open class AGPhotoGalleryService: UIView {

    class var sharedInstance: AGPhotoGalleryService {
        return shared
    }
    
    open var assets : [PHAsset] = []
    
    fileprivate var viewController : UIViewController? {
        get {
            return UIWindow().visibleViewController
        }
    }
    
    lazy var configurator : AGAppConfigurator =
        {
            return  AGAppConfigurator.sharedInstance
    }()

    open func fetchWithCompletion (completion: @escaping (_ assets : [PHAsset],
                                                        _ isSuccess : Bool) -> Void)
    {
        guard let currentVC = self.viewController else {
            completion ([], false)
            return
        }
        
        guard PHPhotoLibrary.authorizationStatus() == .authorized else {
            self.checkStatus(viewController: currentVC, completion)
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let fetchResult = PHAsset.fetchAssets(with: .image, options: PHFetchOptions())
            
            if fetchResult.count > 0 {
                var assets = [PHAsset]()
                fetchResult.enumerateObjects({ object, index, stop in
                    assets.insert(object, at: 0)
                })
                
                DispatchQueue.main.async {
                    self.assets.removeAll()
                    self.assets = assets
                    completion(assets, true)
                }
                return
            }
            completion([], true)
        }
    }
    
    open func resolveAsset(_ asset: PHAsset, size: CGSize = CGSize(width: 720, height: 1280), completion: @escaping (_ image: UIImage?) -> Void) {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.isNetworkAccessAllowed = true
        
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { image, info in
            DispatchQueue.main.async(execute: {
                completion(image)
            })
        }
    }
    
    open func resolveAsset(atIndex index : Int, size: CGSize = CGSize(width: 720, height: 1280)) -> UIImage? {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
        
        if self.assets.count > index {
            var assetImage : UIImage? = nil
            imageManager.requestImage(for: self.assets[index], targetSize: size, contentMode: .aspectFill, options: requestOptions) { image, info in
                assetImage = image
            }
            return assetImage
        }
        return nil
    }
    
    open func resolveAssets(_ assets: [PHAsset], size: CGSize = CGSize(width: 720, height: 1280)) -> [UIImage] {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        var images = [UIImage]()
        for asset in assets {
            imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { image, info in
                if let image = image {
                    images.append(image)
                }
            }
        }
        return images
    }
    
    open func imagesFromPhotoGallery (completion : @escaping ((_ images : [UIImage]) -> Void))
    {
        self.fetchWithCompletion() {[unowned self] (assets, isSuccess) in
            var images : [UIImage] = []
            var fullImages :  [UIImage] = []
            var maxRange : Int = 0
            
            if (isSuccess)
            {
                if let firstImage = self.resolveAsset(atIndex: 0){
                    images.append(firstImage)
                    fullImages.append(firstImage)
                }
                if assets.count > 1 {
                    maxRange = min(40, assets.count)
                    let array = Array(assets[1..<maxRange])
                    images += AGPhotoGalleryService.sharedInstance.resolveAssets(array, size: CGSize(width: 150, height: 150))
                }
            }
            completion(images)
            self.fetchImagesWith(images: images, startIndex: maxRange, step: 40, completion: completion)
            return
        }
    }
    
    open func saveImageToCameraRoll (image : UIImage)
    {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(AGPhotoGalleryService.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("===>>> AGPhotoGalleryService: Error saving image to the photo gallery : \n \(error.localizedDescription)")
        } else {
            print("===>>> AGPhotoGalleryService: Image saved successfully")
        }
    }
}

extension AGPhotoGalleryService
{
    fileprivate func checkStatus(viewController : UIViewController,
                          _ completion: @escaping (_ assets : [PHAsset],
        _ isSuccess : Bool) -> Void)
    {
        let currentStatus = PHPhotoLibrary.authorizationStatus()
        guard currentStatus != .authorized else {
            completion ([], false)
            return
        }
        
        PHPhotoLibrary.requestAuthorization {[unowned self] (authorizationStatus) -> Void in
            DispatchQueue.main.async {
                if authorizationStatus == .denied {
                    self.presentAskPermissionAlert(viewController : viewController, completion)
                    return
                }
            }
        }
    }
    
    fileprivate func presentAskPermissionAlert(viewController : UIViewController,
                                               _ completion: @escaping (_ assets : [PHAsset],
        _ isSuccess: Bool) -> Void)
    {
        let alertController = UIAlertController(title: self.configurator.requestPermissionTitle,
                                                message: self.configurator.requestPermissionMessage,
                                                preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: self.configurator.okButtonTitle.capitalized, style: .default) { _ in
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(settingsURL)
                return
            }
            completion ([], false)
        }
        
        let cancelAction = UIAlertAction(title: self.configurator.cancelButtonTitle, style: .cancel) { _ in
            viewController.dismiss(animated: true, completion: nil)
            completion ([], false)
            return
        }
        
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func fetchImagesWith (images : [UIImage], startIndex : Int, step : Int, completion : @escaping ((_ images : [UIImage]) -> Void))
    {
        
        DispatchQueue.global(qos: .background).async {
            var rangeImages : [UIImage] = []
            if self.assets.count > startIndex {
                let maxRange = min(startIndex + step, self.assets.count)
                let array = Array(self.assets[startIndex..<maxRange])
                rangeImages += AGPhotoGalleryService.sharedInstance.resolveAssets(array, size: CGSize(width: 150, height: 150))
            }
            DispatchQueue.main.async {
                var newImages = images
                newImages += rangeImages
                completion (newImages)
                
                if (rangeImages.count != step) {
                    return
                }
                completion(newImages)
                self.fetchImagesWith(images: newImages, startIndex: startIndex + step, step: step, completion: completion)
            }
        }
    }
}

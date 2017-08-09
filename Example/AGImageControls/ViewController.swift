//
//  ViewController.swift
//  AGImageControls
//
//  Created by liptugamichael@gmail.com on 07/26/2017.
//  Copyright (c) 2017 liptugamichael@gmail.com. All rights reserved.
//

import UIKit
import AGImageControls

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func captureNewImageButtonDidTouch(_ sender: Any) {
        let camera = AGCameraSnapViewController.create()
            camera.delegate = self
        self.present(camera, animated: true, completion: nil)
    }
    
    
    @IBAction func openPhotoGalleryButtonDidTouch(_ sender: Any) {
        let photoGallery = AGPhotoGalleryViewController()
            photoGallery.delegate = self
        self.present(photoGallery, animated: true, completion: nil)
    }
}

extension ViewController : AGCameraSnapViewControllerDelegate {
    
    func fetchImage (cameraSnapViewController : AGCameraSnapViewController, image : UIImage) {
        self.imageView.image = image
    }
    
}

extension ViewController : AGPhotoGalleryViewControllerDelegate {
    
    func posterImage (photoGalleryViewController : AGPhotoGalleryViewController, image : UIImage) {
        self.imageView.image = image
    }
    
}

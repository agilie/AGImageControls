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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func captureNewImageButtonDidTouch(_ sender: Any) {
        let camera = AGCameraSnapViewController.create()
            camera.delegate = self
        self.present(camera, animated: true, completion: nil)
    }
}

extension ViewController : AGCameraSnapViewControllerDelegate
{
    func fetchImage (cameraSnapViewController : AGCameraSnapViewController, image : UIImage)
    {
        self.imageView.image = image
    }
    
}

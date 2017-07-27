<p align="center">
<img src="https://user-images.githubusercontent.com/4165054/28629674-c7a917aa-7230-11e7-94c6-4e76ffa2b032.png" alt="AGImageControls" title="AGImageControls" width="557"/>
</p>

<p align="center">
<img src="http://weekly.ascii.jp/elem/000/000/261/261806/Macp11_Metal_1200x.jpg" alt="Metal" title="Metal" width="100"/>
</p>

<p>

</p>

<p align="center">

<a href="https://www.agilie.com?utm_source=github&utm_medium=referral&utm_campaign=Git_Swift&utm_term=AGImageControls">
<img src="https://img.shields.io/badge/Made%20by-Agilie-green.svg?style=flat" alt="Made by Agilie">
</a>

<a href="https://travis-ci.org/liptugamichael@gmail.com/AGImageControls">
<img src="http://img.shields.io/travis/agilie/AGImageControls.svg?style=flat" alt="CI Status">
</a>

<a href="http://cocoapods.org/pods/AGImageControls">
<img src="https://img.shields.io/cocoapods/v/AGImageControls.svg?style=flat" alt="Version">
</a>

<a href="http://cocoapods.org/pods/AGImageControls">
<img src="https://img.shields.io/cocoapods/l/AGImageControls.svg?style=flat" alt="License">
</a>

<a href="http://cocoapods.org/pods/AGImageControls">
<img src="https://img.shields.io/cocoapods/p/AGImageControls.svg?style=flat" alt="Platform">
</a>

</p>

Hey, everyone!
We’re happy to share with you our new lightweight and open-source library called AGImageControls and free to use. 
Integrate AGImageControls library into your project and get an efficient tool for photos, screenshots, and other images processing. (Supporting Metal Performance Shaders)

AGImageControls allows users to:

- process any image with special filters. Due to these filters, a user can control the saturation, brightness, contrast, and sharpness of the picture, and also apply a gradient of the appropriate color and the suitable transparency

- easily supplement an image with a title and a brief description. In addition, one can select the font type, color, and size

- use vector masks to add emotions and accents to the image. You can also turn the elements through 360 degrees and set the desired slope

## Note (Device only)

Make sure that you are running on an actual device (not the simulator) that has an A7 or better chip (an iPhone 5S, iPhone 6, iPhone 6 Plus, iPad Air, or iPad mini (2nd generation))

## Installation

AGImageControls is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AGImageControls"
```

## Demo

<img src="https://user-images.githubusercontent.com/4165054/28632257-9be44f24-7238-11e7-95da-1e65d40dad25.gif" alt="AGImageControls Demo" height="430" width="250" border ="50"> <img src="https://user-images.githubusercontent.com/4165054/28632626-eceb39b8-7239-11e7-8fd0-2c49aac29ac1.gif" alt="AGImageControls Demo" height="430" width="250" border ="50">

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
You can also see an example :

## Usage

1. Import `AGImageControls` module to your `ViewController` class

   ```swift
   import AGImageControls
   ```

2. Add `AGCameraSnapViewController` to `ViewController`, then set delegate for it

   ```swift
   let camera = AGCameraSnapViewController()
       camera.delegate = self
   self.present(camera, animated: true, completion: nil)
   ```

3. Conform your `ViewController` to `AGCameraSnapViewControllerDelegate` protocol
    
   ```swift
   func fetchImage (cameraSnapViewController : AGCameraSnapViewController, image : UIImage) {
     self.imageView.image = image
   }
   ```

4. `AGCameraSnapViewController` works with default implementation.


## Troubleshooting
Problems? Check the [Issues](https://github.com/agilie/AGImageControls/issues) block
to find the solution or create an new issue that we will fix asap. Feel free to contribute.

## Author

This iOS visual component is open-sourced by [Agilie Team](https://www.agilie.com?utm_source=github&utm_medium=referral&utm_campaign=Git_Swift&utm_term=AGImageControls) <info@agilie.com>

## Contributors
- [Michael Liptuga](https://github.com/Liptuga-Michael)

## Contact us
If you have any questions, suggestions or just need a help with web or mobile development, please email us at
<ios@agilie.com>. You can ask us anything from basic to complex questions.

## License

AGImageControls is available under
The [MIT](LICENSE.md) License (MIT) Copyright © 2017 [Agilie Team](https://www.agilie.com?utm_source=github&utm_medium=referral&utm_campaign=Git_Swift&utm_term=AGImageControls) 

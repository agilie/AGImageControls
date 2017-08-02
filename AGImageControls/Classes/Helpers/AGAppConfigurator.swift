//
//  AGAppConfigurator.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 24.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

private let shared = AGAppConfigurator()

public class AGAppConfigurator {
    
    class var sharedInstance: AGAppConfigurator {
        return shared
    }
    //MARK: Icons
    public var cameraFocusIcon = "focusIcon"
    public var backButtonIcon = "backButton_icon"
    public var sliderThumbIcon = "sliderThumb_icon"
    public var snapButtonIcon = "snap_icon"
    public var rotateCameraButtonIcon = "rotateCamera_icon"
    public var trashButtonIcon = "trashButton_icon"

    // MARK: Colors
    public var mainColor = UIColor.colorWith(redColor: 20, greenColor: 13, blueColor: 38, alpha: 1.0)
    
    public var noCameraColor = UIColor.white
    public var settingsColor = UIColor.white
    
    public var underlineViewColor = UIColor.white
    public var flashButtonSelectedColor = UIColor.colorWith(redColor : 254, greenColor: 200, blueColor : 53, alpha : 1.0)
    public var imageEditorButtonsColor = UIColor.init(white: 0, alpha: 0.5)
    
    // MARK: Fonts
    public var flashButton =  UIFont.ubuntuMediumFontWithSize(size: 14)
    
    public var noCameraFont = UIFont.ubuntuMediumFontWithSize(size: 18)
    public var settingsFont = UIFont.ubuntuMediumFontWithSize(size: 18)
    
    public var okButtonFont = UIFont.ubuntuMediumFontWithSize(size: 12)
    public var cancelButtonFont = UIFont.ubuntuMediumFontWithSize(size: 12)
    
    public var doneButtonFont = UIFont.ubuntuMediumFontWithSize(size: 17)

    public var sliderValueFont = UIFont.ubuntuMediumFontWithSize(size: 16)
    public var titleSettingsFont = UIFont.ubuntuMediumFontWithSize(size: 12)
    
    public var flashButtonFont =  UIFont.ubuntuMediumFontWithSize(size: 13)
    
    public var addNewImageButtonFont = UIFont.ubuntuMediumFontWithSize(size: 16)
    public var undoImageButtonFont = UIFont.ubuntuMediumFontWithSize(size: 16)
    public var captionTextButtonFont = UIFont.ubuntuMediumFontWithSize(size: 36)
    public var detailsTextButtonFont = UIFont.ubuntuMediumFontWithSize(size: 26)

    public var fontButtonTitleLabelFont = UIFont.ubuntuMediumFontWithSize(size: 18)
    
    // MARK: Titles
    public var okButtonTitle = "ok"
    public var cancelButtonTitle = "Cancel"
    public var doneButtonTitle = "done"
    public var noImagesTitle = "No images available"
    public var noCameraTitle = "Camera isn't available"
    public var settingsTitle = "Settings"
    public var requestPermissionTitle = "Permission denied"
    public var requestPermissionMessage = "Please, allow the application to access to your photo library."
    
    
    public var flashButtonOnTitle = "ON"
    public var flashButtonOffTitle = "OFF"
    public var flashButtonAutoTitle = "AUTO"
    
    
    public var addNewImageButtonTitle = "add"
    public var undoImageButtonTitle = "undo"
    public var captionTextButtonTitle = "Aa"
    public var detailsTextButtonTitle = "Bb"
    
    public var captionTextLabelTitle = "Caption"
    public var detailsTextLabelTitle = "Details"
    
    
    // MARK: Custom behaviour
    public var canRotateCamera = true
    public var isMetalAvailable = false
    
//    public init() {}
}

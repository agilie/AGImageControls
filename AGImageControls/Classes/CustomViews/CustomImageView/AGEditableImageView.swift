//
//  AGEditableImageView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 17.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit


protocol AGEditableImageViewDelegate : class {
    func imageDidTouch (imageView : AGEditableImageView)
    func startMoving (imageView : AGEditableImageView)
    func endMoving (imageView : AGEditableImageView, touchLocation : CGPoint)
    func showTextEditor (imageView : AGEditableImageView)
}

internal struct AGPositionStruct {
    
    var centerPoint     : CGPoint
    var scale           : CGFloat
    var rotateAngle     : CGFloat
    
    init(center : CGPoint, scale: CGFloat, angle : CGFloat) {
        self.centerPoint = center
        self.scale = scale
        self.rotateAngle = angle
    }
}

class AGEditableImageView: UIImageView {

    weak var delegate : AGEditableImageViewDelegate?

    lazy var configurator : AGAppConfigurator = {
            return  AGAppConfigurator.sharedInstance
    }()
    
    struct ViewSizes {
        static let textViewDefaultSize : CGSize = CGSize(width : UIScreen.main.bounds.width - ViewSizes.textViewRightLeftOffsetSize * 2, height: 120.0)
        static let textViewRightLeftOffsetSize : CGFloat = 16.0
    }
    
    lazy var textView : UITextView = { [unowned self] in
        let textView = UITextView ()
        
        textView.backgroundColor = UIColor.clear
        textView.alpha = 1.0
        textView.isUserInteractionEnabled = false
        
        return textView
    }()
    
    var settingsType : AGSettingMenuItemTypes {
        get {
            switch self.type {
            case .icons:
                return .iconsAdjustment
            case .shapes:
                return .shapesMaskAdjustment
            default:
                return .textAdjustment
            }
        }
    }
    
    var initialBounds : CGRect = CGRect.zero
    
    var maskColor : AGColorEditorItem = AGColorEditorItem()
    {
        didSet {
            switch self.type {
            case .captionText, .detailsText:
                self.textView.textColor = maskColor.color
                self.textView.alpha = CGFloat(maskColor.currentValue / 100.0)
            default:
                guard let image = self.image else { return }
                self.image = image.withRenderingMode(.alwaysTemplate)
                self.tintColor = maskColor.color
                self.alpha = CGFloat(maskColor.currentValue / 100.0)
            }
        }
    }

    var lastMaskColor : AGColorEditorItem? = nil
    
    var newPosition : AGPositionStruct? = nil
    {
        didSet
        {
            switch self.type {
            case .captionText, .detailsText:
                self.updateTextSizes(scale: self.newPosition?.scale ?? 1.0)
            default:
                self.transform = CGAffineTransform.identity.rotated(by: self.newPosition?.rotateAngle ?? 0).scaledBy(x: self.newPosition?.scale ?? 1, y: self.newPosition?.scale ?? 1)
            }
        }
    }
    
    var lastPosition : AGPositionStruct? = nil
    
    var currentFont : AGFontEditorItem? = nil
    {
        didSet {
            guard let font = currentFont, let position = newPosition  else { return }
            self.textView.font = font.font.withSize(position.scale * font.minFontSize)
            self.updateImage()
        }
    }
    
    var lastFont : AGFontEditorItem? = nil

    var text : String? {
        didSet {
            guard let _ = text else { return }
            self.textView.text = text
            self.updateImageWithAnimation()
        }
    }
    
    var lastText : String? = nil
    
    var placeholder : String {
        get {
            switch self.type {
            case .captionText:
                return self.configurator.captionTextLabelTitle
            case .detailsText:
                return self.configurator.detailsTextLabelTitle
            default:
                return ""
            }
        }
    }
    
    
    var lastCenterPosition = CGPoint.zero
    
    var isActive : Bool = true
    
    var imageName : String = ""
    
    var type : AGImageEditorTypes = .icons
   
    let imageDefaultSize : CGSize = CGSize(width : 50, height : 50)
    
    class func createWithImage (imageName : String, type : AGImageEditorTypes, tag : Int, size : CGSize = CGSize(width: 78.0, height: 100), center : CGPoint = CGPoint(x: 59.0, y: 154.0), scale : CGFloat = 1.0, color : UIColor = UIColor.init(hexString : "#FFFFFF")) -> AGEditableImageView
    {
        let newImageView = self.create(type: type, tag: tag, size: size, center: center, scale: scale, color: color)
        newImageView.image = UIImage.fromPDF(filename: imageName + "_pdf", size: newImageView.imageDefaultSize, scale: max(size.width / newImageView.imageDefaultSize.width, size.height / newImageView.imageDefaultSize.height))
        newImageView.imageName = imageName + "_pdf"
        return newImageView
    }
    
    class func createWithText (type : AGImageEditorTypes, tag : Int, size : CGSize = ViewSizes.textViewDefaultSize, center : CGPoint = CGPoint(x: 140, y: 160), scale : CGFloat = 1.0, color : UIColor = UIColor.init(hexString : "#FFFFFF")) -> AGEditableImageView
    {
        let newImageView = self.create(type: type, tag: tag, size: size, center: center, scale: scale, color: color)
        newImageView.text = newImageView.placeholder
        
        newImageView.currentFont = AGFontEditorItem.createWithType(type: type)
        newImageView.addTextView()
        
        return newImageView
    }

    fileprivate class func create (type : AGImageEditorTypes, tag : Int, size : CGSize, center : CGPoint, scale : CGFloat = 1.0, color : UIColor) -> AGEditableImageView {
        let newImageView = AGEditableImageView()
        
        newImageView.type = type
        newImageView.contentMode = .scaleAspectFit
        newImageView.maskColor = AGColorEditorItem.createWithColor(color: color)
        newImageView.frame.size = size
        newImageView.center = center
        newImageView.newPosition = AGPositionStruct.init(center: center, scale: 1.0, angle: 0.0)
        newImageView.tag = tag
        
        newImageView.isUserInteractionEnabled = true
        
        newImageView.addGestureRecognizers()
        
        newImageView.becomeFirstResponder()
        
        return newImageView
    }
    
    func updateImage (scale: CGFloat = 1.0) {
        switch self.type {
        case .icons, .shapes:
            self.updateShapeSizes()
        default:
            self.updateTextSizes(scale: self.newPosition?.scale ?? 1.0)
        }
    }
    
    func undoImageChanges () {
        if (self.lastPosition == nil) {
            self.removeFromSuperview()
            return
        }
        
        self.currentFont = self.lastFont ?? AGFontEditorItem.createWithType(type: type)
        self.text = self.lastText
        self.newPosition = self.lastPosition
        self.maskColor = self.lastMaskColor ?? AGColorEditorItem()
        self.center = self.newPosition?.centerPoint ?? CGPoint.zero
        
        self.updateImage()
    }
    
    func updateLastPosition() {
        self.lastFont = self.currentFont ?? AGFontEditorItem.createWithType(type: type)
        self.lastText = self.text
        self.lastPosition = self.newPosition
        self.lastMaskColor = self.maskColor
    }
    
    func showHideImageView () {
        self.delegate?.imageDidTouch(imageView: self)
    }
    
    func moveEditableImageView (_ gestureRecognizer : UIPanGestureRecognizer) {
        if (!self.isActive) { return }
        let touchLocation = gestureRecognizer.location(in: self.superview)
        switch gestureRecognizer.state {
        case .began:
            self.delegate?.startMoving(imageView: self)
            let point = self.newPosition?.centerPoint ?? CGPoint.zero
            self.lastCenterPosition = CGPoint(x: point.x - touchLocation.x, y: point.y - touchLocation.y)
        case .changed:
            self.center = CGPoint(x: self.lastCenterPosition.x + touchLocation.x, y: self.lastCenterPosition.y + touchLocation.y)
            self.newPosition?.centerPoint = self.center
        case .ended:
            self.delegate?.endMoving(imageView: self, touchLocation: touchLocation)
        default:
            return
        }
    }
    
    func openTextEditor (_ gestureRecognizer : UITapGestureRecognizer) {
        if (!self.isActive) { return }
        guard let position = self.newPosition else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.245) {
            self.delegate?.showTextEditor(imageView: self)
        }

        UIView.animate(withDuration: 0.5, animations: { _ in
            self.transform = CGAffineTransform.identity.rotated(by: 0).scaledBy(x: 1.0 / position.scale, y: 1.0 / position.scale)
            self.frame.origin = CGPoint(x: AGTextEditorView.ViewSizes.textViewRightLeftOffset, y: AGTextEditorView.ViewSizes.textViewLeftTopPoint.y)
            self.textView.alpha = 0
        })
    }
    
    func updateImageWithAnimation () {
        UIView.animate(withDuration: 0.3, animations: { _ in
            self.updateTextSizes(scale: self.newPosition?.scale ?? 1.0)
            self.textView.alpha = 1.0
        })
    }
    
    func modifiedScaling (scale : CGFloat) -> CGFloat {
        switch self.type {
        case .captionText, .detailsText:
            guard let font = self.currentFont else { return 1 }
            let maxScale = max(0.5, scale)
            let minScale = min(maxScale, font.maxFontSize / font.minFontSize)
            return minScale
        default:
            let maxScale = max(0.5, scale)
            let minScale = min(maxScale, 8.0)
            return minScale
        }
    }
}


extension AGEditableImageView
{
    func addGestureRecognizers () {
        let singleTap = UITapGestureRecognizer.init(target: self, action:  #selector(AGEditableImageView.showHideImageView))
            self.addGestureRecognizer(singleTap)
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action:  #selector(AGEditableImageView.moveEditableImageView(_:)))
            self.addGestureRecognizer(panGesture)
        
        switch self.type {
        case .captionText, .detailsText:
            let doubleTap = UITapGestureRecognizer.init(target: self, action:  #selector(AGEditableImageView.openTextEditor(_:)))
                doubleTap.numberOfTapsRequired = 2
            self.addGestureRecognizer(doubleTap)
        default:
            break
        }
    }
    
    func addTextView () {
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.frame.size = self.textView.sizeThatFits(CGSize(width : ViewSizes.textViewDefaultSize.width + 8, height: CGFloat(MAXFLOAT)))
        self.frame.size = self.textView.frame.size
        
        self.initialBounds = self.frame

        self.addSubview(self.textView)
    }
    
    func updateShapeSizes () {
        let screenSize = UIScreen.main.bounds.size
        
        let maxScale = max(screenSize.width / self.imageDefaultSize.width, screenSize.height / self.imageDefaultSize.height)
        let currentScale = max(self.frame.size.width / self.imageDefaultSize.width, self.frame.size.height / self.imageDefaultSize.height)
        
        let minScale = min(maxScale, currentScale)
        let tempMask = self.maskColor
        self.image = UIImage.fromPDF(filename: self.imageName, size: imageDefaultSize, scale: minScale)
        self.maskColor = tempMask
    }
    
    func updateTextSizes(scale : CGFloat) {
        guard let font = self.currentFont, let position = self.newPosition else { return }
        
            self.transform = CGAffineTransform.identity
        
            self.textView.font = font.font.withSize(scale * font.minFontSize)
            let width =  (ViewSizes.textViewDefaultSize.width + 8) * scale
            self.textView.frame.size = self.textView.sizeThatFits(CGSize(width : width, height: CGFloat(MAXFLOAT)))
            self.frame = CGRect(x: self.initialBounds.origin.x * scale, y: self.initialBounds.origin.y * scale, width: self.textView.frame.size.width, height: self.textView.frame.size.height)
            self.center = position.centerPoint
        
        self.transform = CGAffineTransform.identity.rotated(by: self.newPosition?.rotateAngle ?? 0)
    }
}



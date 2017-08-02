//
//  AGMainImageEditingService.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 27.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit
import OpenGLES

class AGMainImageEditingService : NSObject
{
    var defaultImage                             : UIImage? = nil
    var tempAdjustmentImage                      : UIImage? = nil
    var modifiedImage                            : UIImage? = nil
    var gradientImage                            : UIImage? = nil
    
    var tempGradientImage         : UIImage? = nil
    
    var selectedGradientFilterItem : AGGradientFilterItemModel? = nil
    
    var colorControlFilter : CIFilter? = nil
    
    var saturationMetal : AGImageChain? = nil
    
    
    var ciContext : CIContext? = nil
    var coreImage : CIImage? = nil
    
    open class func  create() -> AGMainImageEditingService
    {
        let service = AGMainImageEditingService()
        return service
    }
    
    func setImage (image : UIImage) {
        self.modifiedImage = image
        self.defaultImage = image
        if !AGImageChain.isMetalAvailable() || !AGAppConfigurator.sharedInstance.isMetalAvailable {
            self.configureCIContext()
        }
    }
    
    lazy var settingsMenuItems : [AGSettingMenuItemModel] = {
        return [AGSettingMenuItemModel.imageAdjustmentMenuItem(),
                AGSettingMenuItemModel.imageFilterMaskAdjustmentMenuItem(),
                AGSettingMenuItemModel.textAdjustmentMenuItem(),
                AGSettingMenuItemModel.shapesMaskAdjustmentMenuItem(),
                AGSettingMenuItemModel.imageMaskAdjustmentMenuItem()]
    }()

    
    lazy var adjustmentItems : [AGAdjustmentMenuItem] =
    {
        return [AGAdjustmentMenuItem.adjustmentDefaultItem(),
                AGAdjustmentMenuItem.saturationItem(),
                AGAdjustmentMenuItem.brightnessItem(),
                AGAdjustmentMenuItem.contrastItem(),
//                AGAdjustmentMenuItem.adjustItem(),
                AGAdjustmentMenuItem.structureItem(),
                AGAdjustmentMenuItem.imageMaskAdjustmentMenuItem(),
                AGAdjustmentMenuItem.sharpenItem(),
                AGAdjustmentMenuItem.warmthItem()]
    }()
    
    lazy var gradientFilterItems : [AGGradientFilterItemModel] =
        {
            var items : [AGGradientFilterItemModel] = [AGGradientFilterItemModel.defaultGradientItem()]
            
            for i in 1...7
            {
                items.append(AGGradientFilterItemModel.createWithName(name: ("filter_gradient_\(i)")))
            }
            return items
    }()
    
    lazy var shapesMenuList: [String] = { [unowned self] in
        return ["cube_icon", "oval_icon", "polygon_icon", "rectangle_icon", "rectangle-with-rounded-corners_icon"]
        }()
    
    lazy var iconsMenuList: [String] = { [unowned self] in
        return ["flower_icon", "heart_icon", "pin_icon", "clock_icon", "alien_icon",
                "chat_icon", "woman_icon", "man_icon", "like_icon", "unlike_icon",
                "head_icon", "cup_icon", "camera_icon"]
        }()

    
    func applyFilterFor (adjustmentItem : AGAdjustmentMenuItem) -> UIImage? {
        guard let image = self.modifiedImage else {
            return nil
        }
        if (tempAdjustmentImage == nil) { self.tempAdjustmentImage = image }
        
        switch adjustmentItem.type {
        case .adjustmentDefault:
            self.removeAllFilters()
            return self.defaultImage
        default:
            self.applyFilters()
        }
        return self.tempAdjustmentImage
    }
    
    func applyFilterImage (adjustmentItem : AGAdjustmentMenuItem) {
        adjustmentItem.lastValue = adjustmentItem.currentValue
    }
    
    func removeAllFilters () {
        self.modifiedImage = self.defaultImage
        self.tempAdjustmentImage = nil
        for adjustmentItem in self.adjustmentItems {
            adjustmentItem.reset()
        }
    }
    
    @discardableResult
    func applyFilters () -> UIImage?  {
        guard let image = self.modifiedImage else {
            return nil
        }
        if AGImageChain.isMetalAvailable() && AGAppConfigurator.sharedInstance.isMetalAvailable {
            return self.applyMetalFilter(image: image)
        }
       return self.applyCoreImageFilter()
    }
    
    
    fileprivate func applyMetalFilter (image : UIImage) -> UIImage {
        let processMetal = AGImageChain.init(image: image)
        
        self.adjustmentItems.forEach {
            if $0.currentValue != $0.defaultValue {
                switch $0.type {
                case .saturationType:
                    processMetal.saturation(color: $0.currentValue / 100 + 1.0)
                case .brightnessType:
                    processMetal.brightness(($0.currentValue / 100) / 4)
                case .contrastType:
                    processMetal.contrast(($0.currentValue / 100.0) / 4 + 1.0)
                case .structureType:
                    processMetal.details($0.currentValue / 60)
                case .tiltShiftType:
                    processMetal.blur($0.currentValue / 2)
                case .sharpenType:
                    processMetal.sharpen($0.currentValue / 60)
                case .warmthType:
                    processMetal.softLightFilter(Int($0.currentValue / 3))
                default:
                    break
                }
            }
        }
        guard let adjustmentImage = processMetal.image() else { return image }
        self.tempAdjustmentImage = adjustmentImage
        return self.tempAdjustmentImage!
    }
    

    func applyGradientFilterFor (modifiedImage : UIImage, gradientImage : UIImage) -> UIImage? {
        return UIImage.combineImages(images: [modifiedImage, gradientImage])
    }
    
    func addGradientFilterImage (gradientFilterItem : AGGradientFilterItemModel) {
        guard let modImage = self.modifiedImage else { return }
        if (self.selectedGradientFilterItem != gradientFilterItem) {
            self.selectedGradientFilterItem?.lastValue = self.selectedGradientFilterItem?.defaultValue ?? 0
        }
        
        gradientFilterItem.lastValue = gradientFilterItem.currentValue
        self.selectedGradientFilterItem = gradientFilterItem
        
        if (self.gradientImage == nil) {
            self.gradientImage = UIImage.resizeImage(image: AGAppResourcesService.getImage(gradientFilterItem.imageName),
                                                    targetSize: modImage.size,
                                                    alpha: CGFloat(gradientFilterItem.currentValue / 100.0))
        }
        guard let tempAdjustment = self.tempAdjustmentImage, let gradImage = self.gradientImage else {
            guard let modImage = self.modifiedImage, let gradImage = self.gradientImage else {
                return
            }
            self.tempGradientImage = self.applyGradientFilterFor(modifiedImage: modImage, gradientImage: gradImage)
            return
        }
        self.tempGradientImage = self.applyGradientFilterFor(modifiedImage: tempAdjustment, gradientImage: gradImage)
    }
    
    
    func removeGradientFilterImage () {
        self.tempGradientImage = nil
        self.gradientImage = nil
        self.selectedGradientFilterItem?.lastValue = self.selectedGradientFilterItem?.defaultValue ?? 0
        self.selectedGradientFilterItem = nil
    }
    
    func posterImage (editorImage : UIImage?) -> UIImage {
        guard let mainImage = self.applyFilters() else {
            return UIImage()
        }
        guard let gradientImage = self.gradientImage else {
            guard let masksImage = editorImage else {
                return mainImage
            }
            let finalMaskImage = UIImage.resizeImage(image: masksImage, targetSize: mainImage.size, alpha: 1.0)
            return UIImage.combineImages(images: [mainImage, finalMaskImage ])
        }
        let finalGradientImage = UIImage.resizeImage(image: gradientImage, targetSize: mainImage.size, alpha: CGFloat(self.selectedGradientFilterItem?.lastValue ?? 0) / 100.0)

        guard let masksImage = editorImage else {
            return UIImage.combineImages(images: [mainImage, finalGradientImage])
        }
        let finalMaskImage = UIImage.resizeImage(image: masksImage, targetSize: mainImage.size, alpha: 1.0)
        
        let posterImage = UIImage.combineImages(images: [mainImage, finalGradientImage, finalMaskImage])
        self.cleanService()
        return posterImage
    }
    
    @discardableResult
    func applyCoreImageFilter() -> UIImage? {
        
        guard let ciImage = self.imageWithCIFilters()  else { return nil }
        
        guard let cgImageResult = self.ciContext?.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        let result = UIImage.init(cgImage: cgImageResult)
        
        self.tempAdjustmentImage = result
        
        return result
    }
    
    
    fileprivate func imageWithCIFilters () -> CIImage? {
        guard let ciImage = self.coreImage else { return nil }
        
        var newCIImage : CIImage? = ciImage
        
        self.adjustmentItems.forEach {
            if $0.currentValue != $0.defaultValue {
                switch $0.type {
                case .saturationType:
                    newCIImage = self.addCIFilter(image: newCIImage,
                                                  coreImageFilter: "CIColorControls",
                                                  filterKeys: [kCIInputSaturationKey : $0.currentValue / 100 + 1.0])
                case .brightnessType:
                    newCIImage = self.addCIFilter(image: newCIImage,
                                                  coreImageFilter: "CIColorControls",
                                                  filterKeys: [kCIInputBrightnessKey : ($0.currentValue / 100) / 4 ])
                case .contrastType:
                    newCIImage = self.addCIFilter(image: newCIImage,
                                                  coreImageFilter: "CIColorControls",
                                                  filterKeys: [kCIInputContrastKey : ($0.currentValue / 100.0) / 4 + 1.0])
                    
                case .structureType:
                    newCIImage = self.addCIFilter(image: newCIImage,
                                                  coreImageFilter: "CISharpenLuminance",
                                                  filterKeys: [kCIInputSharpnessKey : $0.currentValue / 50 + 0.4])
                case .tiltShiftType:
                    newCIImage = self.addCIFilter(image: newCIImage,
                                                  coreImageFilter: "CIBoxBlur",
                                                  filterKeys: [kCIInputRadiusKey : $0.currentValue / 4])
                case .sharpenType:
                    newCIImage = self.addCIFilter(image: newCIImage,
                                                  coreImageFilter: "CIUnsharpMask",
                                                  filterKeys: [kCIInputRadiusKey : $0.currentValue])
                case .warmthType:
                    let correctionValue = $0.currentValue / 200
                    let r: CGFloat = $0.currentValue > 0 ? CGFloat(1.0 + correctionValue) : CGFloat(1.0 + correctionValue)
                    let g: CGFloat = 1.0
                    let b: CGFloat = $0.currentValue < 0 ? CGFloat(1.0 - correctionValue) : CGFloat(1.0 - correctionValue)
                    let a: CGFloat = 1.0
                    newCIImage = self.addCIFilter(image: newCIImage,
                                                  coreImageFilter: "CIColorMatrix",
                                                  filterKeys: ["inputRVector" : CIVector(x:r, y:0, z:0, w:0),
                                                               "inputGVector" : CIVector(x:0, y:g, z:0, w:0),
                                                               "inputBVector" : CIVector(x:0, y:0, z:b, w:0),
                                                               "inputAVector" : CIVector(x:0, y:0, z:0, w:a),] )
                default:
                    break
                }
                
            }
        }
        return newCIImage
    }

    fileprivate func addCIFilter (image: CIImage?, coreImageFilter : String,  filterKeys: [String : Any] /*, value : Float*/) -> CIImage? {
        guard let image = image else { return nil }
        guard let filter = CIFilter(name: coreImageFilter) else { return image}
            filter.setValue(image, forKey: kCIInputImageKey)
            filterKeys.forEach {
                filter.setValue($0.value, forKey: $0.key)
            }
        return filter.value(forKey: kCIOutputImageKey) as? CIImage
    }
    
    fileprivate func configureCIContext () {
        if self.ciContext != nil {
            return
        }
        guard let image = self.modifiedImage else { return }
        guard let cgimg = image.cgImage else { return }
        
        self.coreImage = CIImage(cgImage: cgimg)
        let openGLContext = EAGLContext(api: .openGLES2)
        self.ciContext = CIContext.init(eaglContext: openGLContext!, options: [kCIContextPriorityRequestLow: true])
    }
    
    fileprivate func cleanService () {
        self.removeAllFilters()
        self.ciContext = nil
        self.coreImage = nil
        self.defaultImage = nil
        self.modifiedImage = nil
    }
    
}

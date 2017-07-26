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
    
    open class func  create() -> AGMainImageEditingService
    {
        let service = AGMainImageEditingService()
        return service
    }
    
    func setImage (image : UIImage) {
        self.modifiedImage = image
        self.defaultImage = image
    }
    
    lazy var settingsMenuItems : [AGSettingMenuItemModel] = {
        return [AGSettingMenuItemModel.imageAdjustmentMenuItem(),
                AGSettingMenuItemModel.imageFilterMaskAdjustmentMenuItem(),
//                AGSettingMenuItemModel.textAdjustmentMenuItem(),
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

    
    func applyFilterFor (adjustmentItem : AGAdjustmentMenuItem) -> UIImage?
    {
        guard let image = self.modifiedImage else {
            return nil
        }
        if (tempAdjustmentImage == nil) { self.tempAdjustmentImage = image }
        
        switch adjustmentItem.type {
        case .saturationType:
            self.addSaturationFilter(adjustmentItem: adjustmentItem, image: image)
        case .brightnessType:
            self.addBrightnessFilter(adjustmentItem: adjustmentItem, image: image)
        case .contrastType:
            self.addContrastFilter(adjustmentItem: adjustmentItem, image: image)
        case .adjustType:
            return self.modifiedImage
        case .structureType:
            self.addDetailsFilter(adjustmentItem: adjustmentItem, image: image)
        case .tiltShiftType:
            self.addBlurFilter(adjustmentItem: adjustmentItem, image: image)
        case .sharpenType:
            self.addSharpenFilter(adjustmentItem: adjustmentItem, image: image)
        case .warmthType:
            self.addSoftLightFilter(adjustmentItem: adjustmentItem, image: image)
        default:
            self.removeAllFilters()
            return self.defaultImage
        }
        
        return self.tempAdjustmentImage
    }
    
    func applyFilterImage (adjustmentItem : AGAdjustmentMenuItem) {
        adjustmentItem.lastValue = adjustmentItem.currentValue
    }
    
    func removeAllFilters ()
    {
        self.modifiedImage = self.defaultImage
        self.tempAdjustmentImage = nil
        for adjustmentItem in self.adjustmentItems
        {
            adjustmentItem.reset()
        }
    }
    
    
    func addBrightnessFilter (adjustmentItem : AGAdjustmentMenuItem, image : UIImage)
    {
        let value = (adjustmentItem.currentValue / 100.0) / 4
        if AGImageChain.isMetalAvailable()
        {
            self.applyMetalFilter()
            return
        }
        self.tempAdjustmentImage = self.colorControlFilter(image: image,
                                                           coreImageFilter: "CIColorControls",
                                                           filterKey: kCIInputBrightnessKey,
                                                           value: value)
    }
    
    func addContrastFilter (adjustmentItem : AGAdjustmentMenuItem, image : UIImage)
    {
        let value = (adjustmentItem.currentValue / 100.0) / 4 + 1
        if AGImageChain.isMetalAvailable()
        {
            self.applyMetalFilter()
            return
        }
        self.tempAdjustmentImage = self.colorControlFilter(image: image,
                                                           coreImageFilter: "CIColorControls",
                                                           filterKey: kCIInputContrastKey,
                                                           value: value)
    }

    func addSaturationFilter (adjustmentItem : AGAdjustmentMenuItem, image : UIImage)
    {
        let value = (adjustmentItem.currentValue / 100.0) + 1
            
        if AGImageChain.isMetalAvailable()
        {
            self.applyMetalFilter()
            return
        }
        self.tempAdjustmentImage = self.colorControlFilter(image: image,
                                                           coreImageFilter: "CIColorControls",
                                                           filterKey: kCIInputSaturationKey,
                                                           value: value)
    }
    
    func addDetailsFilter (adjustmentItem : AGAdjustmentMenuItem, image : UIImage)
    {
        if AGImageChain.isMetalAvailable()
        {
            self.applyMetalFilter()
            return
        }
        self.tempAdjustmentImage = self.addFilterTo(image: image,
                                                    coreImageFilter: "CIBoxBlur",
                                                    filterKey: kCIInputRadiusKey,
                                                    value: adjustmentItem.currentValue)
    }
    
    func addBlurFilter (adjustmentItem : AGAdjustmentMenuItem, image : UIImage)
    {
        if AGImageChain.isMetalAvailable()
        {
            self.applyMetalFilter()
            return
        }
        self.tempAdjustmentImage = self.addFilterTo(image: image,
                                                    coreImageFilter: "CIBoxBlur",
                                                    filterKey: kCIInputRadiusKey,
                                                    value: adjustmentItem.currentValue)
    }

    func addSharpenFilter (adjustmentItem : AGAdjustmentMenuItem, image : UIImage)
    {
        if AGImageChain.isMetalAvailable()
        {
            self.applyMetalFilter()
            return
        }
        self.tempAdjustmentImage = self.addFilterTo(image: image,
                                                    coreImageFilter: "CIUnsharpMask",
                                                    filterKey: kCIInputRadiusKey,
                                                    value: adjustmentItem.currentValue)
    }

    func addSoftLightFilter (adjustmentItem : AGAdjustmentMenuItem, image : UIImage)
    {
        if AGImageChain.isMetalAvailable()
        {
            self.applyMetalFilter()
            return
        }
        self.tempAdjustmentImage = self.addFilterTo(image: image,
                                                    coreImageFilter: "CIUnsharpMask",
                                                    filterKey: kCIInputRadiusKey,
                                                    value: adjustmentItem.currentValue)
    }
    
    @discardableResult
    func applyMetalFilter () -> UIImage?
    {
        guard let image = self.modifiedImage else {
            return nil
        }
        return self.applyMetalFilterFor(image: image)
    }
    
    fileprivate func applyMetalFilterFor (image : UIImage) -> UIImage
    {
        let processMetal = AGImageChain.init(image: image)
        
        if self.adjustmentItems[1].currentValue != self.adjustmentItems[1].defaultValue
        {
            _ = processMetal.saturation(color: self.adjustmentItems[1].currentValue / 100 + 1.0)
        }
        
        if self.adjustmentItems[2].currentValue != self.adjustmentItems[2].defaultValue
        {
            _ = processMetal.brightness((self.adjustmentItems[2].currentValue / 100) / 4)
        }
        
        if self.adjustmentItems[3].currentValue != self.adjustmentItems[3].defaultValue
        {
            _ = processMetal.contrast((self.adjustmentItems[3].currentValue / 100.0) / 4 + 1.0)
        }
        
        if self.adjustmentItems[4].currentValue != self.adjustmentItems[4].defaultValue
        {
            _ = processMetal.details(self.adjustmentItems[4].currentValue / 60)
        }
        
        if self.adjustmentItems[5].currentValue != self.adjustmentItems[5].defaultValue
        {
            _ = processMetal.blur(self.adjustmentItems[5].currentValue / 2)
        }
        
        if self.adjustmentItems[6].currentValue != self.adjustmentItems[6].defaultValue
        {
            _ = processMetal.sharpen(self.adjustmentItems[6].currentValue / 60)
        }
    
        if self.adjustmentItems[7].currentValue != self.adjustmentItems[7].defaultValue
        {
            _ = processMetal.softLightFilter(Int(self.adjustmentItems[7].currentValue / 3))
        }
        
        guard let adjustmentImage = processMetal.image() else
        {
            return image
        }
        self.tempAdjustmentImage = adjustmentImage
        return self.tempAdjustmentImage!
    }
    
    
            
    func colorControlFilter (image: UIImage, coreImageFilter : String,  filterKey: String, value : Float) -> UIImage {
        
        if (self.colorControlFilter == nil)
        {
            guard let filter = CIFilter(name: coreImageFilter) else { return image}
            self.colorControlFilter = filter
            let sourceImage = CIImage(image: image)
            self.colorControlFilter!.setValue(sourceImage, forKey: kCIInputImageKey)
        }
        let openGLContext = EAGLContext(api: .openGLES2)
        let context = CIContext.init(eaglContext: openGLContext!, options: [kCIContextPriorityRequestLow: true])
        self.colorControlFilter!.setValue(value, forKey: filterKey)
        
        if let output = self.colorControlFilter!.outputImage {
            let cgimgresult = context.createCGImage(output, from: output.extent)
            let result = UIImage.init(cgImage: cgimgresult!)
            return result
        }
        return image
    }
    
    func addFilterTo (image: UIImage, coreImageFilter : String,  filterKey: String, value : Float) -> UIImage {
        
        guard let filter = CIFilter(name: coreImageFilter) else { return image}
        let sourceImage = CIImage(image: image)
        filter.setValue(sourceImage, forKey: kCIInputImageKey)
        let openGLContext = EAGLContext(api: .openGLES2)
        let context = CIContext.init(eaglContext: openGLContext!, options: [kCIContextPriorityRequestLow: true])
        filter.setValue(value, forKey: filterKey)
        
        if let output = filter.outputImage {
            let cgimgresult = context.createCGImage(output, from: output.extent)
            let result = UIImage.init(cgImage: cgimgresult!)
            return result
        }
        return image
    }
    
    func applyGradientFilterFor (modifiedImage : UIImage, gradientImage : UIImage) -> UIImage?
    {
        return UIImage.combineImages(images: [modifiedImage, gradientImage])
    }
    
    func addGradientFilterImage (gradientFilterItem : AGGradientFilterItemModel)
    {
        guard let modImage = self.modifiedImage else { return }
        if (self.selectedGradientFilterItem != gradientFilterItem)
        {
            self.selectedGradientFilterItem?.lastValue = self.selectedGradientFilterItem?.defaultValue ?? 0
        }
        
        gradientFilterItem.lastValue = gradientFilterItem.currentValue
        self.selectedGradientFilterItem = gradientFilterItem
        
        if (self.gradientImage == nil)
        {
            self.gradientImage = UIImage.resizeImage(image: AGAssetsService.getImage(gradientFilterItem.imageName),
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
    
    func posterImage (editorImage : UIImage?) -> UIImage
    {
        guard let mainImage = self.applyMetalFilter() else {
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
        return UIImage.combineImages(images: [mainImage, finalGradientImage, finalMaskImage])
    }
}

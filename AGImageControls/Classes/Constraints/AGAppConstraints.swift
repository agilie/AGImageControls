//
//  AGAppConstraints.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 25.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addAndPin(view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        addConstraints([left, right, top, bottom])
    }
}

extension AGCameraBottomView {
    
    func setupConstraints() {
        
        for attribute: NSLayoutAttribute in [.centerX] {
            addConstraint(NSLayoutConstraint(item: snapButton, attribute: attribute, relatedBy: .equal,
                                             toItem: self, attribute: attribute, multiplier: 1,
                                             constant: 0))
        }
        
        for attribute: NSLayoutAttribute in [.centerY] {
            addConstraint(NSLayoutConstraint(item: snapButton, attribute: attribute, relatedBy: .equal,
                                             toItem: self, attribute: attribute, multiplier: 1,
                                             constant: -((photoGalleryView.frame.height - photoGalleryView.imageView.frame.width) / 3)))
        }
        
        for attribute: NSLayoutAttribute in [.width, .height] {
            addConstraint(NSLayoutConstraint(item: snapButton, attribute: attribute, relatedBy: .equal,
                                             toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                             constant: snapButton.frame.size.width))
            
            addConstraint(NSLayoutConstraint(item: photoGalleryView, attribute: attribute, relatedBy: .equal,
                                             toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                             constant: photoGalleryView.frame.width))
            
            addConstraint(NSLayoutConstraint(item: rotateCameraButton, attribute: attribute, relatedBy: .equal,
                                             toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                             constant: rotateCameraButton.frame.width))
        }
        
        addConstraint(NSLayoutConstraint(item: rotateCameraButton, attribute: .centerY, relatedBy: .equal,
                                         toItem: self, attribute: .centerY, multiplier: 1,
                                         constant: 16))
        
        addConstraint(NSLayoutConstraint(item: photoGalleryView, attribute: .centerY, relatedBy: .equal,
                                         toItem: self, attribute: .centerY, multiplier: 1, constant: 16))
        
        addConstraint(NSLayoutConstraint(item: rotateCameraButton, attribute: .centerX,
                                         relatedBy: .equal, toItem: self, attribute: .right,
                                         multiplier: 1, constant: -(UIScreen.main.bounds.width - (snapButton.frame.size.width + UIScreen.main.bounds.width)/2)/2))
        
        addConstraint(NSLayoutConstraint(item: photoGalleryView, attribute: .centerX,
                                         relatedBy: .equal, toItem: self, attribute: .left,
                                         multiplier: 1, constant: UIScreen.main.bounds.width/4 - snapButton.frame.size.width/3))
    }
}

extension AGCameraTopView {
    
    func setupConstraints() {
        let buttons = [flashButton, flashOffButton, flashOnButton, flashAutoButton]
        
        for button in buttons
        {
            guard let index : Int = buttons.index(of: button) else { return }
            
            addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal,
                                             toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                             constant: ViewSizes.width))
            
            addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal,
                                             toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                             constant: ViewSizes.height))
            
            addConstraint(NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal,
                                             toItem: self, attribute: .right, multiplier: 1,
                                             constant: -(ViewSizes.rightOffset * CGFloat(index + 1) + ViewSizes.width * CGFloat((index)))))
        }
        addConstraint(NSLayoutConstraint(item: flashButton, attribute: .centerY,
                                         relatedBy: .equal, toItem: self, attribute: .centerY,
                                         multiplier: 1, constant: 0))
    }
}

extension AGCameraSnapViewController {
    
    func setupConstraints() {
        let attributes: [NSLayoutAttribute] = [.bottom, .right, .width]
        let topViewAttributes: [NSLayoutAttribute] = [.left, .top, .width]
        
        for attribute in attributes {
            view.addConstraint(NSLayoutConstraint(item: bottomContainer, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
        }
        
        for attribute: NSLayoutAttribute in [.left, .top, .width] {
            view.addConstraint(NSLayoutConstraint(item: cameraController.view, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
        }
        
        for attribute in topViewAttributes {
            view.addConstraint(NSLayoutConstraint(item: topView, attribute: attribute,
                                                  relatedBy: .equal, toItem: self.view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
        }
        
        view.addConstraint(NSLayoutConstraint(item: bottomContainer, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: AGCameraBottomView.ViewSizes.height))
        
        view.addConstraint(NSLayoutConstraint(item: topView, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: AGCameraTopView.ViewSizes.height))
        
        view.addConstraint(NSLayoutConstraint(item: cameraController.view, attribute: .height,
                                              relatedBy: .equal, toItem: view, attribute: .height,
                                              multiplier: 1, constant: 0))
    }
}

extension AGPhotoGalleryViewController {
    func setupConstraints() {
        for attribute: NSLayoutAttribute in [.left, .top, .right] {
            view.addConstraint(NSLayoutConstraint(item: navigationView, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
        }
        
        view.addConstraint(NSLayoutConstraint(item: navigationView, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: AGNavigationView.ViewSizes.viewHeight))
        
        for attribute: NSLayoutAttribute in [.left, .right, .bottom, .top] {
            view.addConstraint(NSLayoutConstraint(item: photoGalleryCollectionView, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
        }
    }
    
}

extension AGPhotoResizeViewController {
    
    func setupConstraints() {
        for attribute: NSLayoutAttribute in [.left, .top, .right] {
            view.addConstraint(NSLayoutConstraint(item: navigationView, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
        }
        
        view.addConstraint(NSLayoutConstraint(item: navigationView, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: AGNavigationView.ViewSizes.viewHeight))
        
        for attribute: NSLayoutAttribute in [.left, .right, .bottom, .top] {
            view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
        }
        
        for attribute: NSLayoutAttribute in [.centerX, .centerY] {
            view.addConstraint(NSLayoutConstraint(item: activityView, attribute: attribute, relatedBy: .equal,
                                                  toItem: self.view, attribute: attribute, multiplier: 1,
                                                  constant: 0))
        }
    }
    
}

extension AGPhotoGalleryCollectionViewCell {
    func setupConstraints() {
        contentView.addAndPin(view: imageView)
    }
}

extension AGNavigationView
{
    func setupConstraints()
    {
        for button in [backButton, doneButton]
        {
            addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal,
                                             toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                             constant: ViewSizes.buttonWidth))
        }
        
        
        addConstraint(NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal,
                                         toItem: self, attribute: .left, multiplier: 1,
                                         constant: ViewSizes.leftOffset))
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal,
                                         toItem: doneButton, attribute: .right, multiplier: 1,
                                         constant: ViewSizes.rightOffset))
        
        for attribute: NSLayoutAttribute in [.top, .bottom]
        {
            for button in [backButton, doneButton]
            {
                addConstraint(NSLayoutConstraint(item: button, attribute: attribute, relatedBy: .equal,
                                                 toItem: self, attribute: attribute, multiplier: 1,
                                                 constant: 0))
            }
        }
    }
}


extension AGImageEditingViewController
{
    func setupConstraints()
    {
        for attribute: NSLayoutAttribute in [.left, .right] {
            view.addConstraint(NSLayoutConstraint(item: navigationView, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
        }
        
        navigationViewTopConstraint = NSLayoutConstraint(item: navigationView, attribute: .top,
                                                         relatedBy: .equal, toItem: view, attribute: .top,
                                                         multiplier: 1, constant: 0)
        view.addConstraint(navigationViewTopConstraint!)
        
        for attribute: NSLayoutAttribute in [.left, .bottom, .right] {
            view.addConstraint(NSLayoutConstraint(item: gradientView, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
        }
        
        gradientViewHeightConstraint = NSLayoutConstraint(item: gradientView, attribute: .height,
                                                          relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                                          multiplier: 1, constant: 0)
        view.addConstraint(gradientViewHeightConstraint!)
        
        view.addConstraint(NSLayoutConstraint(item: navigationView, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: AGNavigationView.ViewSizes.viewHeight))
        
        
        var constraints = [self.scrollImageViewLeftConstraint, self.scrollImageViewRightConstraint, self.scrollImageViewBottomConstraint, self.scrollImageViewTopConstraint]
        for i in 0..<constraints.count
        {
            view.addConstraint(constraints[i])
        }
        
        settingsMenuCollectionViewTopConstraint = NSLayoutConstraint(item: settingsMenuCollectionView, attribute: .top,
                                                                     relatedBy: .equal, toItem: view, attribute: .bottom,
                                                                     multiplier: 1, constant: 0)
        view.addConstraint(settingsMenuCollectionViewTopConstraint!)
        
        view.addConstraint(NSLayoutConstraint(item: settingsMenuCollectionView, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: AGSettingsMenuCollectionView.ViewSizes.height))
        
        for attribute: NSLayoutAttribute in [.left, .right] {
            view.addConstraint(NSLayoutConstraint(item: settingsMenuCollectionView, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
            
            view.addConstraint(NSLayoutConstraint(item: imageAdjustmentView, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
            
            view.addConstraint(NSLayoutConstraint(item: gradientFilterView, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
            
            view.addConstraint(NSLayoutConstraint(item: imageMasksView, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
            
        }
        
        view.addConstraint(NSLayoutConstraint(item: gradientFilterView, attribute: .bottom,
                                              relatedBy: .equal, toItem: settingsMenuCollectionView, attribute: .top,
                                              multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: gradientFilterView, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: AGGradientFilterView.ViewSizes.height))
        
        view.addConstraint(NSLayoutConstraint(item: imageAdjustmentView, attribute: .bottom,
                                              relatedBy: .equal, toItem: settingsMenuCollectionView, attribute: .top,
                                              multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: imageAdjustmentView, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: AGImageAdjustmentView.ViewSizes.height))
        
        
        view.addConstraint(NSLayoutConstraint(item: imageMasksView, attribute: .bottom,
                                              relatedBy: .equal, toItem: settingsMenuCollectionView, attribute: .top,
                                              multiplier: 1, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: imageMasksView, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: AGImageMasksView.ViewSizes.height))
    }
}

extension AGSettingsMenuCollectionViewCell
{
    func setupConstraints()
    {
        for attribute: NSLayoutAttribute in [.centerX, .centerY] {
            contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: attribute, relatedBy: .equal,
                                                         toItem: self.contentView, attribute: attribute, multiplier: 1,
                                                         constant: 0))
        }
        
        underlineViewRightConstraint = NSLayoutConstraint(item: contentView, attribute: .right,
                                                          relatedBy: .equal, toItem: underlineView, attribute: .right,
                                                          multiplier: 1, constant: underlineViewDefaultOffset)
        
        underlineViewLeftConstraint = NSLayoutConstraint(item: underlineView, attribute: .left,
                                                         relatedBy: .equal, toItem: contentView, attribute: .left,
                                                         multiplier: 1, constant: underlineViewDefaultOffset)
        
        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .bottom,
                                                     relatedBy: .equal, toItem: underlineView , attribute: .bottom,
                                                     multiplier: 1, constant: ViewSizes.underlineBottomOffset))
        
        contentView.addConstraint(NSLayoutConstraint(item: underlineView, attribute: .height,
                                                     relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                                     multiplier: 1, constant: ViewSizes.underlineViewHeight))
        
        contentView.addConstraints([underlineViewRightConstraint!, underlineViewLeftConstraint!])
        
        for attribute: NSLayoutAttribute in [.width, .height] {
            addConstraint(NSLayoutConstraint(item: imageView, attribute: attribute, relatedBy: .equal,
                                             toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                             constant: ViewSizes.imageViewSize.width))
        }
    }
}


extension AGImageAdjustmentCollectionViewCell
{
    func setupConstraints()
    {
        for attribute: NSLayoutAttribute in [.bottom, .right] {
            contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: attribute,
                                                         relatedBy: .equal, toItem: titleLabel , attribute: attribute,
                                                         multiplier: 1, constant: ViewSizes.labelOffset))
        }
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left,
                                                     relatedBy: .equal, toItem: contentView , attribute: .left,
                                                     multiplier: 1, constant: ViewSizes.labelOffset))
        
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height,
                                                     relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                                     multiplier: 1, constant: ViewSizes.labelHeight))
        
        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .right,
                                                     relatedBy: .equal, toItem: imageView, attribute: .right,
                                                     multiplier: 1, constant: ViewSizes.imageLeftOffset))
        
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .left,
                                                     relatedBy: .equal, toItem: contentView, attribute: .left,
                                                     multiplier: 1, constant: ViewSizes.imageLeftOffset))
        
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .top,
                                                     relatedBy: .equal, toItem: contentView, attribute: .top,
                                                     multiplier: 1, constant: ViewSizes.imageTopOffset))
        
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height,
                                                     relatedBy: .equal, toItem: imageView, attribute: .width,
                                                     multiplier: 1, constant: 0))
    }
}


extension AGGradientFilterCollectionViewCell
{
    func setupConstraints()
    {
        contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .right,
                                                     relatedBy: .equal, toItem: imageView, attribute: .right,
                                                     multiplier: 1, constant: ViewSizes.imageLeftOffset))
        
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .left,
                                                     relatedBy: .equal, toItem: contentView, attribute: .left,
                                                     multiplier: 1, constant: ViewSizes.imageLeftOffset))
        
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .top,
                                                     relatedBy: .equal, toItem: contentView, attribute: .top,
                                                     multiplier: 1, constant: ViewSizes.imageTopOffset))
        
        contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height,
                                                     relatedBy: .equal, toItem: imageView, attribute: .width,
                                                     multiplier: 1, constant: 0))
    }
}


extension AGImageAdjustmentView
{
    func setupConstraints()
    {
        for attribute: NSLayoutAttribute in [.left, .top, .right, .bottom] {
            addConstraint(NSLayoutConstraint(item: collectionView, attribute: attribute,
                                             relatedBy: .equal, toItem: self, attribute: attribute,
                                             multiplier: 1, constant: 0))
        }
        
        for subview in [slider, cancelButton, okButton] as [UIView]
        {
            addConstraint(NSLayoutConstraint(item: subview, attribute: .centerY,
                                             relatedBy: .equal, toItem: self, attribute: .centerY,
                                             multiplier: 1, constant: -10.0))
        }
        
        addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .left,
                                         relatedBy: .equal, toItem: self, attribute: .left,
                                         multiplier: 1, constant: 8))
        
        for attribute: NSLayoutAttribute in [.height, .width] {
            for subview in [cancelButton, okButton] as [UIView]
            {
                addConstraint(NSLayoutConstraint(item: subview, attribute: attribute,
                                                 relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                                 multiplier: 1, constant: ViewSizes.buttonWidth))
            }
        }
        
        addConstraint(NSLayoutConstraint(item: slider, attribute: .left,
                                         relatedBy: .equal, toItem: cancelButton, attribute: .right,
                                         multiplier: 1, constant: ViewSizes.buttonOffset))
        
        
        addConstraint(NSLayoutConstraint(item: okButton, attribute: .left,
                                         relatedBy: .equal, toItem: slider, attribute: .right,
                                         multiplier: 1, constant: ViewSizes.buttonOffset))
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .right,
                                         relatedBy: .equal, toItem: okButton, attribute: .right,
                                         multiplier: 1, constant: ViewSizes.buttonOffset))
        
        addConstraint(NSLayoutConstraint(item: sliderValueLabel, attribute: .centerX,
                                         relatedBy: .equal, toItem: self, attribute: .centerX,
                                         multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: sliderValueLabel, attribute: .top,
                                         relatedBy: .equal, toItem: slider, attribute: .bottom,
                                         multiplier: 1, constant: 0))
    }
}

extension AGGradientFilterView
{
    func setupConstraints()
    {
        for attribute: NSLayoutAttribute in [.left, .top, .right, .bottom] {
            addConstraint(NSLayoutConstraint(item: collectionView, attribute: attribute,
                                             relatedBy: .equal, toItem: self, attribute: attribute,
                                             multiplier: 1, constant: 0))
        }
        
        for subview in [slider, cancelButton, okButton] as [UIView]
        {
            addConstraint(NSLayoutConstraint(item: subview, attribute: .centerY,
                                             relatedBy: .equal, toItem: self, attribute: .centerY,
                                             multiplier: 1, constant: -10.0))
        }
        
        addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .left,
                                         relatedBy: .equal, toItem: self, attribute: .left,
                                         multiplier: 1, constant: 8))
        
        for attribute: NSLayoutAttribute in [.height, .width] {
            for subview in [cancelButton, okButton] as [UIView]
            {
                addConstraint(NSLayoutConstraint(item: subview, attribute: attribute,
                                                 relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                                 multiplier: 1, constant: ViewSizes.buttonWidth))
            }
        }
        
        addConstraint(NSLayoutConstraint(item: slider, attribute: .left,
                                         relatedBy: .equal, toItem: cancelButton, attribute: .right,
                                         multiplier: 1, constant: ViewSizes.buttonOffset))
        
        
        addConstraint(NSLayoutConstraint(item: okButton, attribute: .left,
                                         relatedBy: .equal, toItem: slider, attribute: .right,
                                         multiplier: 1, constant: ViewSizes.buttonOffset))
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .right,
                                         relatedBy: .equal, toItem: okButton, attribute: .right,
                                         multiplier: 1, constant: ViewSizes.buttonOffset))
        
        addConstraint(NSLayoutConstraint(item: sliderValueLabel, attribute: .centerX,
                                         relatedBy: .equal, toItem: self, attribute: .centerX,
                                         multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: sliderValueLabel, attribute: .top,
                                         relatedBy: .equal, toItem: slider, attribute: .bottom,
                                         multiplier: 1, constant: 0))
    }
}



extension AGScrollImageView
{
    func setupConstraints()
    {
        for attribute: NSLayoutAttribute in [.left, .right, .bottom, .top] {
            addConstraint(NSLayoutConstraint(item: scrollView, attribute: attribute,
                                             relatedBy: .equal, toItem: self, attribute: attribute,
                                             multiplier: 1, constant: 0))
        }
    }
}



extension AGImageEditorViewController
{
    func setupConstraints()
    {
        //Navigation constraints
        for attribute: NSLayoutAttribute in [.left, .right] {
            view.addConstraint(NSLayoutConstraint(item: navigationView, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: editorMainMenu, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: fontEditorMenu, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: colorEditorMenu, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
            
        }
        
        navigationViewTopConstraint = NSLayoutConstraint(item: navigationView, attribute: .top,
                                                         relatedBy: .equal, toItem: view, attribute: .top,
                                                         multiplier: 1, constant: 0)
        view.addConstraint(navigationViewTopConstraint!)
        
        view.addConstraint(NSLayoutConstraint(item: navigationView, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: AGNavigationView.ViewSizes.viewHeight))
        
        imageEditorMainMenuCollectionViewBottomConstraint = NSLayoutConstraint(item: editorMainMenu, attribute: .bottom,
                                                                               relatedBy: .equal, toItem: view, attribute: .bottom,
                                                                               multiplier: 1, constant: 0)
        view.addConstraint(imageEditorMainMenuCollectionViewBottomConstraint!)
        
        view.addConstraint(NSLayoutConstraint(item: editorMainMenu, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: AGImageEditorMainMenuCollectionView.ViewSizes.height))
        
        
        fontEditorCollectionViewBottomConstraint = NSLayoutConstraint(item: fontEditorMenu, attribute: .bottom,
                                                                      relatedBy: .equal, toItem: editorMainMenu, attribute: .top,
                                                                      multiplier: 1, constant: 0)
        view.addConstraint(fontEditorCollectionViewBottomConstraint!)
        
        
        view.addConstraint(NSLayoutConstraint(item: fontEditorMenu, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: AGFontEditorView.ViewSizes.height))
        
        view.addConstraint(NSLayoutConstraint(item: colorEditorMenu, attribute: .bottom,
                                              relatedBy: .equal, toItem: editorMainMenu, attribute: .top,
                                              multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: colorEditorMenu, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: AGColorEditorView.ViewSizes.height))
        
        for attribute: NSLayoutAttribute in [.left, .bottom, .right] {
            view.addConstraint(NSLayoutConstraint(item: gradientView, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
        }
        
        gradientViewHeightConstraint = NSLayoutConstraint(item: gradientView, attribute: .height,
                                                          relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                                          multiplier: 1, constant: 0)
        view.addConstraint(gradientViewHeightConstraint!)
        
        for attribute: NSLayoutAttribute in [.left, .top, .width, .bottom] {
            view.addConstraint(NSLayoutConstraint(item: imageView, attribute: attribute,
                                                  relatedBy: .equal, toItem: view, attribute: attribute,
                                                  multiplier: 1, constant: 0))
        }

        
        view.addConstraint(NSLayoutConstraint(item: view , attribute: .bottom,
                                              relatedBy: .equal, toItem: trashButton, attribute: .bottom,
                                              multiplier: 1, constant: AGImageEditorViewController.ViewSizes.trashButtonBottomOffset + AGImageEditorMainMenuCollectionView.ViewSizes.height))

        
        view.addConstraint(NSLayoutConstraint(item: view , attribute: .right,
                                              relatedBy: .equal, toItem: trashButton, attribute: .right,
                                              multiplier: 1, constant: AGImageEditorViewController.ViewSizes.trashButtonRightOffset))

        trashButtonWidthConstraint = NSLayoutConstraint(item: trashButton, attribute: .width,
                                                          relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                                          multiplier: 1, constant: AGImageEditorViewController.ViewSizes.trashButtonDefaultWidth)

        view.addConstraint(trashButtonWidthConstraint!)
        
        view.addConstraint(NSLayoutConstraint(item: trashButton, attribute: .height,
                                              relatedBy: .equal, toItem: trashButton, attribute: .width,
                                              multiplier: 1, constant: 0))
        
        
        
    }
}

extension AGImageEditorMainMenuCollectionViewCell
{
    func setupConstraints ()
    {
        for attribute: NSLayoutAttribute in [.centerX, .centerY] {
            contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: attribute, relatedBy: .equal,
                                                         toItem: contentView, attribute: attribute, multiplier: 1,
                                                         constant: 0))
        }
        
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height,
                                                     relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                                     multiplier: 1, constant: ViewSizes.labelSize.height))
        
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .width,
                                                     relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                                     multiplier: 1, constant: ViewSizes.labelSize.width))
    }
}

extension AGFontEditorView
{
    func setupConstraints ()
    {
        for attribute: NSLayoutAttribute in [.left, .right, .top] {
            self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: attribute,
                                                  relatedBy: .equal, toItem: self, attribute: attribute,
                                                  multiplier: 1, constant: 0))
            
        }
        for attribute: NSLayoutAttribute in [.left, .right, .bottom] {
            self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: attribute,
                                                  relatedBy: .equal, toItem: self, attribute: attribute,
                                                  multiplier: 1, constant: 0))
            
        }
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: ViewSizes.collectionHeight))
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height,
                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                              multiplier: 1, constant: ViewSizes.titleLabelHeight))
    }
}

extension AGFontEditorCollectionViewCell
{
    func setupConstraints ()
    {
        contentView.addAndPin(view: fontNameLabel)
    }
}


extension AGColorEditorView
{
    func setupConstraints ()
    {
        for attribute: NSLayoutAttribute in [.left, .right, .top] {
            addConstraint(NSLayoutConstraint(item: collectionView, attribute: attribute,
                                             relatedBy: .equal, toItem: self, attribute: attribute,
                                             multiplier: 1, constant: 0))
        }
        addConstraint(NSLayoutConstraint(item: collectionView, attribute: .height,
                                         relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                         multiplier: 1, constant: ViewSizes.collectionViewHeight))
        
        addConstraint(NSLayoutConstraint(item: sliderValueLabel, attribute: .bottom,
                                         relatedBy: .equal, toItem: self, attribute: .bottom,
                                         multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: sliderValueLabel, attribute: .height,
                                         relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                         multiplier: 1, constant: ViewSizes.sliderValueLabelHeight))
        
        addConstraint(NSLayoutConstraint(item: sliderValueLabel, attribute: .centerX, relatedBy: .equal,
                                         toItem: self, attribute: .centerX, multiplier: 1,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: slider, attribute: .left,
                                         relatedBy: .equal, toItem: self, attribute: .left,
                                         multiplier: 1, constant: ViewSizes.sliderRightAndLeftOffset))
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .right,
                                         relatedBy: .equal, toItem: slider, attribute: .right,
                                         multiplier: 1, constant: ViewSizes.sliderRightAndLeftOffset))
        
        addConstraint(NSLayoutConstraint(item: slider, attribute: .bottom,
                                         relatedBy: .equal, toItem: self, attribute: .bottom,
                                         multiplier: 1, constant: 0))
        
        
        addConstraint(NSLayoutConstraint(item: slider, attribute: .height,
                                         relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                         multiplier: 1, constant: ViewSizes.sliderHeight))
    }
}

extension AGColorEditorCollectionViewCell
{
    func setupConstraints ()
    {
        contentView.addAndPin(view: colorView)
    }
}


extension AGImageMasksView
{
    func setupConstraints ()
    {
        for button in [addNewImageButton, detailsTextButton, captionTextButton]
        {
            addConstraint(NSLayoutConstraint(item: button, attribute: .left,
                                             relatedBy: .equal, toItem: self, attribute: .left,
                                             multiplier: 1, constant: ViewSizes.buttonLeftOffset))
        }
        
        for button in [addNewImageButton, undoButton]
        {
            addConstraint(NSLayoutConstraint(item: self, attribute: .bottom,
                                             relatedBy: .equal, toItem: button, attribute: .bottom,
                                             multiplier: 1, constant: ViewSizes.buttonBottomOffset))
        }
        
        addConstraint(NSLayoutConstraint(item: addNewImageButton, attribute: .right,
                                         relatedBy: .equal, toItem: undoButton, attribute: .left,
                                         multiplier: 1, constant: -ViewSizes.buttonRightOffset))
        
        for attribute : NSLayoutAttribute in [.height, .width]
        {
            addConstraint(NSLayoutConstraint(item: addNewImageButton, attribute: attribute,
                                             relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                             multiplier: 1, constant: ViewSizes.buttonSize.width))
            addConstraint(NSLayoutConstraint(item: undoButton, attribute: attribute,
                                             relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                             multiplier: 1, constant: ViewSizes.buttonSize.width))
            
            addConstraint(NSLayoutConstraint(item: detailsTextButton, attribute: attribute,
                                             relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                             multiplier: 1, constant: ViewSizes.textButtonSize.width))
            
            addConstraint(NSLayoutConstraint(item: captionTextButton, attribute: attribute,
                                             relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                             multiplier: 1, constant: ViewSizes.textButtonSize.width))
        }
        
        addConstraint(NSLayoutConstraint(item: addNewImageButton, attribute: .top,
                                         relatedBy: .equal, toItem: detailsTextButton, attribute: .bottom,
                                         multiplier: 1, constant: ViewSizes.buttonTopOffset))
        
        addConstraint(NSLayoutConstraint(item: detailsTextButton, attribute: .top,
                                         relatedBy: .equal, toItem: captionTextButton, attribute: .bottom,
                                         multiplier: 1, constant: ViewSizes.textButtonTopOffset))
        
        addConstraint(NSLayoutConstraint(item: detailsTitleLabel, attribute: .centerY, relatedBy: .equal,
                                         toItem: detailsTextButton, attribute: .centerY, multiplier: 1,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: detailsTitleLabel, attribute: .left,
                                         relatedBy: .equal, toItem: detailsTextButton, attribute: .right,
                                         multiplier: 1, constant: ViewSizes.titleLabelOffset))
        
        addConstraint(NSLayoutConstraint(item: captionTitleLabel, attribute: .centerY, relatedBy: .equal,
                                         toItem: captionTextButton, attribute: .centerY, multiplier: 1,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: captionTitleLabel, attribute: .left,
                                         relatedBy: .equal, toItem: captionTextButton, attribute: .right,
                                         multiplier: 1, constant: ViewSizes.titleLabelOffset))
        
        for attribute: NSLayoutAttribute in [.left, .right] {
            addConstraint(NSLayoutConstraint(item: shapesMenuCollectionView, attribute: attribute,
                                             relatedBy: .equal, toItem: self, attribute: attribute,
                                             multiplier: 1, constant: 0))
        }
        
        addConstraint(NSLayoutConstraint(item: shapesMenuCollectionView, attribute: .height,
                                         relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                         multiplier: 1, constant: ViewSizes.shapesMenuCollectionViewHeight))
        
        
        addConstraint(NSLayoutConstraint(item: addNewImageButton, attribute: .top,
                                         relatedBy: .equal, toItem: shapesMenuCollectionView, attribute: .bottom,
                                         multiplier: 1, constant: ViewSizes.buttonTopOffset))
    }
}

extension AGShapesMenuCollectionViewCell
{
    func setupConstraints ()
    {        
        contentView.addConstraint(NSLayoutConstraint(item: shapeImageView, attribute: .centerX, relatedBy: .equal,
                                                     toItem: contentView, attribute: .centerX, multiplier: 1,
                                                     constant: 0))
        
        contentView.addConstraint(NSLayoutConstraint(item: shapeImageView, attribute: .centerY, relatedBy: .equal,
                                                     toItem: contentView, attribute: .centerY, multiplier: 1,
                                                     constant: 10))
        
        contentView.addConstraint(NSLayoutConstraint(item: shapeImageView, attribute: .height,
                                                     relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                                     multiplier: 1, constant: ViewSizes.shapeImageViewSize.height))
        
        contentView.addConstraint(NSLayoutConstraint(item: shapeImageView, attribute: .width,
                                                     relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                                     multiplier: 1, constant: ViewSizes.shapeImageViewSize.width))
    }
}

extension AGTextEditorView {
    func setupConstraints () {
        for attribute: NSLayoutAttribute in [.left, .top, .right] {
                addConstraint(NSLayoutConstraint(item: navigationView, attribute: attribute,
                                                  relatedBy: .equal, toItem: self, attribute: attribute,
                                                  multiplier: 1, constant: 0))
        }
        
        addConstraint(NSLayoutConstraint(item: navigationView, attribute: .height,
                                         relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                         multiplier: 1, constant: AGNavigationView.ViewSizes.viewHeight))
        
        addConstraint(NSLayoutConstraint(item: navigationView, attribute: .bottom,
                                         relatedBy: .equal, toItem: textView, attribute: .top,
                                         multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: textView, attribute: .left,
                                         relatedBy: .equal, toItem: self, attribute: .left,
                                         multiplier: 1, constant: ViewSizes.textViewRightLeftOffset))

        addConstraint(NSLayoutConstraint(item: self, attribute: .right,
                                         relatedBy: .equal, toItem: textView, attribute: .right,
                                         multiplier: 1, constant: ViewSizes.textViewRightLeftOffset))
        
        addConstraint(NSLayoutConstraint(item: textView, attribute: .bottom,
                                         relatedBy: .equal, toItem: self, attribute: .bottom,
                                         multiplier: 1, constant: 0))
    }
}


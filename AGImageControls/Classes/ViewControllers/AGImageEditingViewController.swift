//
//  AGImageEditingViewController.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 26.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit
import MetalKit

protocol AGImageEditingViewControllerDelegate : class {
    func posterImage (imageEditingViewController : AGImageEditingViewController, image : UIImage)
}

class AGImageEditingViewController: AGMainViewController {

    weak var delegate : AGImageEditingViewControllerDelegate?
    
    var settingsMenuCollectionViewTopConstraint : NSLayoutConstraint? = nil
    
    var settingsMenuCollectionViewBottomConstraint : NSLayoutConstraint? = nil
    
    lazy var scrollImageViewTopConstraint : NSLayoutConstraint = { [unowned self] in
        return NSLayoutConstraint(item: self.scrollImageView, attribute: .top,
                                  relatedBy: .equal, toItem: self.view, attribute: .top,
                                  multiplier: 1, constant: 0)
    }()
    
    lazy var scrollImageViewBottomConstraint : NSLayoutConstraint = { [unowned self] in
        return NSLayoutConstraint(item: self.scrollImageView, attribute: .bottom,
                                  relatedBy: .equal, toItem: self.view, attribute: .bottom,
                                  multiplier: 1, constant: 0)
        }()

    lazy var scrollImageViewLeftConstraint : NSLayoutConstraint = { [unowned self] in
        return NSLayoutConstraint(item: self.scrollImageView, attribute: .left,
                                  relatedBy: .equal, toItem: self.view, attribute: .left,
                                  multiplier: 1, constant: 0)
        }()

    lazy var scrollImageViewRightConstraint : NSLayoutConstraint = { [unowned self] in
        return NSLayoutConstraint(item: self.scrollImageView, attribute: .right,
                                  relatedBy: .equal, toItem: self.view, attribute: .right,
                                  multiplier: 1, constant: 0)
        }()

        
    var imageEditorViewController : AGImageEditorViewController? = nil
    
    var selectedSettingItem : AGSettingMenuItemModel? = nil

    open class func createWithImage (image : UIImage) -> AGImageEditingViewController
    {
        let controller = AGImageEditingViewController()
            controller.editingService.setImage (image: image)
        return controller
    }
    
    lazy var editingService : AGMainImageEditingService = { [unowned self] in
        return AGMainImageEditingService.create()
    } ()
    
    lazy var scrollImageView: AGScrollImageView = { [unowned self] in
        let scrollImageView = AGScrollImageView()
            scrollImageView.dataSource = self
        return scrollImageView
    }()
    
    lazy var settingsMenuCollectionView : AGSettingsMenuCollectionView = { [unowned self] in
        let settingsMenuCollectionView = AGSettingsMenuCollectionView(frame: self.view.bounds, collectionViewLayout: nil)
            settingsMenuCollectionView.settingsMenuDataSource = self
            settingsMenuCollectionView.settingsMenuDelegate = self
        return settingsMenuCollectionView
    }()
    
    lazy var imageAdjustmentView : AGImageAdjustmentView = { [unowned self] in
        let imageAdjustmentView = AGImageAdjustmentView()
            imageAdjustmentView.delegate = self
            imageAdjustmentView.dataSource = self
            imageAdjustmentView.isHidden = true
            imageAdjustmentView.backgroundColor = .clear
            imageAdjustmentView.alpha = 0.0
        return imageAdjustmentView
    }()
    
    lazy var gradientFilterView : AGGradientFilterView = { [unowned self] in
        let gradientFilterView = AGGradientFilterView()
            gradientFilterView.delegate = self
            gradientFilterView.dataSource = self
            gradientFilterView.isHidden = true
            gradientFilterView.backgroundColor = .clear
            gradientFilterView.alpha = 0.0
        return gradientFilterView
    }()
    
    
    lazy var imageMasksView : AGImageMasksView = { [unowned self] in
        let imageMasksView = AGImageMasksView.init(frame: CGRect(x: 0, y: 0, width : UIScreen.main.bounds.size.width, height: 0))
            imageMasksView.dataSource = self
            imageMasksView.delegate = self
            imageMasksView.backgroundColor = .clear
            imageMasksView.isHidden = true
            imageMasksView.alpha = 0.0
        return imageMasksView
        }()
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureImageEditingViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.settingsMenuCollectionView.show(viewController: self)
        self.gradientView.updateHeight(viewController: self, height: AGSettingsMenuCollectionView.ViewSizes.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func navigationViewDoneButtonDidTouch(view: AGNavigationView) {
        self.activityViewAnimated(isAnimated: true)
        self.dismiss(animated: false) { [weak self] in
            guard let `self` = self else { return }
            let posterImage = self.editingService.posterImage(editorImage: self.imageEditorViewController?.imageView.obtainItsVisibleImage())
            AGPhotoGalleryService.sharedInstance.saveImageToCameraRoll(image: posterImage)
            self.delegate?.posterImage(imageEditingViewController: self, image: posterImage)
            self.activityViewAnimated(isAnimated: false)
        }
    }
}

extension AGImageEditingViewController
{
    fileprivate func configureImageEditingViewController() {
        self.view.backgroundColor = self.configurator.mainColor
        
        [self.scrollImageView, self.navigationView,  self.gradientView, self.settingsMenuCollectionView, self.imageAdjustmentView, self.gradientFilterView, self.imageMasksView, self.activityView].forEach {
            ($0 as! UIView).translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0 as! UIView)
        }
        self.setupConstraints()
    }
    
    fileprivate func showSettingsMenuForItem (item : AGSettingMenuItemModel) {
        self.closePreviousMenu(item: self.selectedSettingItem, newItem : item)

        if (self.selectedSettingItem?.type != item.type) {
            //Show Menu Item
            self.selectedSettingItem = item
            self.openNewMenu(item: item)
            return
        }
        //Close Menu Item
        self.gradientView.updateHeight(viewController: self, height: AGSettingsMenuCollectionView.ViewSizes.height)
        self.selectedSettingItem = nil
    }
    
    fileprivate func closePreviousMenu (item : AGSettingMenuItemModel?, newItem : AGSettingMenuItemModel) {
        guard let currentItem = item else {
            return
        }
        switch currentItem.type {
        case .imageAdjustment:
            self.imageAdjustmentView.show(toShow: false, withAnimation: true)
            return
        case .imageFilterMaskAdjustment:
            self.gradientFilterView.needToShowWithAnimation(isShown: false, animated: true)
            return
        default:
            if (currentItem.type == newItem.type)
            {
                self.imageMasksView.show(type: currentItem.type, toShow: false, animated: true)
                return
            }
            switch newItem.type {
            case .imageAdjustment, .imageFilterMaskAdjustment:
                self.imageMasksView.show(type: currentItem.type, toShow: false, animated: true)
                return
            default:
                return
            }
        }
    }
    
    fileprivate func openNewMenu (item : AGSettingMenuItemModel) {
        switch item.type {
        case .imageAdjustment:
            self.imageAdjustmentView.show(toShow: true, withAnimation: true)
            break
        case .imageFilterMaskAdjustment:
            self.gradientFilterView.needToShowWithAnimation(isShown: true, animated: true)
            break
        default:
            self.imageMasksView.show(type: item.type, toShow: true, animated: true)
            break
        }
        self.gradientView.updateHeight(viewController: self, height: AGSettingsMenuCollectionView.ViewSizes.height + 100)
    }
    
    fileprivate func showImageEditorViewController (type : AGImageEditorTypes?, editableImage : AGEditableImageView?, imageName : String?) {
        self.navigationView.hide(viewController: self)
        self.settingsMenuCollectionView.hide(viewController: self)
        
        self.gradientView.updateHeight(viewController: self, height: 0.0)
        if (self.imageEditorViewController == nil)
        {
            self.imageEditorViewController = AGImageEditorViewController.createWithType(type: type ?? .icons, imageName : imageName)
            self.imageEditorViewController?.delegate = self
            
//            self.view.insertSubview(self.imageEditorViewController!.view, belowSubview: self.navigationView)
            
            self.view.insertSubview(self.imageEditorViewController!.view, aboveSubview: self.scrollImageView)
            return
        }
        self.imageEditorViewController?.view.isUserInteractionEnabled = true
        self.imageEditorViewController?.showWith(type: type, editableImage: editableImage, imageName: imageName)
        self.imageEditorViewController?.editorMainMenu.reloadData()
        return
    }    
}

extension AGImageEditingViewController : AGSettingsMenuCollectionViewDataSource
{
    func numberOfItemsInSection (section : Int) -> Int {
        return self.editingService.settingsMenuItems.count
    }
    
    func menuItemAtIndexPath (indexPath : IndexPath) -> AGSettingMenuItemModel {
        return self.editingService.settingsMenuItems[indexPath.row]
    }
}

extension AGImageEditingViewController : AGSettingsMenuCollectionViewDelegate
{
    func selectedMenuItem (atIndexPath indexPath: IndexPath) {
        self.showSettingsMenuForItem(item: self.editingService.settingsMenuItems[indexPath.row])
    }
}

extension AGImageEditingViewController : AGImageAdjustmentViewDelegate
{
    func updateImageAdjustment (view : AGImageAdjustmentView, adjustmentItem : AGAdjustmentMenuItem, value : Int) {
        switch adjustmentItem.type {
        case .adjustType:
            self.scrollImageView.rotateImage(angle: value)
            return
        default:
            self.scrollImageView.updateImage(image: self.editingService.applyFilterFor(adjustmentItem: adjustmentItem))
        }
    }
    
    func applyFilterButtonDidTouch (view : AGImageAdjustmentView, adjustmentItem : AGAdjustmentMenuItem, value : Int) {
        self.settingsMenuCollectionView.show(viewController: self)
        self.navigationView.show(viewController: self)

        self.editingService.applyFilterImage(adjustmentItem: adjustmentItem)
        self.scrollImageView.updateImage(image: self.editingService.applyFilterFor(adjustmentItem: adjustmentItem))
        self.gradientView.updateHeight(viewController: self, height: AGSettingsMenuCollectionView.ViewSizes.height + 100)
    }
    
    func beginImageRotation(view: AGImageAdjustmentView) {
        self.scrollImageView.rotationDidStart(viewController : self)
    }
    
    func adjustmentMenuItemDidSelect (view : AGImageAdjustmentView) {
        self.settingsMenuCollectionView.hide(viewController: self)
        self.navigationView.hide(viewController: self)
        self.gradientView.updateHeight(viewController: self, height: AGSettingsMenuCollectionView.ViewSizes.height)
        
    }
    
    func cancelFilterButtonDidTouch (view : AGImageAdjustmentView) {
        self.settingsMenuCollectionView.show(viewController: self)
        self.navigationView.show(viewController: self)
        self.gradientView.updateHeight(viewController: self, height: AGSettingsMenuCollectionView.ViewSizes.height + 100)

        self.scrollImageView.updateImage(image: self.editingService.applyMetalFilter())
    }
    
    func cancelAllFiltersButtonDidTouch(view : AGImageAdjustmentView) {
        self.settingsMenuCollectionView.show(viewController: self)
        self.navigationView.show(viewController: self)
        
        self.editingService.removeAllFilters()
        self.scrollImageView.updateImage(image: self.editingService.modifiedImage)
    }
}

extension AGImageEditingViewController : AGImageAdjustmentViewDataSource
{
    func adjustmentMenuItems () -> [AGAdjustmentMenuItem] {
        return self.editingService.adjustmentItems
    }
}

extension AGImageEditingViewController : AGGradientFilterViewDelegate
{
    func updateGradientFilter (view : AGGradientFilterView, gradientFilterItem : AGGradientFilterItemModel, value : Int) {
        self.scrollImageView.updateGradientFilterImage(gradientFilterItem: gradientFilterItem)
    }
    
    func applyGradientFilterButtonDidTouch (view : AGGradientFilterView, gradientFilterItem : AGGradientFilterItemModel, value : Int) {
        self.editingService.addGradientFilterImage(gradientFilterItem: gradientFilterItem)
        self.settingsMenuCollectionView.show(viewController: self)
        self.navigationView.show(viewController: self)
    }
    
    func cancelGradientFilterButtonDidTouch (view : AGGradientFilterView) {
        self.scrollImageView.removeGradientFilterImage()
        self.settingsMenuCollectionView.show(viewController: self)
        self.navigationView.show(viewController: self)

        guard let previousItem = self.editingService.selectedGradientFilterItem else {
            return
        }
        previousItem.currentValue = previousItem.lastValue
        self.scrollImageView.updateGradientFilterImage(gradientFilterItem: previousItem)
    }
    
    func gradientFilterDidChange (view : AGGradientFilterView, newItem : AGGradientFilterItemModel) {
        self.settingsMenuCollectionView.hide(viewController: self)
        self.navigationView.hide(viewController: self)

        self.scrollImageView.removeGradientFilterImage()
        self.scrollImageView.updateGradientFilterImage(gradientFilterItem: newItem)
    }
    
    func cancelAllGradientFiltersButtonDidTouch(view : AGGradientFilterView) {
        self.settingsMenuCollectionView.show(viewController: self)
        self.navigationView.show(viewController: self)
        self.scrollImageView.removeGradientFilterImage()
        self.editingService.removeGradientFilterImage()
        self.scrollImageView.updateImage(image: self.editingService.applyMetalFilter())
    }
}

extension AGImageEditingViewController : AGGradientFilterViewDataSource
{
    func gradientFilterItems () -> [AGGradientFilterItemModel] {
        return self.editingService.gradientFilterItems
    }
}

extension AGImageEditingViewController : AGScrollImageViewDataSource
{
    func image(view: AGScrollImageView) -> UIImage? {
        return self.editingService.modifiedImage
    }
}

extension AGImageEditingViewController : AGImageEditorViewControllerDelegate
{
    func editableImageDidSelect(viewController: AGImageEditorViewController, editableImage: AGEditableImageView) {
        var selectedType : AGSettingMenuItemTypes = .imageAdjustment
        switch editableImage.type {
        case .captionText, .detailsText:
            selectedType = .textAdjustment
        case .icons:
            selectedType = .iconsAdjustment
        default:
            selectedType = .shapesMaskAdjustment
        }
        if (self.selectedSettingItem?.type == selectedType)
        {
            editableImage.isActive = true
            self.imageMasksView.show(type: selectedType, toShow: false, animated: true)
            self.showImageEditorViewController(type: nil, editableImage: editableImage, imageName: nil)
        }
    }

    func imageEditorViewControllerDidClose (viewController : AGImageEditorViewController) {
        self.navigationView.show(viewController: self)
        self.settingsMenuCollectionView.show(viewController: self)
        if (self.selectedSettingItem != nil) {
            self.settingsMenuCollectionView.unselectCell(selectedIndexPath: self.settingsMenuCollectionView.selectedIndexPath)
            self.showSettingsMenuForItem(item: self.selectedSettingItem!)
        }
    }
}

extension AGImageEditingViewController : AGImageMasksViewDataSource
{
    func shapesMenuList () -> [String] {
        return self.editingService.shapesMenuList
    }
    
    func iconsMenuList () -> [String] {
        return self.editingService.iconsMenuList
    }
}

extension AGImageEditingViewController : AGImageMasksViewDelegate
{
    func imageMaskDidSelectAtIndexPath (indexPath : IndexPath?, settingType: AGSettingMenuItemTypes, editorType : AGImageEditorTypes) {
        var imageName : String? = nil
        
        if let index = indexPath {
            switch editorType {
            case .icons:
                imageName = self.editingService.iconsMenuList[index.row]
            default:
                imageName = self.editingService.shapesMenuList[index.row]
            }
        }
        self.showSettingsMenuForItem(item: self.editingService.settingsMenuItems[settingType.rawValue])
        self.showImageEditorViewController(type: editorType, editableImage: nil, imageName: imageName)
        self.selectedSettingItem = self.editingService.settingsMenuItems[settingType.rawValue]
    }
    
    func undoLastChanges (settingsType : AGSettingMenuItemTypes) {
        self.imageEditorViewController?.undoLastChangesForType (type : settingsType)
    }
}




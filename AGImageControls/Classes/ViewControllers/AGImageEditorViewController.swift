//
//  AGImageEditorViewController.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 13.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGImageEditorViewControllerDelegate: class {
    func imageEditorViewControllerDidClose (viewController : AGImageEditorViewController)
    func editableImageDidSelect (viewController : AGImageEditorViewController, editableImage : AGEditableImageView)
}

class AGImageEditorViewController: AGMainViewController {
    
    weak var delegate : AGImageEditorViewControllerDelegate?
    
    var rotationGestureRecognizer  : UIRotationGestureRecognizer?  = nil
    var pinchGestureRecognizer     : UIPinchGestureRecognizer?     = nil
    
    var imageEditorMainMenuCollectionViewBottomConstraint : NSLayoutConstraint? = nil
    var fontEditorCollectionViewBottomConstraint : NSLayoutConstraint? = nil

    var trashButtonWidthConstraint : NSLayoutConstraint? = nil

    
    var selectedEditableImageView : AGEditableImageView? = nil
    
    var isGesturesEnable : Bool = false
    {
        didSet {
            isGesturesEnable ? self.setupGestureReconizers() : self.removeAllGestureRecognizers()
        }
    }
    
    var currentEditorType : AGEditorMainMenuTypes? = nil
    {
        didSet{
            guard let type = currentEditorType else {
                self.updateImageEditorViewController(isSizeActive: false, isFontMenuActive: false, isColorMenuActive: false)
                self.gradientView.updateHeight(viewController: self, height: AGImageEditorMainMenuCollectionView.ViewSizes.height)
                return
            }
            let menuHeight : CGFloat = type == .size ? 0.0 : type == .font ? AGFontEditorView.ViewSizes.height : AGColorEditorView.ViewSizes.height
            self.updateImageEditorViewController(isSizeActive: type == .size, isFontMenuActive: type == .font, isColorMenuActive: type == .color)
            self.gradientView.updateHeight(viewController: self, height: AGImageEditorMainMenuCollectionView.ViewSizes.height + menuHeight)
        }
    }
    
    struct ViewSizes {
        static let trashButtonDefaultWidth : CGFloat = 35.0
        static let trashButtonRightOffset  : CGFloat = 16.0
        static let trashButtonBottomOffset : CGFloat = 16.0
    }
    
    lazy var editorService : AGImageEditorService = { [unowned self] in
        let editorService = AGImageEditorService()
            editorService.delegate = self
        return editorService
    } ()
    
    lazy var imageView : UIImageView = { [unowned self] in
        let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var editorMainMenu : AGImageEditorMainMenuCollectionView = { [unowned self] in        
        let imageEditorMainMenu = AGImageEditorMainMenuCollectionView(frame: self.view.bounds, collectionViewLayout: nil)
        imageEditorMainMenu.imageEditorMainMenuDataSource = self
        imageEditorMainMenu.imageEditorMainMenuDelegate = self
        return imageEditorMainMenu
    }()
    
    lazy var fontEditorMenu : AGFontEditorView = { [unowned self] in
        let fontEditorMenu = AGFontEditorView()
            fontEditorMenu.isHidden = true
            fontEditorMenu.delegate = self
            fontEditorMenu.dataSource = self
        return fontEditorMenu
        }()

    lazy var colorEditorMenu : AGColorEditorView = { [unowned self] in
        let colorEditorMenu = AGColorEditorView()
            colorEditorMenu.isHidden = true
            colorEditorMenu.delegate = self
            colorEditorMenu.dataSource = self
        return colorEditorMenu
        }()
    
    lazy var trashButton : UIButton = { [unowned self] in
        let trashButton = UIButton()
            trashButton.setImage(AGAssetsService.getImage(self.configurator.trashButtonIcon), for: .normal)
        return trashButton
    }()
    
    open class func createWithType (type : AGImageEditorTypes, imageName : String?) -> AGImageEditorViewController {
        let controller = AGImageEditorViewController()
            controller.view.frame = UIScreen.main.bounds
            controller.editorService.currentType = type
            controller.currentEditorType = nil
            controller.createNewEditableImage(imageName: imageName)
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureImageEditorViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showWith (type : AGImageEditorTypes?, editableImage : AGEditableImageView? = nil, imageName : String? = nil) {
        self.trashButton.showWithAnimation(isShown: true, animated: true)
        self.currentEditorType = nil
        self.navigationView.show(viewController: self)
        self.editorMainMenu.show(viewController: self)
        self.editorService.currentType = type ?? editableImage?.type ?? .icons
        
        if (editableImage == nil)
        {
            self.createNewEditableImage(imageName: imageName)
            return
        }
        self.selectedEditableImageView = editableImage
        self.selectedEditableImageView?.updateLastPosition()
    }
    
    func undoLastChangesForType (type : AGSettingMenuItemTypes) {
        self.editorService.undoLastChangesForType(type: type)
    }
}

extension AGImageEditorViewController
{
    fileprivate func updateImageEditorViewController( isSizeActive : Bool, isFontMenuActive : Bool, isColorMenuActive : Bool) {
        self.isGesturesEnable = isSizeActive
        self.fontEditorMenu.show(toShow: isFontMenuActive, animated: true)
        if (isColorMenuActive) { self.editorService.resetEditorColorItems()}
        self.colorEditorMenu.show(toShow: isColorMenuActive, animated: true)
    }
    
    fileprivate func configureImageEditorViewController() {
        self.view.backgroundColor = .clear
        self.navigationView.doneButton.setTitle(self.configurator.okButtonTitle, for: .normal)
        
        for subview : UIView in [self.imageView, self.gradientView, self.editorMainMenu, self.fontEditorMenu, colorEditorMenu, self.navigationView, self.trashButton]
        {
            subview.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(subview)
        }
        self.setupConstraints()
    }
    
    override func navigationViewDoneButtonDidTouch (view : AGNavigationView) {
        self.editorService.addNewImageItem(imageView: self.selectedEditableImageView)
        self.close()
    }

    override func navigationViewBackButtonDidTouch(view: AGNavigationView) {
        self.selectedEditableImageView?.undoImageChanges()
        self.close()
    }
    
    fileprivate func close () {
        self.selectedEditableImageView?.isActive = false
        self.selectedEditableImageView = nil
        
        self.navigationView.hide(viewController: self)
        self.editorMainMenu.hide(viewController: self)
        self.trashButton.showWithAnimation(isShown: false, animated: true)
        
        self.closeAllSubviews()
        self.delegate?.imageEditorViewControllerDidClose(viewController: self)
        self.gradientView.updateHeight(viewController: self, height: 0.0)
    }
    
    fileprivate func closeAllSubviews () {
        self.fontEditorMenu.show(toShow: false, animated: true)
        self.colorEditorMenu.show(toShow: false, animated: true)
        self.editorService.unselectAllImageEditorItems()
        self.editorMainMenu.unselectAllMenuItems()
    }
    
    
    func createNewEditableImage (imageName : String?) {
        switch self.editorService.currentType {
        case .icons, .shapes:
            guard let name = imageName else { return }
            self.selectedEditableImageView = AGEditableImageView.createWithImage(imageName: name, type: self.editorService.currentType, tag: self.editorService.newImageViewTag)
            self.selectedEditableImageView?.delegate = self
            self.imageView.addSubview(self.selectedEditableImageView!)
            return
        default:
            return
        }
    }
    
    //MARK: Gesture recognizers methods
    func setupGestureReconizers () {
        if self.rotationGestureRecognizer == nil {
            self.rotationGestureRecognizer = UIRotationGestureRecognizer.init(target: self, action: #selector(AGImageEditorViewController.rotateEditableImageView(_:)))
            self.rotationGestureRecognizer!.delegate = self
            self.view.addGestureRecognizer(self.rotationGestureRecognizer!)
        }
        
        if self.pinchGestureRecognizer == nil {
            self.pinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action:  #selector(AGImageEditorViewController.zoomEditableImageView(_:)))
            self.pinchGestureRecognizer!.delegate = self
            self.view.addGestureRecognizer(self.pinchGestureRecognizer!)
        }
    }
    
    func removeAllGestureRecognizers () {
        if let currentRotateRotationGestureRecognizer = self.rotationGestureRecognizer {
            self.view.removeGestureRecognizer(currentRotateRotationGestureRecognizer)
            self.rotationGestureRecognizer = nil
        }
        
        if let currentZoomPinchGestureRecognizer = self.pinchGestureRecognizer {
            self.view.removeGestureRecognizer(currentZoomPinchGestureRecognizer)
            self.pinchGestureRecognizer = nil
        }
    }
    
    func rotateEditableImageView (_ rotateRotationGestureRecognizer : UIRotationGestureRecognizer) {
        switch rotateRotationGestureRecognizer.state {
        case .began:
            rotateRotationGestureRecognizer.rotation = self.selectedEditableImageView?.newPosition?.rotateAngle ?? 0
        case .changed:
            self.selectedEditableImageView?.newPosition?.rotateAngle = rotateRotationGestureRecognizer.rotation
        case .ended:
            rotateRotationGestureRecognizer.rotation = 0
        default:
            return
        }
    }
    
    func zoomEditableImageView (_ zoomPinchGestureRecognizer : UIPinchGestureRecognizer) {
        switch zoomPinchGestureRecognizer.state {
        case .began:
            zoomPinchGestureRecognizer.scale = self.selectedEditableImageView?.newPosition?.scale ?? 1
        case .changed:
            self.selectedEditableImageView?.newPosition?.scale = zoomPinchGestureRecognizer.scale
        case .ended:
            self.selectedEditableImageView?.updateImage()
            zoomPinchGestureRecognizer.scale = 1
        default:
            return
        }
    }
    
    func changeTrashButtonSize (isActive : Bool) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.245, animations: {
            self.trashButtonWidthConstraint!.constant = isActive ? ViewSizes.trashButtonDefaultWidth * 2 : ViewSizes.trashButtonDefaultWidth
            self.view.layoutIfNeeded()
        })
    }
}

extension AGImageEditorViewController : AGImageEditorServiceDelegate
{
    func undoLastChanges (imageChangesItem : AGImageChangesItem) {
        if let imageView = self.imageView.subviews.viewWithTag(tag: imageChangesItem.tag) as? AGEditableImageView {
            imageView.lastPosition = imageChangesItem.position
            imageView.lastMaskColor = imageChangesItem.mask
            imageView.undoImageChanges()
        }
    }
}

extension AGImageEditorViewController : UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension AGImageEditorViewController : AGImageEditorMainMenuCollectionViewDataSource
{
    func numberOfItemsInSection (section : Int) -> Int {
        return self.editorService.imageEditorItems.count
    }
    
    func menuItemAtIndexPath (indexPath : IndexPath) -> AGImageEditorMainMenuItem {
        return self.editorService.imageEditorItems[indexPath.row]
    }
}

extension AGImageEditorViewController : AGImageEditorMainMenuCollectionViewDelegate
{
    func selectedItem (atIndexPath indexPath: IndexPath) {
        self.currentEditorType = self.editorService.imageEditorItems[indexPath.row].type == self.currentEditorType ? nil : self.editorService.imageEditorItems[indexPath.row].type
    }
}

extension AGImageEditorViewController : AGFontEditorViewDelegate
{
    func updateFont (view : AGFontEditorView, newFont : AGFontEditorItem) {
//        print(newFont.fullName)
    }
    
    func fontEditorDidClose (view : AGFontEditorView) {
        self.closeAllSubviews()
    }
}

extension AGImageEditorViewController : AGFontEditorViewDataSource
{
    func fontEditorItems () -> [AGFontEditorItem] {
        switch self.editorService.currentType {
        case .captionText:
            return self.editorService.captionFontEditorItems
        default:
            return self.editorService.detailsFontEditorItems
        }
    }
}

extension AGImageEditorViewController : AGColorEditorViewDataSource
{
    func colorEditorMenuItems () -> [AGColorEditorItem] {
        return self.editorService.editorColorItems
    }
}

extension AGImageEditorViewController : AGColorEditorViewDelegate
{
    func updateColor (view : AGColorEditorView, colorEditorItem : AGColorEditorItem) {
        self.selectedEditableImageView?.changeColor(colorItem: colorEditorItem)
    }
    
    func colorEditorDidClose (view : AGColorEditorView) {
        self.closeAllSubviews()
    }
}

extension AGImageEditorViewController : AGEditableImageViewDelegate
{
    func imageDidTouch (imageView : AGEditableImageView) {
        if (self.selectedEditableImageView == nil) {
            self.delegate?.editableImageDidSelect(viewController: self, editableImage: imageView)
        }
    }
    
    func startMoving (imageView : AGEditableImageView) {
        self.changeTrashButtonSize(isActive: true)
    }
    
    func endMoving (imageView : AGEditableImageView, touchLocation : CGPoint) {
        if self.trashButton.frame.contains(touchLocation) {
            self.editorService.removeImageItem(imageView: self.selectedEditableImageView)
            self.selectedEditableImageView?.removeFromSuperview()
            self.close()
        }
        self.changeTrashButtonSize(isActive: false)
    }
}

extension Array where Element: UIView {
    func viewWithTag(tag: Int) -> UIView? {
        return filter { $0.tag == tag }.first
    }
}


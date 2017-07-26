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
    
    var rotateRotationGestureRecognizer : UIRotationGestureRecognizer?  = nil
    var zoomPinchGestureRecognizer      : UIPinchGestureRecognizer?     = nil
    
    var imageEditorMainMenuCollectionViewBottomConstraint : NSLayoutConstraint? = nil
    var fontEditorCollectionViewBottomConstraint : NSLayoutConstraint? = nil

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
    
    lazy var editorService : AGImageEditorService = { [unowned self] in
        let editorService = AGImageEditorService()
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
    
    open class func createWithType (type : AGImageEditorTypes, imageName : String?) -> AGImageEditorViewController {
        let controller = AGImageEditorViewController()
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
    
    fileprivate func configureImageEditorViewController()
    {
        self.view.backgroundColor = .clear
        self.navigationView.doneButton.setTitle(self.configurator.okButtonTitle, for: .normal)
        
        for subview : UIView in [self.imageView, self.gradientView, self.editorMainMenu, self.fontEditorMenu, colorEditorMenu, self.navigationView]
        {
            subview.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(subview)
        }
        self.setupConstraints()
    }
    
    override func navigationViewDoneButtonDidTouch (view : AGNavigationView)
    {
        self.selectedEditableImageView?.lastPosition = self.selectedEditableImageView?.newPosition
        self.selectedEditableImageView?.lastMaskColor = self.selectedEditableImageView?.maskColor
        self.close()
    }

    
    override func navigationViewBackButtonDidTouch(view: AGNavigationView) {
        if (self.selectedEditableImageView?.lastPosition == nil){
            self.selectedEditableImageView?.removeFromSuperview()
        } else {
            self.selectedEditableImageView?.newPosition = self.selectedEditableImageView?.lastPosition
            self.selectedEditableImageView?.maskColor = self.selectedEditableImageView?.lastMaskColor ?? AGColorEditorItem()
            self.selectedEditableImageView?.updateImagePosition()
            self.transformImage()
        }
        
        self.close()
    }
    
    fileprivate func close () {
        self.selectedEditableImageView?.isActive = false
        self.selectedEditableImageView = nil
        
        self.navigationView.hide(viewController: self)
        self.editorMainMenu.hide(viewController: self)
        
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
            
            self.selectedEditableImageView = AGEditableImageView.createWithImage(imageName: name, type: self.editorService.currentType)
            self.selectedEditableImageView?.delegate = self
            self.imageView.addSubview(self.selectedEditableImageView!)
            return
        default:
            return
        }
    }
    
    //MARK: Gesture recognizers methods
    func setupGestureReconizers () {
        
        if self.rotateRotationGestureRecognizer == nil {
            self.rotateRotationGestureRecognizer = UIRotationGestureRecognizer.init(target: self, action: #selector(AGImageEditorViewController.rotateEditableImageView(_:)))
            self.rotateRotationGestureRecognizer!.delegate = self
            self.view.addGestureRecognizer(self.rotateRotationGestureRecognizer!)
        }
        
        if self.zoomPinchGestureRecognizer == nil {
            self.zoomPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action:  #selector(AGImageEditorViewController.zoomEditableImageView(_:)))
            self.zoomPinchGestureRecognizer!.delegate = self
            self.view.addGestureRecognizer(self.zoomPinchGestureRecognizer!)
        }
    }
    
    func removeAllGestureRecognizers () {
        if let currentRotateRotationGestureRecognizer = self.rotateRotationGestureRecognizer {
            self.view.removeGestureRecognizer(currentRotateRotationGestureRecognizer)
            self.rotateRotationGestureRecognizer = nil
        }
        
        if let currentZoomPinchGestureRecognizer = self.zoomPinchGestureRecognizer {
            self.view.removeGestureRecognizer(currentZoomPinchGestureRecognizer)
            self.zoomPinchGestureRecognizer = nil
        }
    }
    
    func rotateEditableImageView (_ rotateRotationGestureRecognizer : UIRotationGestureRecognizer) {
        switch rotateRotationGestureRecognizer.state {
        case .began:
            rotateRotationGestureRecognizer.rotation = self.selectedEditableImageView?.newPosition?.rotateAngle ?? 0
            return
        case .changed:
            self.selectedEditableImageView?.newPosition?.rotateAngle = rotateRotationGestureRecognizer.rotation
            self.transformImage()
            return
        case .ended:
            self.selectedEditableImageView?.newPosition?.rotateAngle = rotateRotationGestureRecognizer.rotation
            rotateRotationGestureRecognizer.rotation = 0
            return
        default:
            return
        }
    }
    
    func zoomEditableImageView (_ zoomPinchGestureRecognizer : UIPinchGestureRecognizer) {
        switch zoomPinchGestureRecognizer.state {
        case .began:
            zoomPinchGestureRecognizer.scale = self.selectedEditableImageView?.newPosition?.scale ?? 1
            return
        case .changed:
            self.selectedEditableImageView?.newPosition?.scale = zoomPinchGestureRecognizer.scale
            self.transformImage()
            return
        case .ended:
            self.selectedEditableImageView?.newPosition?.scale = zoomPinchGestureRecognizer.scale
            self.selectedEditableImageView?.updateImage()
            zoomPinchGestureRecognizer.scale = 1

            return
        default:
            return
        }
    }
    
    func transformImage () {
        self.selectedEditableImageView?.transform = CGAffineTransform.identity.rotated(by: self.selectedEditableImageView?.newPosition?.rotateAngle ?? 0).scaledBy(x: self.selectedEditableImageView?.newPosition?.scale ?? 1, y: self.selectedEditableImageView?.newPosition?.scale ?? 1)
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
        print(newFont.fullName)
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
}


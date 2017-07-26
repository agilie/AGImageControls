//
//  AGImageMasksView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 18.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGImageMasksViewDataSource : class {
    func shapesMenuList () -> [String]
    func iconsMenuList () -> [String]
}

protocol AGImageMasksViewDelegate : class {
    func imageMaskDidSelectAtIndexPath (indexPath : IndexPath?, settingType: AGSettingMenuItemTypes, editorType : AGImageEditorTypes)
}

class AGImageMasksView: UIView {

    var type : AGSettingMenuItemTypes = .textAdjustment
    {
        didSet
        {
            self.showShapesMenuCollectionView(isShown: false)
            self.showNewItemsForTextType (isShown: false)
        }
    }
    
    weak var dataSource   : AGImageMasksViewDataSource?
    weak var delegate   : AGImageMasksViewDelegate?

    struct ViewSizes {
        
        static let height: CGFloat = 256.0
        
        static let buttonSize: CGSize = CGSize (width: 48, height : 48)
        static let buttonLeftOffset: CGFloat = 20.0
        static let buttonRightOffset: CGFloat = 12.0
        static let buttonBottomOffset: CGFloat = 26.0
        static let buttonTopOffset: CGFloat = 24.0

        static let textButtonSize: CGSize = CGSize (width: 71, height : 71)
        static let textButtonTopOffset: CGFloat = 8.0

        static let titleLabelHeight : CGFloat = 24.0
        static let titleLabelOffset : CGFloat = 8.0
        
        static let shapesMenuCollectionViewHeight : CGFloat = AGShapesMenuCollectionView.ViewSizes.height
    }
    
    lazy var configurator : AGAppConfigurator =
        {
            return  AGAppConfigurator()
    }()
    
    lazy var addNewImageButton: UIButton = { [unowned self] in
        let addNewImageButton =  UIButton.createButtonWith(title: self.configurator.addNewImageButtonTitle,
                                                           font: self.configurator.addNewImageButtonFont,
                                                           backgroundColor: self.configurator.imageEditorButtonsColor,
                                                           radius: 4.0)
            addNewImageButton.addTarget(self, action: #selector(addNewImageButtonDidTouch(_:)), for: .touchUpInside)
        
        return addNewImageButton
        }()

    lazy var undoButton: UIButton = { [unowned self] in
        let undoButton =  UIButton.createButtonWith(title: self.configurator.undoImageButtonTitle,
                                                           font: self.configurator.undoImageButtonFont,
                                                           backgroundColor: self.configurator.imageEditorButtonsColor,
                                                           radius: 4.0)
            undoButton.addTarget(self, action: #selector(undoButtonDidTouch(_:)), for: .touchUpInside)
        return undoButton
        }()

    
    lazy var captionTextButton: UIButton = { [unowned self] in
        let captionTextButton =  UIButton.createButtonWith(title: self.configurator.captionTextButtonTitle,
                                                    font: self.configurator.captionTextButtonFont,
                                                    backgroundColor: self.configurator.imageEditorButtonsColor,
                                                    radius: 4.0)
            captionTextButton.addTarget(self, action: #selector(captionTextButtonDidTouch(_:)), for: .touchUpInside)
        return captionTextButton
        }()

    lazy var detailsTextButton: UIButton = { [unowned self] in
        let detailsTextButton =  UIButton.createButtonWith(title: self.configurator.detailsTextButtonTitle,
                                                           font: self.configurator.detailsTextButtonFont,
                                                           backgroundColor: self.configurator.imageEditorButtonsColor,
                                                           radius: 4.0)
            detailsTextButton.addTarget(self, action: #selector(detailsTextButtonDidTouch(_:)), for: .touchUpInside)
        return detailsTextButton
        }()

    lazy var detailsTitleLabel: UILabel = { [unowned self] in
        let detailsTitleLabel = UILabel()
            detailsTitleLabel.isHidden = true
            detailsTitleLabel.text = self.configurator.detailsTextLabelTitle
            detailsTitleLabel.backgroundColor = .clear
            detailsTitleLabel.textColor = .white
            detailsTitleLabel.font = self.configurator.fontButtonTitleLabelFont
        
        return detailsTitleLabel
        }()

    lazy var captionTitleLabel: UILabel = { [unowned self] in
        let captionTitleLabel = UILabel()
            captionTitleLabel.isHidden = true
            captionTitleLabel.text = self.configurator.captionTextLabelTitle
            captionTitleLabel.backgroundColor = .clear
            captionTitleLabel.textColor = .white
            captionTitleLabel.font = self.configurator.fontButtonTitleLabelFont
        
        return captionTitleLabel
        }()

    lazy var shapesMenuCollectionView: AGShapesMenuCollectionView = { [unowned self] in
                
        let collectionView = AGShapesMenuCollectionView(frame: self.bounds, collectionViewLayout: nil)
            collectionView.shapesMenuCollectionViewDataSource = self
            collectionView.shapesMenuCollectionViewDelegate = self
            collectionView.isHidden = true
        
        return collectionView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureImageMasksView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show (type : AGSettingMenuItemTypes, toShow : Bool, animated : Bool) {
        if (toShow) { self.type = type }
        self.showWithAnimation(view: self, isShown: toShow, animated: animated)
    }
    
    //MARK: Button actions
    func addNewImageButtonDidTouch (_ button : UIButton) {
        self.showMenu(isShown : true)
    }
    
    func undoButtonDidTouch (_ button : UIButton) {
        print("undoButtonDidTouch")
    }
    
    func captionTextButtonDidTouch (_ button : UIButton) {
        self.delegate?.imageMaskDidSelectAtIndexPath(indexPath: nil, settingType : self.type, editorType : .captionText)
    }
    
    func detailsTextButtonDidTouch (_ button : UIButton) {
        self.delegate?.imageMaskDidSelectAtIndexPath(indexPath: nil, settingType : self.type, editorType: .detailsText)
    }
}

extension AGImageMasksView
{
    fileprivate func configureImageMasksView() {
        [addNewImageButton, undoButton, captionTextButton, detailsTextButton, captionTitleLabel, detailsTitleLabel, shapesMenuCollectionView].forEach {
            self.addSubview($0 as! UIView)
            ($0 as! UIView).translatesAutoresizingMaskIntoConstraints = false
        }
        self.setupConstraints()
    }
    
    fileprivate func showWithAnimation (view : UIView, isShown : Bool, animated : Bool) {
        if (isShown) { view.isHidden = !isShown }
        
        UIView.animate(withDuration: animated ? 0.245 : 0.0, animations: {
            view.alpha = isShown ? 1.0 : 0.0
        }) {[weak self] (isFinished) in
            guard let `self` = self else { return }
            if (!isShown) {
                view.isHidden = !isShown
            }
            if (view.isKind(of: AGShapesMenuCollectionView.classForCoder())) {self.shapesMenuCollectionView.reloadData()}
        }
    }
    
    fileprivate func showMenu (isShown : Bool) {
        switch self.type {
        case .textAdjustment:
            self.showNewItemsForTextType(isShown: isShown)
            return
        default:
            self.showShapesMenuCollectionView(isShown: isShown)
            return
        }
    }
    
    fileprivate func showNewItemsForTextType (isShown : Bool) {
        [captionTextButton, captionTitleLabel, detailsTextButton, detailsTitleLabel].forEach {
            self.showWithAnimation(view: $0, isShown: isShown, animated: true)
        }
    }
    
    fileprivate func showShapesMenuCollectionView (isShown : Bool) {
        self.showWithAnimation(view: self.shapesMenuCollectionView, isShown: isShown, animated: true)
    }
}

extension AGImageMasksView : AGShapesMenuCollectionViewDataSource
{
    func numberOfItemsInSection (shapesMenuCollectionView : AGShapesMenuCollectionView, section : Int) -> Int {
        switch self.type {
        case .shapesMaskAdjustment:
            return self.dataSource?.shapesMenuList().count ?? 0
        case .iconsAdjustment:
            return self.dataSource?.iconsMenuList().count ?? 0
        default:
            return 0
        }
    }
    
    func shapeNameAtIndexPath (shapesMenuCollectionView : AGShapesMenuCollectionView, indexPath : IndexPath) -> String {
        switch self.type {
        case .shapesMaskAdjustment:
            return self.dataSource?.shapesMenuList()[indexPath.row] ?? ""
        case .iconsAdjustment:
            return self.dataSource?.iconsMenuList()[indexPath.row] ?? ""
        default:
            return ""
        }
    }
}

extension AGImageMasksView : AGShapesMenuCollectionViewDelegate
{
    func selectedItem (shapesMenuCollectionView : AGShapesMenuCollectionView, atIndexPath indexPath: IndexPath) {
        switch self.type {
        case .shapesMaskAdjustment:
            self.delegate?.imageMaskDidSelectAtIndexPath(indexPath: indexPath, settingType: self.type, editorType: .shapes)
            return
        case .iconsAdjustment:
            self.delegate?.imageMaskDidSelectAtIndexPath(indexPath: indexPath, settingType: self.type, editorType: .icons)
            return
        default:
            return
        }
    }
}


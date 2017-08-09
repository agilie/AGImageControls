//
//  AGSettingsMenuCollectionViewCell.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 26.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGSettingsMenuCollectionViewCell: AGMainCollectionViewCell {
    
    var underlineViewLeftConstraint : NSLayoutConstraint? = nil
    var underlineViewRightConstraint : NSLayoutConstraint? = nil
    
    lazy var configurator : AGAppConfigurator = {
        return  AGAppConfigurator.sharedInstance
    }()

    struct ViewSizes {
        static let imageViewSize : CGSize = CGSize(width: 32, height: 32)
        static let underlineViewHeight      : CGFloat = 5
        static let underlineBottomOffset    : CGFloat = 2
    }
    
    lazy var imageView : UIImageView = { [unowned self] in
        let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.backgroundColor = .clear
        return imageView
        }()
    
    lazy var underlineView : UIView = { [unowned self] in
        let underlineView = UIView()
            underlineView.backgroundColor = self.configurator.underlineViewColor
            underlineView.withCornerRadius(radius: ViewSizes.underlineViewHeight / 2)
        underlineView.isHidden = true
        return underlineView
        }()

    lazy var underlineViewDefaultOffset : CGFloat = { [unowned self] in
        return (AGSettingsMenuCollectionViewCell.cellSize().width - ViewSizes.underlineViewHeight) / 2
    }()
    
    open override class func cellSize () -> CGSize {
        return CGSize(width: screenSize.width / 5, height : screenSize.width / 5)
    }
        
    override func configureForObject (object: Any?) {
        guard let settingItem = object as? AGSettingMenuItemModel else { return }

        self.imageView.image = AGAppResourcesService.getImage(settingItem.iconName)
    }
    
    func select () {
        self.hideUnderlineView(isHidden: false)
    }
    
    func unselect () {
        self.hideUnderlineView(isHidden: true)
    }
}

extension AGSettingsMenuCollectionViewCell
{
    fileprivate func hideUnderlineView (isHidden : Bool) {
        self.underlineView.isHidden = false
        
        UIView.animate(withDuration: 0.245, animations: { [weak self] in
            guard let `self` = self else { return }
            self.underlineViewLeftConstraint?.constant = isHidden ? self.underlineViewDefaultOffset : 5
            self.underlineViewRightConstraint?.constant = isHidden ? self.underlineViewDefaultOffset : 5
            self.layoutIfNeeded()
        }) { [weak self] (isFinished) in
            guard let `self` = self else { return }
            self.underlineView.isHidden = isHidden
        }
    }
    
    override func setupCollectionViewCell() {
        [imageView, underlineView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        setupConstraints()
    }
    
}


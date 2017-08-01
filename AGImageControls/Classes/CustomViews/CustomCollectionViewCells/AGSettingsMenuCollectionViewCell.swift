//
//  AGSettingsMenuCollectionViewCell.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 26.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGSettingsMenuCollectionViewCell: UICollectionViewCell, AGCellInterface {
    
    var underlineViewLeftConstraint : NSLayoutConstraint? = nil
    var underlineViewRightConstraint : NSLayoutConstraint? = nil
    
    lazy var configurator : AGAppConfigurator =
        {
            return  AGAppConfigurator()
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
    
    open class func cellSize () -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 5, height : UIScreen.main.bounds.width / 5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [imageView, underlineView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureForSettingMenuItem (menuItem: AGSettingMenuItemModel) {
        self.imageView.image = AGAppResourcesService.getImage(menuItem.iconName)
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
}


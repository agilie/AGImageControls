//
//  AGImageAdjustmentCollectionViewCell.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 27.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGImageAdjustmentCollectionViewCell: AGMainCollectionViewCell {
    
    lazy var configurator : AGAppConfigurator = {
        return  AGAppConfigurator.sharedInstance
    }()

    struct ViewSizes {
        static let imageViewSize : CGSize = AGImageAdjustmentCollectionViewCell.cellSize()
        static let labelOffset : CGFloat = 8.0
        static let labelHeight : CGFloat = 16.0
        static let imageTopOffset: CGFloat = 12.0
        static let imageLeftOffset: CGFloat = 20.0
    }
    
    lazy var imageView : UIImageView = { [unowned self] in
        let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.backgroundColor = .clear
        return imageView
        }()
    
    lazy var titleLabel : UILabel = { [unowned self] in
        let label = UILabel()
            label.font = self.configurator.titleSettingsFont
            label.textAlignment = .center
            label.numberOfLines = 1
            label.textColor = .white
        return label
        }()

    static let maxCellSize : CGFloat = 414.0 / 4.0
    
    open override class func cellSize () -> CGSize {
        return CGSize(width: min(screenSize.width / 4, maxCellSize), height : min(screenSize.width / 4, maxCellSize))
    }
    
    override func configureForObject (object: Any?) {
        guard let adjustmentItem = object as? AGAdjustmentMenuItem else { return }

        self.imageView.image = AGAppResourcesService.getImage(adjustmentItem.iconName)
        self.titleLabel.text = adjustmentItem.name.capitalized
        self.addBorderToImageView(menuItem: adjustmentItem)
    }
    
    func addBorderToImageView (menuItem: AGAdjustmentMenuItem) {
        self.imageView.viewWithRadiusAndBorder(radius: min(self.imageView.frame.height, self.imageView.frame.width) / 2,
                                               borderWidth: menuItem.currentValue != menuItem.defaultValue ? 1.0 : 0.0,
                                               borderColor: menuItem.currentValue != menuItem.defaultValue ? UIColor.white : UIColor.clear)
    }

}

extension AGImageAdjustmentCollectionViewCell {
    
    override func setupCollectionViewCell() {
        [imageView, titleLabel].forEach {
            ($0 as! UIView).translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0 as! UIView)
        }
        setupConstraints()
    }
}

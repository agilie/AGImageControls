//
//  AGImageAdjustmentCollectionView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 27.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGImageAdjustmentCollectionViewDataSource : class {
    func numberOfItemsInSection (section : Int) -> Int
    func menuItemAtIndexPath (indexPath : IndexPath) -> AGAdjustmentMenuItem
}

protocol AGImageAdjustmentCollectionViewDelegate: class {
    func selectedItem (atIndexPath indexPath: IndexPath)
}

class AGImageAdjustmentCollectionView: AGMainCollectionView {

    weak var imageAdjustmentDataSource : AGImageAdjustmentCollectionViewDataSource?
    weak var imageAdjustmentDelegate : AGImageAdjustmentCollectionViewDelegate?
    
    struct ViewSizes {
        static let height: CGFloat = AGImageAdjustmentCollectionViewCell.cellSize().height
    }
}

extension AGImageAdjustmentCollectionView {
    
    override func registerCollectionViewCells() {
        self.register(AGImageAdjustmentCollectionViewCell.self, forCellWithReuseIdentifier: AGImageAdjustmentCollectionViewCell.id)
    }
    
    override func cellSize(atIndexPath : IndexPath) -> CGSize {
        return AGImageAdjustmentCollectionViewCell.cellSize()
    }
    
    override func numberOfItems (section : Int) -> Int {
        return self.imageAdjustmentDataSource?.numberOfItemsInSection(section: section) ?? 0
    }
    
    override func cellIdentifierAt (indexPath : IndexPath) -> String {
        return AGImageAdjustmentCollectionViewCell.id
    }
    
    override func objectAt (indexPath : IndexPath) -> Any? {
        return self.imageAdjustmentDataSource?.menuItemAtIndexPath(indexPath: indexPath)
    }
    
    override func didSelectItemAtIndexPath (indexPath : IndexPath) {
        self.imageAdjustmentDelegate?.selectedItem(atIndexPath: indexPath)
    }
}

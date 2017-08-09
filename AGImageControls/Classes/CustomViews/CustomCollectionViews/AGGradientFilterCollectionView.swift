//
//  AGGradientFilterCollectionView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 11.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGGradientFilterCollectionViewDataSource : class {
    func numberOfItemsInSection (section : Int) -> Int
    func menuItemAtIndexPath (indexPath : IndexPath) -> AGGradientFilterItemModel
}

protocol AGGradientFilterCollectionViewDelegate: class {
    func selectedItem (atIndexPath indexPath: IndexPath)
}

class AGGradientFilterCollectionView: AGMainCollectionView {
    
    weak var gradientFilterDataSource : AGGradientFilterCollectionViewDataSource?
    weak var gradientFilterDelegate : AGGradientFilterCollectionViewDelegate?
    
    struct ViewSizes {
        static let height: CGFloat = AGGradientFilterCollectionViewCell.cellSize().height
    }        
}

//MARK: Private methods

extension AGGradientFilterCollectionView {
    override func registerCollectionViewCells() {
        self.register(AGGradientFilterCollectionViewCell.self, forCellWithReuseIdentifier: AGGradientFilterCollectionViewCell.id)
    }
        
    override func cellSize(atIndexPath : IndexPath) -> CGSize {
        return AGGradientFilterCollectionViewCell.cellSize()
    }
    
    override func numberOfItems (section : Int) -> Int {
        return self.gradientFilterDataSource?.numberOfItemsInSection(section: section) ?? 0
    }
    
    override func cellIdentifierAt (indexPath : IndexPath) -> String {
        return AGGradientFilterCollectionViewCell.id
    }
    
    override func objectAt (indexPath : IndexPath) -> Any? {
        return self.gradientFilterDataSource?.menuItemAtIndexPath(indexPath: indexPath)
    }

    override func didSelectItemAtIndexPath (indexPath : IndexPath) {
        self.gradientFilterDelegate?.selectedItem(atIndexPath: indexPath)
    }
}

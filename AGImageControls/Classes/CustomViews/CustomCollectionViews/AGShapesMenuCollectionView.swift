//
//  AGShapesMenuCollectionView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 19.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGShapesMenuCollectionViewDataSource : class {
    func numberOfItemsInSection (shapesMenuCollectionView : AGShapesMenuCollectionView, section : Int) -> Int
    func shapeNameAtIndexPath (shapesMenuCollectionView : AGShapesMenuCollectionView, indexPath : IndexPath) -> String
}

protocol AGShapesMenuCollectionViewDelegate: class {
    func selectedItem (shapesMenuCollectionView : AGShapesMenuCollectionView, atIndexPath indexPath: IndexPath)
}

class AGShapesMenuCollectionView: AGMainCollectionView {
    
    weak var shapesMenuCollectionViewDataSource : AGShapesMenuCollectionViewDataSource?
    weak var shapesMenuCollectionViewDelegate : AGShapesMenuCollectionViewDelegate?
    
    struct ViewSizes {
        static let height: CGFloat = AGShapesMenuCollectionViewCell.cellSize().height
    }
}

extension AGShapesMenuCollectionView {
    
    override func registerCollectionViewCells () {
        self.register(AGShapesMenuCollectionViewCell.self, forCellWithReuseIdentifier: AGShapesMenuCollectionViewCell.id)
    }
    
    override func cellSize(atIndexPath : IndexPath) -> CGSize {
        return AGShapesMenuCollectionViewCell.cellSize()
    }
    
    override func numberOfItems (section : Int) -> Int {
        return self.shapesMenuCollectionViewDataSource?.numberOfItemsInSection(shapesMenuCollectionView: self, section: section) ?? 0
    }
    
    override func cellIdentifierAt (indexPath : IndexPath) -> String {
        return AGShapesMenuCollectionViewCell.id
    }
    
    override func objectAt (indexPath : IndexPath) -> Any? {
        if !((self.shapesMenuCollectionViewDataSource?.numberOfItemsInSection(shapesMenuCollectionView: self, section: indexPath.section) ?? 0) > indexPath.row) {
            return nil
        }
        return self.shapesMenuCollectionViewDataSource?.shapeNameAtIndexPath(shapesMenuCollectionView: self, indexPath: indexPath)
    }
    
    override func didSelectItemAtIndexPath (indexPath : IndexPath) {
        self.shapesMenuCollectionViewDelegate?.selectedItem(shapesMenuCollectionView: self, atIndexPath: indexPath)
    }
    
}

//
//  AGFontEditorCollectionView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 14.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGFontEditorCollectionViewDataSource : class {
    func numberOfItemsInSection (fontEditorCollectionView : AGFontEditorCollectionView, section : Int) -> Int
    func menuItemAtIndexPath (fontEditorCollectionView : AGFontEditorCollectionView, indexPath : IndexPath) -> AGFontEditorItem
}

protocol AGFontEditorCollectionViewDelegate: class {
    func selectedItem (fontEditorCollectionView : AGFontEditorCollectionView, atIndexPath indexPath: IndexPath)
    func fontChanged (fontEditorCollectionView : AGFontEditorCollectionView, fontIndex : Int)
}

class AGFontEditorCollectionView: AGMainCollectionView {
 
    weak var fontEditorCollectionViewDataSource : AGFontEditorCollectionViewDataSource?
    weak var fontEditorCollectionViewDelegate : AGFontEditorCollectionViewDelegate?
    
    struct ViewSizes {
        static let height: CGFloat = AGFontEditorCollectionViewCell.cellSize().height
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout?) {
        let flowLayout = AGCarouselFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = AGFontEditorCollectionViewCell.cellSize()
            flowLayout.spacingMode = AGCarouselFlowLayoutSpacingMode.fixed(spacing: 12)
            flowLayout.sideItemScale = 0.72
    
        super.init(frame: frame, collectionViewLayout: flowLayout)
        if #available(iOS 10.0, *) { self.isPrefetchingEnabled = false }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }    
}

extension AGFontEditorCollectionView {
    
    override func registerCollectionViewCells () {
        self.register(AGFontEditorCollectionViewCell.self, forCellWithReuseIdentifier: AGFontEditorCollectionViewCell.id)
    }
    
    override func cellSize(atIndexPath : IndexPath) -> CGSize {
        return AGFontEditorCollectionViewCell.cellSize()
    }
    
    override func numberOfItems (section : Int) -> Int {
        return self.fontEditorCollectionViewDataSource?.numberOfItemsInSection(fontEditorCollectionView: self, section: section) ?? 0
    }
    
    override func cellIdentifierAt (indexPath : IndexPath) -> String {
        return AGFontEditorCollectionViewCell.id
    }
    
    override func objectAt (indexPath : IndexPath) -> Any? {
        return self.fontEditorCollectionViewDataSource?.menuItemAtIndexPath(fontEditorCollectionView: self, indexPath: indexPath)
    }
    
    override func didSelectItemAtIndexPath (indexPath : IndexPath) {
        self.fontEditorCollectionViewDelegate?.selectedItem(fontEditorCollectionView: self, atIndexPath: indexPath)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = self.indexPathForItem(at: center) {
            self.fontDidChange (indexPath: ip)
        }
    }
    
    fileprivate func fontDidChange (indexPath : IndexPath) {
        self.fontEditorCollectionViewDelegate?.fontChanged(fontEditorCollectionView: self, fontIndex: indexPath.row)
    }
}

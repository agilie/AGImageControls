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

class AGFontEditorCollectionView: UICollectionView {
 
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

        self.setupCollectionView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }    
}

extension AGFontEditorCollectionView {
    fileprivate func setupCollectionView () {
        self.dataSource = self
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.register(AGFontEditorCollectionViewCell.self, forCellWithReuseIdentifier: AGFontEditorCollectionViewCell.id)
        self.backgroundColor = .clear
    }
    
    fileprivate func fontDidChange (indexPath : IndexPath) {
        self.fontEditorCollectionViewDelegate?.fontChanged(fontEditorCollectionView: self, fontIndex: indexPath.row)
    }
}

extension AGFontEditorCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fontEditorCollectionViewDataSource?.numberOfItemsInSection(fontEditorCollectionView: self, section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = AGFontEditorCollectionViewCell.id
        
        guard let currentMenuItem = self.fontEditorCollectionViewDataSource?.menuItemAtIndexPath(fontEditorCollectionView: self, indexPath: indexPath) else {
            return UICollectionViewCell()
            
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AGFontEditorCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureForMenuItem(menuItem: currentMenuItem)
        return cell
    }
}

extension AGFontEditorCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.fontEditorCollectionViewDelegate?.selectedItem(fontEditorCollectionView: self, atIndexPath: indexPath)
    }
}

extension AGFontEditorCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return AGFontEditorCollectionViewCell.cellSize()
    }
}

extension AGFontEditorCollectionView : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = self.indexPathForItem(at: center) {
            self.fontDidChange (indexPath: ip)
        }
    }
}


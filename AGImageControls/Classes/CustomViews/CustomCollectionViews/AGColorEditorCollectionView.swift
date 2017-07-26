//
//  AGColorEditorCollectionView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 17.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGColorEditorCollectionViewDataSource : class {
    func numberOfItemsInSection (colorEditorCollectionView : AGColorEditorCollectionView, section : Int) -> Int
    func menuItemAtIndexPath (colorEditorCollectionView : AGColorEditorCollectionView, indexPath : IndexPath) -> AGColorEditorItem
}

protocol AGColorEditorCollectionViewDelegate: class {
    func selectedItem (colorEditorCollectionView : AGColorEditorCollectionView, atIndexPath indexPath: IndexPath)
    func colorChanged (colorEditorCollectionView : AGColorEditorCollectionView, colorIndex : Int)
}

class AGColorEditorCollectionView: UICollectionView {
    
    weak var colorEditorCollectionViewDataSource : AGColorEditorCollectionViewDataSource?
    weak var colorEditorCollectionViewDelegate : AGColorEditorCollectionViewDelegate?
    
    struct ViewSizes {
        static let height: CGFloat = AGColorEditorCollectionViewCell.cellSize().height
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout?) {
        
        let flowLayout = AGCarouselFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.itemSize = AGColorEditorCollectionViewCell.cellSize()
            flowLayout.spacingMode = AGCarouselFlowLayoutSpacingMode.fixed(spacing: 12)
            flowLayout.sideItemScale = 0.62
            flowLayout.sideItemAlpha = 1.0
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        if #available(iOS 10.0, *) { self.isPrefetchingEnabled = false }
        self.setupCollectionView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}

extension AGColorEditorCollectionView {
    fileprivate func setupCollectionView () {
        self.dataSource = self
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.register(AGColorEditorCollectionViewCell.self, forCellWithReuseIdentifier: AGColorEditorCollectionViewCell.id)
        self.backgroundColor = .clear
    }
    
    fileprivate func colorDidChange (indexPath : IndexPath) {
        self.colorEditorCollectionViewDelegate?.colorChanged(colorEditorCollectionView: self, colorIndex: indexPath.row)
        self.isUserInteractionEnabled = true
    }
}

extension AGColorEditorCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorEditorCollectionViewDataSource?.numberOfItemsInSection(colorEditorCollectionView: self, section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = AGColorEditorCollectionViewCell.id
        
        guard let currentMenuItem = self.colorEditorCollectionViewDataSource?.menuItemAtIndexPath(colorEditorCollectionView: self, indexPath: indexPath) else {
            return UICollectionViewCell()
            
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AGColorEditorCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureForMenuItem(menuItem: currentMenuItem)
        return cell
    }
}

extension AGColorEditorCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.colorEditorCollectionViewDelegate?.selectedItem(colorEditorCollectionView: self, atIndexPath: indexPath)
    }
}

extension AGColorEditorCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return AGColorEditorCollectionViewCell.cellSize()
    }
}

extension AGColorEditorCollectionView : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = self.indexPathForItem(at: center) {
            self.colorDidChange(indexPath: ip)
        }
    }
}

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

class AGImageAdjustmentCollectionView: UICollectionView {

    weak var imageAdjustmentDataSource : AGImageAdjustmentCollectionViewDataSource?
    weak var imageAdjustmentDelegate : AGImageAdjustmentCollectionViewDelegate?
    
    struct ViewSizes {
        static let height: CGFloat = AGImageAdjustmentCollectionViewCell.cellSize().height
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout?) {
        
        let flowLayout = UICollectionViewFlowLayout()
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            flowLayout.scrollDirection = .horizontal

        super.init(frame: frame, collectionViewLayout: flowLayout)
        self.setupCollectionView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func hide (isHidden : Bool) {
        self.hideWithAnimation(isHidden: isHidden)
    }
}

extension AGImageAdjustmentCollectionView {
    
    fileprivate func setupCollectionView () {
        self.dataSource = self
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.register(AGImageAdjustmentCollectionViewCell.self, forCellWithReuseIdentifier: AGImageAdjustmentCollectionViewCell.id)
        self.backgroundColor = .clear
    }
    
    fileprivate func hideWithAnimation (isHidden : Bool) {
        UIView.animate(withDuration: 0.245,
                       animations:
            {
                self.alpha = isHidden ? 0.0 : 1.0
        }) { (isFinished) in
            if (isFinished) {self.isHidden = isHidden}
        }
    }
}

extension AGImageAdjustmentCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageAdjustmentDataSource?.numberOfItemsInSection(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = AGImageAdjustmentCollectionViewCell.id
        
        guard let currentMenuItem = self.imageAdjustmentDataSource?.menuItemAtIndexPath(indexPath: indexPath) else {
            return UICollectionViewCell()
            
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AGImageAdjustmentCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureForMenuItem(menuItem: currentMenuItem)
        return cell
    }
}

extension AGImageAdjustmentCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageAdjustmentDelegate?.selectedItem(atIndexPath: indexPath)
    }
}

extension AGImageAdjustmentCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return AGImageAdjustmentCollectionViewCell.cellSize()
    }
}

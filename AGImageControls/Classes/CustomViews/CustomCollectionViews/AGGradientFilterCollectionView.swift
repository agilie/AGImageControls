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

class AGGradientFilterCollectionView: UICollectionView {
    
    weak var gradientFilterDataSource : AGGradientFilterCollectionViewDataSource?
    
    weak var gradientFilterDelegate : AGGradientFilterCollectionViewDelegate?
    
    struct ViewSizes {
        static let height: CGFloat = AGGradientFilterCollectionViewCell.cellSize().height
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
    
    func hide (isHidden : Bool)
    {
        self.hideWithAnimation (isHidden: isHidden)
    }
}


//MARK: Private methods

extension AGGradientFilterCollectionView {
    fileprivate func setupCollectionView () {
        self.dataSource = self
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.register(AGGradientFilterCollectionViewCell.self, forCellWithReuseIdentifier: AGGradientFilterCollectionViewCell.id)
        self.backgroundColor = .clear
    }
    
    fileprivate func hideWithAnimation (isHidden : Bool)
    {
        UIView.animate(withDuration: 0.245,
                       animations:
            {
                self.alpha = isHidden ? 0.0 : 1.0
        }) { (isFinished) in
            if (isFinished) {self.isHidden = isHidden}
        }
    }
}

extension AGGradientFilterCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gradientFilterDataSource?.numberOfItemsInSection(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = AGGradientFilterCollectionViewCell.id
        
        guard let currentMenuItem = self.gradientFilterDataSource?.menuItemAtIndexPath(indexPath: indexPath) else {
            return UICollectionViewCell()
            
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AGGradientFilterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureForMenuItem(menuItem: currentMenuItem)
        return cell
    }
}

extension AGGradientFilterCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.gradientFilterDelegate?.selectedItem(atIndexPath: indexPath)
    }
}

extension AGGradientFilterCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return AGGradientFilterCollectionViewCell.cellSize()
    }
}

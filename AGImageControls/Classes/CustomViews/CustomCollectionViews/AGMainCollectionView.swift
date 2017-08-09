//
//  AGMainCollectionView.swift
//  Pods
//
//  Created by Michael Liptuga on 07.08.17.
//
//

import UIKit

class AGMainCollectionView: UICollectionView {
    
    class func flowLayout () -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = self.collectionViewScrollDirection()
        return flowLayout
    }
    
    class func collectionViewScrollDirection () -> UICollectionViewScrollDirection {
        return .horizontal
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout?) {
        super.init(frame: frame, collectionViewLayout: layout ?? AGMainCollectionView.flowLayout())
        self.setupCollectionView()
        self.registerCollectionViewCells()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    func hide (isHidden : Bool) {
        self.hideWithAnimation (isHidden: isHidden)
    }
}

extension AGMainCollectionView {
    
    func setupCollectionView () {
        self.dataSource = self
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .clear
    }
    
    func registerCollectionViewCells () {
    
    }
    
    func cellSize(atIndexPath : IndexPath) -> CGSize {
        return CGSize.zero
    }
    
    func numberOfItems (section : Int) -> Int {
        return 0
    }
    
    func cellIdentifierAt (indexPath : IndexPath) -> String {
        return ""
    }
    
    func objectAt (indexPath : IndexPath) -> Any? {
        return nil
    }
    
    func didSelectItemAtIndexPath (indexPath : IndexPath) {
        
    }
    
    func hideWithAnimation (isHidden : Bool) {
        UIView.animate(withDuration: 0.245,
                       animations:
            {
                self.alpha = isHidden ? 0.0 : 1.0
        }) { (isFinished) in
            if (isFinished) {self.isHidden = isHidden}
        }
    }
}

extension AGMainCollectionView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = self.cellIdentifierAt(indexPath: indexPath)
        
        guard let object = self.objectAt(indexPath: indexPath) else {
            return UICollectionViewCell()
            
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AGMainCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureForObject(object: object)
        return cell
    }
}

extension AGMainCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectItemAtIndexPath(indexPath: indexPath)
    }
}

extension AGMainCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellSize(atIndexPath: indexPath)
    }
}

extension AGMainCollectionView : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

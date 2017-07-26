//
//  AGImageEditorMainMenuCollectionView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 14.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGImageEditorMainMenuCollectionViewDataSource : class {
    func numberOfItemsInSection (section : Int) -> Int
    func menuItemAtIndexPath (indexPath : IndexPath) -> AGImageEditorMainMenuItem
}

protocol AGImageEditorMainMenuCollectionViewDelegate: class {
    func selectedItem (atIndexPath indexPath: IndexPath)
}


class AGImageEditorMainMenuCollectionView: UICollectionView {

    weak var imageEditorMainMenuDataSource : AGImageEditorMainMenuCollectionViewDataSource?
    weak var imageEditorMainMenuDelegate : AGImageEditorMainMenuCollectionViewDelegate?
    
    var selectedIndexPath : IndexPath? = nil
    
    struct ViewSizes {
        static let height: CGFloat = AGImageEditorMainMenuCollectionViewCell.cellSize().height
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
    
    func show (viewController : AGImageEditorViewController) {
        self.hideWithAnimation(viewController: viewController, isHidden: false)
    }
    
    func hide (viewController : AGImageEditorViewController) {
        self.hideWithAnimation(viewController: viewController, isHidden: true)
    }
    
    func unselectAllMenuItems () {
        self.selectedIndexPath = nil
        self.reloadData()
    }
}

//MARK: Private methods

extension AGImageEditorMainMenuCollectionView {
    fileprivate func setupCollectionView () {
        self.dataSource = self
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.register(AGImageEditorMainMenuCollectionViewCell.self, forCellWithReuseIdentifier: AGImageEditorMainMenuCollectionViewCell.id)
        self.backgroundColor = .clear
    }
    
    fileprivate func hideWithAnimation (viewController : AGImageEditorViewController, isHidden : Bool) {
        if let index = self.selectedIndexPath {
            if let previousItem = self.imageEditorMainMenuDataSource?.menuItemAtIndexPath(indexPath: index) {
                previousItem.isSelected = false
            }
        }
        UIView.animate(withDuration: 0.245) {
            viewController.imageEditorMainMenuCollectionViewBottomConstraint?.constant = isHidden ? ViewSizes.height : 0
            viewController.view.layoutIfNeeded()
        }
    }
}

extension AGImageEditorMainMenuCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageEditorMainMenuDataSource?.numberOfItemsInSection(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = AGImageEditorMainMenuCollectionViewCell.id
        
        guard let currentMenuItem = self.imageEditorMainMenuDataSource?.menuItemAtIndexPath(indexPath: indexPath) else {
            return UICollectionViewCell()
            
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AGImageEditorMainMenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureForMenuItem(menuItem: currentMenuItem)
        return cell
    }
}

extension AGImageEditorMainMenuCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.imageEditorMainMenuDelegate?.selectedItem(atIndexPath: indexPath)
        
        if let index = self.selectedIndexPath {
            if let previousItem = self.imageEditorMainMenuDataSource?.menuItemAtIndexPath(indexPath: index) {
                previousItem.isSelected = false
                if (index == indexPath) {
                    self.selectedIndexPath = nil
                    previousItem.isSelected = false
                    self.reloadData()
                    return
                }
            }
        }
        if let currentMenuItem = self.imageEditorMainMenuDataSource?.menuItemAtIndexPath(indexPath: indexPath) {
            self.selectedIndexPath = indexPath
            currentMenuItem.isSelected = true
        }
        self.reloadData()
    }
}

extension AGImageEditorMainMenuCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return AGImageEditorMainMenuCollectionViewCell.cellSize()
    }
}

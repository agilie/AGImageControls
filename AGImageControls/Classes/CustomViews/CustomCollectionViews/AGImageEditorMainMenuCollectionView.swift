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

class AGImageEditorMainMenuCollectionView: AGMainCollectionView {

    weak var imageEditorMainMenuDataSource : AGImageEditorMainMenuCollectionViewDataSource?
    weak var imageEditorMainMenuDelegate : AGImageEditorMainMenuCollectionViewDelegate?
    
    var selectedIndexPath : IndexPath? = nil
    
    struct ViewSizes {
        static let height: CGFloat = AGImageEditorMainMenuCollectionViewCell.cellSize().height
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
    
    override func registerCollectionViewCells() {
        self.register(AGImageEditorMainMenuCollectionViewCell.self, forCellWithReuseIdentifier: AGImageEditorMainMenuCollectionViewCell.id)
    }
    
    override func cellSize(atIndexPath : IndexPath) -> CGSize {
        return AGImageEditorMainMenuCollectionViewCell.cellSize()
    }
    
    override func numberOfItems (section : Int) -> Int {
        return self.imageEditorMainMenuDataSource?.numberOfItemsInSection(section: section) ?? 0
    }
    
    override func cellIdentifierAt (indexPath : IndexPath) -> String {
        return AGImageEditorMainMenuCollectionViewCell.id
    }
    
    override func objectAt (indexPath : IndexPath) -> Any? {
        return self.imageEditorMainMenuDataSource?.menuItemAtIndexPath(indexPath: indexPath)
    }
    
    override func didSelectItemAtIndexPath (indexPath : IndexPath) {
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

extension AGImageEditorMainMenuCollectionView {
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

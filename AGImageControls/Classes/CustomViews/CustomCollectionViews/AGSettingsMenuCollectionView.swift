//
//  AGSettingsMenuCollectionView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 26.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGSettingsMenuCollectionViewDataSource : class {
    func numberOfItemsInSection (section : Int) -> Int
    func menuItemAtIndexPath (indexPath : IndexPath) -> AGSettingMenuItemModel
}

protocol AGSettingsMenuCollectionViewDelegate: class {
    func selectedMenuItem (atIndexPath indexPath: IndexPath)
}

class AGSettingsMenuCollectionView: AGMainCollectionView {
    
    weak var settingsMenuDataSource : AGSettingsMenuCollectionViewDataSource?
    weak var settingsMenuDelegate : AGSettingsMenuCollectionViewDelegate?
    
    var selectedIndexPath : IndexPath? = nil
    
    struct ViewSizes {
        static let height: CGFloat = AGSettingsMenuCollectionViewCell.cellSize().height
    }
    
    func show (viewController : AGImageEditingViewController) {
        self.hideWithAnimation(viewController: viewController, isHidden: false)
    }
    
    func hide (viewController : AGImageEditingViewController) {
        self.hideWithAnimation(viewController: viewController, isHidden: true)
    }
    
    func unselectCell (selectedIndexPath : IndexPath?) {
        guard let indexPath = selectedIndexPath else {
            return
        }
        if let cell = self.cellForItem(at: indexPath) as? AGSettingsMenuCollectionViewCell {
            if let index = self.selectedIndexPath {
                if let selectedCell = self.cellForItem(at: index) as? AGSettingsMenuCollectionViewCell {
                    selectedCell.unselect()
                }
                if index != indexPath { cell.select() }
                self.selectedIndexPath = index == indexPath ? nil : indexPath
                return
            }
            cell.select()
            self.selectedIndexPath = indexPath
        }
    }
}

extension AGSettingsMenuCollectionView {

    override func registerCollectionViewCells () {
        self.register(AGSettingsMenuCollectionViewCell.self, forCellWithReuseIdentifier: AGSettingsMenuCollectionViewCell.id)
    }
    
    override func cellSize(atIndexPath : IndexPath) -> CGSize {
        return AGSettingsMenuCollectionViewCell.cellSize()
    }
    
    override func numberOfItems (section : Int) -> Int {
        return self.settingsMenuDataSource?.numberOfItemsInSection(section: section) ?? 0
    }
    
    override func cellIdentifierAt (indexPath : IndexPath) -> String {
        return AGSettingsMenuCollectionViewCell.id
    }
    
    override func objectAt (indexPath : IndexPath) -> Any? {
        return self.settingsMenuDataSource?.menuItemAtIndexPath(indexPath: indexPath)
    }
    
    override func didSelectItemAtIndexPath (indexPath : IndexPath) {
        self.settingsMenuDelegate?.selectedMenuItem(atIndexPath: indexPath)
        self.unselectCell(selectedIndexPath: indexPath)
    }
    
}

extension AGSettingsMenuCollectionView {
    fileprivate func hideWithAnimation (viewController : AGImageEditingViewController, isHidden : Bool) {
        UIView.animate(withDuration: 0.245) {
            viewController.settingsMenuCollectionViewTopConstraint?.constant = isHidden ? 0 : -ViewSizes.height
            viewController.view.layoutIfNeeded()
        }
    }
}

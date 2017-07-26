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

class AGSettingsMenuCollectionView: UICollectionView {
    
    weak var settingsMenuDataSource : AGSettingsMenuCollectionViewDataSource?
    weak var settingsMenuDelegate : AGSettingsMenuCollectionViewDelegate?
    
    var selectedIndexPath : IndexPath? = nil
    
    struct ViewSizes {
        static let height: CGFloat = AGSettingsMenuCollectionViewCell.cellSize().height
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
    fileprivate func setupCollectionView () {
        self.dataSource = self
        self.delegate = self
        self.register(AGSettingsMenuCollectionViewCell.self, forCellWithReuseIdentifier: AGSettingsMenuCollectionViewCell.id)
        self.backgroundColor = .clear
    }
    
    fileprivate func hideWithAnimation (viewController : AGImageEditingViewController, isHidden : Bool) {
        UIView.animate(withDuration: 0.245) {
            viewController.settingsMenuCollectionViewTopConstraint?.constant = isHidden ? 0 : -ViewSizes.height
            viewController.view.layoutIfNeeded()
        }
    }
}

extension AGSettingsMenuCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.settingsMenuDataSource?.numberOfItemsInSection(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = AGSettingsMenuCollectionViewCell.id
        
        guard let currentMenuItem = self.settingsMenuDataSource?.menuItemAtIndexPath(indexPath: indexPath) else {
            return UICollectionViewCell()
            
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AGSettingsMenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureForSettingMenuItem(menuItem: currentMenuItem)
        return cell
    }
}

extension AGSettingsMenuCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.settingsMenuDelegate?.selectedMenuItem(atIndexPath: indexPath)
        self.unselectCell(selectedIndexPath: indexPath)
    }
}

extension AGSettingsMenuCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return AGSettingsMenuCollectionViewCell.cellSize()
    }
}

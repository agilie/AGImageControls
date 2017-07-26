//
//  AGShapesMenuCollectionView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 19.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGShapesMenuCollectionViewDataSource : class {
    func numberOfItemsInSection (shapesMenuCollectionView : AGShapesMenuCollectionView, section : Int) -> Int
    func shapeNameAtIndexPath (shapesMenuCollectionView : AGShapesMenuCollectionView, indexPath : IndexPath) -> String
}

protocol AGShapesMenuCollectionViewDelegate: class {
    func selectedItem (shapesMenuCollectionView : AGShapesMenuCollectionView, atIndexPath indexPath: IndexPath)
}

class AGShapesMenuCollectionView: UICollectionView {
    
    weak var shapesMenuCollectionViewDataSource : AGShapesMenuCollectionViewDataSource?
    weak var shapesMenuCollectionViewDelegate : AGShapesMenuCollectionViewDelegate?
    
    struct ViewSizes {
        static let height: CGFloat = AGShapesMenuCollectionViewCell.cellSize().height
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
}

extension AGShapesMenuCollectionView {
    
    fileprivate func setupCollectionView () {
        self.dataSource = self
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.register(AGShapesMenuCollectionViewCell.self, forCellWithReuseIdentifier: AGShapesMenuCollectionViewCell.id)
        self.backgroundColor = .clear
    }
    
}

extension AGShapesMenuCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shapesMenuCollectionViewDataSource?.numberOfItemsInSection(shapesMenuCollectionView: self, section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = AGShapesMenuCollectionViewCell.id
        
        if !((self.shapesMenuCollectionViewDataSource?.numberOfItemsInSection(shapesMenuCollectionView: self, section: indexPath.section) ?? 0) > indexPath.row)
        { return UICollectionViewCell() }
        
        guard let shapeName = self.shapesMenuCollectionViewDataSource?.shapeNameAtIndexPath(shapesMenuCollectionView: self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AGShapesMenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureWith(imageName: shapeName)
        return cell
    }
}

extension AGShapesMenuCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.shapesMenuCollectionViewDelegate?.selectedItem(shapesMenuCollectionView: self, atIndexPath: indexPath)
    }
}

extension AGShapesMenuCollectionView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return AGShapesMenuCollectionViewCell.cellSize()
    }
}

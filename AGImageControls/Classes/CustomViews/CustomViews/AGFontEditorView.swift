//
//  AGFontEditorView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 17.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGFontEditorViewDataSource : class {
    func fontEditorItems () -> [AGFontEditorItem]
}

protocol AGFontEditorViewDelegate : class {
    func updateFont (view : AGFontEditorView, newFont : AGFontEditorItem)
    func fontEditorDidClose (view : AGFontEditorView)
}

class AGFontEditorView: UIView {
    
    weak var delegate   : AGFontEditorViewDelegate?
    weak var dataSource : AGFontEditorViewDataSource?
    
    struct ViewSizes {
        static let collectionHeight : CGFloat = AGFontEditorCollectionView.ViewSizes.height
        static let titleLabelHeight : CGFloat = 25.0
        static let height : CGFloat = collectionHeight + titleLabelHeight
    }
    
    lazy var collectionView : AGFontEditorCollectionView = { [unowned self] in
        let fontEditorMenu = AGFontEditorCollectionView(frame: self.bounds, collectionViewLayout: nil)
            fontEditorMenu.fontEditorCollectionViewDataSource = self
            fontEditorMenu.fontEditorCollectionViewDelegate = self
        return fontEditorMenu
        }()
    
    lazy var titleLabel : UILabel = { [unowned self] in
        let label = UILabel()
            label.textAlignment = .center
            label.backgroundColor = .clear
            label.textColor = .white
            label.font = label.font.withSize(16.0)
        return label
        }()
    
    lazy var fontEditorItems : [AGFontEditorItem] = { [unowned self] in
        return self.dataSource?.fontEditorItems() ?? []
        }()
    
    var selectedItem : AGFontEditorItem? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureFontEditorView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show (toShow : Bool, animated : Bool) {
        self.showWithAnimation(view: self, isShown: toShow, animated: animated)
    }
}

extension AGFontEditorView
{
    fileprivate func configureFontEditorView() {
        [collectionView, titleLabel].forEach {
            self.addSubview($0 as! UIView)
            ($0 as! UIView).translatesAutoresizingMaskIntoConstraints = false
        }
        self.setupConstraints()
    }
    
    fileprivate func showWithAnimation (view : UIView, isShown : Bool, animated : Bool) {
        if (isShown) { view.isHidden = !isShown }
        
        UIView.animate(withDuration: animated ? 0.245 : 0.0, animations: {
            view.alpha = isShown ? 1.0 : 0.0
        }) { (isFinished) in
            if (!isShown) {
                view.isHidden = !isShown
            } else {
                self.updateTitleLabel()
            }
        }
    }
    
    fileprivate func updateTitleLabel () {
        guard let selectedFont = self.selectedItem else {
            self.updateTitleLabelFor(fontEditorItem: self.fontEditorItems.first ?? AGFontEditorItem())
            return
        }
        self.updateTitleLabelFor(fontEditorItem: selectedFont)
    }
    
    fileprivate func updateTitleLabelFor(fontEditorItem : AGFontEditorItem) {
        self.titleLabel.text = fontEditorItem.fullName
        self.titleLabel.font = fontEditorItem.font?.withSize(self.titleLabel.font.pointSize)
        self.delegate?.updateFont(view: self, newFont: fontEditorItem)
    }
}

extension AGFontEditorView : AGFontEditorCollectionViewDataSource
{
    func numberOfItemsInSection (fontEditorCollectionView : AGFontEditorCollectionView, section : Int) -> Int {
        return self.fontEditorItems.count
    }
    
    func menuItemAtIndexPath (fontEditorCollectionView : AGFontEditorCollectionView, indexPath : IndexPath) -> AGFontEditorItem {
        return self.fontEditorItems[indexPath.row]
    }    
}

extension AGFontEditorView : AGFontEditorCollectionViewDelegate
{
    func selectedItem (fontEditorCollectionView : AGFontEditorCollectionView, atIndexPath indexPath: IndexPath) {
        self.selectedItem = self.fontEditorItems[indexPath.row]
        self.updateTitleLabel()
        self.show(toShow: false, animated: true)
        self.delegate?.fontEditorDidClose(view: self)
    }
    
    func fontChanged (fontEditorCollectionView : AGFontEditorCollectionView, fontIndex : Int) {
        if (self.fontEditorItems.count > fontIndex && fontIndex >= 0)
        {
            self.selectedItem = self.fontEditorItems[fontIndex]
            self.updateTitleLabel()
        }
    }

}

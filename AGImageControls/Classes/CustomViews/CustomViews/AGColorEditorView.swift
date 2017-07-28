//
//  AGColorEditorView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 17.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit


protocol AGColorEditorViewDelegate : class {
    func updateColor (view : AGColorEditorView, colorEditorItem : AGColorEditorItem)
    func colorEditorDidClose (view : AGColorEditorView)
}

protocol AGColorEditorViewDataSource : class {
    func colorEditorMenuItems () -> [AGColorEditorItem]
}

class AGColorEditorView: UIView {
    
    weak var delegate   : AGColorEditorViewDelegate?
    weak var dataSource : AGColorEditorViewDataSource?
    
    struct ViewSizes {
        
        static let sliderValueLabelHeight : CGFloat = 22.0
        static let sliderHeight : CGFloat = 62.0
        static let sliderTopOffset : CGFloat = 23.0
        static let sliderRightAndLeftOffset : CGFloat = 53.0

        static let collectionViewHeight : CGFloat = AGColorEditorCollectionView.ViewSizes.height

        static let height : CGFloat = collectionViewHeight + sliderHeight + sliderTopOffset
    }
    
    lazy var configurator : AGAppConfigurator =
        {
            return  AGAppConfigurator()
    }()
    
    lazy var collectionView : AGColorEditorCollectionView = { [unowned self] in
        let colorEditorMenu = AGColorEditorCollectionView(frame: self.bounds, collectionViewLayout: nil)
            colorEditorMenu.colorEditorCollectionViewDataSource = self
            colorEditorMenu.colorEditorCollectionViewDelegate = self
        return colorEditorMenu
    }()

    lazy var sliderValueLabel: UILabel = { [unowned self] in
        let sliderValueLabel = UILabel()
        sliderValueLabel.font = UIFont.adjustmentSliderValueFont()
        sliderValueLabel.textColor = .white
        sliderValueLabel.text = "0"
        return sliderValueLabel
        }()
    
    lazy var slider : AGCustomSlider = { [unowned self] in
        let slider = AGCustomSlider.create()
            slider.isHidden = false
            slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
        }()
    
    lazy var colorEditorMenuItems : [AGColorEditorItem] = { [unowned self] in
        return self.dataSource?.colorEditorMenuItems() ?? []
        }()
    
    var selectedItem : AGColorEditorItem? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureImageAdjustmentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show (toShow : Bool, animated : Bool) {
        self.showWithAnimation(isShown: toShow, animated: animated)
    }
    
    func sliderValueChanged (_ slider : UISlider) {
        guard let item = self.selectedItem else {
            return
        }
        self.sliderValueLabel.text = "\(Int(slider.value))"
        if (item.currentValue != slider.value)
        {
            item.currentValue = slider.value
            self.delegate?.updateColor(view: self, colorEditorItem: item)
        }
    }
}

extension AGColorEditorView
{
    fileprivate func configureImageAdjustmentView() {
        for subview in [sliderValueLabel, slider, collectionView] as [UIView]
        {
            self.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        self.setupConstraints()
    }
    
    fileprivate func updateSliderForItem (item : AGColorEditorItem) {
        self.slider.maximumValue = item.maxValue
        self.slider.minimumValue = item.minValue
        self.slider.value = item.currentValue
        self.sliderValueLabel.text = "\(Int(item.currentValue))"
    }
    
    fileprivate func updateColor (index : Int) {
        if (self.colorEditorMenuItems.count > index && index >= 0)
        {
            self.selectedItem = self.colorEditorMenuItems[index]
            self.updateSliderForItem (item : self.colorEditorMenuItems[index])
            self.delegate?.updateColor(view: self, colorEditorItem: self.colorEditorMenuItems[index])
        }
    }
}

extension AGColorEditorView : AGColorEditorCollectionViewDataSource
{
    func numberOfItemsInSection (colorEditorCollectionView : AGColorEditorCollectionView, section : Int) -> Int {
        return self.colorEditorMenuItems.count
    }
    
    func menuItemAtIndexPath (colorEditorCollectionView : AGColorEditorCollectionView, indexPath : IndexPath) -> AGColorEditorItem {
        return self.colorEditorMenuItems[indexPath.row]
    }
}

extension AGColorEditorView : AGColorEditorCollectionViewDelegate
{
    func selectedItem (colorEditorCollectionView : AGColorEditorCollectionView, atIndexPath indexPath: IndexPath) {
        self.updateColor(index : indexPath.row)
        self.show(toShow: false, animated: true)
        self.delegate?.colorEditorDidClose(view: self)
    }
    
    func colorChanged (colorEditorCollectionView : AGColorEditorCollectionView, colorIndex : Int) {
        self.updateColor(index : colorIndex)
    }
}


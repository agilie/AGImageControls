//
//  AGImageAdjustmentView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 27.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGImageAdjustmentViewDelegate : class {
    func updateImageAdjustment (view : AGImageAdjustmentView, adjustmentItem : AGAdjustmentMenuItem, value : Int)
    func applyFilterButtonDidTouch (view : AGImageAdjustmentView, adjustmentItem : AGAdjustmentMenuItem, value : Int)
    func beginImageRotation (view : AGImageAdjustmentView)

    func adjustmentMenuItemDidSelect (view : AGImageAdjustmentView)
    
    func cancelFilterButtonDidTouch (view : AGImageAdjustmentView)
    func cancelAllFiltersButtonDidTouch(view : AGImageAdjustmentView)
}

protocol AGImageAdjustmentViewDataSource : class {
    func adjustmentMenuItems () -> [AGAdjustmentMenuItem]
}

class AGImageAdjustmentView: UIView {

    weak var delegate   : AGImageAdjustmentViewDelegate?
    weak var dataSource : AGImageAdjustmentViewDataSource?

    struct ViewSizes {
        static let height: CGFloat = AGImageAdjustmentCollectionViewCell.cellSize().height
        static let buttonOffset: CGFloat = 8.0
        static let buttonWidth: CGFloat = 54.0
    }
    
    lazy var configurator : AGAppConfigurator =
        {
            return  AGAppConfigurator()
    }()
    
    lazy var collectionView : AGImageAdjustmentCollectionView = { [unowned self] in
        let collectionView = AGImageAdjustmentCollectionView(frame: self.bounds, collectionViewLayout: nil)
            collectionView.imageAdjustmentDataSource = self
            collectionView.imageAdjustmentDelegate = self

        return collectionView
    }()
    
    lazy var okButton: UIButton = { [unowned self] in
        let button = UIButton()
            button.setTitle(self.configurator.okButtonTitle.capitalized, for: .normal)
            button.titleLabel?.font = self.configurator.okButtonFont
            button.isHidden = true
            button.addTarget(self, action: #selector(okButtonDidTouch(_:)), for: .touchUpInside)
            button.contentHorizontalAlignment = .center
        return button
        }()

    lazy var cancelButton: UIButton = { [unowned self] in
        let button = UIButton()
            button.setTitle(self.configurator.cancelButtonTitle.capitalized, for: .normal)
            button.titleLabel?.font = self.configurator.okButtonFont
            button.isHidden = true
            button.addTarget(self, action: #selector(cancelButtonDidTouch(_:)), for: .touchUpInside)
            button.contentHorizontalAlignment = .center
        return button
    }()
    
    lazy var sliderValueLabel: UILabel = { [unowned self] in
        let sliderValueLabel = UILabel()
            sliderValueLabel.font = self.configurator.sliderValueFont
            sliderValueLabel.isHidden = true
            sliderValueLabel.textColor = .white
            sliderValueLabel.text = "0"        
        return sliderValueLabel
    }()
    
    lazy var slider : AGCustomSlider = { [unowned self] in
        let slider = AGCustomSlider.create()
            slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    lazy var adjustmentMenuItems : [AGAdjustmentMenuItem] = { [unowned self] in
        return self.dataSource?.adjustmentMenuItems() ?? []
    }()
    
    var selectedItem : AGAdjustmentMenuItem? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureImageAdjustmentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show (toShow : Bool, withAnimation : Bool) {
        self.showWithAnimation(isShown: toShow, animated: withAnimation)
    }
    
    func sliderValueChanged (_ slider : UISlider) {
        guard let item = self.selectedItem else { return }
        
        self.sliderValueLabel.text = "\(Int(slider.value))"
        if (item.currentValue != slider.value)
        {
            item.currentValue = slider.value
            self.delegate?.updateImageAdjustment(view: self, adjustmentItem: item, value: Int(slider.value))
        }
    }
    
    func okButtonDidTouch (_ button : UIButton) {
        guard let item = self.selectedItem else { return }
        self.collectionView.reloadData()
        self.showSlider(isHidden: true)
        self.delegate?.applyFilterButtonDidTouch(view: self, adjustmentItem: item, value: Int(item.currentValue))
    }
    
    func cancelButtonDidTouch (_ button : UIButton) {
        guard let item = self.selectedItem else { return }
        item.currentValue = (item.lastValue == item.defaultValue) ? item.defaultValue : item.lastValue
        self.delegate?.updateImageAdjustment(view: self, adjustmentItem: item, value: Int(item.defaultValue))
        self.showSlider(isHidden: true)
        self.delegate?.cancelFilterButtonDidTouch(view: self)
    }
}

extension AGImageAdjustmentView
{
    fileprivate func configureImageAdjustmentView() {
        [cancelButton, okButton, sliderValueLabel, slider, collectionView].forEach {
            self.addSubview($0 as! UIView)
            ($0 as! UIView).translatesAutoresizingMaskIntoConstraints = false
        }
        self.setupConstraints()
    }
    
    fileprivate func updateSliderForItem (item : AGAdjustmentMenuItem)
    {
        self.slider.maximumValue = item.maxValue
        self.slider.minimumValue = item.minValue
        self.slider.value = item.currentValue
        self.sliderValueLabel.text = "\(Int(item.currentValue))"
        self.showSlider(isHidden: false)
    }
    
    fileprivate func showSlider (isHidden : Bool)
    {
        self.collectionView.hide(isHidden: !isHidden)
        [cancelButton, okButton, sliderValueLabel, slider].forEach {
            ($0 as! UIView).showWithAnimation(isShown: !isHidden, animated: true)
//            self.showWithAnimation(view: $0, toShow: !isHidden, animated: true)
        }
    }
    
    fileprivate func adjustmentMenuItemDidSelect ()
    {
        guard let item = self.selectedItem else { return }
        switch item.type {
        case .adjustmentDefault:
            self.delegate?.cancelAllFiltersButtonDidTouch(view: self)
            self.collectionView.reloadData()
            return
        case .adjustType:
            self.delegate?.beginImageRotation(view: self)
            break
        default:
            break
        }
        self.updateSliderForItem(item: self.selectedItem!)
        self.delegate?.adjustmentMenuItemDidSelect(view: self)
    }
}

extension AGImageAdjustmentView : AGImageAdjustmentCollectionViewDataSource
{
    func numberOfItemsInSection (section : Int) -> Int
    {
        return self.adjustmentMenuItems.count
    }
    
    func menuItemAtIndexPath (indexPath : IndexPath) -> AGAdjustmentMenuItem
    {
        return self.adjustmentMenuItems[indexPath.row]
    }
}

extension AGImageAdjustmentView : AGImageAdjustmentCollectionViewDelegate
{
    func selectedItem (atIndexPath indexPath: IndexPath)
    {
        self.selectedItem = self.adjustmentMenuItems[indexPath.row]
        self.adjustmentMenuItemDidSelect()
    }
}


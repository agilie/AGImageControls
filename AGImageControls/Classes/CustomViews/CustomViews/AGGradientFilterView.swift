//
//  AGGradientFilterView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 11.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGGradientFilterViewDelegate : class {
    
    func updateGradientFilter (view : AGGradientFilterView, gradientFilterItem : AGGradientFilterItemModel, value : Int)
    func applyGradientFilterButtonDidTouch (view : AGGradientFilterView, gradientFilterItem : AGGradientFilterItemModel, value : Int)
    
    func cancelGradientFilterButtonDidTouch (view : AGGradientFilterView)
    func gradientFilterDidChange (view : AGGradientFilterView, newItem : AGGradientFilterItemModel)
    func cancelAllGradientFiltersButtonDidTouch(view : AGGradientFilterView)
}

protocol AGGradientFilterViewDataSource : class {
    func gradientFilterItems () -> [AGGradientFilterItemModel]
}

class AGGradientFilterView: UIView {
    
    weak var delegate   : AGGradientFilterViewDelegate?
    weak var dataSource : AGGradientFilterViewDataSource?
    
    var selectedItem : AGGradientFilterItemModel? = nil

    struct ViewSizes {
        static let height: CGFloat = AGGradientFilterCollectionViewCell.cellSize().height
        static let buttonOffset: CGFloat = 8.0
        static let buttonWidth: CGFloat = 54.0
    }
    
    lazy var configurator : AGAppConfigurator =
        {
            return  AGAppConfigurator()
    }()
    
    lazy var collectionView : AGGradientFilterCollectionView = { [unowned self] in
        let collectionView = AGGradientFilterCollectionView(frame: self.bounds, collectionViewLayout: nil)
            collectionView.gradientFilterDataSource = self
            collectionView.gradientFilterDelegate = self
        
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
            button.setTitle(self.configurator.cancelButtonTitle, for: .normal)
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
    
    lazy var gradientFilterItems : [AGGradientFilterItemModel] = { [unowned self] in
        return self.dataSource?.gradientFilterItems() ?? []
        }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureImageAdjustmentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func needToShowWithAnimation (isShown : Bool, animated : Bool) {
        self.showWithAnimation(view: self, isShown: isShown, animated: animated)
    }
    
    func sliderValueChanged (_ slider : UISlider) {
        guard let item = self.selectedItem else { return }
        
        self.sliderValueLabel.text = "\(Int(slider.value))"
        if (item.currentValue != slider.value)
        {
            item.currentValue = slider.value
            self.delegate?.updateGradientFilter(view: self, gradientFilterItem: item, value: Int(slider.value))
        }
    }
    
    func okButtonDidTouch (_ button : UIButton) {
        guard let item = self.selectedItem else { return }
        
        self.showSlider(isHidden: true)
        self.delegate?.applyGradientFilterButtonDidTouch(view: self, gradientFilterItem: item, value: Int(item.currentValue))
    }
    
    func cancelButtonDidTouch (_ button : UIButton) {
        guard let item = self.selectedItem else { return }
        
        self.delegate?.updateGradientFilter(view: self, gradientFilterItem: item, value: Int(item.defaultValue))
        self.showSlider(isHidden: true)
        self.delegate?.cancelGradientFilterButtonDidTouch(view: self)
    }
}

extension AGGradientFilterView
{
    fileprivate func configureImageAdjustmentView() {
        [collectionView, cancelButton, okButton, sliderValueLabel, slider].forEach {
            self.addSubview($0 as! UIView)
            ($0 as! UIView).translatesAutoresizingMaskIntoConstraints = false
        }
        self.setupConstraints()
    }
    
    fileprivate func showWithAnimation (view : UIView, isShown : Bool, animated : Bool)
    {
        if (isShown) { view.isHidden = !isShown }
        
        UIView.animate(withDuration: animated ? 0.245 : 0.0, animations: {
            view.alpha = isShown ? 1.0 : 0.0
        }) { (isFinished) in
            if (!isShown) {
                view.isHidden = !isShown
            }
        }
    }
    
    fileprivate func updateSliderForItem (item : AGGradientFilterItemModel)
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
        [okButton, cancelButton, sliderValueLabel, slider].forEach {
            self.showWithAnimation(view: $0, isShown: !isHidden, animated: true)
        }
    }
    
    fileprivate func adjustmentMenuItemDidSelect ()
    {
        guard let item = self.selectedItem else { return }
        
        switch item.type {
        case .gradientDefault:
            self.delegate?.cancelAllGradientFiltersButtonDidTouch(view: self)
            return
        default:
            break
        }
        self.delegate?.gradientFilterDidChange(view: self, newItem: item)
        self.updateSliderForItem(item: item)
    }
}

extension AGGradientFilterView : AGGradientFilterCollectionViewDataSource
{
    func numberOfItemsInSection (section : Int) -> Int
    {
        return self.gradientFilterItems.count
    }
    
    func menuItemAtIndexPath (indexPath : IndexPath) -> AGGradientFilterItemModel
    {
        return self.gradientFilterItems[indexPath.row]
    }
}

extension AGGradientFilterView : AGGradientFilterCollectionViewDelegate
{
    func selectedItem (atIndexPath indexPath: IndexPath)
    {
        self.selectedItem = self.gradientFilterItems[indexPath.row]
        self.selectedItem?.currentValue = self.gradientFilterItems[indexPath.row].lastValue
        self.adjustmentMenuItemDidSelect()
    }
}

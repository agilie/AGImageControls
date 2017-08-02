//
//  AGCustomSlider.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 27.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGCustomSlider: UISlider {

    lazy var configurator : AGAppConfigurator =
        {
            return  AGAppConfigurator.sharedInstance
    }()


    open class func create () -> AGCustomSlider
    {
        let slider = AGCustomSlider()
        
        slider.thumbTintColor = .white
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .white
        slider.minimumValue = -100
        slider.maximumValue = 100
        
        slider.value = 0
        slider.isHidden = true
        
        slider.setThumbImage(AGAppResourcesService.getImage(slider.configurator.sliderThumbIcon), for: .normal)
        slider.setThumbImage(AGAppResourcesService.getImage(slider.configurator.sliderThumbIcon), for: .highlighted)
        slider.setThumbImage(AGAppResourcesService.getImage(slider.configurator.sliderThumbIcon), for: .selected)
        
        return slider
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.trackRect(forBounds: bounds)
            result.origin.x = 0
            result.size.width = bounds.size.width
            result.size.height = 1
        return result
    }

    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        return super.thumbRect(forBounds: bounds, trackRect: rect, value: value).offsetBy(dx: 0, dy: 2)
    }
}

//
//  AGScrollImageMaskView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 10.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGScrollImageMaskView: UIView {

    lazy var portalRectOffset: CGFloat = { [unowned self] in
        let bounds = UIScreen.main.bounds
        let x = -(self.bottomOffset * bounds.width) / (bounds.width - 2 * bounds.height)
        return x
    }()
    
    lazy var portalRect : CGRect = { [unowned self] in
        let bounds = UIScreen.main.bounds
        let h = bounds.height - self.bottomOffset - self.portalRectOffset
        let w = bounds.width - self.portalRectOffset * 2
        
        let portalRect = CGRect( x: self.portalRectOffset, y: self.portalRectOffset, width: w, height: h)
        return portalRect
        }()

    let bottomOffset : CGFloat = 150.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        self.drawRectangle(context: context, rect: rect)
    }
}

extension AGScrollImageMaskView
{
    fileprivate func drawRectangle (context: CGContext, rect : CGRect) {
        let outterFill = UIBezierPath(rect: rect)
        let color = UIColor.init(white: 0.0, alpha: 0.4)
            color.setFill()
       
        let portal = UIBezierPath(roundedRect: portalRect, cornerRadius: 0)
       
        outterFill.append(portal)
        outterFill.usesEvenOddFillRule = true
        outterFill.fill()
    }
}

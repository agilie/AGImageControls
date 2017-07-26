//
//  AGGradientView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 26.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

class AGGradientView: UIView {
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        self.addLinearGradient(context: context)
    }
    
    fileprivate func addLinearGradient ( context : CGContext)
    {
        let colors = [UIColor.clear.cgColor,
                      UIColor.black.cgColor] as CFArray
        
        if let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        {
            context.drawLinearGradient(gradient,
                                       start: CGPoint(x: 0, y: 0),
                                       end:  CGPoint(x : 0, y : self.frame.height),
                                       options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        }
    }
    
    func updateHeight (viewController : AGMainViewController, height : CGFloat)
    {
        if (viewController.gradientViewHeightConstraint?.constant != height) {
            self.updateHeightWithAnimation(viewController: viewController, height: height)
        }
    }    
}

extension AGGradientView
{
    fileprivate func updateHeightWithAnimation (viewController : AGMainViewController, height : CGFloat)
    {
        UIView.animate(withDuration: 0.245) {
            viewController.gradientViewHeightConstraint?.constant = height
            viewController.view.layoutIfNeeded()
            self.setNeedsDisplay()
        }
    }
}

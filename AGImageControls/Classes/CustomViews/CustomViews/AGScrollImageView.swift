//
//  AGScrollImageView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 10.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGScrollImageViewDataSource : class
{
    func image (view : AGScrollImageView) -> UIImage?
}

class AGScrollImageView: UIView {
    
    weak var dataSource : AGScrollImageViewDataSource?

    var lastVisibleRect : CGRect = CGRect.zero
    
    var needToScroll : Bool = false
    
    lazy var imageView: UIImageView = { [unowned self] in
        
        let imageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .clear
        return imageView
        }()
    
    lazy var gradientImageView: UIImageView = { [unowned self] in
        
        let imageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .clear
        
        return imageView
        }()
    
    lazy var scrollView: UIScrollView = { [unowned self] in
        let scrollView = UIScrollView()
//            scrollView.delegate = self
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureScrollImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.configureScrollView(image: self.dataSource?.image(view: self))
    }
    
    func rotateImage (angle : Int) {
        self.rotateImageViewByAngle(angle: CGFloat(angle))
    }
    
    func updateImage (image : UIImage?) {
        self.imageView.image = image
    }
    
    func updateGradientFilterImage (gradientFilterItem : AGGradientFilterItemModel) {
        if self.gradientImageView.image == nil
        {
            self.gradientImageView.image = AGAssetsService.getImage(gradientFilterItem.imageName)
        }
        self.gradientImageView.alpha = CGFloat(gradientFilterItem.currentValue / 100.0)
    }
    
    func removeGradientFilterImage () {
        self.gradientImageView.image = nil
    }

    func rotationDidStart (viewController : AGImageEditingViewController) {
        
    }
}

extension AGScrollImageView
{
    fileprivate func configureScrollImageView () {
        for subview in [scrollView/*, scrollImageMaskView*/] as [UIView]
        {
            self.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        self.setupConstraints()
    }
    
    fileprivate func configureScrollView (image : UIImage?) {
        guard let newImage = image else { return }
        
        for subview in scrollView.subviews
        {
            subview.removeFromSuperview()
        }
        self.scrollView.contentSize = UIScreen.main.bounds.size
        
        for view in [imageView, gradientImageView]
        {
            view.frame.size = self.scrollView.contentSize
            self.scrollView.addSubview(view)
        }
        
        self.imageView.image = newImage
        self.scrollView.scrollRectToVisible(CGRect (x: (self.scrollView.contentSize.width - UIScreen.main.bounds.width) / 2,
                                                    y: (self.scrollView.contentSize.height - UIScreen.main.bounds.height) / 2,
                                                    width: UIScreen.main.bounds.width,
                                                    height: UIScreen.main.bounds.height), animated: false)
    }

    fileprivate func scaleToFill (containerSize : CGSize, contentSize : CGSize, atAngle angle : CGFloat) -> CGFloat {
        
        let h = contentSize.height
        let H = containerSize.height
        let w = contentSize.width
        let W = containerSize.width
        
        let scale1 = (H*cos(fabs(angle)) + W*sin(fabs(angle)))/h
        let scale2 = (H*sin(fabs(angle)) + W*cos(fabs(angle)))/w
        
        let scaleFactor = max(scale1, scale2)
        return scaleFactor
    }
    
    func rotateImageViewByAngle (angle : CGFloat) {
        let angleRad = AGMathHelper.rad(fromDegrees: fabs(angle))
        
        let scaledFactor = self.scaleToFill(containerSize: self.bounds.size,
                                            contentSize: self.imageView.bounds.size,
                                            atAngle: angleRad) * 1.2
        
        let newScrollHeight = self.bounds.height * scaledFactor * angleRad
        let newScrollWidth = self.bounds.width * scaledFactor * angleRad
        ////
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width + newScrollWidth,
                                             height: self.scrollView.frame.size.height + newScrollHeight)
        
        let rotation = CGAffineTransform.init(rotationAngle: AGMathHelper.rad(fromDegrees: angle))
        
        let rotationAndScaled =  rotation.scaledBy(x: CGFloat(scaledFactor),
                                                   y: CGFloat(scaledFactor))
        
        self.imageView.transform = rotationAndScaled
        self.gradientImageView.transform = rotationAndScaled

        self.scrollView.contentSize = self.imageView.frame.size

        self.imageView.center = CGPoint(x : self.scrollView.contentSize.width / 2,
                                        y : self.scrollView.contentSize.height / 2)
        self.gradientImageView.center = self.imageView.center

        self.scrollView.scrollRectToVisible(CGRect(x : (self.scrollView.contentSize.width - self.imageView.bounds.size.width) / 2,
                                                   y : (self.scrollView.contentSize.height - self.imageView.bounds.size.height) / 2,
                                                   width : self.imageView.bounds.size.width,
                                                   height: self.imageView.bounds.size.height), animated: false)
    }
}


/*
extension AGScrollImageView : UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var scrollVisibleRect = CGRect.zero
            scrollVisibleRect.origin = scrollView.contentOffset
            scrollVisibleRect.size = scrollView.frame.size

        let topLeftPoint = scrollVisibleRect.origin
        let topRightPoint = CGPoint (x : scrollVisibleRect.origin.x + scrollVisibleRect.size.width, y: scrollVisibleRect.origin.y)
        let bottomLeftPoint = CGPoint (x : scrollVisibleRect.origin.x, y: scrollVisibleRect.origin.y + scrollVisibleRect.size.height)
        let bottomRightPoint = CGPoint (x : scrollVisibleRect.origin.x + scrollVisibleRect.size.width, y: scrollVisibleRect.origin.y + scrollVisibleRect.size.height)
        
        let triangle1 : AGTriangleStruct = AGTriangleStruct.init(point1: self.imageView.newTopLeft(),
                                                                 point2: self.imageView.newBottomLeft(),
                                                                 point3: self.imageView.topLeft())
        
        
        let triangle2 : AGTriangleStruct = AGTriangleStruct.init(point1: self.imageView.bottomLeft() ,
                                                                 point2: self.imageView.newBottomLeft(),
                                                                 point3: self.imageView.newBottomRight())
        
        
        let triangle3 : AGTriangleStruct = AGTriangleStruct.init(point1: self.imageView.topRight(),
                                                                 point2: self.imageView.newTopRight(),
                                                                 point3: self.imageView.newTopLeft())
        
        let triangle4 : AGTriangleStruct = AGTriangleStruct.init(point1: self.imageView.bottomRight(),
                                                                 point2: self.imageView.newBottomRight(),
                                                                 point3: self.imageView.newTopRight())
        
        if (AGMathHelper.isTriangleContainsPoint(triangle: triangle1, point: topLeftPoint)) ||
            (AGMathHelper.isTriangleContainsPoint(triangle: triangle2, point: bottomLeftPoint)) ||
            (AGMathHelper.isTriangleContainsPoint(triangle: triangle3, point: topRightPoint)) ||
            (AGMathHelper.isTriangleContainsPoint(triangle: triangle4, point: bottomRightPoint))
        {
            self.needToScroll = true
        } else {
            self.needToScroll = false
            self.lastVisibleRect = scrollVisibleRect
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.needToScroll {
            self.scrollView.setContentOffset(self.lastVisibleRect.origin, animated: false)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) { // called on finger up as we are moving
        if self.needToScroll {
            self.scrollView.setContentOffset(self.lastVisibleRect.origin, animated: true)
        }

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.needToScroll {
            self.scrollView.setContentOffset(self.lastVisibleRect.origin, animated: true)
        }
    }
}
*/

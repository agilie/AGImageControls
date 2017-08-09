//
//  AGMainViewController.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 14.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

open class AGMainViewController: UIViewController {

    var navigationViewTopConstraint : NSLayoutConstraint? = nil
   
    var gradientViewHeightConstraint : NSLayoutConstraint? = nil

    lazy var navigationView : AGNavigationView = { [unowned self] in
        let navigationView = AGNavigationView()
            navigationView.doneButton.isHidden = false
            navigationView.delegate = self
        return navigationView
    }()
    
    lazy var gradientView : AGGradientView = { [unowned self] in
        let gradientView = AGGradientView.init(frame: CGRect(x: 0, y: 0, width : screenSize.width, height: 0))
            gradientView.backgroundColor = .clear
            gradientView.tintColor = .clear
            gradientView.setNeedsDisplay()
        
        return gradientView
    }()
    
    lazy var activityView: UIActivityIndicatorView = { [unowned self] in
        let view = UIActivityIndicatorView()
            view.activityIndicatorViewStyle = .whiteLarge
            view.alpha = 0.0
        return view
    }()
    
    lazy var blurView: UIVisualEffectView = { [unowned self] in
        let effect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: effect)
            blurView.frame = self.view.bounds
        return blurView
    }()

    lazy var configurator : AGAppConfigurator =
        {
            return  AGAppConfigurator.sharedInstance
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Rotation
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - StatusBar
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func  activityViewAnimated (isAnimated : Bool) {
        self.activityView.center = self.view.center
        self.view.isUserInteractionEnabled = !isAnimated
        isAnimated ? self.activityView.startAnimating() : self.activityView.stopAnimating()
        UIView.animate(withDuration: 0.245, animations: {
            self.activityView.alpha = isAnimated ? 1.0 : 0.0
        })
    }
}

extension AGMainViewController : AGNavigationViewDelegate
{
    func navigationViewBackButtonDidTouch (view : AGNavigationView) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func navigationViewDoneButtonDidTouch (view : AGNavigationView)
    {

    }
}

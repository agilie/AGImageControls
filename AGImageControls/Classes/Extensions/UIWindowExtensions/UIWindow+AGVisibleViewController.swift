//
//  UIWindow+AGVisibleViewController.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 24.07.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

public extension UIWindow {
    public var visibleViewController: UIViewController? {
        let appDelegate  = UIApplication.shared.delegate
        return UIWindow.getVisibleViewControllerFrom(appDelegate?.window??.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

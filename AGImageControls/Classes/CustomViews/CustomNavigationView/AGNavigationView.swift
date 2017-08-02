//
//  AGNavigationView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 23.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGNavigationViewDelegate: class {
    func navigationViewBackButtonDidTouch (view : AGNavigationView)
    func navigationViewDoneButtonDidTouch (view : AGNavigationView)
}

extension AGNavigationViewDelegate
{
    func navigationViewDoneButtonDidTouch (view : AGNavigationView) {}
}

class AGNavigationView: UIView {
    
    weak var delegate: AGNavigationViewDelegate?

    struct ViewSizes {
        static let leftOffset: CGFloat = 10
        static let rightOffset: CGFloat = 10
        static let buttonHeight: CGFloat = 42
        static let buttonWidth: CGFloat = 50
        static let viewHeight: CGFloat = 48
    }
    
    lazy var configurator : AGAppConfigurator =
        {
            return  AGAppConfigurator.sharedInstance
    }()

    lazy var backButton: UIButton = { [unowned self] in
        let button = UIButton()
            button.setImage(AGAppResourcesService.getImage(self.configurator.backButtonIcon), for: .normal)
            button.addTarget(self, action: #selector(backButtonDidTouch(_:)), for: .touchUpInside)
            button.contentHorizontalAlignment = .center
        return button
    }()

    lazy var doneButton: UIButton = { [unowned self] in
        let button = UIButton()
            button.setTitle(self.configurator.doneButtonTitle, for: .normal)
            button.titleLabel?.font = self.configurator.doneButtonFont
            button.isHidden = true
            button.addTarget(self, action: #selector(doneButtonDidTouch(_:)), for: .touchUpInside)
            button.contentHorizontalAlignment = .center
        return button
    }()
    
    public init() {
        super.init(frame: .zero)
        configureNavigationView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureNavigationView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Button Actions
    
    func backButtonDidTouch( _ button : UIButton) {
        self.delegate?.navigationViewBackButtonDidTouch(view: self)
    }
    
    func doneButtonDidTouch( _ button : UIButton) {
        self.delegate?.navigationViewDoneButtonDidTouch(view: self)
    }
    
    func show (viewController : AGMainViewController) {
        self.hideWithAnimation(viewController: viewController, isHidden: false)
    }
    
    func hide (viewController : AGMainViewController) {
        self.hideWithAnimation(viewController: viewController, isHidden: true)
    }
}

extension AGNavigationView
{
    fileprivate func configureNavigationView () {
        self.backgroundColor = .black
        self.alpha = 0.4
        [backButton, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        setupConstraints()
    }
    
    fileprivate func hideWithAnimation (viewController : AGMainViewController, isHidden : Bool) {
        UIView.animate(withDuration: 0.245) {
            viewController.navigationViewTopConstraint?.constant = isHidden ? -ViewSizes.viewHeight : 0
            viewController.view.layoutIfNeeded()
        }
    }
}

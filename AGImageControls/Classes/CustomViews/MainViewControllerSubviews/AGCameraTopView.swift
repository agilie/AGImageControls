//
//  AGCameraTopView.swift
//  AGPosterSnap
//
//  Created by Michael Liptuga on 21.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

protocol AGCameraTopViewDelegate: class {
    func cameraTopView (view : AGCameraTopView, flashButtonDidPress title: String)
}

class AGCameraTopView: UIView {
    
    weak var delegate: AGCameraTopViewDelegate?

    struct ViewSizes {
        static let leftOffset: CGFloat = 11
        static let rightOffset: CGFloat = 16
        static let height: CGFloat = 48
        static let width: CGFloat = 44
    }
    
    lazy var configurator : AGAppConfigurator =
        {
            return  AGAppConfigurator()
    }()

    lazy var flashButtonTitles : [String] =
    { [unowned self] in
       return [self.configurator.flashButtonAutoTitle, self.configurator.flashButtonOnTitle, self.configurator.flashButtonOffTitle]
    }()
    
    lazy var buttonSelectedColor : UIColor =
        { [unowned self] in
        return self.configurator.flashButtonSelectedColor
    }()
    
    lazy var flashButton: UIButton = { [unowned self] in
        let button = UIButton()
            button.setImage(AGAssetsService.getImage("flash_" + self.flashButtonTitles[0].lowercased() + "_icon"), for: UIControlState())
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = self.configurator.flashButtonFont
            button.addTarget(self, action: #selector(flashButtonDidPress(_:)), for: .touchUpInside)
            button.contentHorizontalAlignment = .center
        return button
    }()
    
    lazy var flashAutoButton: UIButton = { [unowned self] in
        let button = UIButton()
        self.configureButton (button : button,
                              title : self.flashButtonTitles[0],
                              selector : #selector(flashAutoButtonDidPress(_:)))
        button.isSelected = true
        return button
        }()
    
    lazy var flashOnButton: UIButton = { [unowned self] in
        let button = UIButton()
        self.configureButton (button : button,
                              title : self.flashButtonTitles[1],
                              selector : #selector(flashOnButtonDidPress(_:)))
        return button
        }()

    lazy var flashOffButton: UIButton = { [unowned self] in
        let button = UIButton()
        self.configureButton (button : button,
                              title : self.flashButtonTitles[2],
                              selector : #selector(flashOffButtonDidPress(_:)))
        return button
        }()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCameraTopView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Button Action methods
    
    func flashOnButtonDidPress (_ button : UIButton)
    {
        self.buttonDidTouch(button: button)
    }
    
    func flashOffButtonDidPress (_ button : UIButton)
    {
        self.buttonDidTouch(button: button)
    }

    func flashAutoButtonDidPress (_ button : UIButton)
    {
        self.buttonDidTouch(button: button)
    }
    
    func flashButtonDidPress(_ button: UIButton) {
        self.flashButton.isSelected = !button.isSelected
        self.showButtons(isHidden: !button.isSelected)
    }
    
    func hideAllButtons (isHidden: Bool)
    {
        self.flashButton.isHidden = isHidden
        self.showButtons(isHidden: true)
    }
}

extension AGCameraTopView
{
    
    func configureCameraTopView () {
        self.backgroundColor = .black
        self.alpha = 0.4
        [flashButton, flashAutoButton, flashOnButton, flashOffButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        self.showButtons(isHidden: true)
        setupConstraints()
    }

    fileprivate func buttonDidTouch (button : UIButton)
    {
        if button.isSelected == true {
            self.showButtons(isHidden: true)
            return
        }
        
        [flashAutoButton, flashOnButton, flashOffButton].forEach {
            if $0 == button {
                $0.isSelected = !button.isSelected
                $0.setTitleColor(self.buttonSelectedColor, for: .selected)
            } else {
                $0.isSelected = false
            }
        }
        self.showButtons(isHidden: true)
        self.updateFlashButton(newTitle: button.titleLabel?.text)
    }
    
    fileprivate func updateFlashButton (newTitle : String?)
    {
        guard let title = newTitle else {
            return
        }
        self.flashButton.setImage(AGAssetsService.getImage("flash_" + title.lowercased() + "_icon"), for: UIControlState())
        self.delegate?.cameraTopView(view: self, flashButtonDidPress: title.uppercased())
    }
    
    fileprivate func showButtons (isHidden : Bool) {
        self.flashButton.isSelected = !isHidden
        [flashAutoButton, flashOnButton, flashOffButton].forEach {
            $0.isHidden = isHidden
        }
    }
    
    fileprivate func configureButton (button : UIButton, title : String, selector : Selector)
    {
        button.setTitle(title.lowercased(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(self.buttonSelectedColor, for: .selected)
        button.titleLabel?.font = self.configurator.flashButtonFont
        button.addTarget(self, action: (selector), for: .touchUpInside)
        button.contentHorizontalAlignment = .center
    }
}

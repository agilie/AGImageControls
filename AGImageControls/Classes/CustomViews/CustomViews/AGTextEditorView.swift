//
//  AGTextEditorView.swift
//  Pods
//
//  Created by Michael Liptuga on 28.07.17.
//
//

import UIKit

protocol AGTextEditorViewDelegate : class {
    func doneButtonDidTouch (textEditorView : AGTextEditorView, text : String)
}

class AGTextEditorView: UIView {
    
    weak var delegate : AGTextEditorViewDelegate? = nil
    
    struct ViewSizes {
        static let size = UIScreen.main.bounds.size
        static let keyboardSize = CGSize.zero
        static let textViewLeftTopPoint = CGPoint (x: 0, y: AGNavigationView.ViewSizes.viewHeight)
        static let textViewRightLeftOffset : CGFloat = 16.0
    }
        
    lazy var configurator : AGAppConfigurator =
        {
            return  AGAppConfigurator()
    }()

    lazy var navigationView : AGNavigationView = { [unowned self] in
        let navigationView = AGNavigationView()
            navigationView.doneButton.isHidden = false
            navigationView.delegate = self
        
        return navigationView
    }()
    
    lazy var textView: UITextView = { [unowned self] in
        let textView = UITextView()
        
            textView.font = self.configurator.captionTextButtonFont
            textView.textColor = .white
            textView.backgroundColor = .clear
            textView.returnKeyType = .done
            textView.delegate = self
        
            textView.becomeFirstResponder()
        
        return textView
    }()
    
    var placeholder : String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureTextEditorView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func subscribeToKeyboardNotification () {
        NotificationCenter.default.addObserver(self, selector: #selector(AGTextEditorView.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func removeKeyboardNotificationObserver () {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow (_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIKeyboardFrameBeginUserInfoKey] as? CGRect else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.textView.contentInset = contentInsets
    }
    
    func showWithText (text : String?, placeholder : String, font : AGFontEditorItem) {
        self.subscribeToKeyboardNotification()
        self.textView.font = font.font.withSize(font.minFontSize)
        self.placeholder = placeholder
        self.configureTextView(text : text ?? "", placeholder: placeholder)
        self.showWithAnimation(isShown: true, animated: true)
        self.textView.becomeFirstResponder()
    }
    
    func hide () {
        self.endEditing(true)
        self.removeKeyboardNotificationObserver()
        self.delegate?.doneButtonDidTouch(textEditorView: self, text: self.textView.text)
        self.showWithAnimation(isShown: false, animated: true)
    }
    
    func configureTextView (text : String, placeholder : String) {
        if text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || text == placeholder {
            self.configurePlaceholderMode()
        } else {
            self.configureEditMode()
            self.textView.text = text
        }
    }
}

extension AGTextEditorView
{
    func configureTextEditorView () {
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.4)
        self.subscribeToKeyboardNotification()
        [navigationView, textView].forEach{
            ($0 as! UIView).translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0 as! UIView)
        }
        self.setupConstraints()
    }
    
    func configurePlaceholderMode () {
        self.textView.text = self.placeholder
        self.textView.textColor = UIColor.init(white: 1.0, alpha: 0.5)
        self.textView.tag = 0
    }
    
    func configureEditMode () {
        if self.textView.tag == 0 {
            self.textView.text = ""
        }
        self.textView.textColor = .white
        self.textView.tag = 1
    }
    
}

extension AGTextEditorView : UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView){
        if textView.tag == 0 {
            DispatchQueue.main.async {
                textView.selectedRange = NSMakeRange(0, 0)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.configurePlaceholderMode()
            DispatchQueue.main.async {
                textView.selectedRange = NSMakeRange(0, 0)
            }
        } else {
            self.configureEditMode()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            self.hide()
            return true
        }

        if (textView.text.characters.count >= 200 && text != "") || (text == " " || text == "") && textView.tag == 0 {
            return false
        }
        self.configureEditMode()
        return true
    }

}

extension AGTextEditorView : AGNavigationViewDelegate
{
    func navigationViewBackButtonDidTouch (view : AGNavigationView) {
        self.hide()
    }
}

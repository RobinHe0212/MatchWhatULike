//
//  SettingProfileViewController.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/15/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class SettingProfileViewController: UIViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGradientLayer()
        setUpLayout()
        setUpKeyboardObserver()
        setUpTapGesture()
        setUpFormValidObserver()
    }
    
    @objc func tapDismissKeyboard(){
        
        self.view.endEditing(true)
    }
    
    let selectBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Select Photo", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 12
        btn.backgroundColor = .white
        btn.heightAnchor.constraint(equalToConstant: 350).isActive = true
        return btn

    }()
    
    let registerViewModel = RegisterViewModel()
    
    let nameTextField : PaddingTextField = {
        
        let tf = PaddingTextField(padding: 16)
        tf.placeholder = "Enter full name"
        tf.keyboardType = UIKeyboardType.namePhonePad
        tf.addTarget(self, action: #selector(checkTextFieldObserver), for: .editingChanged)
        return tf

    }()
    
    @objc func checkTextFieldObserver(textField:UITextField){
        if textField == nameTextField {
            registerViewModel.name = textField.text
            
        }else if textField == emailTextField {
            registerViewModel.email = textField.text
            
        }else if textField == passwordTextField {
            registerViewModel.password = textField.text
            
        }
        
    }
    
    
    let emailTextField : PaddingTextField = {
        
        let tf = PaddingTextField(padding: 16)
        tf.placeholder = "Enter email"
        tf.keyboardType = UIKeyboardType.emailAddress
        tf.addTarget(self, action: #selector(checkTextFieldObserver), for: .editingChanged)

        return tf
        
    }()
    
    
    let passwordTextField : PaddingTextField = {
        
        let tf = PaddingTextField(padding: 16)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(checkTextFieldObserver), for: .editingChanged)

        return tf
        
    }()
    
    lazy var registerBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        btn.titleLabel?.textAlignment = .center
        btn.isEnabled = false
        btn.backgroundColor = .lightGray
        btn.layer.cornerRadius = 20
        btn.setTitleColor(#colorLiteral(red: 0.3616387844, green: 0.3566553593, blue: 0.3610489368, alpha: 1), for: .normal)

        self.btnHeightContraint = btn.heightAnchor.constraint(equalToConstant: 45)
        self.btnHeightContraint.isActive = true
        return btn
        
        
        
    }()
    
    var btnHeightContraint : NSLayoutConstraint!
    
    let gradientLayer = CAGradientLayer()


    fileprivate func setUpGradientLayer(){
        
        let topClw = #colorLiteral(red: 0.9894037843, green: 0.3799418807, blue: 0.3735582829, alpha: 1)
        let bottomClw = #colorLiteral(red: 0.8940606117, green: 0.1057207957, blue: 0.4612489939, alpha: 1)
        gradientLayer.colors = [topClw.cgColor , bottomClw.cgColor]
        gradientLayer.locations = [0,1]
        gradientLayer.frame = self.view.bounds
        self.view.layer.addSublayer(gradientLayer)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact{
            self.btnHeightContraint.isActive = false
            overallStackView.distribution = .fillEqually
            verticalStackView.spacing = 15
            overallStackView.axis = .horizontal
        }else if self.traitCollection.verticalSizeClass == .regular {
            overallStackView.axis = .vertical
            overallStackView.distribution = .fill
            verticalStackView.spacing = 8



        }
    }
    
    lazy var verticalStackView : UIStackView = {
        let vs = UIStackView(arrangedSubviews: [
            nameTextField,
            emailTextField,
            passwordTextField,
            registerBtn
            
            ])
       
        
        vs.axis = .vertical
        vs.distribution = UIStackView.Distribution.fillEqually
        vs.spacing = 8
        
        return vs
        
        
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectBtn,
       self.verticalStackView
        
        ])
    
    // when u roate screen , view need to be relayout
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    
    fileprivate func setUpLayout(){
        
        overallStackView.axis = .vertical
        overallStackView.spacing = 8
        self.view.addSubview(overallStackView)
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30))
        overallStackView.centerYInSuperview()
    }
    
    fileprivate func setUpTapGesture() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDismissKeyboard)))
    }
    
    fileprivate func setUpFormValidObserver(){
        
        
        registerViewModel.isFormValidObserver = { [unowned self] (isValid) in
            print(isValid)
            self.registerBtn.isEnabled = isValid
            self.registerBtn.backgroundColor = isValid ?  #colorLiteral(red: 0.8131607771, green: 0.09644565731, blue: 0.3356440663, alpha: 1) : .lightGray
            if isValid {
                self.registerBtn.setTitleColor(.white, for: .normal)
            }else {
                self.registerBtn.setTitleColor(#colorLiteral(red: 0.3616387844, green: 0.3566553593, blue: 0.3610489368, alpha: 1), for: .normal)
            }
            
            
        }
        
    }
    
    fileprivate func setUpKeyboardObserver(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardHandler(notification : Notification ){
        guard let data = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardHeight = data.cgRectValue.height
        let topSpace = overallStackView.frame.origin.y
        let height = overallStackView.frame.height
        let pushHeight = keyboardHeight - (self.view.frame.height - topSpace - height)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: -pushHeight - 8)

        }, completion: nil)
        
        
    }
    
    @objc func keyboardDismiss(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        }, completion: nil)
    }

}

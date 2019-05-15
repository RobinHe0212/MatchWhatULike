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
    
    let nameTextField : PaddingTextField = {
        
        let tf = PaddingTextField(padding: 16)
        tf.placeholder = "Enter full name"
        tf.keyboardType = UIKeyboardType.namePhonePad
        return tf

    }()
    
    
    let emailTextField : PaddingTextField = {
        
        let tf = PaddingTextField(padding: 16)
        tf.placeholder = "Enter email"
        tf.keyboardType = UIKeyboardType.emailAddress
        return tf
        
    }()
    
    
    let passwordTextField : PaddingTextField = {
        
        let tf = PaddingTextField(padding: 16)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        return tf
        
    }()
    
    let registerBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = #colorLiteral(red: 0.8131607771, green: 0.09644565731, blue: 0.3356440663, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 20
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return btn
        
        
        
    }()

    fileprivate func setUpGradientLayer(){
        
        let gradientLayer = CAGradientLayer()
        let topClw = #colorLiteral(red: 0.9894037843, green: 0.3799418807, blue: 0.3735582829, alpha: 1)
        let bottomClw = #colorLiteral(red: 0.8940606117, green: 0.1057207957, blue: 0.4612489939, alpha: 1)
        gradientLayer.colors = [topClw.cgColor , bottomClw.cgColor]
        gradientLayer.locations = [0,1]
        gradientLayer.frame = self.view.bounds
        self.view.layer.addSublayer(gradientLayer)
        
    }
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectBtn,
        nameTextField,
        emailTextField,
        passwordTextField,
        registerBtn
        
        ])
    
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

//
//  LoginViewController.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/23/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol FinishLoginInDelegate {
    func finishLogin()
}


class LoginViewController: UIViewController {

   
    var delegate : FinishLoginInDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setUpGradientLayer()
        setUpOverallLayout()
        setUpKeyboard()
        setUpvalidRegister()
    }
    
    
    fileprivate func setUpKeyboard(){
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard)))
    }
    
    @objc func dismissKeyBoard(){
        view.endEditing(true)
    }
    
    fileprivate func setUpOverallLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            pswTextField,
            loginBtn
            
            ])
        stackView.axis = .vertical
        stackView.spacing = 12
        self.view.addSubview(stackView)
        stackView.anchor(top: nil, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30))
        stackView.centerYInSuperview()
        
        self.view.addSubview(registerLabel)
        registerLabel.anchor(top: nil, leading: self.view.leadingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: self.view.trailingAnchor)
    }
    
    
    fileprivate func setUpGradientLayer(){
        
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.9893737435, green: 0.3478936553, blue: 0.3745231032, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.9005827308, green: 0.1075962558, blue: 0.4557676911, alpha: 1)
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        gradientLayer.frame = self.view.bounds
        self.view.layer.addSublayer(gradientLayer)
        
        
        
    }
    
    
    let emailTextField : PaddingTextField = {
        let tf = PaddingTextField(padding: 16)
        tf.placeholder = "Enter email"
        tf.keyboardType = UIKeyboardType.emailAddress
        tf.addTarget(self, action: #selector(emailChange), for: .editingChanged)
        return tf

    }()
    
    let loginViewModel = LoginViewModel()
    
    @objc func emailChange(textField:UITextField){
        
        loginViewModel.email = textField.text
        
    }
    
    let pswTextField : PaddingTextField = {
        let tf = PaddingTextField(padding: 16)
        tf.placeholder = "Enter password"
        tf.keyboardType = UIKeyboardType.default
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(pswChange), for: .editingChanged)

        return tf
        
    }()
    
    @objc func pswChange(textField:UITextField){
        
        loginViewModel.password = textField.text
        
    }
    
    let loginBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Log In", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.6693089008, green: 0.666139245, blue: 0.6693861485, alpha: 1)
        btn.isEnabled = false
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        btn.titleLabel?.textAlignment = .center
        btn.layer.cornerRadius = 20
        btn.constrainHeight(constant: 45)
        btn.addTarget(self, action: #selector(touchLoginIn), for: .touchUpInside)
        return btn
        
        
    }()
    
    @objc func touchLoginIn(){
        
        loginViewModel.handleLogin { (err) in
            if err != nil {
                print("error is ",err)
                return
            }
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    lazy var registerLabel : UILabel = {
        let label = UILabel()
        label.text = "Go to Register"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToRegister)))
        return label
        
        
    }()
    
    @objc func goToRegister(){
        
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    let loginProgressHud : JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "login..."
        hud.dismiss(afterDelay: 3, animated: true)
        return hud
        
        
    }()
    
    fileprivate func setUpvalidRegister(){
        
        loginViewModel.formIsValidToProceed = {
       [unowned self]    (isValidForm) in
            if isValidForm {
                self.loginBtn.backgroundColor = #colorLiteral(red: 0.8132490516, green: 0.09731306881, blue: 0.3328936398, alpha: 1)
                self.loginBtn.isEnabled = true
                self.loginBtn.setTitleColor(.white, for: .normal)

                
            }else {
                self.loginBtn.backgroundColor = #colorLiteral(red: 0.6693089008, green: 0.666139245, blue: 0.6693861485, alpha: 1)
                self.loginBtn.setTitleColor(#colorLiteral(red: 0.5069071651, green: 0.5034047365, blue: 0.5069662333, alpha: 1), for: .normal)
                self.loginBtn.isEnabled = false
            }
            
            
        }
        loginViewModel.isLogin.observer = {
           [unowned self] (islogin) in
            guard let islogin = islogin else {return}
            if islogin {
                self.loginProgressHud.show(in: self.view, animated: true)
                
                
            }else {
                self.loginProgressHud.dismiss(animated: true)
                self.dismiss(animated: true, completion: nil)
                self.delegate?.finishLogin()
            }
            
            
        }
        
        
        
        
    }

}

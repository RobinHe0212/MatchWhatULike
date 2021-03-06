//
//  SettingProfileViewController.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/15/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD


extension RegisterViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        
        if let image = info[.originalImage] as? UIImage{
            registerViewModel.bindprofileImage.value = image
//            registerViewModel.profileImage = image
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    
   fileprivate func setUpImageObserver(){
    
   
    registerViewModel.bindprofileImage.observer = { [unowned self]
        (img) in
        self.selectBtn.setImage(img!.withRenderingMode(.alwaysOriginal), for: .normal)

    }
    
    }
    
}

class RegisterViewController: UIViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGradientLayer()
        setUpLayout()
        setUpKeyboardObserver()
        setUpTapGesture()
        setUpFormValidObserver()
        setUpImageObserver()
    }
    
    @objc func tapDismissKeyboard(){
        
        self.view.endEditing(true)
    }
    
    let selectBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Select Photo", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 12
        btn.backgroundColor = .white
        btn.clipsToBounds = true
        btn.contentMode = UIButton.ContentMode.scaleAspectFill
        btn.heightAnchor.constraint(equalToConstant: 350).isActive = true
        btn.addTarget(self, action: #selector(tapProfileImg), for: .touchUpInside)
        return btn

    }()
    
    @objc func tapProfileImg(){
        
        let imagePikcer = UIImagePickerController()
        imagePikcer.delegate = self
        
        self.present(imagePikcer,animated: true)
    }
    
    
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
        btn.addTarget(self, action: #selector(tapRegister), for: .touchUpInside)
        self.btnHeightContraint = btn.heightAnchor.constraint(equalToConstant: 45)
        self.btnHeightContraint.isActive = true
        return btn
        
        
        
    }()
    
    let registerHud : JGProgressHUD = {
        let registerHud = JGProgressHUD(style: .dark)
        registerHud.textLabel.text = "Register"
        registerHud.dismiss(afterDelay: 3, animated: true)
        return registerHud
        
    }()
    
    // deliberate code based on registering status
    @objc func tapRegister(){
        
        tapDismissKeyboard()
        registerViewModel.handleRegister {[unowned self] (err) in
            if err != nil {
                self.showProgressHud(err: err)
                return
            }
            print("finish uploading")
        }
        
        
        
        
    }
    
    fileprivate func showProgressHud(err:Error?){
        registerHud.dismiss(animated: true)
        guard let err = err else {return}
        let progressHud = JGProgressHUD(style: .dark)
        progressHud.textLabel.text = "Error"
        progressHud.detailTextLabel.text = err.localizedDescription
        progressHud.dismiss(afterDelay: 3)
        progressHud.show(in: self.view, animated: true)
    }
    
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
           
            self.registerBtn.isEnabled = isValid
            self.registerBtn.backgroundColor = isValid ?  #colorLiteral(red: 0.8131607771, green: 0.09644565731, blue: 0.3356440663, alpha: 1) : .lightGray
            if isValid {
                self.registerBtn.setTitleColor(.white, for: .normal)
            }else {
                self.registerBtn.setTitleColor(#colorLiteral(red: 0.3616387844, green: 0.3566553593, blue: 0.3610489368, alpha: 1), for: .normal)
            }
            
            
        }
        registerViewModel.bindIsRegistering.observer = {
            [unowned self]
                (isRegistering) in
            guard let isRegistering = isRegistering else {return}
            if isRegistering {
                self.registerHud.show(in: self.view, animated: true)
                self.registerHud.textLabel.text = "Register"
                
            }else {
                self.registerHud.dismiss(animated: true)
            }
            
        }
        
        
    }
    
    fileprivate func setUpKeyboardObserver(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self) // avoid having a retain circle
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

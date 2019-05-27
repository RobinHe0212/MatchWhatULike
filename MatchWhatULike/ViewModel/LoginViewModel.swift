//
//  LoginViewModel.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/23/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit
import Firebase


class LoginViewModel{
    
    var isLogin = Bindable<Bool>()
    
    func handleLogin(completion:@escaping (Error?)->()){
        
        isLogin.value = true
        guard let email = email,let password = password else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (_, err) in
            if err != nil {
                completion(err)
            }

            print("successfully sign in")
            self.isLogin.value = false
            completion(nil)
        }
        
    }
    
    
    func checkAllowLoginIn(){
        
        if email?.isEmpty == false && password?.isEmpty == false {
            formIsValidToProceed?(true)
        }else {
            formIsValidToProceed?(false)
        }
        
    }
    
    var email : String?{
        didSet{
            
            checkAllowLoginIn()
            
        }

    }
    
    var password : String?{
        didSet{
            checkAllowLoginIn()
            
        }
        
    }
    
    var formIsValidToProceed: ((Bool)->())?
    
    
    
}

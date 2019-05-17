//
//  RegisterViewModel.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/16/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewModel {
    
    
    var bindprofileImage = Bindable<UIImage>()
    var bindIsRegistering = Bindable<Bool>()
    
    func handleRegister(completion:@escaping (Error?)->()){
        
        bindIsRegistering.value = true
        guard let email = email, let password = password else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if err != nil {
                print("error", err)
                completion(err)
                return
            }
            
            print(result?.user.uid)
            guard let uid = result?.user.uid else {return}
            
            let store = Storage.storage().reference(withPath: "/profileImage/\(uid)")
            let dta = self.bindprofileImage.value?.jpegData(compressionQuality: 0.75)
            store.putData(dta ?? Data(), metadata: nil, completion: { (meta, err) in
                if err != nil {
                    completion(err)
                    return
                }
                
                store.downloadURL(completion: { (url, err) in
                    if err != nil {
                        completion(err)
                        return
                    }
                    print(url?.absoluteString)
                    self.bindIsRegistering.value = false

                })
            })
            
        }

        
        
    }
    
//    var profileImage : UIImage?{
//        didSet{
//            changeImageObserver?(profileImage)
//        }
//
//    }
//
//    var changeImageObserver: ((UIImage?)->())?
    
    var name : String?{
        didSet{
            checkFormValid()
        }
    }

    var email : String?{didSet{
        checkFormValid()
        
        }}
    var password : String?{
        didSet{
            checkFormValid()
            
        }
    }
    
    func checkFormValid(){
        
        if name?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false {
            isFormValidObserver?(true)
        }else {
            isFormValidObserver?(false)
        }
        
    }
    
    var isFormValidObserver : ((Bool)->())?
}

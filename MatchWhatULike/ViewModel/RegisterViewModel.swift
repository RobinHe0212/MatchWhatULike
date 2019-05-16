//
//  RegisterViewModel.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/16/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class RegisterViewModel {
    
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

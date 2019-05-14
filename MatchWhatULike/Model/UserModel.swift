//
//  UserModel.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/14/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit


protocol TransferToCardViewModel {
    func toCardViewModel()->CardViewModel
}


struct UserModel : TransferToCardViewModel{
    
    
    let userImages : [String]
    let userName : String
    let userAge : String
    let userProfession : String
    
    
    
    func toCardViewModel() -> CardViewModel {
        
        let attribute =  NSMutableAttributedString(string: userName, attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attribute.append(NSMutableAttributedString(string: " \(userAge)", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]))
        attribute.append(NSMutableAttributedString(string: "\n\(userProfession)", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]))
        
        
        return CardViewModel(alignment: .left, wordAttribute: attribute, bgImages: userImages)
    }
    
  
    
}


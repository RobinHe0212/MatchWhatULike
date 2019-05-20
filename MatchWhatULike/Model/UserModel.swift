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
    
    
    var userImages : [String]?
    var userName : String?
    var userAge : String?
    var userProfession : String?
    var imageUrl1 : String?
    var uid : String?
    init(dictionary : [String:Any]){
        let userName = dictionary["fullname"] as? String
        let userAge = dictionary["age"] as? String
        let userProfession = dictionary["profession"] as? String
         self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.userImages = [imageUrl1 ?? ""]
        self.userAge = userAge
        self.userName = userName
        self.userProfession = userProfession
        self.uid = dictionary["uid"] as? String
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let attribute =  NSMutableAttributedString(string: userName ?? "", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        attribute.append(NSMutableAttributedString(string: " \(userAge ?? "N\\A")", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]))
        attribute.append(NSMutableAttributedString(string: "\n\(userProfession ?? "Not Available")", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]))
        
        
        return CardViewModel(alignment: .left, wordAttribute: attribute, bgImages: [imageUrl1 ?? ""] )
    }
    
  
    
}


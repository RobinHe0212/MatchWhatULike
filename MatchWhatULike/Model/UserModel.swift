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
    var userAge : Int?
    var userProfession : String?
    var minSeekingAge : Int?
    var maxSeekingAge : Int?
    var imageUrl1 : String?
    var imageUrl2 : String?
    var imageUrl3 : String?
    var uid : String?
    init(dictionary : [String:Any]){
        let userName = dictionary["fullname"] as? String
        let userAge = dictionary["age"] as? Int
        let userProfession = dictionary["profession"] as? String
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.userAge = userAge
        self.userName = userName
        self.userProfession = userProfession
        self.uid = dictionary["uid"] as? String
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let attribute =  NSMutableAttributedString(string: userName ?? "", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        attribute.append(NSMutableAttributedString(string: " \(userAge ?? -1)", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]))
        attribute.append(NSMutableAttributedString(string: "\n\(userProfession ?? "Not Available")", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]))
        
        var imageStrSet = [String]()
        if let img = imageUrl1 {
            if img != ""{
                imageStrSet.append(img)
            }
        }
        if let img = imageUrl2 {
            if img != ""{
                imageStrSet.append(img)
                
            }        }
        if let img = imageUrl3 {
            if img != ""{
                imageStrSet.append(img)
                
            }        }
        return CardViewModel(alignment: .left, wordAttribute: attribute, bgImages: imageStrSet, uid: uid ?? "" )
    }
    
  
    
}


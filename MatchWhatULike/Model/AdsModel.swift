//
//  AdsModel.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/14/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

struct AdsModel : TransferToCardViewModel{
   
    let adsImage : String
    let adsTitle : String
    let adsSub : String
    
    
    func toCardViewModel() -> CardViewModel {
        
        let attribute = NSMutableAttributedString(string: adsTitle, attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 35, weight: .heavy)])
        attribute.append(NSMutableAttributedString(string: "\n\(adsSub)", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 25, weight: .regular)]))
        
        return CardViewModel(alignment: .center, wordAttribute: attribute, bgImages: [adsImage])
    }
    
    
}

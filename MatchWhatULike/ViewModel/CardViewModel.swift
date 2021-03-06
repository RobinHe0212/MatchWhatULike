//
//  CardViewModel.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/14/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit


class CardViewModel{
    
    let alignment : NSTextAlignment
    let wordAttribute : NSMutableAttributedString
    let bgImages : [String]
    let uid : String
    
    init(alignment : NSTextAlignment,wordAttribute : NSMutableAttributedString,bgImages : [String],uid:String){
        self.alignment = alignment
        self.wordAttribute = wordAttribute
        self.bgImages = bgImages
        self.uid = uid
        
    }
    
    
    
    // image status should be placed in the view model
    fileprivate var indexStatus = 0{
        didSet{
            
            let imgUrl = bgImages[indexStatus]
            imageObserver?(indexStatus,imgUrl)
            
        }
        
        
    }
    
    var imageObserver : ((Int,String?)->())?
    
    func advancedToNextPic(){
        self.indexStatus = min(indexStatus + 1 , bgImages.count - 1)
    }
    
    func backToPreviousPic(){
        self.indexStatus = max(indexStatus - 1 , 0)
    }
}

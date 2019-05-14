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
    
    init(alignment : NSTextAlignment,wordAttribute : NSMutableAttributedString,bgImages : [String]){
        self.alignment = alignment
        self.wordAttribute = wordAttribute
        self.bgImages = bgImages
        
    }
    
    
    
    // image status should be placed in the view model
    fileprivate var indexStatus = 0{
        didSet{
            
            let img = UIImage(named: bgImages[indexStatus])
            
            imageObserver?(indexStatus,img)
            
        }
        
        
    }
    
    var imageObserver : ((Int,UIImage?)->())?
    
    func advancedToNextPic(){
        self.indexStatus = min(indexStatus + 1 , bgImages.count - 1)
    }
    
    func backToPreviousPic(){
        self.indexStatus = max(indexStatus - 1 , 0)
    }
}

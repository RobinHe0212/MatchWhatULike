//
//  RecentMsgCell.swift
//  MatchWhatULike
//
//  Created by Robin He on 8/15/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

struct RecentMatchMsg {
    let userName : String
    let imgUrl : String
    let latestMsg : String
    let timestamp : Timestamp
    let uid : String
    
    init(dictionary:[String:Any]){
        self.userName = dictionary["userName"] as? String ?? ""
        self.imgUrl = dictionary["imgUrl"] as? String ?? ""
        self.latestMsg = dictionary["rencentMsg"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    
}


class RecentMsgCell: UICollectionViewCell {
    
    var recentMatch : RecentMatchMsg?{
        didSet{
           imageProfile.sd_setImage(with: URL(string: recentMatch?.imgUrl ?? ""))
           userName.text = recentMatch?.userName ?? ""
            recentMsg.text = recentMatch?.latestMsg ?? ""
           
        }
        
    }
    var bgc : [UIColor]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let vStack = UIStackView(arrangedSubviews: [
            userName,
            recentMsg
            ])
        vStack.axis = .vertical
        vStack.spacing = 15
        let hStack = UIStackView(arrangedSubviews: [
            imageProfile,
            vStack]
        )
        hStack.alignment = .center
        hStack.spacing = 12
        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 12)
        addSubview(hStack)
        hStack.fillSuperview()
        
    }
    
    let imageProfile: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.constrainWidth(constant: 90)
        img.constrainHeight(constant: 90)
        img.layer.cornerRadius = 90 / 2
        return img
        
        
    }()
    let userName : UILabel = {
        let label = UILabel()
        label.text = "SOME USERNAME"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    let recentMsg : UILabel = {
        let text = UILabel()
        text.numberOfLines = 2
        text.text = "Some dummy lines of codes about to fetch from firestore later"
        text.textColor = .gray
        return text
        
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

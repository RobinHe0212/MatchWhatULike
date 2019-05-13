//
//  TopStackView.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/13/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class TopStackView: UIStackView {

    let leftBtn = UIButton(type: .system)
    let rightBtn = UIButton(type: .system)
    let fireImg : UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "app_icon")
        img.contentMode = UIView.ContentMode.scaleAspectFit
        return img
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.constrainHeight(constant: 100)
        leftBtn.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        rightBtn.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
       
        [ leftBtn,
          UIView(),
          fireImg,
          UIView(),
          rightBtn].forEach{
            
            self.addArrangedSubview($0)
        }
        
      
        distribution = .equalCentering
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  BottomStackView.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/13/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class BottomStackView: UIStackView {

    static func createButton(image:UIImage!)-> UIButton {
        
        let btn = UIButton(type: .system)
        btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
        
        
    }
    
    let refreshBtn = createButton(image: UIImage(named: "refresh_circle"))
    let dismissBtn = createButton(image: UIImage(named: "dismiss_circle"))
    let superLikeBtn = createButton(image: UIImage(named: "super_like_circle"))
    let likeBtn = createButton(image: UIImage(named: "like_circle"))
    let boostBtn = createButton(image: UIImage(named: "boost_circle"))

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [refreshBtn,dismissBtn,superLikeBtn,likeBtn,boostBtn].forEach{
            self.addArrangedSubview($0)
            
        }
        
        distribution = .fillEqually
        self.constrainHeight(constant: 120)
    }
    
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

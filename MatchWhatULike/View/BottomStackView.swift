//
//  BottomStackView.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/13/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class BottomStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let UIBtnSubViews = [UIImage(named: "refresh_circle"),UIImage(named: "dismiss_circle"),UIImage(named: "super_like_circle"),UIImage(named: "like_circle"),UIImage(named: "boost_circle")].map { (v) -> UIView in
            let btn = UIButton(type: .system)
            btn.setImage(v?.withRenderingMode(.alwaysOriginal), for: .normal)
            return btn
        }
        UIBtnSubViews.forEach{
            self.addArrangedSubview($0)
            
        }
        distribution = .fillEqually
        self.constrainHeight(constant: 120)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

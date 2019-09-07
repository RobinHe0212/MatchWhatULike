//
//  SendChatBtn.swift
//  MatchWhatULike
//
//  Created by Robin He on 8/2/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class SendChatBtn: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = rect.height/2
        let leftClw = #colorLiteral(red: 0.9736394286, green: 0.1545777619, blue: 0.4609097242, alpha: 1)
        let rightClw = #colorLiteral(red: 0.9749943614, green: 0.4005878568, blue: 0.3255684078, alpha: 1)
        gradientLayer.colors = [leftClw.cgColor,rightClw.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = rect
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
   
    
}

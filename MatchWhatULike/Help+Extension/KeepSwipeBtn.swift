//
//  KeepSwipeBtn.swift
//  MatchWhatULike
//
//  Created by Robin He on 8/2/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class KeepSwipeBtn: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 1, green: 0.01176470588, blue: 0.4470588235, alpha: 1)
        let rightColor = #colorLiteral(red: 1, green: 0.3921568627, blue: 0.3176470588, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        let maskLayer = CAShapeLayer()
        maskLayer.lineWidth = 2
        let cornerRadius = rect.height/2
        maskLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        gradientLayer.mask = maskLayer
        gradientLayer.frame = rect
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        self.layer.addSublayer(gradientLayer)
    }

}

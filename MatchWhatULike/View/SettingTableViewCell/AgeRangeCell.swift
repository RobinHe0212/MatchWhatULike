//
//  AgeRangeCell.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/22/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class AgeRangeCell: UITableViewCell {

    
    class CustomLabel : UILabel{
        
        override var intrinsicContentSize: CGSize{
            return .init(width: 80, height: 0)
        }
        
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let overallStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel,minAgeSlider]),
            UIStackView(arrangedSubviews: [maxLabel,maxAgeSlider]),
            ])
        overallStackView.axis = .vertical
        overallStackView.spacing = 16
        self.addSubview(overallStackView)
        overallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 16, left: 22, bottom: 16, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let minAgeSlider : UISlider = {
        
        let minSlider = UISlider()
        minSlider.maximumValue = 88
        minSlider.minimumValue = 18
        return minSlider
        
        
    }()
    
    let maxAgeSlider : UISlider = {
        
        let maxSlider = UISlider()
        maxSlider.maximumValue = 88
        maxSlider.minimumValue = 18
        return maxSlider
        
        
    }()
    let minLabel : CustomLabel = {
        let label = CustomLabel()
        label.text = "Min 88"
        return label
        
    }()
    
    let maxLabel : CustomLabel = {
        let label = CustomLabel()
        label.text = "Max 88"
        return label
        
    }()
}

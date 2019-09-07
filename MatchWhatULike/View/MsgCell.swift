//
//  MsgCell.swift
//  MatchWhatULike
//
//  Created by Robin He on 8/8/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class MsgCell: UICollectionViewCell {
    
    
    var cellInfo : MsgSave?{
        didSet{
            textView.text = cellInfo?.msg
            guard let checkFromCurrentUser = cellInfo?.isFromCurrentUser else{return}
            if checkFromCurrentUser{
                anchorConstaints.trailing?.isActive = true
                anchorConstaints.leading?.isActive = false
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.06654306501, green: 0.7638835311, blue: 0.9986026883, alpha: 1)
                textView.textColor = .white
            }else{
                anchorConstaints.trailing?.isActive = false
                anchorConstaints.leading?.isActive = true
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.9028351903, green: 0.8977944255, blue: 0.9064740539, alpha: 1)
                textView.textColor = .black
                
            }
        }
    }
    
    var anchorConstaints : AnchoredConstraints!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleContainer)
       anchorConstaints = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        anchorConstaints.leading?.constant = 20
//        anchorConstaints.trailing?.isActive = false
        anchorConstaints.trailing?.constant = -20
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
    
        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
    
    let bubbleContainer : UIView = {
        let container = UIView()
        container.backgroundColor = #colorLiteral(red: 0.9028351903, green: 0.8977944255, blue: 0.9064740539, alpha: 1)
        container.layer.cornerRadius = 12
        return container
        
    }()
    
    let textView : UITextView = {
        let text = UITextView()
        text.isScrollEnabled = false
        text.isEditable = false
        text.backgroundColor = .clear
        text.font = UIFont.systemFont(ofSize: 15)
        return text
    }()
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//
//  SettingTableViewCell.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/20/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit


class CustomTextField : UITextField {
    
    override var intrinsicContentSize: CGSize{
        
        return .init(width: self.frame.width, height: 44)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 22, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 22, dy: 0)
    }
    
}

class SettingTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textField : CustomTextField = {
        let tf = CustomTextField()
        tf.placeholder = "Enter Name"
        return tf
        
        
    }()
    

    
}

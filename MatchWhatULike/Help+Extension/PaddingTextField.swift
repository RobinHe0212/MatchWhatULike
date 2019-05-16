//
//  PaddingTextField.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/15/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class PaddingTextField: UITextField {

    init(padding:CGFloat){
    
        
        self.padding = padding
        super.init(frame: .zero)
        layer.cornerRadius = 20
        backgroundColor = .white
       
    }
    
    var padding : CGFloat
    
    override var intrinsicContentSize: CGSize{

        return .init(width: 0, height: 45)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

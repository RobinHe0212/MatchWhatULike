//
//  CartView.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/13/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class CartView: UIView {

    let image : UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "lady5c")
        img.contentMode = .scaleAspectFill
        return img
        
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.addSubview(image)
        image.fillSuperview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

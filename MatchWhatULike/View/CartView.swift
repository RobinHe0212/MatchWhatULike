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
    // Configuration
   fileprivate let threshold : CGFloat = 100

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.addSubview(image)
        image.fillSuperview()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panCard))
        self.addGestureRecognizer(pan)
    }
    
    @objc func panCard(gesture:UIPanGestureRecognizer){
        
       
        
        switch gesture.state {
        case .changed : changeSwipeCard(gesture)
            
            
        case .ended : endSwipeCard(gesture)
            
            
        default : ()
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func changeSwipeCard(_ gesture:UIPanGestureRecognizer){
        
         let tran = gesture.translation(in: nil)
        let degree : CGFloat = tran.x / 20
        let angle = degree * .pi / 180

            self.transform = CGAffineTransform(rotationAngle: angle).translatedBy(x:tran.x , y: tran.y)
 
    }
    
    
    
    fileprivate func endSwipeCard(_ gesture:UIPanGestureRecognizer){
        
        let gestureABS = gesture.translation(in: nil).x
        let dismissCard = abs(gestureABS) > threshold
        
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                
                if dismissCard {
                    if gestureABS > 0 {
                        self.frame = .init(x: 1000, y: 0, width: self.frame.width, height: self.frame.height)

                    }else {
                        self.frame = .init(x: -1000, y: 0, width: self.frame.width, height: self.frame.height)

                    }
                    

                }else{
                    self.transform = .identity
                    
                }
                
            }) { (_) in
                self.transform = .identity
                self.frame = .init(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)

            }
       
        
       
        
    }
}

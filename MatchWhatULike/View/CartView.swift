//
//  CartView.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/13/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class CartView: UIView {

    
    var cardsContent : CardViewModel!{
        
        didSet{
            
            image.image = UIImage(named: cardsContent.bgImage)
            infoLabel.attributedText = cardsContent.wordAttribute
            infoLabel.textAlignment = cardsContent.alignment
        }
        
        
    }
    
    let image : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
        
        
    }()
    
    let infoLabel = UILabel()
    
    
    // Configuration
   fileprivate let threshold : CGFloat = 100

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.addSubview(image)
        image.fillSuperview()
        image.addSubview(infoLabel)
        infoLabel.textColor = .white
        infoLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: 16, right: 16))
//        infoLabel.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        infoLabel.numberOfLines = 0
        
        
        
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
        let direction : CGFloat = gestureABS > 0 ? 1 : -1
        let dismissCard = abs(gestureABS) > threshold
        
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                
                if dismissCard {
                   
                        self.frame = .init(x: 1000*direction, y: 0, width: self.frame.width, height: self.frame.height)
                
                }else{
                    self.transform = .identity
                    
                }
                
            }) { (_) in
                self.transform = .identity
                if dismissCard{
                    self.removeFromSuperview()

                }

            }
       
        
       
        
    }
}

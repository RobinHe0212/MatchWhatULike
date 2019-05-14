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
            
            image.image = UIImage(named: cardsContent.bgImages.first ?? "")
            infoLabel.attributedText = cardsContent.wordAttribute
            infoLabel.textAlignment = cardsContent.alignment
            setUpBarStackView()
         
        }
        
        
    }
    
    let image : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
        
        
    }()
    
    let infoLabel = UILabel()
     let gradientlayer = CAGradientLayer()
    let barStackView = UIStackView()
    fileprivate let deselectClw = UIColor(white: 0, alpha: 0.1)
    
    // Configuration
   fileprivate let threshold : CGFloat = 100

   
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpImage()
        setUpGradientLayer()
        setUpInfoLabel()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panCard))
        self.addGestureRecognizer(pan)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPic)))
    }
    
    @objc func tapPic(gesture:UITapGestureRecognizer){
        
        let shouldAdvance = gesture.location(in: nil).x > self.frame.width / 2 ? true : false
        if shouldAdvance {
            cardsContent.advancedToNextPic()
        }else {
            cardsContent.backToPreviousPic()
        }
        
    }
    
    fileprivate func setUpBarStackView(){
        
        
       let count = cardsContent.bgImages.count
        (0..<count).forEach{ _ in
            let v = UIView()
            v.backgroundColor = deselectClw
            barStackView.addArrangedSubview(v)
            
        }
        barStackView.axis = .horizontal
        barStackView.distribution = .fillEqually
        barStackView.spacing = 8
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 5))
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        setUpImageIndexTapObserver()
        
    }
    
    func setUpImageIndexTapObserver(){
        
       
        cardsContent.imageObserver = {
            [unowned self]     (idx,image) in
            self.image.image = image
            self.barStackView.arrangedSubviews.forEach{
                $0.backgroundColor = self.deselectClw
            }
             self.barStackView.arrangedSubviews[idx].backgroundColor = .white
            
        }
       
       
    }
    
    
    fileprivate func setUpImage() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.addSubview(image)
        image.fillSuperview()
    }
    
    // add shadow in the bottom of the image
    fileprivate func setUpGradientLayer(){
        
       
        gradientlayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientlayer.locations = [0.5,1.1]
        self.layer.addSublayer(gradientlayer)

        
        
    }
    
    // because when u call setUpGradientLayer, the frame has not done initiated yet,you need to call layoutSubviews
    // after init,then execute this one
    override func layoutSubviews() {
        gradientlayer.frame = self.frame
    }
    
    fileprivate func setUpInfoLabel() {
        addSubview(infoLabel)
        infoLabel.textColor = .white
        infoLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        infoLabel.numberOfLines = 0
    }
    
    @objc func panCard(gesture:UIPanGestureRecognizer){
        
       
        
        switch gesture.state {
            // fix the swipe dismiss not stable bug
        case .began :
            self.superview!.subviews.forEach{
                
                $0.layer.removeAllAnimations()
            }
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
                    self.superview!.sendSubviewToBack(self)

                }

            }
       
        
       
        
    }
}

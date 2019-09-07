//
//  MatchView.swift
//  MatchWhatULike
//
//  Created by Robin He on 8/2/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit
import Firebase


protocol SendToChatVCDelegate {
    func sendToChat(cardUid:String)
}

class MatchView: UIView {

    var currentUserModel : UserModel!{
        didSet{}
    }
    var cardUID : String!{
        didSet{
            // remember to fix the offline issue , fetch correct image from firebase
            print("cardId is \(cardUID)")
            Firestore.firestore().collection("users").document(cardUID).getDocument { (snap, err) in
                if let err = err{
                    print("cannot fetch user, error is:",err)
                    return
                }
                guard let data = snap?.data() else{return}
               let user = UserModel(dictionary: data)
                self.matchLabel.text = "You and \(user.userName ?? "") have liked each other"
                self.matchingUser.sd_setImage(with: URL(string: user.imageUrl1 ?? ""), completed: { (_, _, _, _) in
                   self.currentUser.sd_setImage(with: URL(string: self.currentUserModel.imageUrl1 ?? ""))
                    self.setUpAnimation()
                })
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpBlur()
        setUpLayout()
        setUpAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate func setUpBlur(){
        visualEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMatchView)))
        visualEffect.alpha = 0
        addSubview(visualEffect)
        visualEffect.fillSuperview()
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: .curveEaseOut, animations: {
            self.visualEffect.alpha = 1

        }) { (_) in
            
        }
    }
    
    fileprivate func setUpAnimation(){
        let angle : CGFloat = 30 * CGFloat.pi/180
        currentUser.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        matchingUser.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        sendCharBtn.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipeBtn.transform = CGAffineTransform(translationX: 500, y: 0)
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0.6, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.currentUser.transform = CGAffineTransform(rotationAngle: -angle)
                self.matchingUser.transform = CGAffineTransform(rotationAngle: angle)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.65, relativeDuration: 0.5, animations: {
                self.currentUser.transform = .identity
                self.matchingUser.transform = .identity
            })
            
            
        })
        
        UIView.animate(withDuration: 0.75, delay: 0.6*1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.sendCharBtn.transform = .identity
                self.keepSwipeBtn.transform = .identity
        }) { (_) in
            
        }
        
    }
    
    @objc func dismissMatchView(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()

        }
    }
    
    let currentUser : UIImageView = {
        let user = UIImageView()
        user.contentMode = UIView.ContentMode.scaleAspectFill
        user.clipsToBounds = true
        user.layer.borderColor = UIColor.white.cgColor
        user.layer.borderWidth = 2
        return user
        
        
    }()
    
    let matchingUser : UIImageView = {
        let user = UIImageView()
        user.contentMode = UIView.ContentMode.scaleAspectFill
        user.clipsToBounds = true
        user.layer.borderColor = UIColor.white.cgColor
        user.layer.borderWidth = 2
        return user
        
        
    }()
    
    let matchLabel : UILabel = {
        let label = UILabel()
        label.text = "You and XX have liked each other"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let itIsAMatchIcon : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        image.contentMode = .scaleAspectFill
        return image
        
    }()
    
    var delegate : SendToChatVCDelegate?
    
    let sendCharBtn : UIButton = {
        let btn = SendChatBtn(type: .system)
        btn.setTitle("SEND MESSAGE", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(sendToChatVC), for: .touchUpInside)
        return btn
        
        
    }()
    
    
    
    @objc func sendToChatVC(){
        delegate?.sendToChat(cardUid: cardUID)
    }
    
    let keepSwipeBtn : KeepSwipeBtn = {
        let btn = KeepSwipeBtn(type: .system)
        btn.setTitle("KEEP SWIPING", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(removeMatchView), for: .touchUpInside)
        return btn
        
        
    }()
    
    @objc func removeMatchView(){
        self.removeFromSuperview()
    
    }
    
    fileprivate func setUpLayout(){
        let imageWidth : CGFloat = 144
        self.addSubview(currentUser)
        self.addSubview(matchingUser)
        self.addSubview(matchLabel)
        self.addSubview(itIsAMatchIcon)
        self.addSubview(sendCharBtn)
        self.addSubview(keepSwipeBtn)
        currentUser.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: imageWidth, height: imageWidth))
        currentUser.centerYInSuperview()
        currentUser.layer.cornerRadius = imageWidth/2
        matchingUser.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: imageWidth, height: imageWidth))
        matchingUser.centerYInSuperview()
        matchingUser.layer.cornerRadius = imageWidth/2
        
        matchLabel.anchor(top: nil, leading: nil, bottom: currentUser.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 25, right: 0))
        matchLabel.centerXInSuperview()
        itIsAMatchIcon.anchor(top: nil, leading: nil, bottom: matchLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 25, right: 0))
        itIsAMatchIcon.centerXInSuperview()
        sendCharBtn.anchor(top: currentUser.bottomAnchor, leading: currentUser.leadingAnchor, bottom: nil, trailing: matchingUser.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 40))
        
        keepSwipeBtn.anchor(top: sendCharBtn.bottomAnchor, leading: sendCharBtn.leadingAnchor, bottom: nil, trailing: sendCharBtn.trailingAnchor, padding: .init(top: 25, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 40))
    }
    
}

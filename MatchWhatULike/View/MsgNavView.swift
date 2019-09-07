//
//  MsgNavView.swift
//  MatchWhatULike
//
//  Created by Robin He on 8/8/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class MsgNavView: UIView {

    let match : Match
    
    init(match:Match){
        self.match = match
        super.init(frame: .zero)
        backgroundColor = .white
        setUpNav()
        profileImg.sd_setImage(with: URL(string: match.profileImageUrl ?? ""), completed: nil)
        profileLabel.text = match.name ?? ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImg : UIImageView = {
        let profileImg = UIImageView()
        profileImg.contentMode = .scaleAspectFill
        profileImg.constrainWidth(constant: 44)
        profileImg.constrainHeight(constant: 44)
        profileImg.clipsToBounds = true
        profileImg.layer.cornerRadius = 44 / 2
        return profileImg
        
        
    }()
    let profileLabel : UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
        
    }()
    
    let backBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        btn.tintColor = #colorLiteral(red: 0.9984138608, green: 0.4415079951, blue: 0.4681680799, alpha: 1)
        return btn
        
    }()
    
    
    let flagBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "flag"), for: .normal)
        btn.tintColor = #colorLiteral(red: 0.9984138608, green: 0.4415079951, blue: 0.4681680799, alpha: 1)
        return btn
        
    }()
    
    fileprivate func setUpNav(){
        
        let vStackView = UIStackView(arrangedSubviews: [
            profileImg,
            profileLabel]
        )
        vStackView.spacing = 10
        vStackView.axis = .vertical
        vStackView.alignment = .center
        let vHack = UIStackView(arrangedSubviews: [
            vStackView
            ])
        vHack.axis = .horizontal
        vHack.alignment = .center
        let overallStackView = UIStackView(arrangedSubviews: [
            backBtn,
            vHack,
            flagBtn
            
            ])
        overallStackView.axis = .horizontal
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        
        addSubview(overallStackView)
        overallStackView.fillSuperview()
        
       layer.shadowOpacity = 0.2
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
        
    }
    
}

//
//  ViewController.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/13/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpStackViews()
        setUpCards()
        

    }
    
    let topStackView = TopStackView(frame: .zero)
    let bottomStackView = BottomStackView(frame: .zero)
    let middleView = UIView()
    
    
    let cardModelStacks : [CardViewModel] = {
        
        let viewModel = [
            UserModel(userImages: ["lady1"], userName: "Jane", userAge: "18", userProfession: "Teacher"),
            UserModel(userImages: ["lady2"], userName: "Yuxian Liu", userAge: "24", userProfession: "Soldier"),
            AdsModel(adsImage: "sneaker", adsTitle: "SneakerCon App", adsSub: "Be the hypebeast"),
            UserModel(userImages: ["lady3"], userName: "Joggie", userAge: "20", userProfession: "Student"),
            UserModel(userImages: ["lady4","lady2","lady3"], userName: "Lucy", userAge: "21", userProfession: "Graduate")
        
        ] as [TransferToCardViewModel]
        
        let cardModel = viewModel.map({return $0.toCardViewModel()})
        
        return cardModel
        
    }()
    
    
    fileprivate func setUpCards(){
        

        cardModelStacks.forEach{
            let cartV = CartView()
            cartV.cardsContent = $0
            middleView.addSubview(cartV)
            cartV.fillSuperview()
        }
        
       
        
        
    }
    
    fileprivate func setUpStackViews() {
       
        
        let overallStackView = UIStackView(arrangedSubviews: [
            topStackView,
            middleView,
            bottomStackView
            
            ])
        overallStackView.axis = .vertical
        
        self.view.addSubview(overallStackView)
        overallStackView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: self.view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(middleView)
    }


}


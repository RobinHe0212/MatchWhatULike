//
//  ViewController.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/13/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController, SettingRefreshHomeControllerDelegate {
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpStackViews()
        setUpCards()
        fetchCurrentUserInfo()

    }
    
    var user : UserModel?
    fileprivate func fetchCurrentUserInfo(){
        let uid = Auth.auth().currentUser!.uid
        Firestore.firestore().collection("users").document(uid).getDocument { (snap, err) in
            if err != nil{
                print("error is ",err)
                return
            }
            if let dta = snap?.data() {
                 self.user = UserModel(dictionary: dta)
                self.retriveCardInfoFromFirebase()

            }
            
        }
        
    }

    let topStackView = TopStackView(frame: .zero)
    let bottomStackView = BottomStackView(frame: .zero)
    let middleView = UIView()
    
    var lastUserUid : String?
    let progressHud = JGProgressHUD(style: .dark)
    
    fileprivate func retriveCardInfoFromFirebase(){
        
        progressHud.textLabel.text = "Fetching user"
        progressHud.show(in: self.view, animated: true)
        guard let minAge = self.user?.minSeekingAge else {return}
        guard let maxAge = self.user?.maxSeekingAge else {return}

        print("min is \(minAge)")
        print("max is \(maxAge)")
       
       let query =  Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        
        query.getDocuments { (snapShot, err) in
            if err != nil {
                print("error", err)
                return
            }
            
            self.progressHud.dismiss(animated: true)
            snapShot?.documents.forEach({ (snapShot) in
                let dta = snapShot.data()
                let user = UserModel(dictionary: dta)
                print("after refreshing data \(snapShot.data())")
                self.lastUserUid = user.uid
                self.cardModelStacks.append(user.toCardViewModel())
                self.setUpPaginationCards(user: user)
                
            })
           
        }
  
    }
    
    fileprivate func setUpPaginationCards(user:UserModel){
        let cartV = CartView(frame: .zero)
        cartV.cardsContent = user.toCardViewModel()
        middleView.addSubview(cartV)
        middleView.sendSubviewToBack(cartV)
        cartV.fillSuperview()
        
        
    }

    var cardModelStacks = [CardViewModel]()
    
    fileprivate func setUpCards(){
        

        cardModelStacks.forEach{
            let cartV = CartView(frame: .zero)
            cartV.cardsContent = $0
            middleView.addSubview(cartV)
            middleView.sendSubviewToBack(cartV)
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
        
        topStackView.leftBtn.addTarget(self, action: #selector(tapSettingProfile), for: .touchUpInside)
        bottomStackView.refreshBtn.addTarget(self, action: #selector(tapRefresh), for: .touchUpInside)
    }
    
    @objc func tapRefresh(){
        
        retriveCardInfoFromFirebase()
        
    }
    
    @objc func tapSettingProfile(){
        
        let settingVC = SettingProfileTableViewController()
        settingVC.delegate = self
        let settingProfiletvc = UINavigationController(rootViewController: settingVC)
        
        
        self.present(settingProfiletvc,animated: true)
        
    }
    
    
    func refreshHomeController() {
        fetchCurrentUserInfo()
    }
    


}


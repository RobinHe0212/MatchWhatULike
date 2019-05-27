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

class HomeController: UIViewController, SettingRefreshHomeControllerDelegate,FinishLoginInDelegate,MoreInfoPageDelegate {
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpStackViews()
        setUpCards()
        fetchCurrentUserInfo()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            let loginVC = LoginViewController()
            loginVC.delegate = self
            
            present(UINavigationController(rootViewController: loginVC),animated: true)

        }
    }
    
    
    var user : UserModel?
    fileprivate func fetchCurrentUserInfo(){
        guard  let uid = Auth.auth().currentUser?.uid else {return}
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
       
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
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
                self.cardModelStacks.append(user.toCardViewModel())
                if let userId = user.uid {
                    if userId != uid {
                        self.setUpPaginationCards(user: user)
                        
                    }
                }
               
                
            })
           
        }
  
    }
    
    fileprivate func setUpPaginationCards(user:UserModel){
        let cartV = CartView(frame: .zero)
        cartV.delegate = self
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
    
    func finishLogin() {
        fetchCurrentUserInfo()
    }
    func presentMoreInfo(userModel:CardViewModel) {
        let moreInfoPage = MoreInfoViewController()
       moreInfoPage.viewModel = userModel
        present(moreInfoPage,animated: true)
    }
    
    
    

}


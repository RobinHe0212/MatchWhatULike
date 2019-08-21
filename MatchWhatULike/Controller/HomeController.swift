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

class HomeController: UIViewController, SettingRefreshHomeControllerDelegate,FinishLoginInDelegate,MoreInfoPageDelegate,SendToChatVCDelegate {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
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
    var matchesUser = [String:UserModel]()
    fileprivate func fetchCurrentUserInfo(){
        guard  let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snap, err) in
            if err != nil{
                print("error is ",err)
                return
            }
            if let dta = snap?.data() {
                 self.user = UserModel(dictionary: dta)
                
                self.fetchSwipes()
            }
            
        }
        
    }
    
    var alreadySwipe = [String:Int]()
    
    fileprivate func fetchSwipes(){
        let currentId = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("swipe").document(currentId!).getDocument { (snap, err) in
            if let err = err{
                print("error is ", err)
                return
            }
            let dta = snap?.data() as? [String:Int] ?? [:]
            
            self.alreadySwipe = dta
            self.retriveCardInfoFromFirebase()
        }
        
    }

    let topStackView = TopStackView(frame: .zero)
    let bottomStackView = BottomStackView(frame: .zero)
    let middleView = UIView()
    
    var lastUserUid : String?
    let progressHud = JGProgressHUD(style: .dark)
    
    fileprivate func  retriveCardInfoFromFirebase(){
        
        progressHud.textLabel.text = "Fetching user"
        progressHud.show(in: self.view, animated: true)
        let minAge = self.user?.minSeekingAge ?? 18
        let maxAge = self.user?.maxSeekingAge ?? 50

        print("min is \(minAge)")
        print("max is \(maxAge)")
       
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
       let query =  Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        self.topCardView = nil
        query.getDocuments { (snapShot, err) in
            if err != nil {
                print("error", err)
                return
            }
            
            // using linkedList
            var previousCard : CartView?
            
            self.progressHud.dismiss(animated: true)
            snapShot?.documents.forEach({ (snapShot) in
                let dta = snapShot.data()
                let user = UserModel(dictionary: dta)
                let ifCurrentUser = user.uid == uid ? true : false
               let isSwiped = self.alreadySwipe.keys.contains(user.uid ?? "")
//                if !ifCurrentUser && !isSwiped{
                    self.matchesUser[user.uid!] = user
                    self.cardModelStacks.append(user.toCardViewModel())
                    if let userId = user.uid {
                        if userId != uid {
                            let currentCard =  self.setUpPaginationCards(user: user)
                            previousCard?.nextCardView = currentCard
                            previousCard = currentCard
                            
                            if self.topCardView == nil{
                                self.topCardView = currentCard
                            }
                        }
                    }
//                }
            
//                print("after refreshing data \(snapShot.data())")
                
               
               
                
            })
           
        }
  
    }
    
    @objc func tapLike(){
        
        swipeToSaveFirebase(didLike: 1)
       swipeFunction(translation: 600, angle: 15)
     
    }
    
    
    
    fileprivate func swipeToSaveFirebase(didLike:Int){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        guard let cardV = topCardView?.cardsContent else{return}
        let document = [cardV.uid : didLike]
        Firestore.firestore().collection("swipe").document(uid).getDocument { (snap, err) in
            if let err = err{
                print("cannot save to firebase")
                return
            }
            if snap?.exists == true{
                Firestore.firestore().collection("swipe").document(uid).updateData(document)
                self.checkIfMatchExist(cardUID: cardV.uid)
                
            }else {
                Firestore.firestore().collection("swipe").document(uid).setData(document) { (err) in
                    if let err = err {
                        print("cannot save data in database")
                        return
                    }
                    print("save successfully")
                    self.checkIfMatchExist(cardUID: cardV.uid)

                }
            }
        }
        
       
        
        
    }
    
    fileprivate func checkIfMatchExist(cardUID : String){
        Firestore.firestore().collection("swipe").document(cardUID).getDocument { (snap, err) in
            if let err = err {
                print("Error is", err)
                return
            }
            guard let data = snap?.data() else{return}
            guard let currentId = Auth.auth().currentUser?.uid else {return}
            let signal = data[currentId] as? Int == 1
            if signal {
                print("found a match")
                // save matching user and current user in match_messages firebase
               
                guard let detailMatchesUser = self.matchesUser[cardUID] else{return}
                let documentData = ["name": detailMatchesUser.userName ?? "","profileImageUrl":detailMatchesUser.imageUrl1 ?? "","uid":detailMatchesUser.uid ?? ""]
            Firestore.firestore().collection("match_messages").document(currentId).collection("matches").document(cardUID).setData(documentData, completion: { (err) in
                    if let err = err {
                        print("cannot save firebase, err is",err)
                        return
                    }
                })
                
                
                let matchView = MatchView()
                matchView.cardUID = cardUID
                matchView.currentUserModel = self.user
                matchView.delegate = self
                self.view.addSubview(matchView)
                matchView.fillSuperview()
                
//                let hud = JGProgressHUD(style: .dark)
//                hud.textLabel.text = "Found a Match!"
//                hud.show(in: self.view, animated: true)
//                hud.dismiss(afterDelay: 3)
            }
        }
    }
    
    fileprivate func swipeFunction(translation:CGFloat,angle:CGFloat){
        let animationDuration = 0.5
        
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = animationDuration
        translationAnimation.fillMode = .forwards
        // slow in the beginning ,then accelerate
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = animationDuration
        
        let cardView = self.topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
        
    }
    
    func dismissTopCardView(cardView: CartView) {
        topCardView?.removeFromSuperview()
        topCardView = topCardView?.nextCardView
    }
    
    
    
    var topCardView : CartView?
    
    fileprivate func setUpPaginationCards(user:UserModel) -> CartView{
        let cartV = CartView(frame: .zero)
        cartV.delegate = self
        cartV.cardsContent = user.toCardViewModel()
        middleView.addSubview(cartV)
        middleView.sendSubviewToBack(cartV)
        cartV.fillSuperview()
        
        return cartV
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
        topStackView.rightBtn.addTarget(self, action: #selector(tapMessage), for: .touchUpInside)
        bottomStackView.refreshBtn.addTarget(self, action: #selector(tapRefresh), for: .touchUpInside)
        bottomStackView.likeBtn.addTarget(self, action: #selector(tapLike), for: .touchUpInside)
        bottomStackView.dismissBtn.addTarget(self, action: #selector(tapDislike), for: .touchUpInside)
    }
    
    @objc func tapMessage(){
        let messageController = MessagesFeedController()
        navigationController?.pushViewController(messageController, animated: true)
        
    }
    
    @objc func tapDislike(){
        swipeToSaveFirebase(didLike: 0)

        swipeFunction(translation: -600, angle: -15)
        
    }
    
    @objc func tapRefresh(){
        middleView.subviews.forEach{$0.removeFromSuperview()}

//        if topCardView == nil {
            retriveCardInfoFromFirebase()

//        }
        
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
    
    func sendToChat(cardUid:String) {
        let model = matchesUser[cardUid]
        let chatUser = Match(name: model?.userName ?? "", profileImageUrl: model?.imageUrl1 ?? "", uid: model?.uid ?? "")
        navigationController?.pushViewController(ChatLogController(match: chatUser), animated: true)
    }
    
    
    
    
    
    

}


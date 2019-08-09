//
//  MessagesFeedController.swift
//  MatchWhatULike
//
//  Created by Robin He on 8/6/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

struct Match{
    let name : String?
    let profileImageUrl : String?
    let uid : String!
    
    init(dictionary:[String:String]){
        self.name = dictionary["name"] ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] ?? ""
        self.uid = dictionary["uid"]
    }
    init(name:String,profileImageUrl:String,uid:String){
        self.name = name
        self.profileImageUrl = profileImageUrl
        self.uid = uid
    }
    
}

class MatchesHorizontalController : UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
     fileprivate let matchId = "matchId"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.contentInset = .init(top: 30, left: 0, bottom: 20, right: 0)
        
        collectionView.register(MatchUserCell.self, forCellWithReuseIdentifier: matchId)

        fetchMatchingInfo()
        
    }

    init(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var matUsers = [Match]()
    
    fileprivate func fetchMatchingInfo(){
        // dummy codes
        matUsers.append(Match.init(name: "Robin", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/matchswipe-9bf83.appspot.com/o/profileImage%2FkFEW6TKVbPVbfxEeY4aZbLCgqOn1?alt=media&token=ac849a39-9c7b-454a-8157-953b1b0b510d", uid: "kFEW6TKVbPVbfxEeY4aZbLCgqOn1"))
        matUsers.append(Match.init(name: "Nacy", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/matchswipe-9bf83.appspot.com/o/profileImage%2FkFEW6TKVbPVbfxEeY4aZbLCgqOn1?alt=media&token=ac849a39-9c7b-454a-8157-953b1b0b510d", uid: "kFEW6TKVbPVbfxEeY4aZbLCgqOn1"))
        matUsers.append(Match.init(name: "Lucas", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/matchswipe-9bf83.appspot.com/o/profileImage%2FkFEW6TKVbPVbfxEeY4aZbLCgqOn1?alt=media&token=ac849a39-9c7b-454a-8157-953b1b0b510d", uid: "kFEW6TKVbPVbfxEeY4aZbLCgqOn1"))
        matUsers.append(Match.init(name: "Joe", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/matchswipe-9bf83.appspot.com/o/profileImage%2FkFEW6TKVbPVbfxEeY4aZbLCgqOn1?alt=media&token=ac849a39-9c7b-454a-8157-953b1b0b510d", uid: "kFEW6TKVbPVbfxEeY4aZbLCgqOn1"))
        matUsers.append(Match.init(name: "Jason", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/matchswipe-9bf83.appspot.com/o/profileImage%2FkFEW6TKVbPVbfxEeY4aZbLCgqOn1?alt=media&token=ac849a39-9c7b-454a-8157-953b1b0b510d", uid: "kFEW6TKVbPVbfxEeY4aZbLCgqOn1"))
        
        
        
        let currentUid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("match_messages").document(currentUid!).collection("matches").getDocuments { (snap, err) in
            if let err = err {
                print("cannot fetch data,err is",err)
                return
            }
            snap?.documents.forEach({ (snap) in
                let dta = snap.data() as! [String:String]
                self.matUsers.append(Match(dictionary: dta))
                
            })
            
        }
        self.collectionView.reloadData()

    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchId, for: indexPath) as! MatchUserCell
        cell.users = matUsers[indexPath.item]
        
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 95, height: 120)
    }

//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let msgVC = self.superclass as? MessagesFeedController{
//          let  chatVC = ChatLogController(match: matUsers[indexPath.item])
//            msgVC.navigationController?.pushViewController(chatVC, animated: true)
//        }
//
//    }

}


class MatchUserCell : UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        let iconStack = UIStackView(arrangedSubviews: [iconImg])
        iconStack.axis = .vertical
        iconStack.alignment = .center
        let vStack = UIStackView(arrangedSubviews: [
            iconStack,
            nameLabel
            ])
        vStack.axis = .vertical
        addSubview(vStack)
        vStack.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var users : Match?{
        didSet{
            iconImg.sd_setImage(with: URL(string: users?.profileImageUrl ?? ""))
            nameLabel.text = users?.name ?? "Timmy"
            
        }
    }
    
    let iconImg : UIImageView = {
        let img = UIImageView(image: #imageLiteral(resourceName: "lady2"))
        img.contentMode = .scaleAspectFill
        img.constrainWidth(constant: 80)
        img.constrainHeight(constant: 80)
        img.clipsToBounds = true
        img.layer.cornerRadius = 40
        return img
        
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "some sample"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
        
    }()
    
}



class MatchesHeader : UICollectionReusableView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let horizontalVC = MatchesHorizontalController()
        
        let stackView = UIStackView(arrangedSubviews: [
                newTextlabel,
                horizontalVC.view,
                msgLabel
            
            ])
        
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 20, bottom: 0, right: 0))
    }
    
    let newTextlabel : UILabel = {
        let label = UILabel()
        label.text = "New Matches"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.9984138608, green: 0.4415079951, blue: 0.4681680799, alpha: 1)
        return label
        
        
    }()
    
    let msgLabel : UILabel = {
        let label = UILabel()
        label.text = "Messages"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.9984138608, green: 0.4415079951, blue: 0.4681680799, alpha: 1)
        return label
        
        
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MessagesFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let matchId = "matchId"
    fileprivate let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        setUpNavBar()
        collectionView.contentInset.top = 160
        collectionView.register(MatchUserCell.self, forCellWithReuseIdentifier: matchId)
        collectionView.register(MatchesHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        fetchMatchingInfo()
    }

    init(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var matUsers = [Match]()
    
    fileprivate func fetchMatchingInfo(){
        // dummy codes
        matUsers.append(Match.init(name: "Robin", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/matchswipe-9bf83.appspot.com/o/profileImage%2FkFEW6TKVbPVbfxEeY4aZbLCgqOn1?alt=media&token=ac849a39-9c7b-454a-8157-953b1b0b510d", uid: "kFEW6TKVbPVbfxEeY4aZbLCgqOn1"))
         matUsers.append(Match.init(name: "Lancy", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/matchswipe-9bf83.appspot.com/o/profileImage%2FkFEW6TKVbPVbfxEeY4aZbLCgqOn1?alt=media&token=ac849a39-9c7b-454a-8157-953b1b0b510d", uid: "kFEW6TKVbPVbfxEeY4aZbLCgqOn1"))
         matUsers.append(Match.init(name: "Luis", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/matchswipe-9bf83.appspot.com/o/profileImage%2FkFEW6TKVbPVbfxEeY4aZbLCgqOn1?alt=media&token=ac849a39-9c7b-454a-8157-953b1b0b510d", uid: "kFEW6TKVbPVbfxEeY4aZbLCgqOn1"))
         matUsers.append(Match.init(name: "Mike", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/matchswipe-9bf83.appspot.com/o/profileImage%2FkFEW6TKVbPVbfxEeY4aZbLCgqOn1?alt=media&token=ac849a39-9c7b-454a-8157-953b1b0b510d", uid: "kFEW6TKVbPVbfxEeY4aZbLCgqOn1"))
         matUsers.append(Match.init(name: "Duke", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/matchswipe-9bf83.appspot.com/o/profileImage%2FkFEW6TKVbPVbfxEeY4aZbLCgqOn1?alt=media&token=ac849a39-9c7b-454a-8157-953b1b0b510d", uid: "kFEW6TKVbPVbfxEeY4aZbLCgqOn1"))



        let currentUid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("match_messages").document(currentUid!).collection("matches").getDocuments { (snap, err) in
            if let err = err {
                print("cannot fetch data,err is",err)
                return
            }
            snap?.documents.forEach({ (snap) in
                let dta = snap.data() as! [String:String]
                self.matUsers.append(Match(dictionary: dta))

            })

        }
        self.collectionView.reloadData()


    }
    
    fileprivate func setUpNavBar(){
        view.addSubview(navView)
        view.addSubview(fireBtn)
        fireBtn.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 25, left: 10, bottom: 0, right: 0), size: .init(width: 32, height: 32))
        navView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,size:.init(width: 0, height: 170))
        navView.layer.shadowOpacity = 0.2
        navView.layer.shadowRadius = 8
        navView.layer.shadowOffset = CGSize(width: 3, height: 10)
        navView.layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
        
        
    }
    
    let navView : UIView = {
        let nav = UIView()
        nav.backgroundColor = .white
       
        let messageLabel = UILabel()
        messageLabel.text = "Messages"
        messageLabel.textColor = #colorLiteral(red: 0.9984138608, green: 0.4415079951, blue: 0.4681680799, alpha: 1)
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        let feedLabel = UILabel()
        feedLabel.text = "Feed"
        feedLabel.textColor = .lightGray
        feedLabel.textAlignment = .center
        feedLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        let hStack = UIStackView(arrangedSubviews: [
            messageLabel,
            feedLabel
            ])
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        let msgTopImg = UIImageView(image: #imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysTemplate))
        msgTopImg.contentMode = .scaleAspectFit
        msgTopImg.tintColor = #colorLiteral(red: 0.9984138608, green: 0.4415079951, blue: 0.4681680799, alpha: 1)
        msgTopImg.constrainHeight(constant: 40)
//        msgTopImg.constrainWidth(constant: 40)
        let overallStackView = UIStackView(arrangedSubviews: [msgTopImg,hStack])
        overallStackView.axis = .vertical
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10)
        nav.addSubview(overallStackView)
        overallStackView.fillSuperview()
        
        return nav
    }()
    
    let fireBtn : UIButton = {
        let backFireBtn = UIButton(type: .system)
        backFireBtn.setImage(#imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        backFireBtn.tintColor = .lightGray
        backFireBtn.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
        return backFireBtn
        
    }()
    
    @objc func backToHome(){
        navigationController?.popViewController(animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchId, for: indexPath) as! MatchUserCell
        cell.users = matUsers[indexPath.item]
        
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 95, height: 120)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chatLogVC = ChatLogController(match: matUsers[indexPath.item])
        navigationController?.pushViewController(chatLogVC, animated: true)
        
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MatchesHeader
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 30, left: 20, bottom: 0, right: 0)
    }
}

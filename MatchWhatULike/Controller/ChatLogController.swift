//
//  ChatLogController.swift
//  MatchWhatULike
//
//  Created by Robin He on 8/8/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit
import Firebase

struct MsgSave{
    let msg : String?
    let isFromCurrentUser : Bool?
    let fromUserId : String?
    let toUserId : String?
    let timestamp : Timestamp?
    
    init(dictionary:[String:Any]){
        self.msg = dictionary["text"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.fromUserId = dictionary["fromUserId"] as? String ?? ""
        self.toUserId = dictionary["toUserId"] as? String ?? ""
        self.isFromCurrentUser = Auth.auth().currentUser?.uid ?? "" == self.fromUserId
    }
}

class InputAccessoryFixedView : UIView{
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    let textField = UITextField()
    let sendBtn = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -8)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.2
        
        textField.placeholder = "Enter Comment"
        textField.font = UIFont.systemFont(ofSize: 15)
        
        sendBtn.setTitle("Send", for: .normal)
        sendBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        sendBtn.setTitleColor(.black, for: .normal)
        sendBtn.constrainWidth(constant: 44)
        sendBtn.constrainHeight(constant: 44)
        let stackView = UIStackView(arrangedSubviews: [
            textField,
            sendBtn
            ])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    lazy var navView = MsgNavView(match: match)
    
    let navbarHeight : CGFloat = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboardDismiss()
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .interactive
        collectionView.scrollIndicatorInsets.top = navbarHeight
        collectionView.alwaysBounceVertical = true
        navView.backBtn.addTarget(self, action: #selector(backToMsg), for: .touchUpInside)
        view.addSubview(navView)
        navView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,size: .init(width: view.frame.width, height: navbarHeight))
        view.addSubview(statusView)
        statusView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        collectionView.register(MsgCell.self, forCellWithReuseIdentifier: "cellId")
        // keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        textView.sendBtn.addTarget(self, action: #selector(sendMsg), for: .touchUpInside)
        fetchCurrentUser()
        fetchMsg()
        
        
       
        
    }
    
    
    fileprivate func fetchCurrentUser(){
        guard let currentUserId = Auth.auth().currentUser?.uid else{return}

        Firestore.firestore().collection("users").document(currentUserId).getDocument { (snap, err) in
            if let err = err{
                print("cannot fetch currentUser data")
                return
            }
            guard let dta = snap?.data() else{return}
            let model = UserModel(dictionary: dta)
            self.userMatch = Match(name: model.userName ?? "", profileImageUrl: model.imageUrl1 ?? "", uid: model.uid ?? "")
        }
        
        
        
    }
    
    fileprivate func fetchMsg(){
        guard let currentUserId = Auth.auth().currentUser?.uid else{return}
        Firestore.firestore().collection("match_messages").document(currentUserId).collection(match.uid).order(by: "timestamp").addSnapshotListener({ (snap, err) in
            if let err = err{
                print("error is ",err)
                return
            }
            snap?.documentChanges.forEach({ (doc) in
                if doc.type == .added{
                    let data = doc.document.data()
                    self.msges.append(MsgSave(dictionary: data))
                    
                }
            })
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(item: self.msges.count-1, section: 0), at: .bottom, animated: true)
        })
        
        
        }

    
    
    @objc func sendMsg(){
        
        saveToMessages()
        saveToRecentMessages()
       
    }
    var userMatch : Match?
    
    fileprivate func saveToRecentMessages(){
        guard let currentUserId = Auth.auth().currentUser?.uid else{return}
       
        let data = ["imgUrl":match.profileImageUrl ?? "","rencentMsg" : textView.textField.text ?? "","timeStamp":Timestamp(date: Date()),"uid": match.uid,"userName":match.name] as [String:Any]
        Firestore.firestore().collection("match_messages").document(currentUserId).collection("recentMsg").document(match.uid).setData(data) { (err) in
            if let err = err {
                print("error is ",err)
                return
            }
            print("save to recent msg successfully!")
        }
        
       let toData = ["imgUrl":userMatch?.profileImageUrl ?? "","rencentMsg" : textView.textField.text ?? "","timeStamp":Timestamp(date: Date()),"uid": currentUserId,"userName":userMatch?.name ?? ""] as [String:Any]
        Firestore.firestore().collection("match_messages").document(match.uid).collection("recentMsg").document(currentUserId).setData(toData) { (err) in
            if let err = err {
                print("error is ",err)
                return
            }
            print("save to recent msg successfully!")
        }
        
        
    }
    
    fileprivate func saveToMessages(){
        guard let currentUserId = Auth.auth().currentUser?.uid else{return}
        
        
        let data = ["fromUserId": currentUserId,"toUserId": match.uid,"timestamp":Timestamp(date: Date()),"text":textView.textField.text ?? ""] as [String:Any]
        Firestore.firestore().collection("match_messages").document(currentUserId).collection(match.uid).addDocument(data: data ) { (err) in
            if let err = err {
                print("error is ",err)
                return
            }
            
            
        }
//        let toData = ["fromUserId": match.uid,"toUserId": currentUserId,"timestamp":Timestamp(date: Date()),"text":textView.textField.text ?? ""] as [String:Any]

        Firestore.firestore().collection("match_messages").document(match.uid).collection(currentUserId).addDocument(data: data ) { (err) in
            if let err = err {
                print("error is ",err)
                return
            }
            self.textView.textField.text = nil
            
            self.collectionView.scrollToItem(at: IndexPath(item: self.msges.count-1, section: 0), at: .bottom, animated: true)
        }
        
    }
    
    fileprivate func setUpKeyboardDismiss(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard)))
    }
    
    @objc func dismissKeyBoard(){
        view.endEditing(true)

    }
    
    @objc func backToMsg(){
        navigationController?.popViewController(animated: true)
    }
    
    // inputAccessoryView part
    override var inputAccessoryView: UIView?{
        get{
            return textView
        }
    }
    
    
    
    lazy var textView : InputAccessoryFixedView = {
       let textField = InputAccessoryFixedView(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 50))
        textField.textField.delegate = self
        
        return textField
        
        
    }()
    
    override var canBecomeFirstResponder: Bool
        {
        return true
    }
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollToLastItem()
        collectionView.contentOffset = .init(x: 0, y: 390-navbarHeight+20)

    }

    
    fileprivate func scrollToLastItem(){
        self.collectionView.scrollToItem(at: IndexPath(item: msges.count-1, section: 0), at: .bottom, animated: true)
    }
    
    // keyboard property
    @objc func keyboardWillShow(_ notification:NSNotification){
        if let keyboardframe: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardRec = keyboardframe.cgRectValue
            let keyboardHeight = keyboardRec.height
            print(keyboardHeight)
          
            
        }
        
    }
    
    
    let statusView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
        
    }()
    
    let match : Match
    
    init(match:Match){
        self.match = match
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        super.init(collectionViewLayout: layout)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dummyCell = MsgCell(frame: .init(x: 0, y: 0, width: self.view.frame.width, height: 1000))
        dummyCell.cellInfo = msges[indexPath.item]
        dummyCell.layoutIfNeeded()
        let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
    var msges = [MsgSave]()
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MsgCell
        cell.cellInfo = msges[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return msges.count
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 170, left: 0, bottom: 0, right: 0)
    }
    
 

}

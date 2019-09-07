//
//  SettingProfileTableViewController.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/20/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import JGProgressHUD

class CustomUIImagePickerController : UIImagePickerController{
    
    var imageBtn : UIButton?
}

protocol SettingRefreshHomeControllerDelegate {
    func refreshHomeController()
}


class SettingProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    class CustomUIlabel : UILabel{
        
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 22, dy: 0))
        }
        
        
    }
    var delegate : SettingRefreshHomeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        setUpNavBar()
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        fetchDataFromFirestore()
    }

    
    fileprivate func setUpNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Setting"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(clickCancel))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(clickLogOut)),UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(clickSave))]
        
    }
    
    @objc func clickLogOut(){

            try? Auth.auth().signOut()
        

        dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func clickSave(){
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving"
        hud.show(in: view, animated: true)
        
        let uid = Auth.auth().currentUser?.uid
        saveImageInStorage { err in
            
            if err != nil{
                print("error is ", err)
                return
            }
            let data : [String:Any] = [
                "fullname" : self.userInfo?.userName ?? "",
                "profession" : self.userInfo?.userProfession ?? "",
                "age" : self.userInfo?.userAge ?? "",
                "minSeekingAge" : self.userInfo?.minSeekingAge ?? -1 ,
                "maxSeekingAge" : self.userInfo?.maxSeekingAge ?? -1 ,
                "imageUrl1" : self.userInfo?.imageUrl1 ?? "",
                "imageUrl2" : self.userInfo?.imageUrl2 ?? "",
                "imageUrl3" : self.userInfo?.imageUrl3 ?? "",
                "uid" : uid
                
            ]
            Firestore.firestore().collection("users").document(uid!).setData(data) { (err) in
                if err != nil{
                    print(err)
                    return
                }
                hud.dismiss(animated: true)
                self.dismiss(animated: true, completion: {
                    self.delegate?.refreshHomeController()
                })
            }
        }
        
        
        
        
        
    }
    
    
    fileprivate func saveImageInStorage(completion:@escaping ((Error?)->())){
        let uid = Auth.auth().currentUser?.uid
        if selectedImg == nil {
            completion(nil)
            return
        }
        
        guard let dta = selectedImg?.jpegData(compressionQuality: 0.75) else {return}
        let store = Storage.storage().reference(withPath: "/SettingImage/\(uid!)")
        store.putData(dta, metadata: nil) { (meta, err) in
            if err != nil{
                print("storage issue is ",err)
                completion(err)
                return
            }
            store.downloadURL(completion: { (url, err) in
                if err != nil {
                    print("downLoad url issue ",err)
                    completion(err)
                    return
                }
            print("download url is \(url!.absoluteString)")
                guard let imgUrl = url?.absoluteString else {return}
                if self.pickImgBtn == self.imageBtn1 {
                    self.userInfo?.imageUrl1 = imgUrl

                }else if self.pickImgBtn == self.imageBtn2 {
                    self.userInfo?.imageUrl2 = imgUrl
                    
                }else {
                    self.userInfo?.imageUrl3 = imgUrl

                }
                
                completion(nil)

            })
        }
       
    }
    
    @objc func clickCancel(){
        
        dismiss(animated: true, completion: nil)
    }
    
    var userInfo : UserModel?
    
    fileprivate func fetchDataFromFirestore(){
        
        let uid = Auth.auth().currentUser?.uid
    
        Firestore.firestore().collection("users").document(uid!).getDocument { (snap, err) in
            if err != nil {
                print("err",err)
                return
            }
            
            guard let data = snap?.data() else {return}
            let user = UserModel(dictionary: data)
            self.userInfo = user
            self.loadImage()
            
            self.tableView.reloadData()
        }
        
        
        
    }
    fileprivate func loadImage(){
        
        SDWebImageManager.shared().loadImage(with: URL(string: self.userInfo?.imageUrl1 ?? ""), options: .continueInBackground, progress: nil, completed: { (image, _, _, _, _, _) in
            self.imageBtn1.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        })
        SDWebImageManager.shared().loadImage(with: URL(string: self.userInfo?.imageUrl2 ?? ""), options: .continueInBackground, progress: nil, completed: { (image, _, _, _, _, _) in
            self.imageBtn2.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        })
        SDWebImageManager.shared().loadImage(with: URL(string: self.userInfo?.imageUrl3 ?? ""), options: .continueInBackground, progress: nil, completed: { (image, _, _, _, _, _) in
            self.imageBtn3.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        })
        
    }
    
    fileprivate func createBtn()->UIButton{
        
        let btn = UIButton(type: .system)
        btn.setTitle("Select Image", for: .normal)
        btn.backgroundColor = .white
        btn.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        return btn
        
        
    }
    
    @objc func selectImage(selector:UIButton){
        
        
        let imagePicker = CustomUIImagePickerController()
        imagePicker.imageBtn = selector
        imagePicker.delegate = self
        self.present(imagePicker,animated: true)
    }
    
    var selectedImg : UIImage?
    var pickImgBtn : UIButton?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.originalImage] as? UIImage
        selectedImg = img
        if let pickVC = picker as? CustomUIImagePickerController{
            self.pickImgBtn = pickVC.imageBtn
            pickVC.imageBtn?.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    lazy var imageBtn1 = createBtn()
    lazy var imageBtn2 = createBtn()
    lazy var imageBtn3 = createBtn()


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    
    
    lazy var headerView : UIView = {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        let padding : CGFloat = 16
        headerView.addSubview(imageBtn1)
        imageBtn1.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        imageBtn1.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.45).isActive = true
        let stackView = UIStackView(arrangedSubviews: [imageBtn2,imageBtn3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        headerView.addSubview(stackView)
        stackView.anchor(top: headerView.topAnchor, leading: imageBtn1.trailingAnchor, bottom: imageBtn1.bottomAnchor, trailing: headerView.trailingAnchor,padding: .init(top: padding, left: padding, bottom: 0, right: padding))
        
        return headerView
    }()
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return headerView

        }else {
            
            let textLabel = CustomUIlabel()
            
            switch section {
                
            case  1 : textLabel.text = "Name"
            case  2 : textLabel.text = "Profession"
            case  3 : textLabel.text = "Age"
            case  4 : textLabel.text = "Bio"
            default : textLabel.text = "Seeking Age Range"

            }

            return textLabel
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    
    
    @objc func maxSlide(slide:UISlider){
        
       
      let ageTableCell =  tableView.cellForRow(at: IndexPath(row: 0, section: 5)) as! AgeRangeCell
        maxSlider = slide.value
        slide.value = max(slide.value,minSlider ?? 0)
        ageTableCell.maxLabel.text = "Max \(Int(slide.value))"
        self.userInfo?.maxSeekingAge = Int(slide.value)
    }
    var minSlider : Float?
    var maxSlider : Float?
    
    @objc func minSlide(slide:UISlider){
        
        let ageTableCell =  tableView.cellForRow(at: IndexPath(row: 0, section: 5)) as! AgeRangeCell
        minSlider = slide.value
        slide.value = min(slide.value,maxSlider ?? 0)
        ageTableCell.minLabel.text = "Min \(Int(slide.value))"
        self.userInfo?.minSeekingAge = Int(slide.value)

    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            let cell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            cell.maxAgeSlider.addTarget(self, action: #selector(maxSlide), for: .valueChanged)
            cell.minAgeSlider.addTarget(self, action: #selector(minSlide), for: .valueChanged)
            cell.minLabel.text = "Min \(self.userInfo?.minSeekingAge ?? 18)"
            minSlider = Float(self.userInfo?.minSeekingAge ?? 18)
            cell.maxLabel.text = "Min \(self.userInfo?.maxSeekingAge ?? 50)"
            maxSlider = Float(self.userInfo?.maxSeekingAge ?? 50)
            cell.minAgeSlider.value = Float(self.userInfo?.minSeekingAge ?? Int(cell.minAgeSlider.minimumValue))
            cell.maxAgeSlider.value = Float(self.userInfo?.maxSeekingAge ?? Int(cell.maxAgeSlider.maximumValue))

            return cell
        }
        
        let cell = SettingTableViewCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = userInfo?.userName
            cell.textField.addTarget(self, action: #selector(handleNameType), for: .editingChanged)

            
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = userInfo?.userProfession
            cell.textField.addTarget(self, action: #selector(handleProfessionType), for: .editingChanged)


        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.text = "\(userInfo?.userAge ?? -1)"
            cell.textField.addTarget(self, action: #selector(handleAgeType), for: .editingChanged)


        default:
            cell.textField.placeholder = "Enter Bio"
            
        
            


        }

        return cell
    }
    
    
    @objc fileprivate func handleNameType(textField : UITextField){
        
        userInfo?.userName = textField.text ?? ""
        
    }
    
    @objc fileprivate func handleProfessionType(textField : UITextField){
        
        userInfo?.userProfession = textField.text ?? ""

        
    }
    
    @objc fileprivate func handleAgeType(textField : UITextField){
        
        userInfo?.userAge = Int(textField.text ?? "-1")

        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300

        }else {
            
            return 44
        }
        
    }
}

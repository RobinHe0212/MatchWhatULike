//
//  MoreInfoViewController.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/27/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit
import SDWebImage

class MoreInfoViewController: UIViewController,UIScrollViewDelegate {

    var viewModel : CardViewModel? {
        didSet{
            
            guard let img = viewModel?.bgImages.first, let labelAttribute = viewModel?.wordAttribute else {return}
//            headerImage.sd_setImage(with: URL(string: img), completed: nil)
            swipePageVC.cardViewModel = viewModel
            label.attributedText = labelAttribute
        }
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUplayout()
        
    }
    
    let swipePageVC = SwipePageViewController(allowSwipe: true)
    
    fileprivate func setUplayout() {
        view.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.addSubview(swipePageVC.view)
        
        self.scrollView.addSubview(label)
        label.anchor(top: swipePageVC.view.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        self.view.addSubview(blurTopView)
        blurTopView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.safeAreaLayoutGuide.topAnchor, trailing: self.view.trailingAnchor)
        self.scrollView.addSubview(dismissArray)
        dismissArray.anchor(top: swipePageVC.view.bottomAnchor, leading: nil, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 20), size: .init(width: 50, height: 50))
        let stackView = UIStackView(arrangedSubviews: [
            createBtn(image: UIImage(named: "dismiss_circle")),
            createBtn(image: UIImage(named: "super_like_circle")),
            createBtn(image: UIImage(named: "like_circle"))
            
            ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, trailing: nil)
        stackView.centerXInSuperview()
    }
    
    fileprivate let imageInsetY : CGFloat = 0
    
    override func viewWillLayoutSubviews() {
        swipePageVC.view.frame = .init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width + imageInsetY)
    }
    
    fileprivate func createBtn(image:UIImage!) -> UIButton{
        
        let btn = UIButton(type: .system)
        btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(tapBtn), for: .touchUpInside)
        return btn
        
    }
    @objc func tapBtn(){
        
    }
    
    let dismissArray : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "dismiss").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(tapDismiss), for: .touchUpInside)
        return btn
        
        
    }()
    
    @objc func tapDismiss(){
        
        dismiss(animated: true, completion: nil)
    }
    
    let blurTopView : UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
        
        
    }()
    
    lazy var scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.delegate = self
        sv.contentInsetAdjustmentBehavior = .never
        return sv
        
        
    }()
    

    
    let label : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Amber 30 \nDoctor\n\nLikes to watch Netflix"
        return label
        
        
    }()
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print(offsetY)
        let imageWidth = max(self.view.frame.width - offsetY , self.view.frame.width)
        if offsetY < 0 {
            swipePageVC.view.frame = .init(x: 0, y: offsetY, width: imageWidth, height: imageWidth + imageInsetY)

        }else {
            swipePageVC.view.frame = .init(x: 0, y: -offsetY, width: imageWidth, height: imageWidth + imageInsetY)

        }
        swipePageVC.view.center.x = scrollView.center.x
    }

}

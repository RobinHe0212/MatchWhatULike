//
//  ViewController.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/13/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpStackViews()
        
        

    }
    
    
    
    fileprivate func setUpStackViews() {
        let topStackView = TopStackView(frame: .zero)
        let bottomStackView = BottomStackView(frame: .zero)
        let middleView = UIView()
        let cartV = CartView()
        middleView.addSubview(cartV)
        cartV.fillSuperview()
        
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
    }


}


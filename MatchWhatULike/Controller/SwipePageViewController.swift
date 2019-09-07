//
//  SwipePageViewController.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/27/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import UIKit

class SwipePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var cardViewModel : CardViewModel!{
        
        didSet{
            
            controllers = cardViewModel.bgImages.map({ (img) -> UIViewController in
                let pageVC = PageImageViewController(imageUrl: img)
                return pageVC
            })
            setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
            setUpStackBar()
        }
        
        
    }
    
    var isAllowSwipe : Bool = true
    
    init(allowSwipe : Bool = false){
        isAllowSwipe = allowSwipe
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var barStackView = UIStackView(arrangedSubviews: [])
    
    fileprivate func setUpStackBar(){
        
        
        
        cardViewModel.bgImages.forEach { (_) in
            let barView = UIView()
            barView.layer.cornerRadius = 2
            barView.backgroundColor = deselectClw
            barStackView.addArrangedSubview(barView)
            
        }
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        barStackView.spacing = 8
        barStackView.distribution = .fillEqually
        self.view.addSubview(barStackView)
        barStackView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        
        
    }
    
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if !isAllowSwipe {
            diableSwipeFunction()
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchCard)))
        
    }
    
    @objc func switchCard(ges:UITapGestureRecognizer){
        
        if ges.location(in: self.view).x > self.view.bounds.width / 2 {
            let index = controllers.firstIndex(where: { $0 == viewControllers?.first }) ?? 0
            let nextIndex = min(index + 1, controllers.count - 1)
            self.setViewControllers([controllers[nextIndex]], direction: .forward, animated: false, completion: nil)
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectClw})
            barStackView.arrangedSubviews[nextIndex].backgroundColor = UIColor.white
            
        }else {
            let index = controllers.firstIndex(where: { $0 == viewControllers?.first }) ?? 0
            let previousIndex = max(index - 1, 0)
            self.setViewControllers([controllers[previousIndex]], direction: .forward, animated: false, completion: nil)
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectClw})
            barStackView.arrangedSubviews[previousIndex].backgroundColor = UIColor.white
        }
        
    }
    
    fileprivate func diableSwipeFunction(){
        
        self.view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 {return nil}
        return controllers[index-1]
        
    }
   
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count-1 {return nil}
        return controllers[index+1]
    }
    
    fileprivate let deselectClw = UIColor(white: 0, alpha: 0.2)
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentView = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentView}){
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectClw})
            barStackView.arrangedSubviews[index].backgroundColor = UIColor.white
            
        }
    }
    
    class PageImageViewController : UIViewController{
        
        let image = UIImageView(image: #imageLiteral(resourceName: "lady2"))
        
        init(imageUrl:String){
            super.init(nibName: nil, bundle: nil)
            self.image.sd_setImage(with: URL(string: imageUrl), completed: nil)

        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.addSubview(image)
            image.fillSuperview()
            image.contentMode = .scaleAspectFill
            
        }
        
    }

}

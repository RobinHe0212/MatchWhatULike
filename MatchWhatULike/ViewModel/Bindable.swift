//
//  Bindable.swift
//  MatchWhatULike
//
//  Created by Robin He on 5/16/19.
//  Copyright © 2019 Robin He. All rights reserved.
//

import Foundation

class Bindable<T> {
    
    var value : T?{
        
        didSet{
            observer?(value)
        }
        
    }
    
    var observer : ((T?)->())?
    
//    func bind(observer:@escaping (T?)->()){
//
//        self.observer = observer
//
//    }
    
}

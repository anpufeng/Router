//
//  NoXibViewController.swift
//  RouterDemo
//
//  Created by ethan on 16/8/18.
//  Copyright © 2016年 zhongan. All rights reserved.
//

import UIKit
import Router

class NoXibViewController: UIViewController {
    var age: Int
    var name: String
    
    static let kAgeKey = "int"
    static let kNameKey = "string"

    
    init(age: Int, name: String) {
        self.age = age
        self.name = name
        
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
        
        print("age: \(age), name: \(name)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
}


//MARK: routable

extension NoXibViewController: Routable {
    static func initWithParams(params: RouterParam?) -> UIViewController? {
        if let params = params {
            let routerParam = RouterParams(params: params)
            var age: Int?
            var name: String?
            routerParam.valueWithKey(kAgeKey, out: &age)
            routerParam.valueWithKey(kNameKey, out: &name)
            guard let realAge = age, realName = name else {
                return nil
            }
            return NoXibViewController(age: realAge, name: realName)
        } else {
            return nil
        }
    }
    
    static var routableKey: String {
        return "NoXibViewController"
    }
}




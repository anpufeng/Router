//
//  FirstViewController.swift
//  RouterDemo
//
//  Created by ethan on 16/7/11.
//  Copyright © 2016年 zhongan. All rights reserved.
//

import UIKit
import Router

enum Week {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
}

class ClassModel {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    var description: String {
        return  name
    }

}

struct StructModel {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class FirstViewController: UIViewController {
    static let kStringKey = "string"
    static let kIntKey = "int"
    static let kEnumKey = "enum"
    static let kClassKey = "class"
    static let kStructKey = "struct"
    static let kClosureKey = "closure"
    
    var name: String?
    var age: Int?
    var week: Week = .Monday
    var classModel: ClassModel?
    var structModel: StructModel?
    var closure:((name: String, age: Int) -> String)?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: actions
    
    @IBAction func responseToRouterBtn(sender: UIButton) {
        Router.sharedInstance.open(FirstViewController.routableKey)
    }
    
    @IBAction func responseToRouterParamsBtn(sender: UIButton) {
        let closure = {(name: String, age: Int) -> String in {
                return "name: \(name), age: \(age)"
            }()
        }
        
        let params: RouterParam = [FirstViewController.kStringKey: "zhongan",
                                   FirstViewController.kIntKey: 3,
                                   FirstViewController.kEnumKey: Week.Monday,
                                   FirstViewController.kClassKey: ClassModel(name: "china"),
                                   FirstViewController.kStructKey: StructModel(name: "us"),
                                   FirstViewController.kClosureKey: closure]
        
        Router.sharedInstance.open(FirstViewController.routableKey, params: params)
    }
    @IBAction func responseToRouterWebBtn(sender: UIButton) {
        Router.sharedInstance.open(WebViewController.routableKey, animated: true) { (opened) in
            if let opened = opened as? WebViewController {
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue(), {
                    opened.loadURL("https://www.baidu.com")
                })
                
            }
        }
    }
    
    @IBAction func responseToOptionBtn(sender: AnyObject) {
        let option = RouterOptions(presentationStyle: .FormSheet, transitionStyle: .FlipHorizontal, isModal: true, isRoot: false)
        Router.sharedInstance.open(SecondViewController.routableKey, options: option)
    }
    @IBAction func responseToRouterOptionNavBtn(sender: UIButton) {
        let option = RouterOptions(presentationStyle: .Popover, transitionStyle: .FlipHorizontal, isModal: true, isRoot: false)
        Router.sharedInstance.open(FirstNavigationController.routableKey, options: option)
    }
    @IBAction func responseToPopBtn(sender: UIButton) {
        Router.sharedInstance.pop()
    }
    @IBAction func responseToWithoutAnimatBtn(sender: UIButton) {
        Router.sharedInstance.pop(animated: false)
    }
    
    @IBAction func responseToPopToRootBtn(sender: UIButton) {
        Router.sharedInstance.pop(toRoot:true, animated: true)
    }
    
    
    @IBAction func responseToExternalWebBtn(sender: AnyObject) {
        Router.sharedInstance.openExternal("http://www.baidu.com")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: routable

extension FirstViewController: Routable {
    static func initWithParams(params: RouterParam?) -> UIViewController {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("FirstViewController") as! FirstViewController
        vc.hidesBottomBarWhenPushed = true
        
        if let params = params {
            let routerParam = RouterParams(params: params)
            routerParam.valueWithKey(kStringKey, out: &vc.name)
            routerParam.valueWithKey(kIntKey, out: &vc.age)
            routerParam.valueWithKey(kEnumKey, out: &vc.week)
            routerParam.valueWithKey(kClassKey, out: &vc.classModel)
            routerParam.valueWithKey(kStructKey, out: &vc.structModel)
            routerParam.valueWithKey(kClosureKey, out: &vc.closure)
            
            print("获取到参数 String姓名: \(vc.name)\n Int年龄: \(vc.age)\n Enum周几: \(vc.week)\n Class: \(vc.classModel?.description)\n Struct: \(vc.structModel)\n")
            let result = vc.closure!(name: "Lily", age: 10)
            print("获取到闭包并执行后结果: \(result)")
        }
        
        return vc
    }
    
    static var routableKey: String {
        return "FirstViewController"
    }
}
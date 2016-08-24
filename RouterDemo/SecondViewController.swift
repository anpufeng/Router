//
//  SecondViewController.swift
//  RouterDemo
//
//  Created by ethan on 16/7/11.
//  Copyright © 2016年 ethanwhy. All rights reserved.
//

import UIKit
import Router

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func responseToPopBtn(sender: UIButton) {
        Router.sharedInstance.pop()
    }

    @IBAction func responseToOptionModalBtn(sender: AnyObject) {
        let option = RouterOptions(presentationStyle: .FormSheet, transitionStyle: .FlipHorizontal, isModal: true, isRoot: false)
        Router.sharedInstance.open(SecondViewController.routableKey, options: option)
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

extension SecondViewController: Routable {
    
    static func initWithParams(params: RouterParam?) -> UIViewController? {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("SecondViewController") as! SecondViewController
        vc.hidesBottomBarWhenPushed = true
        
        return vc
    }
    
    static var routableKey: String {
        return "SecondViewController"
    }
    
    static var routerOption: RouterOptions {
       return RouterOptions(presentationStyle: .FormSheet, transitionStyle: .FlipHorizontal, isModal: true, isRoot: false)
    }
}
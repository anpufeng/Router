//
//  FirstNavigationController.swift
//  RouterDemo
//
//  Created by ethan on 16/7/11.
//  Copyright © 2016年 zhongan. All rights reserved.
//

import UIKit
import Router

class FirstNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension FirstNavigationController: Routable {
    static func initWithParams(params: RouterParam?) -> UIViewController? {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("SecondViewController") as! SecondViewController
        vc.hidesBottomBarWhenPushed = true
        let nav = UINavigationController(rootViewController: vc)
        
        return nav
    }
    
    static var routableKey: String {
        return "FirstNavigationController"
    }
}
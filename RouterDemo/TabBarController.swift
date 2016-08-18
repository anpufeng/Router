//
//  TabBarController.swift
//  RouterDemo
//
//  Created by ethan on 16/7/11.
//  Copyright © 2016年 zhongan. All rights reserved.
//

import UIKit
import Router

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initRouter()

        // Do any additional setup after loading the view.
    }
    
    func initRouter() {
        guard let navs = self.viewControllers, nav = navs[0] as? UINavigationController else {
            return
        }
        
        let router = Router.sharedInstance
        router.navigationController = nav
        
        router.map(FirstViewController.routableKey, className: FirstViewController.description())
        router.map(SecondViewController.routableKey, className: SecondViewController.description())
        router.map(LoginViewController.routableKey, className: LoginViewController.description())
        router.map(WebViewController.routableKey, className: WebViewController.description())
        router.map(FirstNavigationController.routableKey, className: FirstNavigationController.description())
        router.map(NoXibViewController.routableKey, className: NoXibViewController.description())
        router.map(UIAlertController.routableKey, className: UIAlertController.description())
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

//
//  LoginViewController.swift
//  RouterDemo
//
//  Created by ethan on 16/7/11.
//  Copyright © 2016年 ethanwhy. All rights reserved.
//

import UIKit
import Router

class LoginViewController: UIViewController {

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


//MARK: routable

extension LoginViewController: Routable {
    static func initWithParams(params: RouterParam?) -> UIViewController? {
        let vc = LoginViewController()
//        let sb = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewControllerWithIdentifier("LoginViewController") as! SecondViewController
//        if let params = params {
//            let rp = RouterParams(params: params)
//        }
        return vc
    }
    
    static var routableKey: String {
        return "LoginViewController"
    }
}
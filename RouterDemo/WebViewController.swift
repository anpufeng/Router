//
//  WebViewController.swift
//  RouterDemo
//
//  Created by ethan on 16/7/11.
//  Copyright © 2016年 ethanwhy. All rights reserved.
//

import UIKit
import Router

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func loadURL(_ url: String) {
        guard let u = URL(string: url) else {
            return
        }

        let request = URLRequest(url: u)
        self.webView.loadRequest(request)
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

extension WebViewController: Routable {
    static func initWithParams(_ params: RouterParam?) -> UIViewController? {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
    
    static var routableKey: String {
        return "WebViewController"
    }
}

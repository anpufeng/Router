//
//  SpecialRoutable.swift
//  RouterDemo
//
//  Created by ethan on 16/8/18.
//  Copyright © 2016年 ethanwhy. All rights reserved.
//

import Foundation

extension UIAlertController: Routable {
    public class func alertParams(_ title: String?, message: String?, preferredStyle: UIAlertControllerStyle) -> RouterParam {
        return ["title": title,
                "message": message,
                "preferredStyle": preferredStyle]
    }
    
    public class var defaultRouterOptions: RouterOptions {
        return RouterOptions(presentationStyle: .fullScreen, transitionStyle: .coverVertical, isModal: true, isRoot: false)
    }
    
    public static func initWithParams(_ params: RouterParam?) -> UIViewController? {
        guard let params = params else {
            return nil
        }
        
        var title: String?
        var message: String?
        var style: UIAlertControllerStyle?
        let converter = RouterParamsConverter(params: params)
        converter.valueWithKey("title", out: &title)
        converter.valueWithKey("message", out: &message)
        converter.valueWithKey("preferredStyle", out: &style)
        
        return UIAlertController(title: title, message: message, preferredStyle: style ?? .alert)
    }
   
    public static var routableKey:String {
        return "UIAlertController"
    }
}

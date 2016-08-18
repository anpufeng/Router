//
//  Router.swift
//  ZAFinance
//
//  Created by ethan on 16/7/8.
//  Copyright © 2016年 zhongan. All rights reserved.
//

import Foundation

//TODO: 1: 传参是否可优化 2: 更多场景测试

public typealias  RouterParam = [String: Any]

public enum ExternalRouterType {
    case Safari
    case Phone
    case SMS
    case Mail
    case OtherApp
    
    func router(url: String) -> NSURL? {
        switch self {
        case .Safari:
            return NSURL(string: url)
        case .Phone:
            return NSURL(string: "tel:\(url)")
        case .SMS:
            return NSURL(string: "sms:\(url)")
        case .Mail:
            return NSURL(string: "mailto:\(url)")
        case .OtherApp:
            return NSURL(string: url)
        }
    }
}

//MARK: Routable
public protocol Routable {
    
    /**
     类的初始化方法 
     - params 传参字典
     */
    static func initWithParams(params: RouterParam?) -> UIViewController?
    /**
     每个类跳转对应的key
     */
    static var routableKey:String { get }
}

//MARK: RouterOptions

public class RouterOptions {
    let presentationStyle: UIModalPresentationStyle
    let transitionStyle: UIModalTransitionStyle
    /** 只有在isModal为true是才会考虑modal下的style */
    var isModal = false
    /** 只对pushViewController有效 */
    var shouldOpenAsRoot = false
    
    public class func defaultOptions() -> RouterOptions {
        return RouterOptions(presentationStyle: .FullScreen, transitionStyle: .CoverVertical, isModal: true, isRoot: false)
    }
    
    public init(presentationStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle) {
        self.presentationStyle = presentationStyle
        self.transitionStyle = transitionStyle
    }
    
    public init(presentationStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle, isModal: Bool, isRoot: Bool) {
        self.presentationStyle = presentationStyle
        self.transitionStyle = transitionStyle
        self.isModal = isModal
        self.shouldOpenAsRoot = isRoot
    }
}

//MARK: Router

public class Router {
    public static let sharedInstance = Router()
    
    public var navigationController: UINavigationController?
    var classes: [String: String] = [:]
    
    /**
     将key与对应的类名进行映射
     - key 对应的routableKey
     - className 调用vc.description()函数
     */
    public func map(key: String, className: String) -> Void {
        classes[key] = className
    }
    
    //MARK: open
   
    /**
     打开对应key的界面
     - completion 完成push/present后会调用此closure, 参数为通过key刚初始化的ViewControler
     */
    public func open(key: String, animated: Bool = true, completion: ((opened: UIViewController?) -> Void)? = nil) {
       open(key, params: nil, options: nil, animated: animated, completion: completion)
    }
    
    public func open(key:String, params: RouterParam, animated: Bool = true, completion: ((opened: UIViewController?) -> Void)? = nil) {
       open(key, params: params, options: nil, animated: animated, completion: completion)
    }
    
    public func open(key:String, options: RouterOptions, animated: Bool = true, completion: ((opened: UIViewController?) -> Void)? = nil) {
       open(key, params: nil, options: options, animated: animated, completion: completion)
    }
    
    public func open(key: String, params: RouterParam, options: RouterOptions, animated: Bool, completion: ((opened: UIViewController) -> Void)? = nil) {
       open(key, params: params, options: options, animated: animated, completion: completion)
    }
 
    private func open(key: String, params: RouterParam?, options: RouterOptions?, animated: Bool, completion: ((opened: UIViewController?) -> Void)?) {
        guard let nav = navigationController else {
             completion?(opened: nil)
            return
        }
        
        guard let clsName = classes[key], cls = NSClassFromString(clsName) as? Routable.Type else {
            print("can not find the maaped vc, make sure implement protocol routable and call map method")
            completion?(opened: nil)
            return
        }
        
        if nav.presentedViewController != nil {
            print("dismiss the vc that has been presented:\(nav.presentedViewController)")
            nav.dismissViewControllerAnimated(false, completion: {
                
            })
        }
        
        guard let vc = cls.initWithParams(params) else {
            print("concrete vc error");
            return
        }
        if let options = options {
            if options.isModal {
                vc.modalTransitionStyle = options.transitionStyle
                vc.modalPresentationStyle = options.presentationStyle
                nav.presentViewController(vc, animated: animated, completion: {
                    completion?(opened: vc)
                })
            } else {
                if options.shouldOpenAsRoot {
                    nav.setViewControllers([vc], animated: animated)
                    completion?(opened: vc)
                } else {
                    nav.pushViewController(vc, animated: animated)
                    completion?(opened: vc)
                }
            }
        } else {
            nav.pushViewController(vc, animated: animated)
            completion?(opened: vc)
        }
    }
    
   
    public func openExternal(url: String, type: ExternalRouterType = .Safari) {
        guard let routerURL = type.router(url) else {
            return
        }
       
        UIApplication.sharedApplication().openURL(routerURL)
    }
    
    //MARK:  pop
    
    public func pop(animated animated: Bool = true) {
        guard let nav = navigationController else {
            return
        }
        
        if nav.presentedViewController != nil {
            nav.dismissViewControllerAnimated(animated, completion: { 
                
            })
        } else {
            nav.popViewControllerAnimated(animated)
        }
    }
    
    public func pop(to to: String, animated: Bool) {
        guard let nav = navigationController else {
            print("no navigationController")
            return
        }
        
        
        func popTo() {
            if let clsName = classes[to] {
                for vc in nav.viewControllers {
                    if vc.description == clsName {
                        nav.popToViewController(vc, animated: animated)
                        break
                    }
                }
            } else {
                print("can not find the vc mapped to the key: \(to)")
            }
        }
        
        if let presented = nav.presentedViewController {
            if presented.description == classes[to] {
                nav.dismissViewControllerAnimated(animated, completion: nil)
            } else {
                nav.dismissViewControllerAnimated(false, completion: nil)
                popTo()
            }
        } else {
            popTo()
        }
    }
 
    
    public func pop(toRoot toRoot: Bool, animated: Bool = true) {
        guard let nav = navigationController else {
            return
        }
        
        if nav.presentedViewController != nil {
            nav.dismissViewControllerAnimated(animated, completion: {
                
            })
        } else {
            if toRoot {
                nav.popToRootViewControllerAnimated(animated)
            } else {
                nav.popViewControllerAnimated(animated)
            }
        }
    }
}


//MARK: RouteParamsConvertable

public protocol RouteParamsConvertable {
    func valueWithKey<T>(key: String, inout out: T?) -> Void
    func valueWithKey<T>(key: String, inout out: T) -> Void
}


//MARK: RouterParams

public class RouterParams: RouteParamsConvertable {
   
    var params: RouterParam
    public func valueWithKey<T>(key: String, inout out: T?) -> Void {
        out = (params[key] as? T)
    }
    
    public func valueWithKey<T>(key: String, inout out: T) -> Void {
        out = (params[key] as! T)
    }
    
    public init(params: RouterParam) {
        self.params = params;
    }
}
//
//  Router.swift
//  ethanwhy
//
//  Created by ethan on 16/7/8.
//  Copyright © 2016年 ethanwhy. All rights reserved.
//

import Foundation

//TODO: 1: 传参是否可优化 2: 更多场景测试

public typealias  RouterParam = [String: Any]

public enum ExternalRouterType {
    case safari
    case phone
    case sms
    case mail
    case otherApp
    
    func router(_ url: String) -> URL? {
        switch self {
        case .safari:
            return URL(string: url)
        case .phone:
            return URL(string: "tel:\(url)")
        case .sms:
            return URL(string: "sms:\(url)")
        case .mail:
            return URL(string: "mailto:\(url)")
        case .otherApp:
            return URL(string: url)
        }
    }
}

//MARK: Routable
public protocol Routable {
    
    /**
     类的初始化方法 
     - params 传参字典
     */
    static func initWithParams(_ params: RouterParam?) -> UIViewController?
    /**
     每个类跳转对应的key
     */
    static var routableKey:String { get }
}

//MARK: RouterOptions

open class RouterOptions {
    let presentationStyle: UIModalPresentationStyle
    let transitionStyle: UIModalTransitionStyle
    /** 只有在isModal为true是才会考虑modal下的style */
    var isModal = false
    /** 只对pushViewController有效 */
    var shouldOpenAsRoot = false
    
    open class func defaultOptions() -> RouterOptions {
        return RouterOptions(presentationStyle: .fullScreen, transitionStyle: .coverVertical, isModal: true, isRoot: false)
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

open class Router {
    open static let sharedInstance = Router()
    
    open var navigationController: UINavigationController?
    var classes: [String: String] = [:]
    
    /**
     将key与对应的类名进行映射
     - key 对应的routableKey
     - className 调用vc.description()函数
     */
    open func map(_ key: String, className: String) -> Void {
        classes[key] = className
    }
    
    //MARK: open
   
    /**
     打开对应key的界面
     - completion 完成push/present后会调用此closure, 在animated完成前, 参数为通过key刚初始化的ViewControler
     */
    open func open(_ key: String, animated: Bool = true, completion: ((_ opened: UIViewController?) -> Void)? = nil) {
       open(key, params: nil, options: nil, animated: animated, completion: completion, unused: true)
    }
    
    open func open(_ key:String, params: RouterParam, animated: Bool = true, completion: ((_ opened: UIViewController?) -> Void)? = nil) {
       open(key, params: params, options: nil, animated: animated, completion: completion, unused: true)
    }
    
    open func open(_ key:String, options: RouterOptions, animated: Bool = true, completion: ((_ opened: UIViewController?) -> Void)? = nil) {
       open(key, params: nil, options: options, animated: animated, completion: completion, unused: true)
    }
    
    open func open(_ key: String, params: RouterParam, options: RouterOptions, animated: Bool, completion: ((_ opened: UIViewController?) -> Void)? = nil) {
       open(key, params: params, options: options, animated: animated, completion: completion, unused: true)
    }
 
    /**
     private 只为调用方便
 
     - parameter unused:     仅为区分函数调用
     */
    fileprivate func open(_ key: String, params: RouterParam?, options: RouterOptions?, animated: Bool, completion: ((_ opened: UIViewController?) -> Void)?, unused: Bool) {
        guard let nav = navigationController else {
             completion?(nil)
            return
        }
        
        guard let clsName = classes[key], let cls = NSClassFromString(clsName) as? Routable.Type else {
            print("can not find the maaped vc, make sure implement protocol routable and call map method")
            completion?(nil)
            return
        }
        
        if nav.presentedViewController != nil {
            print("dismiss the vc that has been presented:\(nav.presentedViewController)")
            nav.dismiss(animated: false, completion: nil)
        }
        
        guard let vc = cls.initWithParams(params) else {
            print("concrete vc error");
            return
        }
        
        if let options = options {
            if options.isModal {
                vc.modalTransitionStyle = options.transitionStyle
                vc.modalPresentationStyle = options.presentationStyle
                nav.present(vc, animated: animated, completion: nil)
                completion?(vc)
                
            } else {
                if options.shouldOpenAsRoot {
                    nav.setViewControllers([vc], animated: animated)
                    completion?(vc)
                } else {
                    nav.pushViewController(vc, animated: animated)
                    completion?(vc)
                }
            }
        } else {
            nav.pushViewController(vc, animated: animated)
            completion?(vc)
        }
    }
    
   
    open func openExternal(_ url: String, type: ExternalRouterType = .safari) {
        guard let routerURL = type.router(url) else {
            return
        }
       
        UIApplication.shared.openURL(routerURL)
    }
    
    //MARK:  pop
    
    open func pop(animated: Bool = true) {
        guard let nav = navigationController else {
            return
        }
        
        if nav.presentedViewController != nil {
            nav.dismiss(animated: animated, completion: nil)
        } else {
            nav.popViewController(animated: animated)
        }
    }
    
    open func pop(to: String, animated: Bool) {
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
                nav.dismiss(animated: animated, completion: nil)
            } else {
                nav.dismiss(animated: false, completion: nil)
                popTo()
            }
        } else {
            popTo()
        }
    }
 
    
    open func pop(toRoot: Bool, animated: Bool = true) {
        guard let nav = navigationController else {
            return
        }
        
        if nav.presentedViewController != nil {
            nav.dismiss(animated: animated, completion: nil)
        } else {
            if toRoot {
                nav.popToRootViewController(animated: animated)
            } else {
                nav.popViewController(animated: animated)
            }
        }
    }
}


//MARK: RouteParamsConvertable

public protocol RouteParamsConvertable {
    func valueWithKey<T>(_ key: String, out: inout T?) -> Void
    func valueWithKey<T>(_ key: String, out: inout T) -> Void
}


//MARK: RouterParams

open class RouterParamsConverter: RouteParamsConvertable {
   
    var params: RouterParam
    open func valueWithKey<T>(_ key: String, out: inout T?) -> Void {
        out = (params[key] as? T)
    }
    
    open func valueWithKey<T>(_ key: String, out: inout T) -> Void {
        out = (params[key] as! T)
    }
    
    public init(params: RouterParam) {
        self.params = params;
    }
}

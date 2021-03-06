//
//  AppDelegate.swift
//  RouterDemo
//
//  Created by ethan on 16/7/11.
//  Copyright © 2016年 ethanwhy. All rights reserved.
//

import UIKit
import Router

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let tabbarController = window?.rootViewController as? TabBarController {
            initRouter(tabbarController)
            tabbarController.delegate = self
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


extension AppDelegate: UITabBarControllerDelegate {
    func initRouter(_ tabBarController: TabBarController) {
        guard let navs = tabBarController.viewControllers, let nav = navs[0] as? UINavigationController else {
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let nav = viewController as? UINavigationController {
            Router.sharedInstance.navigationController = nav
        }
    }
}


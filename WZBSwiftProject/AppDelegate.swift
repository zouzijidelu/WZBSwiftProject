//
//  AppDelegate.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/4/17.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Swizzle.performOnce()
        //UIViewController.awake()
        let _ = try? BZMessageSendVC.swift_hook(with: #selector(UIViewController.viewDidLoad), options: .positionBefore) { (info) in
            debugPrint("swift_hook")
        }
        let _ = try? BZMsgSendObject.swift_hook(with: #selector(BZMsgSendObject.testAspect), options: .positionBefore) { (info) in
            debugPrint("testAspect hook")
        }
        var temp = [Int]()
        temp.popLast()
        return true
    }
}


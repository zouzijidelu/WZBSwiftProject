//
//  BZNSNotificationCenter.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/11/23.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    struct Test {
        public static let todo = "com.italkbb.WZBSwiftProject111.todo"
    }
}

class BZNSNotificationCenter {
    static func postNotifcation() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NSNotification.Name.Test.todo), object: [param1:"section1"])
        
    }
}

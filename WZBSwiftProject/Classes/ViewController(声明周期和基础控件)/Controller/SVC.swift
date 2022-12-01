//
//  SVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/24.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit
let param1 = "param1"
class SVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(testNotifcation(noti:)), name:NSNotification.Name(rawValue: NSNotification.Name.Test.todo), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(testNotifcation(noti:)), name:NSNotification.Name(rawValue: NSNotification.Name.Test.todo), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(testNotifcation(noti:)), name:NSNotification.Name(rawValue: NSNotification.Name.Test.todo), object: nil)
    }
    
    @objc func testNotifcation(noti:Notification) {
        let param = noti.userInfo?[param1]
        debugPrint("testNotifcation: \(param ?? "")")
    }
    
    @IBAction func click(_ sender: Any) {
        BZNSNotificationCenter.postNotifcation()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

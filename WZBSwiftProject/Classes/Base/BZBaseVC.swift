//
//  BZBaseVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/24.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZBaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    deinit {
        debugPrint("\(NSStringFromClass(self.classForCoder)) deinit")
    }
}

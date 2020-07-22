//
//  BZBaseNaviController.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/5/18.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZBaseNaviController: UINavigationController {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}

//
//  LayoutUtil.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/24.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit
//1.导航栏高度 88 非IPoneX 64
//2.状态栏高度44 非IPoneX 20
//3.tabar高度83 非IPhoneX 49
class LayoutUtil {
    static func isIphoneXOrLater() -> Bool {
        
        guard #available(iOS 11.0, *) else {
            return false
        }
        let isX = UIApplication.shared.windows[0].safeAreaInsets.bottom > 0
        print("isX \(isX)")
        return isX
    }
    
    static func getTopBarHeight() -> CGFloat {
        return isIphoneXOrLater() ? 88 : 64
    }
    
    static func getBottonHeight() -> CGFloat {
        return isIphoneXOrLater() ? 83 : 49
    }
}

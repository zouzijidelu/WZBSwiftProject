//
//  LayoutUtil.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/24.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

extension UIView {
    func sgm_safeAreaInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets.top
        }
        return 0
    }
}


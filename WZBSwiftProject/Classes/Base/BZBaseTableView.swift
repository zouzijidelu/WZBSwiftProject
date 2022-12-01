//
//  BZBaseTableView.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/28.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZBaseTableView: UITableView, UIGestureRecognizerDelegate {
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

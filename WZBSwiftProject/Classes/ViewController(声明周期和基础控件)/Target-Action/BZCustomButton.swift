//
//  BZCustomButton.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/8/3.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZCustomButton: UIView {

    private var _target: AnyObject?
    private var _action: Selector?
    func addCustomButton(target: AnyObject, action: Selector) {
        if _target === target {
            return
        }
        _target = target
        _action = action
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let target = _target {
            if target.responds(to: _action) {
                _ = target.perform(_action, with: self)
            }
        }
    }
}

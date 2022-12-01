//
//  BZMsgSendObject.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/8/1.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZMsgSendObject: NSObject {
    @objc func testAspect() {
        debugPrint("testAspect original")
    }
    // 动态方法解析
    override class func resolveInstanceMethod(_ sel: Selector!) -> Bool {
        guard let method = class_getInstanceMethod(self, #selector(runIMP)) else {
            return super.resolveInstanceMethod(sel)
        }
        return class_addMethod(self, Selector("test"), method_getImplementation(method), method_getTypeEncoding(method))
    }

    @objc func runIMP() {
        debugPrint("runIMP")
    }
    // 快速消息转发
//    override func forwardingTarget(for aSelector: Selector!) -> Any? {
//        return BZMsgSendObjectTemp()
//    }
}

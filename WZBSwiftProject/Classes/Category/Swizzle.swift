//
//  SwizzleVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/25.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

//protocol SwizzleProtocol: class {
//    static func swizzle()
//}

class Swizzle {

    static func performOnce() {
        UIViewController.swizzle()
    }
    
    // not good
//    func method2() {
//        let typeCount = Int(objc_getClassList(nil, 0))
//        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
//        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
//        objc_getClassList(autoreleasingTypes, Int32(typeCount))
//        for index in 0..<typeCount {
//            (types[index] as? SwizzleProtocol.Type)?.swizzle()
//        }
//        types.deallocate()
//    }
}



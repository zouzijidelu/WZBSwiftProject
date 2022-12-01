//
//  VC+Statistics.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/25.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

extension UIViewController {
    
    private struct VCCategoryKeys {
        static var vcNameKey = "vcNameKey"
        static var isTraceBrowseKey = "isTraceBrowseKey"
    }
    var name: String {
        get{
            guard let t = objc_getAssociatedObject(self, &VCCategoryKeys.vcNameKey) as? String else {
                return NSStringFromClass(self.classForCoder)
            }
            return t
        }
        set{
            objc_setAssociatedObject(self, &VCCategoryKeys.vcNameKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var isTraceBrowse: Bool {
        get{
            guard let isT = objc_getAssociatedObject(self, &VCCategoryKeys.isTraceBrowseKey) as? Bool else {
                return false
            }
            return isT
        }
        set{
            objc_setAssociatedObject(self, &VCCategoryKeys.isTraceBrowseKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    static func swizzle() {
        let originalSelector: Selector = #selector(viewDidAppear(_:))
        let swizzleSelector: Selector = #selector(wzb_viewDidAppear(_:))
        guard let originalM = class_getInstanceMethod(self, originalSelector) else {
            return
        }
        guard let swizzleM = class_getInstanceMethod(self, swizzleSelector) else {
            return
        }
        let didAdd = class_addMethod(self, originalSelector, method_getImplementation(swizzleM), method_getTypeEncoding(swizzleM))
        if didAdd {
            class_replaceMethod(self, swizzleSelector, method_getImplementation(originalM), method_getTypeEncoding(originalM))
        } else {
            method_exchangeImplementations(originalM, swizzleM)
        }
    }
    
    @objc func wzb_viewDidAppear(_ animated: Bool) {
        wzb_viewDidAppear(animated)
        if self.isTraceBrowse {
            debugPrint("统计进入某个页面 --- name: \(self.name)")
        }
        
    }
}


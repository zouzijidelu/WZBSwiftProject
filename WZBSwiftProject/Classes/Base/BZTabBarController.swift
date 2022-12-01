//
//  BZTabBarController.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/12/22.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZTabBarController: UITabBarController,UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = UIColor.clear             //tabbar背景色
        UITabBar.appearance().shadowImage = UIImage()
        tabBar.tintColor = UIColor.red
        tabBar.isTranslucent = true
        Solution().reverseWords("i am a loser")
        
    }
}
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.next = nil
 *     }
 * }
 */

class ListNode {
    public var val: Int
    public var next: ListNode?
    init(val: Int) {
        self.val = val
        self.next = nil
    }
}


class Solution {
    func reverseWords(_ s: String) -> String {
        var t = ""
        let sArr = Array(s)
        var wArr = [String]()
        for i in sArr {
            if i == " " {
                wArr.append(t)
                t = ""
                continue
            }
            t.append(i)
        }
        wArr.append(t)
        t = ""
        for i in wArr.reversed() {
            t.append(i)
        }
        return t
    }
}

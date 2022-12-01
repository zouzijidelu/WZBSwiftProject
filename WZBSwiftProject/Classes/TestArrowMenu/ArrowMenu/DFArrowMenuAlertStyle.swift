//
//  DFArrowMenuAlertStyle.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/8/4.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class DFArrowMenuAlertStyle {
    var backgroundColor: UIColor
    var showSeparateLine: Bool
    var linColor: UIColor
    var triangleSize: CGSize
    var triangleLeftMargin: CGFloat
    var enableShadow: Bool
    var cornerRadius: CGFloat
    var isNeedLine: Bool
    
    init() {
        backgroundColor = .clear
        showSeparateLine = false
        linColor = .lightText
        triangleLeftMargin = 10
        triangleSize = CGSize(width: 18, height: 10)
        cornerRadius = 5
        enableShadow = true
        isNeedLine = true
    }
}

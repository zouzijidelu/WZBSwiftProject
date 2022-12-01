//
//  DFArrowMenuItemStyle.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/8/4.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

enum DFArrowMenuItemType {
    case iconAndText
    case titleAndDetailText
}

class DFArrowMenuItemStyle: NSObject {
    var type: DFArrowMenuItemType?
    var title: String
    var detailText: String
    var icon: UIImage?
    var itemIconSize: CGSize
    var backgroundColor: UIColor
    var pressBackgroundColor: UIColor
    var selectedBackgroundColor: UIColor?
    var textColor: UIColor
    var detailTextColor: UIColor
    var presstextColor: UIColor
    var textFont: UIFont
    var detailTextFont: UIFont
    var itemLeftRightMargin: CGFloat
    var itemImageTextSpace: CGFloat
    var itemWidth: CGFloat
    var itemHeight: CGFloat
    
    override init() {
        
        self.title = ""
        self.detailText = ""
        self.type = .iconAndText
        self.icon = nil
        self.backgroundColor = .white
        self.pressBackgroundColor = UIColor.transferStringToColor("fafafa")
        self.textFont = UIFont.systemFont(ofSize: 15)
        self.detailTextFont = UIFont.systemFont(ofSize: 14)
        self.textColor = UIColor.transferStringToColor("000000")
        self.detailTextColor = UIColor.transferStringToColor("000000")
        self.presstextColor = UIColor.lightGray
        self.itemLeftRightMargin = 15
        self.itemImageTextSpace = 10
        self.itemHeight = 42
        self.itemWidth = 150
        self.itemIconSize = CGSize(width: 25, height: 25)
        super.init()
    }
    
    func textSize() -> CGSize {
        var textSize = CGSize.zero
        let titleT = title as NSString
        let attributes = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: textFont]
        let options = NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(UInt8(NSStringDrawingOptions.usesFontLeading.rawValue) | UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue)))
        
        textSize = titleT.boundingRect(with: CGSize(width: 200, height: itemHeight), options: options, attributes: attributes as [NSAttributedString.Key : Any], context: nil).size

        return textSize
    }
    
    func detailTextSize() -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .right
        
        let detailTextT = detailText as NSString
        let options = NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(UInt8(NSStringDrawingOptions.usesFontLeading.rawValue) | UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue)))
        let attributes = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: textFont,NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let textSize = detailTextT.boundingRect(with: CGSize(width: 58, height: itemHeight), options: options, attributes: attributes, context: nil).size
        return textSize
    }
    
    func itemSize() -> CGSize {
        var width: CGFloat = 0
        if self.type == DFArrowMenuItemType.iconAndText {
            width = itemLeftRightMargin * 2 + itemImageTextSpace + self.textSize().width + itemIconSize.width
        } else {
            width = itemWidth
        }
        return CGSize(width: width, height: itemHeight)
    }
}

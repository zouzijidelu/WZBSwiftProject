//
//  DFArrowMenuItem.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/8/4.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

protocol DFArrowMenuItemDelegate {
    func arrowMenuItem(item: DFArrowMenuItem,didClickAt index: NSInteger)
}

enum MenuItemTouchType {
    case normal
    case highlight
}


class DFArrowMenuItem: UIView {

    var style: DFArrowMenuItemStyle
    
    //private
    private var delegate: DFArrowMenuItemDelegate
    private var currentTouchType: MenuItemTouchType
    private var cornerRadius: CGFloat
    private var index: NSInteger
    private var isNeedLine: Bool
    private var currentTextColor: UIColor
    private var currentBackgroundColor: UIColor

    init(frame: CGRect,style: DFArrowMenuItemStyle, delegate: DFArrowMenuItemDelegate, index: NSInteger, cornerRadius: CGFloat, isNeedLine: Bool) {
        self.delegate = delegate
        self.cornerRadius = cornerRadius
        self.style = style
        self.index = index
        self.currentTouchType = .normal
        self.currentBackgroundColor = style.backgroundColor
        self.currentTextColor = style.textColor
        self.isNeedLine = isNeedLine
        super.init(frame: frame)
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.setNeedsDisplay()
    }
    
    convenience init(style: DFArrowMenuItemStyle, delegate: DFArrowMenuItemDelegate, index: NSInteger, cornerRadius: CGFloat, isNeedLine: Bool) {
        self.init(frame: CGRect.zero,style: style, delegate: delegate, index: index, cornerRadius: cornerRadius, isNeedLine: isNeedLine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder)")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        privateDraw(rect: rect) { (context) in
            currentBackgroundColor.setStroke()
            currentBackgroundColor.setFill()
            let squarePath = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height), cornerRadius: cornerRadius)
            squarePath.stroke()
            squarePath.fill()
            
            switch self.style.type {
            case .iconAndText:
                // icon
                let iconFrame = CGRect(x: style.itemLeftRightMargin, y: (style.itemHeight - style.itemIconSize.height)/2, width: style.itemIconSize.width, height: style.itemIconSize.height)
                style.icon?.draw(in: iconFrame)
                
                // text
                let lineHeight: CGFloat = 1.0
                UIColor.transferStringToColor("ededed").setStroke()
                context.setLineWidth(lineHeight)
                if isNeedLine {
                    let pointLeft = CGPoint(x: style.itemLeftRightMargin + style.itemIconSize.width + style.itemImageTextSpace, y: self.bounds.size.height)
                    let pointRight = CGPoint(x: self.bounds.size.width, y: pointLeft.y)
                    context.move(to: pointLeft)
                    context.addLine(to: pointRight)
                    context.strokePath()
                }
                break
            case .titleAndDetailText:
                let margin: CGFloat = 10.0
                // title
                var textFrame = CGRect.zero
                if style.detailText == "" {
                    textFrame = CGRect(x: (style.itemWidth - style.textSize().width)/2, y: (style.itemHeight - style.textSize().height)/2, width: style.textSize().width, height: style.textSize().height)
                } else {
                    textFrame = CGRect(x: margin, y: (style.itemHeight - style.textSize().height)/2, width: style.textSize().width, height: style.textSize().height)
                }
                
                let titleTemp = style.title as NSString
                let attributesT = [NSAttributedString.Key.foregroundColor:currentTextColor,NSAttributedString.Key.font:style.textFont]
                titleTemp.draw(in: textFrame, withAttributes: attributesT)
                if style.detailText != "" {
                    // detail text
                    let detailTextFrame = CGRect(x: style.itemWidth - style.detailTextSize().width - margin, y: (style.itemHeight-style.detailTextSize().height)/2, width: style.detailTextSize().width, height: style.detailTextSize().height)
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineBreakMode = .byWordWrapping
                    paragraphStyle.alignment = .right
                    let attributesD = [NSAttributedString.Key.foregroundColor:currentTextColor,NSAttributedString.Key.font:style.textFont, NSAttributedString.Key.paragraphStyle:paragraphStyle]
                    let detailText = style.detailText as NSString
                    detailText.draw(in: detailTextFrame, withAttributes: attributesD)
                }
                // line
                let lineHeight: CGFloat = 1.0
                UIColor.transferStringToColor("ededed").setStroke()
                context.setLineWidth(lineHeight)
                
                if isNeedLine {
                    let pointLeft = CGPoint(x: margin, y: self.bounds.size.height)
                    let pointRight = CGPoint(x: self.bounds.size.width, y: pointLeft.y)
                    
                    context.move(to: pointLeft)
                    context.addLine(to: pointRight)
                    context.strokePath()
                }
                break
            default:
                break
            }
        }
    }
    
    private func privateDraw(rect: CGRect, contexthandler: (CGContext)->()) {
        if let context = UIGraphicsGetCurrentContext() {
            context.beginPath()
            contexthandler(context)
            context.closePath()
            context.drawPath(using: .fillStroke)
        }
    }
    
    func changeUI(touchType: MenuItemTouchType) {
        if currentTouchType == touchType {
            return
        }
        currentTouchType = touchType
        switch touchType {
        case .normal:
            currentBackgroundColor = style.backgroundColor
            currentTextColor = style.textColor
            break
        case .highlight:
            currentBackgroundColor = style.pressBackgroundColor
            currentTextColor = style.presstextColor
            break
        default:
            break
        }
        setNeedsDisplay()
    }
    
    //MARK: Touch Status
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.changeUI(touchType: .highlight)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let shouldResponse = DFArrowMenuItem.IfContainTouchPoint(event: event, target: self)
        if shouldResponse {
            delegate.arrowMenuItem(item: self, didClickAt: index)
            changeUI(touchType: .normal)
        } else {
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let shouldResponse = DFArrowMenuItem.IfContainTouchPoint(event: event, target: self)
        if shouldResponse {
            changeUI(touchType: .highlight)
        } else {
            changeUI(touchType: .normal)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        changeUI(touchType: .normal)
    }
    
    func getItemTitle() -> String {
        return style.title
    }
    
    static func IfContainTouchPoint(event: UIEvent?, target: UIView) -> Bool {
        if let allTouoches = event?.allTouches {
            if let touch = (allTouoches as NSSet).anyObject(){
                let loaction = (touch as! UITouch).location(in: target)
                return target.bounds.contains(loaction)
            }
        }
        return false
    }
}

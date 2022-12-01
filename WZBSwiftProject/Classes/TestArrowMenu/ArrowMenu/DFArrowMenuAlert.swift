//
//  DFArrowMenuAlert.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/8/4.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit


let kAnimation_Type_Key = "animationType"
let kAnimation_Show_Value = "show"
let kAnimation_Dismiss_Value = "dismiss"

let kShow_Animation_Key = "kShow_Animation_Key"
let kDismiss_Animation_Key = "kDismiss_Animation_Key"

enum BZArrowMenuViewDirection {
    case leftTop
    case centerTop
    case rigthtTop
    case leftBottom
    case centerBottom
    case rightBottom
}
typealias DFArrowMenuAlertItemClickBlock = (DFArrowMenuItem,NSInteger)->()
typealias DFArrowMenuAlertCancelBlock = ()->()
class DFArrowMenuAlert: UIView, CAAnimationDelegate, DFArrowMenuItemDelegate {
    
    private(set) var isAppear: Bool = false
    
    private var itemStyles: [DFArrowMenuItemStyle]
    private var direction: BZArrowMenuViewDirection?
    private var showPointCenter: CGPoint
    
    private var superViewT: UIView?
    private var coverTapView: UIView?
    
    private var alertStyle: DFArrowMenuAlertStyle
    private var itemViews: [DFArrowMenuItem] = []
    private var points: [CGPoint]?
    
    private var cancelBlock: DFArrowMenuAlertCancelBlock?
    private var itemClickBlock: DFArrowMenuAlertItemClickBlock?
    public class func showToast(style: DFArrowMenuAlertStyle?, items: [DFArrowMenuItemStyle], point: CGPoint, direction: BZArrowMenuViewDirection, superViewT: UIView, cancelClosure: DFArrowMenuAlertCancelBlock?, itemClickClousure: DFArrowMenuAlertItemClickBlock?) -> DFArrowMenuAlert {
        let alert = DFArrowMenuAlert.init(style: style, items: items, point: point, direction: direction, superViewT: superViewT, cancelClosure: cancelClosure, itemClickClousure: itemClickClousure)
        alert.show()
        return alert
    }
    
    init(frame: CGRect, style: DFArrowMenuAlertStyle? = nil, items: [DFArrowMenuItemStyle], point: CGPoint, direction: BZArrowMenuViewDirection, superViewT: UIView, cancelClosure: DFArrowMenuAlertCancelBlock?, itemClickClousure: DFArrowMenuAlertItemClickBlock?) {
        if let styleT = style {
            self.alertStyle = styleT
        } else {
            self.alertStyle = DFArrowMenuAlertStyle()
        }
        self.itemStyles = items
        self.showPointCenter = point
        self.direction = direction
        self.superViewT = superViewT
        self.itemClickBlock = itemClickClousure
        self.cancelBlock = cancelClosure
        super.init(frame: frame)
        initCoverV()
        self.frame = caculateHoleFrame()
        points = calculateTrianglePoints()
        setNeedsDisplay()
        configUIAfterDrawRect()
        self.backgroundColor = .clear
    }
    
    convenience init(style: DFArrowMenuAlertStyle?, items: [DFArrowMenuItemStyle], point: CGPoint, direction: BZArrowMenuViewDirection, superViewT: UIView, cancelClosure: DFArrowMenuAlertCancelBlock?, itemClickClousure: DFArrowMenuAlertItemClickBlock?) {
        
        self.init(frame: CGRect.zero, style: style, items: items, point: point, direction: direction, superViewT: superViewT, cancelClosure: cancelClosure, itemClickClousure: itemClickClousure)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initCoverV() {
        //self.opaque = false;
        coverTapView = UIView(frame: UIScreen.main.bounds)
        coverTapView?.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToDismissAction))
        coverTapView?.addGestureRecognizer(tap)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        private_drawRect(rect: rect) { (context) in
            alertStyle.backgroundColor.setStroke()
            alertStyle.backgroundColor.setFill()
            // 三角形
            if let pointsT = points {
                context?.addLines(between: pointsT)
            }
            
            // 矩形
            var squareX: CGFloat = 0
            var squareY: CGFloat = 0
            var squareWidth: CGFloat = 0
            var squareHeight: CGFloat = 0
            switch direction {
            case .leftTop,.centerTop,.rigthtTop:
                    squareX = 0
                    squareY = 0
                    squareWidth = self.bounds.size.width
                    squareHeight = self.bounds.size.height - alertStyle.triangleSize.height
                    break;
            case .leftBottom,.centerBottom,.rightBottom:
                    squareX = 0
                    squareY = alertStyle.triangleSize.height
                    squareWidth = self.bounds.size.width
                    squareHeight = self.bounds.size.height - alertStyle.triangleSize.height
                    break;
                default:
                    break;
            }
            let squarePath = UIBezierPath(roundedRect: CGRect(x: squareX, y: squareY, width: squareWidth, height: squareHeight), cornerRadius: alertStyle.cornerRadius)
            
            squarePath.fill()
            squarePath.stroke()
        }
    }
    
    func private_drawRect(rect: CGRect, contextHandler: (CGContext?)->()) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        contextHandler(context)
        
        context?.closePath()
        context?.drawPath(using: .fillStroke)
    }
    
    func updateShadow() {
        if !alertStyle.enableShadow {
            return
        }
        let shadowLayer = self.layer;
        shadowLayer.shadowOpacity = 0.1;
        shadowLayer.shadowRadius = 5.0;
        shadowLayer.shadowOffset = CGSize(width:0, height: 1);
    }
    
    override func layoutSubviews() {
        updateShadow()
    }
}

//MARK: ui
extension DFArrowMenuAlert {
    func configUIAfterDrawRect() {
        
        var originalY: CGFloat = 0.0;
        if direction == BZArrowMenuViewDirection.leftBottom || direction == BZArrowMenuViewDirection.centerBottom || direction == BZArrowMenuViewDirection.rightBottom {
            originalY = alertStyle.triangleSize.height;
        }
        
        var lastItem: DFArrowMenuItem? = nil
        for (index,style) in itemStyles.enumerated() {
            let isNeedLine: Bool = !alertStyle.isNeedLine ? alertStyle.isNeedLine : (index != itemStyles.count - 1)
            let item = DFArrowMenuItem.init(style: style, delegate: self, index: index, cornerRadius: alertStyle.cornerRadius, isNeedLine: isNeedLine)
            item.frame = CGRect(x: 0, y: originalY + (lastItem?.bounds.height ?? 0)*CGFloat(index), width: self.frame.width, height: style.itemSize().height)
            self.addSubview(item)
            lastItem = item
            itemViews.append(item)
        }
    }
}

//MARK: api
extension DFArrowMenuAlert {
    func show() {
        showIfDelayDismiss(false)
    }

    func showNerverDismiss() {
        self.showIfDelayDismiss(false)
    }

    func showIfDelayDismiss(_ ifDismiss: Bool) {
        if isAppear {
            return
        }
        isAppear = true
        if let coverV = coverTapView {
            superViewT?.addSubview(coverV)
        }
        superViewT?.addSubview(self)
        self.animation_show()
        
        if (ifDismiss) {
            self.perform(#selector(dismiss), with: nil, afterDelay: 5.0)
        }
    }
    
    @objc func dismiss() {
        if isAppear {
            animation_dismiss()
        }
    }
}
//MARK: Event Method
extension DFArrowMenuAlert {
    @objc func tapToDismissAction() {
        
        if let block = cancelBlock {
            block()
        }
        self.dismiss()
    }
}

//MARK: arrow item delegate
extension DFArrowMenuAlert {
    func arrowMenuItem(item: DFArrowMenuItem, didClickAt index: NSInteger) {
        if let block = itemClickBlock {
            block(item,index)
        }
        dismiss()
    }
}
//MARK: Animation
extension DFArrowMenuAlert {
    private func animation_show() {
        
        let alphaAnima = CABasicAnimation(keyPath: "opacity")
        alphaAnima.duration = 0.2;
        alphaAnima.fromValue = 0;
        alphaAnima.toValue = 1;
        
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.2;
        animation.fillMode = CAMediaTimingFillMode.forwards;
        animation.keyTimes = [ 0, 0.5, 1 ];
        var values: [NSValue] = []
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values;
        
        /** postion and anchorPoint :
         *
         * frame.origin.x = position.x - anchorPoint.x * bounds.size.width；
         * frame.origin.y = position.y - anchorPoint.y * bounds.size.height；
         */
        let  oldFrame = self.frame;
        switch direction {
        case .leftTop:
                self.layer.anchorPoint = CGPoint(x:0.1, y:1)
                break;
        case .centerTop:
                self.layer.anchorPoint = CGPoint(x:0.5, y:1)
                break;
        case  .rigthtTop:
                self.layer.anchorPoint = CGPoint(x:0.9, y:1)
                break;
        case .leftBottom:
                self.layer.anchorPoint = CGPoint(x:0.1, y:0)
                break;
        case .centerBottom:
                self.layer.anchorPoint = CGPoint(x:0.5, y:0)
                break;
        case .rightBottom:
                self.layer.anchorPoint = CGPoint(x:0.9, y:0)
                break;
            default:
                break;
        }
        self.frame = oldFrame; // fix wrong frame when anchorPoint changed.
        
        let group = CAAnimationGroup()
        group.animations = [alphaAnima,animation]
        group.delegate = self;
        
        group.setValue(kAnimation_Show_Value, forKey: kAnimation_Type_Key)
        self.layer.add(group, forKey: kShow_Animation_Key)
        
    }
    
    private func animation_dismiss() {
        layer.removeAnimation(forKey: kShow_Animation_Key)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.alpha = 0.0
        }) { (finished) in
            self.isAppear = false
            self.coverTapView?.removeFromSuperview()
            self.removeFromSuperview()
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}
//MARK: caculate frame
extension DFArrowMenuAlert {
    private func caculateHoleFrame() -> CGRect {
        var maxItemWidth: CGFloat = 0.0
        var totalItemsHeight: CGFloat = 0.0
        for itemS in itemStyles {
            let itemW = (itemS as DFArrowMenuItemStyle).itemSize().width
            let itemH = (itemS as DFArrowMenuItemStyle).itemSize().height
            if itemW > maxItemWidth {
                maxItemWidth = itemW
            }
            totalItemsHeight += itemH
        }
        var toastX: CGFloat = 0.0
        var toastY: CGFloat = 0.0
        let toastW = maxItemWidth
        let toastH = totalItemsHeight + alertStyle.triangleSize.height
        
        switch direction {
        case .leftTop:
            toastX = showPointCenter.x - alertStyle.triangleSize.width/2 - alertStyle.triangleLeftMargin
            toastY = showPointCenter.y - toastH
            break
        case .centerTop:
            toastX = showPointCenter.x - toastW/2
            toastY = showPointCenter.y - toastH
            break
        case .rigthtTop:
            toastX = showPointCenter.x - toastW/2 - (toastW - (alertStyle.triangleLeftMargin + alertStyle.triangleSize.width))
            toastY = showPointCenter.y - toastH
            break
        case .leftBottom:
            toastX = showPointCenter.x - alertStyle.triangleSize.width*0.5 - alertStyle.triangleLeftMargin
            toastY = showPointCenter.y
            break
        case .centerBottom:
            toastX = showPointCenter.x - toastW*0.5
            toastY = showPointCenter.y
            break
        case .rightBottom:
            toastX = showPointCenter.x - alertStyle.triangleSize.width*0.5 - (toastW-(alertStyle.triangleLeftMargin+alertStyle.triangleSize.width))
            toastY = showPointCenter.y
            break
        default:
            break
        }
        return CGRect(x: toastX, y: toastY, width: toastW, height: toastH)
    }
    
    private func calculateTrianglePoints() -> [CGPoint] {
        var triangleLeftMargion: CGFloat = 0.0
        var point0: CGPoint = CGPoint.zero
        var point1: CGPoint = CGPoint.zero
        var point2: CGPoint = CGPoint.zero
        
        switch direction {
        case .leftTop,.centerTop,.rigthtTop:
            if direction == BZArrowMenuViewDirection.leftTop {
                triangleLeftMargion = alertStyle.triangleLeftMargin
            } else if direction == BZArrowMenuViewDirection.centerTop {
                triangleLeftMargion = self.bounds.size.width/2 - alertStyle.triangleSize.width/2
            } else if direction == BZArrowMenuViewDirection.rigthtTop {
                triangleLeftMargion = self.bounds.size.width - (alertStyle.triangleLeftMargin+alertStyle.triangleSize.width)
            }
            
            point0 = CGPoint(x: triangleLeftMargion, y: self.bounds.height - alertStyle.triangleSize.height)
            point1 = CGPoint(x: triangleLeftMargion + alertStyle.triangleSize.width*0.5, y: self.bounds.size.height)
            point2 = CGPoint(x: triangleLeftMargion + alertStyle.triangleSize.width, y: point0.y);
            break
        case .leftBottom,.centerBottom,.rightBottom:
            if direction == BZArrowMenuViewDirection.leftBottom {
                triangleLeftMargion = alertStyle.triangleLeftMargin
            } else if direction == BZArrowMenuViewDirection.centerBottom {
                triangleLeftMargion = self.bounds.size.width*0.5 - alertStyle.triangleSize.width*0.5
            } else if direction == BZArrowMenuViewDirection.rightBottom {
                triangleLeftMargion = self.bounds.size.width - (alertStyle.triangleLeftMargin+alertStyle.triangleSize.width)
            }
            point0 = CGPoint(x: triangleLeftMargion, y: alertStyle.triangleSize.height);
            point1 = CGPoint(x: triangleLeftMargion + alertStyle.triangleSize.width*0.5, y: 0);
            point2 = CGPoint(x: triangleLeftMargion + alertStyle.triangleSize.width, y: point0.y);
            break
        default:
            break
        }
        
        return [point0,point1,point2]
    }
}

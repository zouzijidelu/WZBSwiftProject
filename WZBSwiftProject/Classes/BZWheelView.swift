//
//  BZWheelView.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/12/22.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZWheelView: UIView {
    
    private lazy var toplabel: UILabel = {
        return createDefaultLabel()
    }()
    private lazy var bottomLabel: UILabel = {
        return createDefaultLabel()
    }()
    var contents = [String]()
    private func createDefaultLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        for label in [toplabel, bottomLabel] {
            addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
                label.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
                label.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor)
            ])
        }
    }
    
    var progress: Float = 0.0 {
        didSet {
            progress = min(max(progress, 0.0), 1.0)
            guard contents.count > 0 else { return }
            /** 根据 progress 和 contents 计算出上下两个 label 显示的内容以及 label 的压缩程度和位置
             *
             *  Example:
             *  progress = 0.4, contents = ["A","B","C","D"]
             *
             *  1）计算两个label显示的内容
             *  topIndex = 4 * 0.4 = 1.6, topLabel.text = contents[1] = "B"
             *  bottomIndex = 1.6 + 1 = 2.6, bottomLabel.text = contents[2] = "C"
             *
             *  2） 计算两个label如何压缩和位置调整，这是实现滚轮效果的原理
             *  indexOffset = 1.6 % 1 = 0.6
             *  halfHeight = bounds.height / 2
             *  ┌─────────────┐             ┌─────────────┐
             *  |┌───────────┐|   scaleY    |             |
             *  ||           || 1-0.6=0.4   |             | translationY
             *  ||  topLabel || ----------> |┌─ topLabel─┐| ------------------┐
             *  ||           ||             |└───────────┘| -halfHeight * 0.6 |    ┌─────────────┐
             *  |└───────────┘|             |             |                   |    |┌─ toplabel─┐|
             *  └─────────────┘             └─────────────┘                   |    |└───────────┘|
             *                                                                | -> |┌───────────┐|
             *  ┌─────────────┐             ┌─────────────┐                   |    ||bottomLabel||
             *  |┌───────────┐|   scaleY    |             |                   |    |└───────────┘|
             *  ||           ||    0.6      |┌───────────┐| translationY      |    └─────────────┘
             *  ||bottomLabel|| ----------> ||bottomLabel|| ------------------┘
             *  ||           ||             |└───────────┘| halfHeight * 0.4
             *  |└───────────┘|             |             |
             *  └─────────────┘             └─────────────┘
             *
             * 可以想象出，当 indexOffset 从 0..<1 过程中，
             * topLabel 从满视图越缩越小至0，而 bottomLabel刚好相反越变越大至满视图，即形成一次完整的滚动
             */
            let topIndex = min(max(0.0, Float(contents.count) * progress), Float(contents.count - 1))
            let bottomIndex = min(topIndex + 1, Float(contents.count - 1))
            let indexOffset =  topIndex.truncatingRemainder(dividingBy: 1)
            toplabel.text = contents[Int(topIndex)]
            toplabel.transform = CGAffineTransform(scaleX: 1.0, y: CGFloat(1 - indexOffset))
                .concatenating(CGAffineTransform(translationX: 0, y: -(toplabel.bounds.height / 2) * CGFloat(indexOffset)))
            bottomLabel.text = contents[Int(bottomIndex)]
            bottomLabel.transform = CGAffineTransform(scaleX: 1.0, y: CGFloat(indexOffset))
                .concatenating(CGAffineTransform(translationX: 0, y: (bottomLabel.bounds.height / 2) * (1 - CGFloat(indexOffset))))
        }
    }

}
extension BZWheelView {
    /// 前景色变化事件
    override func tintColorDidChange() {
        [toplabel, bottomLabel].forEach { $0.textColor = tintColor }
        layer.borderColor = tintColor.cgColor
    }
    /// 背景色
    override var backgroundColor: UIColor? {
        get { return toplabel.backgroundColor }
        set { [toplabel, bottomLabel].forEach { $0.backgroundColor = newValue } }
    }
    /// 边框宽度
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set {
            layoutMargins = UIEdgeInsets(top: newValue, left: newValue, bottom: newValue, right: newValue)
            layer.borderWidth = newValue
        }
    }
    /// 字体
    var font: UIFont {
        get { return toplabel.font }
        set { [toplabel, bottomLabel].forEach { $0.font = newValue } }
    }
}

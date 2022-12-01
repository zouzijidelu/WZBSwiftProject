//
//  BZTabBar.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/12/22.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZTabBar: UITabBar {
    var img1: UIImageView!
    var img2: UIImageView!
    var img3: UIImageView!
    var imgArr: [UIImageView] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addsub()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //addsub()
        img1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        img2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        img3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imgArr.append(img1)
        imgArr.append(img2)
        imgArr.append(img3)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        addsub()
    }
    func addsub() {
        var i = 0
        for btn in self.subviews {
            if btn.isKind(of: NSClassFromString("UITabBarButton") ?? UIButton.self) {
                if let btn = btn as? UIControl {
                    btn.addTarget(self, action: #selector(tabbarclick(btn:)), for: .touchUpInside)
                    print(btn.isSelected)
                    btn.tag = i
                    
                }
            }
            i += 1
        }
    }
    
    @objc func tabbarclick(btn: UIControl) {
        for imageV1 in btn.subviews {
            if #available(iOS 13, *) {
                if imageV1.isKind(of: NSClassFromString("UIVisualEffectView") ?? UIImageView.self){
                    for imageV2 in imageV1.subviews {
                        if imageV2.isKind(of: NSClassFromString("_UIVisualEffectContentView") ?? UIImageView.self) {
                            for imageV3 in imageV2.subviews {
                                getImageV(view: imageV3)
                            }
                        }
                    }
                }

            } else {
                getImageV(view: imageV1)
            }
        }
    }
    
    private func getImageV(view: UIView) {
        if view.isKind(of: NSClassFromString("UITabBarSwappableImageView") ?? UIImageView.self) {
            var imageV = view as? UIImageView
            //addAnimation(imageV: &imageV)
            imageAnimation(imageV: imageV!, imageName: "热点_000", imageNumber: 55,frame: imageV?.frame ?? CGRect.zero)
            
        }
        
    }
    
    private func addAnimation( imageV: inout UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0,1.3,0.9,1.15,0.95,1.02,1.0]
        animation.duration = 1
        animation.calculationMode = .cubic
        imageV.layer.add(animation, forKey: "transform.scale")
    }
    
    func imageAnimation(imageV: UIImageView, imageName: String, imageNumber: Int,frame: CGRect)
    {
        
        // 声明一个空的 image 数组
        var imgArray:[UIImage]! = []
        for i in 0..<imageNumber
        {
            var tempName = imageName
            // 拼接名称
            if i<10 { tempName += "0" }
            let name: String? = tempName + "\(i)"
            // 获取app中的图片 参数是:可选值Optionals
            
            // 根据路径获得图片
            let image: UIImage? = UIImage(named: name!)
            // 往数组中添加图片
            imgArray.append(image!)
        }
        // 给动画数组赋值
        imageV.animationImages = imgArray
        // 设置重复次数, 学过的都知道...0 代表无限循环,其他数字是循环次数,负数效果和0一样...
        imageV.animationRepeatCount = 1
        // 动画完成所需时间
        imageV.animationDuration = 1.2
        // 开始动画
        imageV.startAnimating()
    }

}

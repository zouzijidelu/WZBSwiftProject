//
//  BZTestViewAllInit.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/8/4.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZTestViewAllInit: UIView {

   var isNeedUpdateLayout: Bool
    
    // 对于一个类 一旦自定义了一个初始化方法(注意是初始化方法,不是便利!),那么其原有的初始化方法就无法使用了,init(frame: CGrect)无法被点出来,而且其添加的属性必须要在super之前调用,在一级初始化中,先初始化自己的属性,再初始化super,这点和便利构造函数不同
    init(frame: CGRect, isNeedUpdateLayout: Bool) {
        self.isNeedUpdateLayout = isNeedUpdateLayout
        super.init(frame: frame)
    }
    
    // 如果非要使用默认的初始化方法 请重新, 并正确的为其赋值 赋值原则请看上一条
//    override init(frame: CGRect) {
//        self.isNeedUpdateLayout = true
//        super.init(frame: frame)
//    }
    
    // 对应的是init(frame: CGRect, isNeedUpdateLayout: Bool)这个一级初始化方法
    convenience init(isNeedUpdateLayout: Bool) {
        self.init(frame: CGRect.zero, isNeedUpdateLayout: isNeedUpdateLayout)
    }
    
    //  对应的是override init(frame: CGRect)这个方法
//    convenience init() {
//        self.init(frame: CGRect.zero)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  AView.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/23.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class AView: UIView {

    //还有一个重要的点,layoutSubview不是在调用完比如addSubview等方法之后就马上调用,而是会在调用addSubview方法所在的作用域结束之后之后才调用,因此即使你在同一个方法中既使用了addSubViews又更改了frame，也是只会调用一次layoutSubview而已

    override func layoutSubviews() {
        super.layoutSubviews()
        print("AView layoutSubviews")
    }

}

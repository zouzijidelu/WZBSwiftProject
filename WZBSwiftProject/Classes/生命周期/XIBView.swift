//
//  XIBView.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/22.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class XIBView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        print("XIBView layoutSubviews")
    }
}

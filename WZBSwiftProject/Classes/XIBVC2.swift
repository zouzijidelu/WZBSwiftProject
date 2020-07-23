//
//  XIBVC2.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/22.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class XIBVC2: UIViewController {

    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "XIBVC2"
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let xibView = Bundle.main.loadNibNamed("XIBView", owner: nil, options: nil)?.first as? XIBView {
            xibView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
            view.addSubview(xibView)
        }
    }
}

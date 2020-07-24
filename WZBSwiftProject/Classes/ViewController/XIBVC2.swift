//
//  XIBVC2.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/22.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class XIBVC2: BZBaseVC {
    lazy var xibView:XIBView? = {
        let xv = Bundle.main.loadNibNamed("XIBView", owner: nil, options: nil)?.first as? XIBView
        xv?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
        return xv
    }()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "XIBVC2"
        print(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)//44
        print(self.view.safeAreaInsets)//(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        print(self.view.frame)
        //self.navigationController?.navigationBar.isHidden = true
        if let tempXibView = self.xibView {
            view.addSubview(tempXibView)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)//44
        print(self.view.safeAreaInsets)//(top: 88.0, left: 0.0, bottom: 34.0, right: 0.0)
        print(self.view.safeAreaInsets.top)
        print(self.view.frame)
    }
}

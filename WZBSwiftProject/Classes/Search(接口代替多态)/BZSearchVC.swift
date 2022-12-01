//
//  BZSearchVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/8/14.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZSearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let cs = BZClothSearch()
        cs.search()
    }
}

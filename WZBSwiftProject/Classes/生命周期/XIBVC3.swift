//
//  XIBVC3.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/22.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class XIBVC3: UIViewController {

    @IBOutlet weak var testL: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        debugPrint(testL.frame)
    }

}

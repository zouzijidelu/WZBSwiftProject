//
//  XIBVC2.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/22.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class XIBVC2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "XIBVC2"
        if let xibView = Bundle.main.loadNibNamed("XIBView", owner: nil, options: nil)?.first as? XIBView {
            xibView.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 100)
            view.addSubview(xibView)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  CodeVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/21.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class CodeVC: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        if let xibView = Bundle.main.loadNibNamed("XIBView", owner: nil, options: nil)?.first as? XIBView {
            xibView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
            view.addSubview(xibView)
        }
    }
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
    }
}

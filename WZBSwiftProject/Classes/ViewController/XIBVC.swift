//
//  XIBVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/21.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class XIBVC: BZBaseVC {
    @IBOutlet weak var gView: UIView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "XIBVC"
        let colorOne = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        let colorTwo = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
        let colorArr = [colorOne.cgColor,colorTwo.cgColor]
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradient.colors = colorArr
        gradient.frame = gView.layer.bounds
        gView.layer.insertSublayer(gradient, at: 0)
    }
}

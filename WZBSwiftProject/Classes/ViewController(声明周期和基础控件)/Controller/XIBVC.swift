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
    
    #warning("xib 控制器 不要轻易重写此方法")
//    override func loadView() {
//        super.loadView()
//        //只要没有重写loadView，系统就会自动判断有没有storyboard或者xib描述控制器的View,如果有就会去加载它们描述控制器的view;
//        //只要写了该方法，系统就不会去检测storyboard、xib文件
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "XIBVC"
        setBase()
        let dic = ["000":"太和殿","001":"中和殿","002":"保和殿","003":"乾清宫","004":"养心殿","005":"宁寿宫"]
        print(dic.keys)
//        print(DFTimeUtil.getFormatTime(wiht: DFTimeUtil.getCurrentTimeStamp()))
        NotificationCenter.default.addObserver(self, selector: #selector(testNotifcation(noti:)), name:NSNotification.Name(rawValue: NSNotification.Name.Test.todo), object: nil)
    }
    
    @objc func testNotifcation(noti:Notification) {
        let param = noti.userInfo?[param1]
        debugPrint("testNotifcation: \(param ?? "")")
    }
    
    @IBAction func click(_ sender: Any) {
        BZNSNotificationCenter.postNotifcation()
    }
    func setBase() {
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

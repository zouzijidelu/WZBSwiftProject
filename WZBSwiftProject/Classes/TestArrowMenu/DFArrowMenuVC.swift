//
//  DFArrowMenuVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/8/4.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class DFArrowMenuVC: UIViewController {

    var data: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if data?.count != 0 {
            debugPrint("111")
        }
    }

    @IBAction func popMenuVC(_ sender: Any) {
        var styleArr: [DFArrowMenuItemStyle] = []
        let style1 = DFArrowMenuItemStyle()
        style1.title = "全部已读"
        style1.type = .titleAndDetailText
        style1.textColor = .black
        style1.presstextColor = .red
        styleArr.append(style1)
        let style2 = DFArrowMenuItemStyle()
        style2.title = "删除全部"
        style2.type = .titleAndDetailText
        style2.textColor = .black
        style2.presstextColor = .red
        styleArr.append(style2)
        let alertStyle = DFArrowMenuAlertStyle()
        alertStyle.backgroundColor = UIColor.white
        alertStyle.isNeedLine = true
        alertStyle.linColor = .blue
        alertStyle.enableShadow = true
        alertStyle.showSeparateLine = true
        alertStyle.cornerRadius = 5
        
        let menuAlter = DFArrowMenuAlert(style: alertStyle, items: styleArr, point: CGPoint(x: self.view.bounds.size.width - 30, y: 100), direction: .rightBottom, superViewT: self.view, cancelClosure: nil) { (item, index) in
            if index == 0 {
                debugPrint("全部已读")
            } else if index == 1 {
                debugPrint("删除全部")
            }
        }
        menuAlter.show()
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

//
//  BZCustomNavVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/31.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZCustomNavVC: UIViewController {

    @IBOutlet weak var customBtn: BZCustomButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        customBtn.addCustomButton(target: self, action: #selector(groupMenuTouch))
        let wrappedBlock:@convention(block) (AspectInfo)-> Void = { aspectInfo in
              // 你的代码
            debugPrint("wrappedBlock")
          }
          let wrappedObject: AnyObject = unsafeBitCast(wrappedBlock, to: AnyObject.self)
        do {
            try self.aspect_hook(Selector("groupMenuTouch"), with: AspectOptions.positionBefore, usingBlock: wrappedObject)
        }catch{
            print(error)
        }
        groupMenuTouch()
    }
    
    @objc func groupMenuTouch() {
        debugPrint("groupMenuTouch")
    }
}


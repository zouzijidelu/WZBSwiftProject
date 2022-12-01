//
//  BZMessageSendVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/8/1.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZMessageSendVC: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let msgSendObject = BZMsgSendObject()
////        msgSendObject.perform(Selector("test"))
//        
//        
//        msgSendObject.testAspect()
//        
//    }
//}

    override func viewDidLoad() {
        super.viewDidLoad()

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
extension NSObject {
  
    typealias AspectsBlock = (AspectInfo)->()
    
    func swift_hook(with sel: Selector, options: AspectOptions, usingBlock: @escaping AspectsBlock) throws {
        let blockObj: @convention(block) (_ id: AspectInfo)->Void = { aspectInfo in
            usingBlock(aspectInfo)
        }
        try self.aspect_hook(sel, with: options, usingBlock: blockObj)
    }
    
    static func swift_hook(with sel: Selector, options: AspectOptions, usingBlock: @escaping AspectsBlock) throws {
        let blockObj: @convention(block) (_ id: AspectInfo)->Void = { aspectInfo in
            usingBlock(aspectInfo)
        }
        try self.aspect_hook(sel, with: options, usingBlock: blockObj)
    }
}

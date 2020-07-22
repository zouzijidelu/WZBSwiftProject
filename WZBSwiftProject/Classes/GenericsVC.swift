//
//  GenericsVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/4/17.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

protocol TargetAction {
    func performaAction()
}

struct TargetActionWarpper<T: AnyObject> :TargetAction {
    weak var target: T?
    let action: (T) -> () -> ()
    
    func performaAction() -> () {
        if let t = target {
            action(t)()
        }
    }
}

enum ControlEvent {
    case TouchUpInside
    case ValueChanged
}

class Control {
    var actions = [ControlEvent : TargetAction]()
    func setTarget<T: AnyObject>(target: T,
                                 action: @escaping (T) -> () -> (),
                                 controlEvent: ControlEvent) {
        actions[controlEvent] = TargetActionWarpper(target: target, action: action)
    }
    
    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }
    
    func performActionForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent]?.performaAction()
    }
}

class GenericsVC: UIViewController {
    let test = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let con = Control()
        con.setTarget(target: self, action: { (gen) -> () -> () in
            {
                print(self)
                print(gen)
            }
        }, controlEvent: .TouchUpInside)
        con.performActionForControlEvent(controlEvent: .TouchUpInside)
        
        var x: String! = "Hello,world"
        func printString(str: String) {
            print(str)
        }
        printString(str: x) // error!!!!!!
    }

}

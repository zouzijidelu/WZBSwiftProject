//
//  BZSearch.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/8/14.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZSearch {
    
    var assistant: BZSearchManager?
    
    init() {
        let ass = self as! BZSearchManager
        self.assistant = ass
    }
    
    func search() {
        assistant?.split()
        assistant?.resort()
    }
}

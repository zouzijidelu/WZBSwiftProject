//
//  BZTimeDateVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2022/4/22.
//  Copyright © 2022 iTalkBB. All rights reserved.
//

import UIKit
class BZTimeDateVC: UIViewController {
    var favouriteList: [String]? {
        didSet {
            print("didset")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str = DFTimeUtil.getFormatTime(wiht: "1652555347127")
        
        print(str)
    }
    
    private func test() {
        favouriteList = ["2"]
        favouriteList?.append(contentsOf: ["1"])
    }
    
    public func testTime() {
        //        let dateStr = "Fri, 22 Apr 2022 07:34:30 GMT"
        //        let date = BZTimeDateVC.transformer(dateStr)
        //        let timeSec = date?.timeIntervalSince1970
        //        print(timeSec)
    }
    private class func transformer(_ string: String) -> Date? {
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        fmt.locale = Locale(identifier: "en_UK")
        guard let date = fmt.date(from: string) else {
            return nil
        }
        return date
    }
    
    

}

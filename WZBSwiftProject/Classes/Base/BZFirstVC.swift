//
//  BZFirstVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/4/17.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

let cellId = "CELLID"

class BZFirstVC: UITableViewController {

    
    @IBOutlet var swiftTableView: BZBaseTableView!
    let categorys: [String] = ["BZCodebalVC","SwiftyJsonVC","GenericsVC","AlamofireVC","CodeVC","XIBVC","XIBVC2","XIBVC3","BZMessageSendVC","BZCustomNavVC","DFArrowMenuVC","BZSearchVC","BZUIVCAnimatedTransitioning","BZKingfisherVC","BZCollectionVC","BZTimeDateVC"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.view 会影响是否占满全屏
        //navigationController?.navigationBar.isTranslucent = false
//        tabBarController?.tabBar.isTranslucent = false
//        edgesForExtendedLayout = .all
        
        // Do any additional setup after loading the view.
        #if BETAVERSION
        self.view.backgroundColor = UIColor.green
        #else
        self.view.backgroundColor = UIColor.black
        #endif
        self.swiftTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.title = "SwiftBaseVC"
    }
}

// MARK: tableview DataSource
extension BZFirstVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categorys.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sV = UIView()
        sV.backgroundColor = .blue
        return sV
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = categorys[indexPath.section]
        return cell
    }
}
// MARK: tableview delegate
extension BZFirstVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let spaceName = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            return
        }
        
        let name = categorys[indexPath.section]
//        if name == "XIBVC" {
////            if let xibVC = Bundle.main.loadNibNamed("XIBVC", owner: nil, options: nil)?.first as? XIBVC {
////                navigationController?.pushViewController(xibVC, animated: true)
////            }
//            let xibVC = XIBVC(nibName: "XIBVC", bundle: nil)
//            navigationController?.pushViewController(xibVC, animated: true)
//            return
//        }
        if name == "XIBVC2" {
            if let xibVC2 = Bundle.main.loadNibNamed("XIBVC2", owner: nil, options: nil)?.first as? XIBVC2 {
                navigationController?.pushViewController(xibVC2, animated: true)
            }
//            let xibVC2 = XIBVC2(nibName: "XIBVC2", bundle: nil)
//            navigationController?.pushViewController(xibVC2, animated: true)
            return
        }
        if name == "XIBVC3" {
//            if let xibVC3 = Bundle.main.loadNibNamed("XIBVC3", owner: nil, options: nil)?.first as? XIBVC3 {
//                navigationController?.pushViewController(xibVC3, animated: true)
//            }
            let xibVC3 = XIBVC3(nibName: "XIBVC3", bundle: nil)
            navigationController?.pushViewController(xibVC3, animated: true)
            return
        }
        if name == "BZCollectionVC" {
            let storyboardVC = UIStoryboard.init(name: "CollectionVC", bundle: nil).instantiateViewController(withIdentifier: "BZCollectionVC")
            navigationController?.pushViewController(storyboardVC, animated: true)
            return
        }
        let vcClass: AnyClass? = NSClassFromString(spaceName + "." + name)
        guard let typeClass = vcClass as? UIViewController.Type else {
            return
        }
        let myVc = typeClass.init()
        navigationController?.pushViewController(myVc, animated: true)
    }
}

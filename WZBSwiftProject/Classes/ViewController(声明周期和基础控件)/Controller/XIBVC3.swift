//
//  XIBVC3.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/7/22.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit
let Xib3CellID = "BZXIB3Cell"
class XIBVC3: BZBaseVC, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var dataDic: [[String:String]]? = [["section1":"content1"],["section2":"content2"],["section3":"content3"],["section4":"content4"]]
    @IBOutlet weak var testL: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .red
        debugPrint(testL.frame)
        
        setBase()
    }
    func setBase() {
        tableView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.register(UINib(nibName: Xib3CellID, bundle: nil), forCellReuseIdentifier: Xib3CellID)
    }

    func pushStorybardVC(_ sender: Any) {
//        let sb = UIStoryboard(name: "StoryboardVC", bundle: nil)
//        if let vc = sb.instantiateViewController(withIdentifier: "SVC") as? SVC {
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
}
extension XIBVC3: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataDic?.capacity ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Xib3CellID, for: indexPath)
        if let topCell = cell as? BZXIB3Cell {
            print("")
        }
        cell.textLabel?.text = "123"

        return cell
    }
}

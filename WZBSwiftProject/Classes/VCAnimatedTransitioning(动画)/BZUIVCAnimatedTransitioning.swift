//
//  BZUIVCAnimatedTransitioning.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/10/26.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZUIVCAnimatedTransitioning: UIViewController {
    var btn: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 100)
        btn.backgroundColor = .brown
        btn.setTitle("tiaozhuan", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(click), for:  .touchUpInside)
        self.btn = btn
        self.view.addSubview(btn)
    }
    
    @objc func click() {
//        let vc = BZPresentedVC()
////        self.navigationController!.present(vc, inSize: CGSize(width: 100, height: 100), style: .center, animated: true, completion: nil)
//        vc.modalTransitionStyle = .partialCurl
//        vc.modalPresentationStyle = .fullScreen
//        self.navigationController?.present(vc, animated: true, completion: nil)
        BZPresentedVC.customWayToPlayer(from: self, animationView: self.btn!)
    }
}

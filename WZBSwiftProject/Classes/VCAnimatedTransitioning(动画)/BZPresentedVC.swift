//
//  BZPresentedVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/11/3.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

class BZPresentedVC: UIViewController {
    public var animationView: UIView?
    var playerPlaceholderView: UIView?
    var btn: UIButton?
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .green

        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)
        btn.backgroundColor = .brown
        btn.setTitle("dissssss", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(click), for:  .touchUpInside)
        self.btn = btn
        self.playerPlaceholderView = self.btn
        self.view.addSubview(btn)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    @objc func click() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BZPresentedVC {
    public static func customWayToPlayer(from viewController: UIViewController,
                                         customTransition: Bool = false,
                                         animationView: UIView?) {
        if viewController is BZPresentedVC { return }
        let vc = BZPresentedVC()
        vc.animationView = animationView
        viewController.navigationController?.delegate = vc
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 跳转动画
extension BZPresentedVC: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
        guard let animationView = self.animationView else { return nil }
            return DFRecommendNavigationTransition(
                type: operation == .push ? .push : .pop,
                animationView: animationView)
    }
}

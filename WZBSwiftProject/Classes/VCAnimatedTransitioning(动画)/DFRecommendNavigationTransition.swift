//
//  DFRecommendNavigationTransition.swift
//  dftv2
//
//  Created by tjx on 2020/8/11.
//  Copyright © 2020 italktv. All rights reserved.
//

import UIKit

class DFRecommendNavigationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum TransitionType {
        case push
        case pop
    }
    
    var type: TransitionType = .push
    var duration: TimeInterval = 0.5
    var animationView: UIView!
    
    var animationViewFrame = CGRect.zero
    
    init(type: TransitionType,
         duration: TimeInterval = 0.5,
         animationView: UIView) {
        self.type = type
        self.duration = duration
        self.animationView = animationView
    }
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?)
        -> TimeInterval {
            return duration
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .push:
            pushAnimation(transitionContext: transitionContext)
        case .pop:
            popAnimation(transitionContext: transitionContext)
        }
    }
    
}

extension DFRecommendNavigationTransition {
    
    func pushAnimation(transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewController(forKey: .to) as? BZPresentedVC
        
        let containerView = transitionContext.containerView
        let tempView = animationView.snapshotView(afterScreenUpdates: false)
        
        animationViewFrame = animationView.frame
        
        guard let targetVC = toVC,
            let targetView = tempView else {
                transitionContext.completeTransition(true)
                return
        }
        
        targetView.frame = animationView.convert(animationView.bounds, to: containerView)
        targetVC.view.alpha = 0
        
        containerView.addSubview(targetVC.view)
        containerView.addSubview(targetView)
        
        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            animations: {
                
                targetVC.view.alpha = 1
                let frame = targetVC.playerPlaceholderView?.convert(
                    targetVC.playerPlaceholderView?.bounds ?? CGRect.zero,
                    to: containerView
                )
                
                targetView.frame = CGRect(
                    x: 0,
                    y: UIApplication.shared.statusBarFrame.height,
                    width: frame?.width ?? 0,
                    height: frame?.height ?? 0
                )

        }, completion: { _ in
            targetView.isHidden = true
            transitionContext.completeTransition(true)
        })
        
    }
    
    func popAnimation(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from) as? BZPresentedVC
        let toVC = transitionContext.viewController(forKey: .to)

        let containerView = transitionContext.containerView
        let playView = fromVC?.playerPlaceholderView
        let tempView = playView?.snapshotView(afterScreenUpdates: false)

        guard let targetVC = toVC,
            let targetView = tempView else {
                if let view = toVC?.view { containerView.addSubview(view) }
                transitionContext.completeTransition(true)
                return
        }

        targetView.frame = targetView.convert(targetView.bounds, to: containerView)
        targetVC.view.alpha = 0

        containerView.addSubview(targetVC.view)
        containerView.addSubview(targetView)

        UIView.animate(
            withDuration: self.transitionDuration(using: transitionContext),
            animations: {
                targetVC.view.alpha = 1
                targetView.frame = self.animationView.convert(
                    self.animationView.bounds,
                    to: containerView
                )
        }, completion: { _ in
            targetView.isHidden = true
            transitionContext.completeTransition(true)
        })
        
    }
}

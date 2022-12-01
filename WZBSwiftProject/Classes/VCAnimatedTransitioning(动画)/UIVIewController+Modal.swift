//
//  UIVIewController+Modal.swift
//  dftv_ipad
//
//  Created by GSW on 2020/9/9.
//  Copyright © 2020 italkbbtv.com. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func present(_ viewControllerToPresent: UIViewController, inSize size: CGSize, style: DFModalPresentationStyle = .center, animated flag: Bool, completion: (() -> Void)? = nil){
        viewControllerToPresent.modalPresentationStyle = .custom
        viewControllerToPresent.preferredContentSize = size
        let presentationController = DFModalPresentationController(presentedViewController: viewControllerToPresent, presenting: self, style: style)
        presentationController.style = style
        withExtendedLifetime(presentationController) {
            viewControllerToPresent.transitioningDelegate = presentationController
            present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
}

enum DFModalPresentationStyle {
    case center
    case top
    case left
    case right
    case bottom
}

private let modalDimmingViewAlpha: CGFloat = 0.5
private let modalTransitionDuration: TimeInterval = 0.3
private let modalDismissTransitionDuration: TimeInterval = 0.3
private let modalCenterInitialViewSizeRatio: CGFloat = 0.1
private let modalCenterInitialViewAlpha: CGFloat = 0.5

class DFModalPresentationController: UIPresentationController {
    
    public var style: DFModalPresentationStyle!
    
    lazy var dimmingView: UIButton = {
        let view = UIButton(frame: self.containerView?.frame ?? .zero)
        view.backgroundColor = .black
        view.addTarget(self, action: #selector(dimmingViewTapped), for: .touchUpInside)
        return view
    }()
    
    var showKeyboard: Bool = false
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, style: DFModalPresentationStyle) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.style = style
        presentedViewController.modalPresentationStyle = .custom
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.addSubview(dimmingView)
        //获取转场协调器
        let transitionCoordinator = presentingViewController.transitionCoordinator
        
        dimmingView.alpha = 0.0
        //渐变的 dimmingView，使该动画和转场动画并行
        transitionCoordinator?.animate(alongsideTransition: { [weak self](context) in
            guard let `self` = self else {return}
            self.dimmingView.alpha = modalDimmingViewAlpha
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        //获取转场协调器
        let transitionCoordinator = presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { [weak self](context) in
            guard let `self` = self else {return}
            self.dimmingView.alpha = 0.0
        }, completion: nil)
    }
    //MARK: layout
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        
        if container === presentedViewController {
            return container.preferredContentSize
        }else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerViewBounds = containerView?.bounds else {
            return super.frameOfPresentedViewInContainerView
        }
        let presentedViewContentSize = size(
            forChildContentContainer: presentedViewController,
            withParentContainerSize: containerViewBounds.size)
        var presentedViewControllerFrame: CGRect = .zero
        presentedViewControllerFrame.size.width = presentedViewContentSize.width
        presentedViewControllerFrame.size.height = presentedViewContentSize.height
        
        switch self.style {
        case .top:
            presentedViewControllerFrame.origin.y = 0
            presentedViewControllerFrame.origin.x = (containerViewBounds.maxX - presentedViewContentSize.width) / 2
        case .bottom:
            presentedViewControllerFrame.origin.y = containerViewBounds.maxY - presentedViewContentSize.height
            presentedViewControllerFrame.origin.x = (containerViewBounds.maxX - presentedViewContentSize.width) / 2
        case .center:
            presentedViewControllerFrame.origin.y = (containerViewBounds.maxY - presentedViewContentSize.height) / 2
            presentedViewControllerFrame.origin.x = (containerViewBounds.maxX - presentedViewContentSize.width) / 2
        case .left:
            presentedViewControllerFrame.origin.y = (containerViewBounds.maxY - presentedViewContentSize.height) / 2
            presentedViewControllerFrame.origin.x = 0
        case .right:
            presentedViewControllerFrame.origin.y = (containerViewBounds.maxY - presentedViewContentSize.height) / 2
            presentedViewControllerFrame.origin.x = containerViewBounds.maxX - presentedViewContentSize.width
        case .none:
            break
        }
        return presentedViewControllerFrame
    }
    
}

extension DFModalPresentationController {
    
    //MARK: Tap background
    @objc func dimmingViewTapped() {
        if showKeyboard {
            return
        }
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    //MARK: 出现动画的 presentedView 的初始状态
    func toViewInitial(withContainterViewBounds bounds: CGRect, finalSize: CGSize, style: DFModalPresentationStyle) -> CGRect {
        //置中偏移量
        let XOffset = bounds.midX - finalSize.width / 2
        let YOffset = bounds.midY - finalSize.height / 2
        var toViewInitialFrame: CGRect = .zero
        switch self.style {
        case .top:
            toViewInitialFrame.origin = CGPoint(x: XOffset, y: -bounds.maxY)
            toViewInitialFrame.size = finalSize
        case .bottom:
            toViewInitialFrame.origin = CGPoint(x: XOffset, y: bounds.maxY)
            toViewInitialFrame.size = finalSize
        case .center:
            toViewInitialFrame.origin = CGPoint(x: XOffset, y: YOffset)
            toViewInitialFrame.size = finalSize
        case .left:
            toViewInitialFrame.origin = CGPoint(x: -bounds.maxX, y: YOffset)
            toViewInitialFrame.size = finalSize
        case .right:
            toViewInitialFrame.origin = CGPoint(x: bounds.maxX, y: YOffset)
            toViewInitialFrame.size = finalSize
        case .none:
            break
        }
        return toViewInitialFrame
    }
    
    //MARK: 结束动画的 presentedView 的最终状态
    func fromViewFinal(fromViewFrame: CGRect?, style: DFModalPresentationStyle?) -> CGRect {
        guard let fromViewFrame = fromViewFrame else {return .zero}
        var fromViewFinalFrame: CGRect = .zero
        switch self.style {
        case .top:
            fromViewFinalFrame = fromViewFrame.offsetBy(dx: 0, dy: -fromViewFrame.height)
        case .bottom:
            fromViewFinalFrame = fromViewFrame.offsetBy(dx: 0, dy: fromViewFrame.height)
        case .center:
            break
        case .left:
            fromViewFinalFrame = fromViewFrame.offsetBy(dx: -fromViewFrame.width, dy: 0)
        case .right:
            fromViewFinalFrame = fromViewFrame.offsetBy(dx: fromViewFrame.width, dy: 0)
        case .none:
            break
        }
        return fromViewFinalFrame
    }
}

//MARK: UIViewControllerTransitioningDelegate
extension DFModalPresentationController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
}

//MARK: UIViewControllerAnimatedTransitioning
extension DFModalPresentationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard let transitionContext = transitionContext else {
            return 0
        }
        //点开的展现动画，或 dismiss 动画
        let fromViewController = transitionContext.viewController(forKey: .from)
        let isPresenting = (fromViewController == presentingViewController)
        //返回设定的时间
        if transitionContext.isAnimated {
            if isPresenting {
                return modalTransitionDuration
            } else {
                return modalDismissTransitionDuration
            }
        }else{
            return 0
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) else {return}
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        let containerView = transitionContext.containerView
        //点开的展现动画，或 dismiss 动画
        let isPresenting = (fromViewController == presentingViewController)
        var toViewInitialFrame = transitionContext.initialFrame(for: toViewController)
        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromViewController)
        if isPresenting {
            containerView.addSubview(toView!)
            //出现动画
            toViewInitialFrame = toViewInitial(withContainterViewBounds: containerView.bounds, finalSize: toViewFinalFrame.size, style: self.style!)
            toView?.frame = toViewInitialFrame
            if self.style == .center {
                toView?.alpha = modalCenterInitialViewAlpha
                toView?.transform = CGAffineTransform(scaleX: modalCenterInitialViewSizeRatio, y: modalCenterInitialViewSizeRatio)
            }
        }else {
            //结束动画
            fromViewFinalFrame = fromViewFinal(fromViewFrame: fromView?.frame, style: self.style)
        }
        let duration = transitionDuration(using: transitionContext)
           
        if self.style == .center {
            UIView.animate(
                withDuration: duration,
                delay: 0.0,
                options: .curveEaseOut,
                animations: {
                    if isPresenting {
                        //恢复正常态
                        toView?.alpha = 1.0
                        toView?.transform = .identity
                    }else {
                        fromView?.alpha = 0.0
                        fromView?.transform = CGAffineTransform(scaleX: modalCenterInitialViewSizeRatio, y: modalCenterInitialViewSizeRatio)
                    }
            }) { (finished) in
                toView?.frame = toViewFinalFrame
                transitionContext.completeTransition(true)
            }
        }else {
            UIView.animate(
                withDuration: duration,
                delay: 0.0,
                options: .curveEaseOut,
                animations: {
                    if isPresenting {
                        toView?.frame = toViewFinalFrame
                    }else {
                        fromView?.frame = fromViewFinalFrame
                    }
            }) { (finished) in
                transitionContext.completeTransition(true)
            }
        }
    }
}

//MARK: keyboard
extension DFModalPresentationController {
    @objc func keyboardDidShow(_ notification: Notification?) {
        showKeyboard = true
    }
    
    @objc func keyboardDidHide(_ notification: Notification?) {
        showKeyboard = false
    }
}

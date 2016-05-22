//
//  PopAnimator.swift
//  Eigen
//
//  Created by Connor Holowachuk on 2016-05-14.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let infoView = presenting ? toView : transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        let initialFrame = presenting ? originFrame : infoView!.frame
        let finalFrame = presenting ? infoView!.frame : originFrame
        
        let xSlideFactor: CGFloat = 0.0 //presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        
        let ySlideFactor = presenting ? initialFrame.origin.y / finalFrame.origin.y : finalFrame.origin.y / initialFrame.origin.y
        
        let slideTransform = CGAffineTransformMakeTranslation(xSlideFactor, ySlideFactor)
        
        if presenting {
            infoView!.transform = slideTransform
            infoView!.center = CGPoint(
                x: CGRectGetMidX(initialFrame),
                y: CGRectGetMidY(initialFrame))
            infoView!.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(infoView!)
        
        UIView.animateWithDuration(duration, delay:0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {infoView!.transform = self.presenting ? CGAffineTransformIdentity : slideTransform
            infoView!.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))},
                                   completion:{_ in transitionContext.completeTransition(true)}
        )
    }
    
}

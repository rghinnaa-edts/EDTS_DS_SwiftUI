//
//  FloatingAnimationHelper.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 09/01/26.
//

import UIKit

public class AnimationHelper {
    
    public init() {}
    
    public func animateFloating(
        view: UIView,
        distance: CGFloat,
        duration: TimeInterval,
        onEnd: @escaping () -> Void
    ) {
        let startY = view.center.y
        let endY = startY - distance
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseIn],
            animations: {
                view.center.y = endY
            }
        )
        
        UIView.animate(
            withDuration: duration * 0.6,
            delay: duration / 6,
            options: [.curveLinear],
            animations: {
                view.alpha = 0
            }
        )
        
        UIView.animate(
            withDuration: duration / 4,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: duration / 4,
                    delay: 0,
                    options: [.curveEaseInOut],
                    animations: {
                        view.transform = .identity
                    },
                    completion: { _ in
                        onEnd()
                    }
                )
            }
        )
    }
}

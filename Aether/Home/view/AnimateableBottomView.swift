//
//  AnimateableBottomView.swift
//  Aether
//
//  Created by Bruno Pastre on 22/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

protocol AnimateableBottomView: UIView {
    func animateIn(completion: ((Bool) -> Void)?)
    func animateOut(completion: ((Bool) -> Void)?)
    func forceOut()
}

extension AnimateableBottomView {
    func animateIn(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = .identity
        },
        completion: completion)
    }
    func animateOut(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations:  {
            self.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 500)
        },
        completion: completion)
    }
    func forceOut()
    { self.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 500) }
}

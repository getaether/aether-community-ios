//
//  MicroInteractions.swift
//  Aether
//
//  Created by Gabriel Gazal on 30/07/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class Interaction{
    static let instance = Interaction()
    
    private init(){
        
    }
    
    func buttonPressed(withSound: Bool){
        let buttonHaptic = UIImpactFeedbackGenerator(style: .medium)
        buttonHaptic.impactOccurred()
        if withSound{
            AudioManager.shared.play(soundEffect: .button)
        }
    }
    
    func longPressed(){
        let longHaptic = UIImpactFeedbackGenerator(style: .heavy)
        longHaptic.impactOccurred()
    }
    
    func errorHaptic(){
        let errorHaptic = UINotificationFeedbackGenerator()
        errorHaptic.notificationOccurred(.error)

    }
    
    func pulsate(view: UIView, completion: (() -> Void)? = nil ){
        view.transform = view.transform.scaledBy(x: 0.92, y: 0.92)
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.5,
            options: []) {
            view.transform = .identity
        } completion: { (_) in
            completion?()
        }
    }
    
    func lightPulse(view: UIView){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.fromValue = 0.9
        pulse.toValue = 1
        pulse.autoreverses = false
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        view.layer.add(pulse, forKey: nil)
        let buttonHaptic = UIImpactFeedbackGenerator(style: .light)
        buttonHaptic.impactOccurred()
        
    }
}

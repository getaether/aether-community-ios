//
//  EasterEggRevealState.swift
//  Aether
//
//  Created by Bruno Pastre on 16/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

enum EasterEggRevealState {
    
    case bottomRight
    case bottomLeft
    case topLeft
    case topRight
    
    func next() -> EasterEggRevealState? {
        switch self {
        
        case .bottomRight: return .topRight
        case .topRight:    return .bottomLeft
        case .bottomLeft:  return .topLeft
        case .topLeft:     return nil
            
        }
    }
    func touchArea() -> CGFloat { 40.0 }
    
    func inView() -> (x: CGFloat, y: CGFloat) {
        switch self {
        case .bottomLeft: return (0.0, 1.0)
        case .bottomRight: return (1.0, 1.0)
        case .topLeft: return (0.0, 0.0)
        case .topRight: return ( 1.0, 0.0)
        
        }
    }
    
    func offset() -> (x: CGFloat, y: CGFloat) {
        switch self {
        case .bottomLeft:       return (0, -self.touchArea())
        case .bottomRight:      return (-self.touchArea(), -self.touchArea())
        case .topLeft:          return (0, self.touchArea())
        case .topRight:         return (-self.touchArea(), 40 + self.touchArea())
        }
    }
    
    static func getFirstState() -> EasterEggRevealState { .bottomRight}
}

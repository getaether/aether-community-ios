//
//  ShadowTextField.swift
//  Aether
//
//  Created by Gabriel Gazal on 31/07/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class DesignableTextField: UITextField{
    
    var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
            updateLayerProperties()

        }
    }
    
    var borderWidht: CGFloat = 0{
        didSet{
            layer.borderWidth = 0.5
        }
    }
    var borderColor: UIColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    func updateLayerProperties() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
            
        
    }
}

//
//  BodyTextLabel.swift
//  Aether
//
//  Created by Gabriel Gazal on 31/07/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class BodyTextLabel: UILabel{
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
            updateLayerProperties()

        }
    }
   
    
    
    func updateLayerProperties() {
        self.layer.masksToBounds = false
        self.textColor = #colorLiteral(red: 0.08341478556, green: 0.0834178254, blue: 0.08341617137, alpha: 1)
        self.font = UIFont.systemFont(ofSize: 16.0)
    }
}

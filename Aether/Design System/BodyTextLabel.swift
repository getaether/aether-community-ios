//
//  BodyTextLabel.swift
//  Aether
//
//  Created by Gabriel Gazal on 31/07/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class BodyTextLabel: UILabel{
    
    var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
            updateLayerProperties()

        }
    }
    
    init() {
        super.init(frame: .zero)
        
        self.updateLayerProperties()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.updateLayerProperties()
    }
    
    
    
    func updateLayerProperties() {
        self.layer.masksToBounds = false
        self.textColor = ColorManager.bodyTextColor
        self.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        
    }
}

//
//  TitleLabel.swift
//  Aether
//
//  Created by Gabriel Gazal on 31/07/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class TitleLabel: UILabel{
    
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
    }
    
    func updateLayerProperties() {
        self.layer.masksToBounds = false
        self.textColor = ColorManager.titleTextColor
        self.font = UIFont.systemFont(ofSize: 28.0, weight: .bold)
    }
}

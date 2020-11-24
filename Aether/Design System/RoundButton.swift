//
//  DesignableButton.swift
//  InimigosPublicos
//
//  Created by Gabriel Gazal on 04/11/19.
//  Copyright © 2019 Filipe Souza. All rights reserved.
//

import Foundation
import UIKit

class DesignableButton: UIButton{
    
    var cornerRadius: CGFloat = 0{
        didSet{
            updateLayerProperties()
        }
    }
    
    var borderWidht: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidht
        }
    }
    var borderColor: UIColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commomInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commomInit()
    }
    
    func commomInit() {
        
        self.layer.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.3215686275, blue: 0.9882352941, alpha: 1)
        self.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.3215686275, blue: 0.9882352941, alpha: 1)
    }
    
    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        self.updateLayerProperties()
    }
    
    func updateLayerProperties() {
        
        self.clipsToBounds = true
        
        self.layer.cornerRadius = self.frame.height / 2.0
        
        self.setTitleColor(ColorManager.neutralColor, for: .normal)
        
    }
}

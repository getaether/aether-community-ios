//
//  IconItem.swift
//  Aether
//
//  Created by Gabriel Gazal on 24/09/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import  UIKit

class IconItem {
    
    internal init(name: String, iconImage: UIImage) {
        self.name = name
        self.iconImage = iconImage
    }
    
    var name: String
    var iconImage: UIImage
}

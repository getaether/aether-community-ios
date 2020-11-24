//
//  AECustomIconSelectorCell.swift
//  Aether
//
//  Created by Gabriel Gazal on 15/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

class AECustomIconSelectorCell: AECollectionViewCell {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var iconView: UIImageView!
    var room: HMRoom?
    
    override func getMenuObject() -> Any?
    { room }
}

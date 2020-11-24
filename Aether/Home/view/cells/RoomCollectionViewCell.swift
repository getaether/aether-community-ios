//
//  RoomCollectionViewCell.swift
//  Aether
//
//  Created by Bruno Pastre on 04/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

/// [DEPRECATED]
/// This is no longer being used since there is no filter anymore
class RoomCollectionViewCell: AECollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    var room: HMRoom!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.clipsToBounds = false
        
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1
    }
    
    override func getMenuObject() -> Any? {
        return self.room
    }
    
    func setSelected() {
        
        self.contentView.backgroundColor = ColorManager.highlightColor
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        
        self.nameLabel.textColor = UIColor(red: 0xFA/0xFF, green: 0xFA/0xFF, blue: 0xFA/0xFF, alpha: 1)
    }
    
    func setDeselected() {
        let color = UIColor(red: 0xB3/0xFF, green: 0xB3/0xFF, blue: 0xB3/0xFF, alpha: 1)
        
        self.contentView.backgroundColor = .white
        self.contentView.layer.borderColor = color.cgColor
        self.nameLabel.textColor = color
        
    }
    
    override func getPresentingView() -> UIView {
        self.contentView
    }
}

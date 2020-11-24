//
//  AECustomIconPickerCell.swift
//  Aether
//
//  Created by Gabriel Gazal on 24/09/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class AECustomIconPickerCell: UICollectionViewCell {

    private var containerMultiplier: CGFloat = 0.6
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.setUpIconView()
    }
    
    
    //MARK: - Setup
    
    func setUpIconView() {
        let view = self.iconView!
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.clipsToBounds = false
        view.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            view.widthAnchor.constraint(equalTo: self.widthAnchor),
            view.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    func activateShadow(view: UIView) {
        let view = self.iconView!
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.15)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset =  CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 5
    }
    

}

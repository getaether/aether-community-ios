//
//  ImageManager.swift
//  Aether
//
//  Created by Bruno Pastre on 20/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

extension UIImage {
    static let add: UIImage = UIImage(named: "add")!
    static let ghost: UIImage = UIImage(named: "ghost")!
    
    enum Icon {
        static let home = UIImage(named: "home-icon")!
        static let bathroom = UIImage(named: "kitchenIcon")!
        static let kitchen = UIImage(named: "toiletIcon")!
        static let bedroom = UIImage(named: "bedroomIcon")!
        static let garage = UIImage(named: "carIcon")!
        static let garden = UIImage(named: "gardenIcon")!
        static let laundry = UIImage(named: "laundryIcon")!
        static let office = UIImage(named: "officeIcon")!
        static let lamp = UIImage(named: "ideaIcon")!
        static let wardrobe = UIImage(named: "wardrobeIcon")!
        static let living = UIImage(named: "sofaIcon")!

        static var all: [UIImage] {[
            UIImage.Icon.home,
            UIImage.Icon.bathroom,
            UIImage.Icon.kitchen,
            UIImage.Icon.bedroom,
            UIImage.Icon.garage,
            UIImage.Icon.garden,
            UIImage.Icon.laundry,
            UIImage.Icon.office,
            UIImage.Icon.lamp,
            UIImage.Icon.wardrobe,
            UIImage.Icon.living,
        
        ]}
    }
}

//
//  CustomRoom.swift
//  Aether
//
//  Created by Gabriel Gazal on 26/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit
import HomeKit

class CustomRoom {
    
    internal init(
        nome: String,
        image: String,
        hkroom: HMRoom? = nil) {
        self.nome = nome
        self.image = image
        self.hkroom = hkroom
    }
    
   
    var nome: String
    var image: String
    var hkroom: HMRoom?
    
    
    func isHome() -> Bool {
        return hkroom == HomeKitFacade.shared.getDefaultHome()?.roomForEntireHome()
    }
}

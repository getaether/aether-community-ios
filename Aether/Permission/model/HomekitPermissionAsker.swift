//
//  HomekitPermissionAsker.swift
//  Aether
//
//  Created by Bruno Pastre on 22/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

class HomePermissionAsker: NSObject, AEPermissionAsker, HMHomeManagerDelegate {
    
    var name: String { "Home" }
    weak var delegate: PermissionAskerDelegate?
    var isAllowed: Bool = false {
        didSet {
            delegate?.permissionDidChange(self, to: isAllowed)
        }
    }
    var shouldPresentAlert: Bool = false

    private var manager: HMHomeManager?
    
    func updatePermission() {
        shouldPresentAlert = false
        if manager == nil {
            manager = .init()
            manager?.delegate = self
        }
        if manager?.authorizationStatus.contains(.authorized) ?? false {
            isAllowed = true
            return
        }
    }
    
    func ask() {
        shouldPresentAlert = true
        if manager == nil {
            manager = .init()
            manager?.delegate = self
        }
        
        if manager?.authorizationStatus.contains(.authorized) ?? false {
            isAllowed = true
            return
        }
        
        if shouldPresentAlert { presentCustomAlert() }
    }


    func homeManager(_ manager: HMHomeManager, didUpdate status: HMHomeManagerAuthorizationStatus) {
        switch status {
        case .authorized:
            isAllowed = true
        default:
            if shouldPresentAlert { presentCustomAlert() }
        }
    }
}

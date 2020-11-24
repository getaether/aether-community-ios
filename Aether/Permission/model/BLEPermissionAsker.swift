//
//  BLEPermissionAsker.swift
//  Aether
//
//  Created by Bruno Pastre on 22/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import CoreBluetooth
import UIKit

class BLEPermissionAsker: NSObject, AEPermissionAsker, CBCentralManagerDelegate {
    
    var name: String { "Bluetooth" }
    weak var delegate: PermissionAskerDelegate?
    var isAllowed: Bool = false {
        didSet {
            delegate?.permissionDidChange(self, to: isAllowed)
        }
    }
    
    private var shouldTriggerAlert: Bool = false
    private var manager: CBCentralManager?
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            isAllowed = true
        default:
            if shouldTriggerAlert { presentCustomAlert() }
            break
        }
    }
    
    func updatePermission() {
        shouldTriggerAlert = false
        triggerAsk()
    }
    
    
    func ask() {
        shouldTriggerAlert = true
        triggerAsk()
    }
    
    private func triggerAsk() {
        manager = CBCentralManager(
            delegate: self,
            queue: nil,
            options: [CBCentralManagerOptionShowPowerAlertKey: true]
        )
    }
}

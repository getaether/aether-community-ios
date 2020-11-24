//
//  AEBluetoothPeripheral.swift
//  Aether
//
//  Created by Bruno Pastre on 21/09/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import CoreBluetooth

class AEBluetoothPeripheral: NSObject, CBPeripheralDelegate {
    
    private let WIFI_SERVICE_UUID = CBUUID(string: "59462F12-9543-9999-12C8-58B459A2712D")
    private let WIFI_VALUE_CHAR_UUID = CBUUID(string: "5C3A659E-897E-45E1-B016-007107C96DF7")
    private let WIFI_CONFIGURED_CHAR_UUID = CBUUID(string: "5c3a659e-897e-45e1-b016-007107c96df6")
    
    private let UPDATE_SERVICE_UUID = CBUUID(string: "3EE12EC0-9AF0-43B0-86EB-8F0AB4EE386A")
    private let UPDATE_ALLOWED_CHAR_UUID = CBUUID(string: "44cbf242-cba1-4ad7-ab1c-2579daaea64a".uppercased())
    private let UPDATE_AVAILABLE_CHAR_UUID = CBUUID(string: "a73ad85a-8ffb-48f1-8d13-dee93d1adc4b".uppercased())
    private let UPDATE_IDENTIFIER_CHAR_UUID = CBUUID(string: "32cf6c97-36b5-4679-87db-b27b22c9ebfa".uppercased())
    
    var peripheral: CBPeripheral!
    
    private var canUpdateWifi: Bool?
    private var isUpdateAvailable = false
    private let updateService: AEDeviceUpdateService? = nil
    
    init(peripheral: CBPeripheral) {
        super.init()
        self.peripheral = peripheral
        self.peripheral.delegate = self
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            return
        }
        
        for service in peripheral.services! {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let chars = service.characteristics else { return }
        
        for characteristic in chars {
            let char = characteristic as CBCharacteristic
            
            if char.uuid == WIFI_CONFIGURED_CHAR_UUID {
                peripheral.readValue(for: char)
            } else if char.uuid == UPDATE_AVAILABLE_CHAR_UUID {
                peripheral.readValue(for: char)
            } else if char.uuid == UPDATE_IDENTIFIER_CHAR_UUID {
                peripheral.readValue(for: char)
            }
            
            peripheral.setNotifyValue(true, for: char)
        }
        
        if service.uuid == WIFI_SERVICE_UUID {
            self.sendWifiCredentialsIfPossible()
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let cValue = characteristic.value else { return }
        
        var value: UInt8 = 0;
        
        if characteristic.uuid == WIFI_CONFIGURED_CHAR_UUID {

            cValue.copyBytes(to: &value, count: MemoryLayout<UInt8>.size)
            
            self.canUpdateWifi = value == 0
            self.sendWifiCredentialsIfPossible()
            return
        }
        
        if characteristic.uuid == UPDATE_IDENTIFIER_CHAR_UUID {
            guard let readData = String(data: cValue, encoding: .utf8) else { return }
            self.registerDeviceIfPossible(deviceId: readData)
        }
    }
    
    
    func registerDeviceIfPossible(deviceId: String) {
        guard let canUpdate = self.canUpdateWifi, !canUpdate else { return }
        guard !deviceId.isEmpty else { return }
        
        updateService?.registerDevice(serial: deviceId.replacingOccurrences(of: "\0", with: ""))
    }
    
    
    func sendWifiCredentialsIfPossible() {
        guard let creds = WifiManager().getWifi() else { return }
        guard let services = self.peripheral.services else { return }
        guard let canUpdate = self.canUpdateWifi, canUpdate else { return }
        
        for service in services {
            guard let characteristics = service.characteristics else { return }
            
            for characteristic in characteristics {
                guard characteristic.uuid == WIFI_VALUE_CHAR_UUID else { continue }
                
                peripheral.writeValue(creds.bleFormatted().data(using: .utf8)!, for: characteristic, type: .withResponse)
                return
            }
        }
    }
    
}

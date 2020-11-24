//
//  WiFiManager.swift
//  Aether
//
//  Created by Bruno Pastre on 31/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation

class WifiManager {
    
    private let storage = StorageFacade()
    
    public func isWifiConfigured() -> Bool { self.storage.getWifi() != nil }
    public func getWifi() -> WifiCredentials? { self.storage.getWifi() }
    public func setWifi(credentials: WifiCredentials, completion: @escaping (Bool) -> () ) {
        let tester = WifiTester(credentials: credentials) { (success) in
            
            if success {
                self.storage.saveWifi(credentials: credentials)
            }
            
            completion(success)
        }
        
        tester.testWifi()
    }
}

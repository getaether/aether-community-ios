//
//  WifiTester.swift
//  Aether
//
//  Created by Bruno Pastre on 11/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

class WifiTester: NSObject{
    
    private var ssid, password: String
    private var completion: ((Bool) -> ())!
    
    private var hasFailed = false
    private var isTestingWifi: Bool = false
    private var isAppActive: Bool = true
    private var isLoading: Bool = false
    
    init(credentials: WifiCredentials, completion: @escaping (Bool) -> ()) {
        
        self.ssid = credentials.ssid
        self.password = credentials.password
        self.completion = completion
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.willResign), name: UIApplication.willResignActiveNotification, object: nil)
            
    }
    
    @objc func willResign() {
        if self.isTestingWifi {
            self.hasFailed = true
            self.completion(false)
        }
    }
    
    func testWifi() {
        
        #if targetEnvironment(simulator)
            completion(true)
            return
        #else
        
        let configuration = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
        configuration.joinOnce = true
        
        
        NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
            
            self.isTestingWifi = true
            self.isAppActive = true
            
            if let error = error {
                self.completion(false)
                print("ERROR!", error)
                return
            }
            
            Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (_) in
                if self.hasFailed { return }
                self.completion(self.isTestingWifi)
            }
        }
        
        #endif
    }
}

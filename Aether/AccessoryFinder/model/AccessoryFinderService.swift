//
//  AccessoryFinderService.swift
//  Automator
//
//  Created by Bruno Pastre on 29/05/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import HomeKit

protocol AccessoryFinderDelegate {
    func onNewAccessory(accessory: HMAccessory)
}

class AccessoryFinderService: NSObject,  HMAccessoryBrowserDelegate {
    
    public static let instance = AccessoryFinderService()
    private let browser: HMAccessoryBrowser! = HMAccessoryBrowser()
    
    var delegate: AccessoryFinderDelegate?
    
    private var cachedAccessories: [HMAccessory] = []
    private var isSearching: Bool = false
    
    override private init() {
        super.init()
        if self.browser.delegate == nil {
            self.browser.delegate = self
        }
    }
    
    func startService() {
        guard !self.isSearching else { return }
        
        browser.startSearchingForNewAccessories()
        self.isSearching = true
    }
    
    final func accessoryDidRegister(accessory: HMAccessory?) {
        self.cachedAccessories.removeAll { $0 == accessory }
        self.startService()
        
    }
    
    final func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        guard
            !self.cachedAccessories.map({ $0.uniqueIdentifier }).contains(accessory.uniqueIdentifier)
        else { return }
        
        self.cachedAccessories.append(accessory)
        self.delegate?.onNewAccessory(accessory: accessory)
        
        self.browser.stopSearchingForNewAccessories()
        self.isSearching = false
    }
    
    final func getCachedAccessories() -> [HMAccessory] { self.cachedAccessories }
    
    final func restartSearch() {
        self.browser.stopSearchingForNewAccessories()
        self.cachedAccessories.removeAll()
        
        self.isSearching = false
        self.startService()
    }
    
}

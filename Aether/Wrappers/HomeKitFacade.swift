//
//  HomeKitFacade.swift
//  Aether
//
//  Created by Bruno Pastre on 30/07/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import HomeKit

@objc protocol HomeKitEventListener{
    @objc func homeDidChange()
    @objc func accessoryDidChange(_ notification: NSNotification)
}

enum CustomError: Error {
    case noHomeYet
}


class HomeKitFacade: NSObject, HMHomeManagerDelegate, HMAccessoryDelegate {
    
    private let manager = HMHomeManager()
    private let notificationCenter = NotificationCenter.default
    private let HOME_CHANGE = Notification.Name("homeDidChange")
    private let ACCESSORY_CHANGE = Notification.Name("accessoryDidChange")
    private let storage = StorageFacade()
    
    public static let shared = HomeKitFacade()
    
    private override init() {
        super.init()
        self.manager.delegate = self
    }
    
    func setupDefaultValuesIfNeeded() {
        if self.getHomes().count == 0 {
            self.manager.addHome(withName: AEStrings.HomekitFacade.defaultHomeName) { (home, error) in
                if let error = error {
                    print("---- xFailed to create default room!", error)
                }
                
                print("Deu boa bro!")
            }
        }
        
        
    }
    
    //MARK: - Home methods
    
    public func getHomes() -> [HMHome] { self.manager.homes }



    public func getDefaultHome() -> HMHome? { self.manager.primaryHome }
    
    // MARK: - Room methods
    
    public func getRooms() -> [HMRoom]? {
        guard let home = self.getDefaultHome() else { return nil }
        var ret = home.rooms.map { $0 }
        
        if !ret.contains(home.roomForEntireHome()) {
            ret.append(home.roomForEntireHome())
        }
        
        return ret
    }
    
    public func changeAccessoryRoom(accessory: HMAccessory, newRoom: HMRoom, completion: @escaping(Error?) -> Void) {
        guard
            let home = self.getHomes().filter { $0.accessories.contains(accessory)}.first else {
            completion(NSError())
            return
        }
        
        home.assignAccessory(accessory, to: newRoom) { error in
            if let error = error {
                print("Failed to change accessory room")
            }
            completion(error)
        }
    }
    
    public func changeDefaultRoom(to roomNamed: String, completion: @escaping () -> () ) {
        guard let home = self.getHomes().first(where: {$0.name == roomNamed}) else { return }
        
        self.manager.updatePrimaryHome(home) { (error) in
            if let error = error {
                print(error)
            }
            
            self.notifyHomeUpdate()
            
            completion()
        }
    }
    
    public func addRoom(name: String, completion: @escaping (HMRoom?, Error?) -> Void) {
        guard let home = self.getHomes().first else {
            completion(nil, CustomError.noHomeYet)
            return
        }
        
        home.addRoom(withName: name, completionHandler: completion)
    }
    
    // MARK: - Accessories
    
    public func getAccessories(_ filter: AESegmentedOptions, room: HMRoom? = nil) -> [HMAccessory]? {
        
        switch filter {
            case .Cômodos: return room?.accessories
            case .Favoritos: return self.getFavoriteAccessories()
            case .Todos: return self.getAllAccessories()
        }
    }
    
    private func getFavoriteAccessories() -> [HMAccessory] {
        let accessories = self.getAllAccessories() ?? []
        let favorites = self.storage.getFavorites()
        
        return accessories.filter { favorites.contains($0.uniqueIdentifier.uuidString) }
    }
    
    private func getAllAccessories() -> [HMAccessory]? {
        var ret = [HMAccessory]()
        
        if let home = self.getDefaultHome() {
            for accessory in home.accessories {
                
                 if let characteristic = accessory.find(serviceType: HMServiceTypeLightbulb, characteristicType: HMCharacteristicMetadataFormatBool) {
                    
                    ret.append(accessory)
                    accessory.delegate = self
                    characteristic.enableNotification(true) { (error) in

                    }
                }
            }
            
            return ret
        }
        
        return nil
    }
    
    public func addAccessory(completion: @escaping (Error?) -> () ) {
        guard let home = self.getDefaultHome() else {
            completion(CustomError.noHomeYet)
            return
        }
        
        home.addAndSetupAccessories(completionHandler: completion)
    }
    
    public func removeAccessory(_ accessory: HMAccessory,completion: @escaping(Error?) -> () ){
        guard let home = self.getDefaultHome() else{
            completion(CustomError.noHomeYet)
            return
        }
        home.removeAccessory(accessory, completionHandler: completion)
    }
    
    public func toggleLight(_ accessory: HMAccessory, completion: @escaping () -> () ) {
        if let characteristic = accessory.find(serviceType: HMServiceTypeLightbulb, characteristicType: HMCharacteristicMetadataFormatBool) {
            guard let toggled = (characteristic.value as? Bool) else { return }
            
            characteristic.writeValue(NSNumber(value: !toggled)) { (error) in
                if let error = error {
                    // TODO handle this
                    print("Error on writing value", error)
                    return
                }

                completion()
            }
        }
    }
    
    // MARK: - Scene methods
    func getScenes() -> [HMActionSet]? {
        getDefaultHome()?.actionSets
    }
    
    func getScene(by id: String) -> HMActionSet?
    { getScenes()?.first(where: { $0.uniqueIdentifier.uuidString == id } ) }
    
    func updateScene(sceneId: String, isOn: Bool, completion: @escaping () -> Void ) {
        guard let scene = getScene(by: sceneId),
              let home = getDefaultHome()
        else { return }
        
        home.executeActionSet(scene) { (error) in
            if let error = error {
                print("EROORO", error)
                
            }
            completion()
        }
    }
    
    private let sceneDeletionGroup: DispatchGroup = .init()
    private let sceneDeletionQueue: DispatchQueue = .global()
    
    func deleteScene(sceneId: String, completion: @escaping (Error?) -> Void) {
        guard let scene = getScene(by: sceneId),
              let home = getDefaultHome()
        else {
            completion(CustomError.noHomeYet)
            return
        }
        var lastError: Error?
        let triggers = home.triggers.filter { $0.actionSets.contains(scene) }
        
        for trigger in triggers {
            if trigger.actionSets.count == 1 {
                sceneDeletionGroup.enter()
                sceneDeletionQueue.async {
                    home.removeTrigger(trigger) {
                        if lastError == nil { lastError = $0 }
                        self.sceneDeletionGroup.leave()
                    }
                }
            }
        }
        
        sceneDeletionGroup.enter()
        sceneDeletionQueue.async {
            home.removeActionSet(scene) {
                if lastError == nil { lastError = $0 }
                self.sceneDeletionGroup.leave()
            }
        }
        
        sceneDeletionGroup.notify(queue: .main) {
            completion(lastError)
        }
        
        
    }
    //MARK: - Favorite helpers
    
    public func isFavorite(_ accessory: HMAccessory) -> Bool {
        self.getFavoriteAccessories().contains(accessory)
    }
    
    public func updateFavorite(accessory: HMAccessory) {
        
        let isFavorited = self.getFavoriteAccessories().contains(accessory)
        
        if isFavorited {
            var newFavorites = self.storage.getFavorites()
            newFavorites.removeAll(where: { accessory.uniqueIdentifier.uuidString == $0})
            
            self.storage.saveFavorites(newFavorites)
        } else {
            var newFavorites = self.storage.getFavorites()
            newFavorites.append(accessory.uniqueIdentifier.uuidString)
            
            self.storage.saveFavorites(newFavorites)
        }
        
    }
    
    // MARK: - Storage
    
    
    // MARK: - Notification Center
    public func registerListener(_ listener: HomeKitEventListener) {
        
        self.notificationCenter.addObserver(listener, selector: #selector(listener.homeDidChange), name: self.HOME_CHANGE, object: nil)
        self.notificationCenter.addObserver(listener, selector: #selector(listener.accessoryDidChange), name: self.ACCESSORY_CHANGE, object: nil)

    }
    
    func notifyHomeUpdate() {
        self.notificationCenter.post(name: self.HOME_CHANGE, object: nil)
    }
    
    func notifyAccessoryUpdate(_ accessory: HMAccessory, _ service: HMService, _ characteristic: HMCharacteristic) {
        self.notificationCenter.post(name: self.ACCESSORY_CHANGE, object: nil, userInfo: [
            "accessory": accessory,
            "service": service,
            "characteristic": characteristic
        ])
    }
    
    // MARK: - HMHomeManagerDelegate
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        self.notifyHomeUpdate()
        
        self.setupDefaultValuesIfNeeded()
    }
    
    func homeManagerDidUpdatePrimaryHome(_ manager: HMHomeManager) {
        self.notifyHomeUpdate()
    }
    
    func homeManager(_ manager: HMHomeManager, didUpdate status: HMHomeManagerAuthorizationStatus) {
        self.notifyHomeUpdate()
        
    }
    
    func homeManager(_ manager: HMHomeManager, didReceiveAddAccessoryRequest request: HMAddAccessoryRequest) {
        self.notifyHomeUpdate()
    }
    
    // MARK: - Accessory updates
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        self.notifyAccessoryUpdate(accessory, service, characteristic)
    }
    
}



extension HMAccessory {
    func find(serviceType: String, characteristicType: String) -> HMCharacteristic? {
        return services.lazy
            .filter { $0.serviceType == serviceType }
            .flatMap { $0.characteristics }
            .first { $0.metadata?.format == characteristicType }
    }
}


extension HMActionSet {
    func isOn() -> Bool {
        for action in self.actions {
            guard let action = action as? HMCharacteristicWriteAction<NSNumber>
            else { continue }
            if action.characteristic.value as? NSNumber == action.targetValue { continue }
            return false
        }
        
        return true
    }
}

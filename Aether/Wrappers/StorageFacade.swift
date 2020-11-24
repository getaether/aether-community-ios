//
//  StorageFacade.swift
//  Aether
//
//  Created by Bruno Pastre on 11/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation

struct WifiCredentials: Codable {
    var ssid, password: String
    
    func bleFormatted() -> String { "\(ssid)\n\(password)\0" }
    func toJson() -> Data { try! JSONEncoder().encode(self) }
}

class StorageFacade {
    
    private let defaults = UserDefaults.standard
    
    private let WIFI_KEY = "Wifi credentias"
    private let FAVORITES_KEY = "Favorites credentias"
    private let REGISTERED_DEVICES = "devices"
    private let AUTOMATIC_UPDATE_KEY = "automatic update"
    private let ALLOW_AUTO_UPDATE_KEY = "autoupdateallowed"
    private let WELCOME_SCREEN_KEY = "welcomeKey"
    private let SCENE_WITH_IMAGE_KEY = "scenewithimagekey"
    private let ROOM_WITH_IMAGE_KEY = "scenewithimagekey"
    
    func saveWifi(credentials: WifiCredentials) { self.defaults.set(credentials.toJson(), forKey: self.WIFI_KEY) }
    
    func getWifi() -> WifiCredentials? {
        if let data = self.defaults.data(forKey: self.WIFI_KEY) {
            return try? JSONDecoder().decode(WifiCredentials.self, from: data)
        }
        
        return nil
    }
    
    func removeWifi() {
        self.defaults.set(nil, forKey: self.WIFI_KEY)
    }
    
    func saveFavorites(_ favoritesList: [String]) {
        self.defaults.set(favoritesList, forKey: self.FAVORITES_KEY)
    }
    
    func getFavorites() -> [String] {
        return (defaults.array(forKey: self.FAVORITES_KEY) as? [String]) ?? []
    }
    
    func resetFavorites() {
        self.defaults.set(nil, forKey: self.FAVORITES_KEY)
    }
    
    func setOwnedDevices(_ devices: [String]) {
        self.defaults.set(devices, forKey: self.AUTOMATIC_UPDATE_KEY)
    }
    
    func getOwnedDevices() -> [String] {
        self.defaults.array(forKey: self.AUTOMATIC_UPDATE_KEY) as? [String] ?? []
    }
    
    func setUpdateConfig(to: Bool) {
        self.defaults.setValue(to, forKey: self.ALLOW_AUTO_UPDATE_KEY)
    }
    func getUpdateConfig() -> Bool {
        self.defaults.bool(forKey: ALLOW_AUTO_UPDATE_KEY)
    }
    
    func clearDevices() {
        self.defaults.setValue([], forKey: AUTOMATIC_UPDATE_KEY)
    }
    
    func hasPresentedWelcomeScreen() -> Bool {
        self.defaults.bool(forKey: WELCOME_SCREEN_KEY)
    }
    
    func setPresentedWelcomeScreen() {
        self.defaults.setValue(true, forKey: WELCOME_SCREEN_KEY)
    }
    
    func getScenesWithImage() -> [SceneWithImage]? {
        guard let data = defaults.data(forKey: SCENE_WITH_IMAGE_KEY),
              let array = try? JSONDecoder().decode(
                [SceneWithImage].self,
                from: data
              )
        else { return nil}
        return array
    }
    
    func updateScenesWithImage(to newArray: [SceneWithImage]) {
        guard let encoded = try? JSONEncoder().encode(newArray)
        else { return }
        self.defaults.setValue(encoded, forKey: SCENE_WITH_IMAGE_KEY)
    }
    
    func getRoomsWithImage() -> [RoomWithImage]? {
        guard let data = defaults.data(forKey: ROOM_WITH_IMAGE_KEY),
              let array = try? JSONDecoder().decode(
                [RoomWithImage].self,
                from: data
              )
        else { return nil}
        return array
    }
    
    func updateRoomsWithImage(to newArray: [RoomWithImage]) {
        guard let encoded = try? JSONEncoder().encode(newArray)
        else { return }
        self.defaults.setValue(encoded, forKey: ROOM_WITH_IMAGE_KEY)
    }
}

//
//  AEDeviceUpdateService.swift
//  
//
//  Created by Bruno Pastre on 22/09/20.
//

import Foundation


/// This is not open source, therefore every function is mocked
/// If you want auto updates, you can implement this protocol,
///     inject it where needed (*⌘+⇧+F  AEDeviceUpdateService*)
///     and fill in with your backend data
protocol AEDeviceUpdateService {
    /// Register a device on your backend
    /// - Parameter serial: serial ID of your lamp
    func registerDevice(serial: String)
    
    
    /// Check if user has enabled updates
    /// - Returns: Returns if update is enabled by the user
    func canUpdate() -> Bool
    
    
    /// Update firmware updating permission on your backend
    /// - Parameter to: new permission value
    func setFirmwareUpdatePermission(to: Bool)
}

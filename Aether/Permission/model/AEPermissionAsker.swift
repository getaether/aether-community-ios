//
//  AEPermissionAsker.swift
//  
//
//  Created by Bruno Pastre on 22/10/20.
//

import UIKit

protocol AEPermissionAsker {
    var isAllowed: Bool { get }
    var name: String { get }
    
    func ask()
    func updatePermission()
    
    var delegate: PermissionAskerDelegate? { get set }
}

extension AEPermissionAsker {
    
    func presentCustomAlert() {
        let alert = UIAlertController(
            title: "\(AEStrings.Alert.Permission.title) \(name)",
            message: AEStrings.Alert.Permission.message,
            preferredStyle: .alert
        )
        
        let allowAction: UIAlertAction = UIAlertAction(
            title: AEStrings.Alert.Permission.Action.title,
            style: .default) { (action) in
            let url =
                URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(
                url,
                options: [UIApplication.OpenExternalURLOptionsKey : Any](),
                completionHandler: nil
            )
        }
        
        let dismissAction = UIAlertAction(
            title: AEStrings.Alert.Permission.Action.no,
            style: .default) { (_) in
//            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(allowAction)
        alert.addAction(dismissAction)
        
        delegate?.presentAlert(alert)
    }
}

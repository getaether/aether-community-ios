//
//  PermissionAskerDelegate.swift
//  Aether
//
//  Created by Bruno Pastre on 22/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

protocol PermissionAskerDelegate: class {
    func presentAlert(_ alert: UIAlertController)
    func permissionDidChange(_ asker: AEPermissionAsker, to isAllowed: Bool)
}

//
//  AEOtherDeviceViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 05/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class AEOtherDeviceViewController: UIViewController {

    @IBAction func onDismiss() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}

//
//  AESplashScreenViewController.swift
//  Aether
//
//  Created by Gabriel Gazal on 12/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import Lottie

class AESplashScreenViewController: UIViewController {

    lazy var splashAnimation: AnimationView = {
       let view = AnimationView()
        view.animation = Animation.named("splash")
        view.loopMode = .loop
        view.play()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if WifiManager().isWifiConfigured() {
            bootServices()
        }
        self.view.addSubview(splashAnimation)
        constrainSubview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
            self.view.window?.rootViewController = self.getStartingView()
        }
    }
    
    func constrainSubview() {
        NSLayoutConstraint.activate([
            splashAnimation.topAnchor.constraint(equalTo: self.view.topAnchor),
            splashAnimation.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            splashAnimation.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            splashAnimation.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    private func getStartingView() -> UIViewController {
            
        if WifiManager().isWifiConfigured() {
            return getMainVc()
        }
        if
            StorageFacade().hasPresentedWelcomeScreen() {
            return UINavigationController(rootViewController: AEPermissionsViewController())
        }
            
        return UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
    }
    
    public func getMainVc() -> UIViewController {
        let vc = AETabBarViewController()
        return vc
    }

    private func bootServices() {
        _ = HomeKitFacade.shared
        _ = BluetoothService.instance
    }
}

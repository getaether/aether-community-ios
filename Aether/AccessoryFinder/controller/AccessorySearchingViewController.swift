//
//  AccessorySearchingViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 29/05/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import HomeKit
import UIKit


class AccessorySearchingViewController: UIViewController, AccessoryFinderDelegate, ViewControllerDismissDelegate {
    
    func onDismiss(_ sender: UIViewController, should goOn: Bool) {
        
        guard goOn else { return }
        
        if sender is NewAccessoryViewController {
            
            HomeKitFacade.shared.addAccessory{ (error) in
                if let error = error {
                    return
                }
                
                self.onNewAccessory()
            }
        }
        
        if sender is IntroductionOnboardingViewController {
            
            let vc = LampSetupViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: true, completion: nil)
            
            return
        }
        
        if sender is LampSetupViewController {
            self.forceAccessorySearch()
        }
        
    }
    
    
    private let service = AccessoryFinderService.instance
    
    private var searchView: UIView?
    private var currentPresentingVC: NewAccessoryViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        service.delegate = self
        currentPresentingVC = nil
        
        self.service.startService()
    }
    
    final func onNewAccessory(accessory: HMAccessory) {
        self.dismissSearchView()
        self.presentNewAccessoryVC(accessory: accessory)
    }
    
    private final func presentNewAccessoryVC(accessory: HMAccessory?) {
        let sb = UIStoryboard(name: "NewAccessory", bundle: nil)
        
        if
            let vc = self.currentPresentingVC,
            let accessory = accessory {
            vc.onAccessoryFound(accessory)
            return
        }
        
        guard let vc = sb.instantiateInitialViewController() as? NewAccessoryViewController else { return }
        
        vc.accessory = accessory
        vc.delegate = self
        vc.completion = { [weak self] in
            guard let self = self else { return }
            
            self.service.accessoryDidRegister(accessory: accessory)
            self.onNewAccessory()
        }
        
        self.currentPresentingVC = vc
        self.present(vc, animated: true, completion: nil)
    }
    
    func presentLampOnboarding() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "introduction") as! IntroductionOnboardingViewController
        
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func onNewAccessory() {
        // Abstract method so that child view controllers can override
    }
    
    func forceAccessorySearch() {
        self.service.restartSearch()
        
        self.presentSearchView()
    }
    
    func presentSearchView() {
        self.presentNewAccessoryVC(accessory: nil)
    }
    
    
    func dismissSearchView() {
        self.searchView?.removeFromSuperview()
        self.searchView = nil
    }
    
    @objc func onSearchTapped() {
        
        UIView.animate(withDuration: 0.3, animations: {
            if let view = self.searchView {
                view.alpha = 0
            }
        }) { (_) in

            self.dismissSearchView()
        }
    }
}

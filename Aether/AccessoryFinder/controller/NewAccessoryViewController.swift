//
//  NewAccessoryViewController.swift
//  Automator
//
//  Created by Bruno Pastre on 29/05/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit
import Lottie

protocol ViewControllerDismissDelegate: class{
    func onDismiss(_ sender: UIViewController, should goOn: Bool )
}

class NewAccessoryViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var connectView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchingLabel: BodyTextLabel!
    @IBOutlet weak var foundDeviceLabel: BodyTextLabel!
    @IBOutlet weak var SearchView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var radarAnimation: AnimationView!
    
    // MARK: - Properties
    private let strings = AEStrings.NewAccessoryViewController.self
    private var isSearching: Bool { self.accessory == nil }
    
    // MARK: - Dependencies
    var completion: (() -> Void) = {}
    weak var delegate: ViewControllerDismissDelegate?
    var accessory: HMAccessory?
    
    // MARK: - Viewcontroller lifecycle
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        self.connectButton.addTarget(self, action: #selector(self.onConnect), for: .touchDown)
        connectButton.setTitle(
            strings.Button.connect,
            for: .normal)
        searchingLabel.text = AEStrings.NewAccessoryViewController.Label.searching
        
        if let name = accessory?.name{
            foundDeviceLabel.text = "\(name) \(strings.Label.found)"
        }else{
            foundDeviceLabel.text = "\(strings.Label.newAccessory) \(strings.Label.found)"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.connectView.isHidden = false
        self.addView.isHidden = true
        self.SearchView.isHidden = false
        
        self.connectView.transform = self.connectView.transform.translatedBy(x: self.view.frame.width, y: 0)
        
        if self.isSearching{
            
            self.connectView.transform.translatedBy(x: -self.connectView.frame.width, y: 0)
            self.SearchView.transform = .identity
            radarAnimation.play()
            radarAnimation.loopMode = .loop
        
        }else{
            SearchView.isHidden = true
            self.connectView.transform = .identity
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard
            let cached = AccessoryFinderService.instance.getCachedAccessories().first
        else { return }
        
        self.onAccessoryFound(cached)
    }
    
    override func viewDidLayoutSubviews() {
        self.connectButton.layer.cornerRadius = self.connectButton.frame.height / 2
        
        self.addButton.layer.cornerRadius = self.addButton.frame.height / 2
        self.contentView.layer.cornerRadius = 30
    }
    
    // MARK: - Helpers
    func onAccessoryFound(_ accessory: HMAccessory) {
        self.accessory = accessory
        
        UIView.animate(withDuration: 0.2, animations: {
            self.SearchView.alpha = 0.0
            self.connectView.transform = .identity
        })
    }
    
    // MARK: - Callbacks
    @objc func onConnect() {
        self.dismiss(animated: true, completion: {
            self.delegate?.onDismiss(self, should: true)
        })
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        UIView.animate(withDuration: 0.5) {
            self.contentView.transform = self.connectView.transform.translatedBy(x: 0, y: -keyboardHeight)
        }
    }
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        UIView.animate(withDuration: 0.5) {
            self.contentView.transform = .identity
        }
    }
}

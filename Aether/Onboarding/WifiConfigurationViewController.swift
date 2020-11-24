//
//  SetUPViewController.swift
//  Aether
//
//  Created by Gabriel Gazal on 06/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import Lottie


class WifiConfigurationViewController: UIViewController, UITextFieldDelegate, KeyboardManagerDelegate {
    
    private let strings = AEStrings.WifiConfigurationViewController.self
    
    @IBOutlet weak var titleLAbel: TitleLabel!
    @IBOutlet weak var descLabel: BodyTextLabel!
    @IBOutlet weak var wifiNameTextField: DesignableTextField!
    @IBOutlet weak var wifiPasswordTextField: DesignableTextField!
    
    @IBOutlet weak var invalidWifi: UILabel!
    @IBOutlet weak var littleEye: UIButton!
    @IBOutlet weak var continueButton: DesignableButton!
    
    @IBOutlet weak var loadingAnimation: AnimationView!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var warningImageView: UIImageView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    var displaysBackButton = true;
    public lazy var titleText: String = strings.Label.registerTitle
    
    func hideWarning() {
        self.warningLabel.isHidden = true
        self.warningImageView.isHidden = true
    }
    
    func showWarning() {
        self.warningLabel.isHidden = false
        self.warningImageView.isHidden = false
    }
    
    // MARK: - UIViewController lifecycle
    
    private let keyboardManager = KeyboardManager()
    private var keyboardAppeared: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardManager.delegate = self
        
        descLabel.text = strings.Label.description
        littleEye.setImage(UIImage(named: "openEye"), for: .normal)
        
        wifiNameTextField.delegate = self
        wifiNameTextField.tag = 0
        wifiNameTextField.returnKeyType = .next
        wifiNameTextField.placeholder = strings.TextField.wifi
        configureTextField(textField: wifiNameTextField)
        
        wifiPasswordTextField.delegate = self
        wifiPasswordTextField.tag = 1
        wifiPasswordTextField.returnKeyType = .go
        wifiPasswordTextField.placeholder = strings.TextField.password
        configureTextField(textField: wifiPasswordTextField)
        
        wifiNameTextField.becomeFirstResponder()
        
        invalidWifi.text = strings.Label.invalidWifi
        
        continueButton.setTitle(
            strings.Button.continue,
            for: .normal
        )
        
        self.hideWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wifiNameTextField.becomeFirstResponder()
        
        littleEye.imageView?.tintColor = ColorManager.titleTextColor
        
        self.continueButton.isEnabled = false
        enableButton()
        
        self.titleLAbel.text = self.titleText
    }
    
    
    // MARK: - Keyboard management
    
    func keyboardWillAppear(size: CGRect?) {
        
        if !keyboardAppeared {
            keyboardAppeared = true
            let height = size?.height ?? 0
            contentViewBottomConstraint.constant = height
        }
    }
    
    func keyboardWillDisappear() {
        
    }
    
    
    // MARK: - View modifiers
    
    func configureTextField(textField: UITextField) {
        textField.layer.cornerRadius = 7
        textField.layer.borderWidth = 0
        textField.layer.borderColor = ColorManager.highlightColor.cgColor
        textField.layer.backgroundColor = ColorManager.backgroundColor.cgColor
        textField.autocorrectionType = .yes
    }
    
    
    func enableButton(){
        if continueButton.isEnabled {
            continueButton.backgroundColor = ColorManager.highlightColor
        }else{
            continueButton.backgroundColor = ColorManager.lighterColor
        }
    }
    
    // MARK: - Text field delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        continueButton.isEnabled = (wifiNameTextField.text != "") && (wifiPasswordTextField.text != "")
        
        
        if textField.text?.isEmpty == false{
            textField.layer.borderColor = ColorManager.highlightColor.cgColor
            textField.layer.borderWidth = 1
        }
        
        enableButton()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            wifiPasswordTextField.becomeFirstResponder()
        } else {
            proceedButton(self)
        }
        return false
    }
    
    // MARK: - Wifi handlers
    
    func onWifiOk() {
        
        StorageFacade().setPresentedWelcomeScreen()
        self.loadingAnimation.stop()
        if !self.displaysBackButton {
            self.dismiss(animated: true, completion: nil)
        } else {
            let newViewController = AETabBarViewController()
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    func onWifiFailed() {
        
        self.loadingAnimation.stop()
        self.loadingAnimation.isHidden = true
        self.continueButton.isHidden = false
        self.showWarning()
        self.wifiNameTextField.layer.borderColor = ColorManager.errorColor.cgColor
        self.wifiPasswordTextField.layer.borderColor = ColorManager.errorColor.cgColor
        Interaction.instance.errorHaptic()
    }
    
    // MARK: - Callbacks
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func proceedButton(_ sender: Any) {
        //aparece a animacao de loading
        continueButton.isHidden = true
        loadingAnimation.isHidden = false
        loadingAnimation.loopMode = .loop
        loadingAnimation.play()
         
        let ssid = wifiNameTextField.text!
        let password = wifiPasswordTextField.text!
        
        WifiManager().setWifi(credentials: WifiCredentials(ssid: ssid, password: password)) { (success) in
            if success {
                self.onWifiOk()
            } else {
                self.onWifiFailed()
            }
        }
        
    }
    
    @IBAction func blockPassword(_ sender: Any) {
        wifiPasswordTextField.isSecureTextEntry = !wifiPasswordTextField.isSecureTextEntry
        littleEye.imageView?.tintColor = ColorManager.titleTextColor
        if wifiPasswordTextField.isSecureTextEntry{
            littleEye.setImage(UIImage(named: "openEye"), for: .normal)
        }else{
            littleEye.setImage(UIImage(named: "crossEye"), for: .normal)
        }
    }
}


extension UIButton {
    func setBackgroundColor(color: UIColor, for state: UIControl.State) {
        let size = CGSize(width: 1, height: 1)
        
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: state)
    }
}

//
//  SettingsViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 12/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

enum AEAjusteOption {
    case wifi
    case changeHome
    case share
    case firmwareUpdate
}

class SettingsViewController: UIViewController {
    typealias strings = AEStrings.SettingsViewController
    let topView = AENavigationViewBuilder()
        .withTitle(strings.Navigation.title)
        .build()
    var wifiOption: AEAjustesOptionView!
    var shareOption: AEAjustesOptionView!
    var homeOptions: AEAjustesOptionView!
    var firmwareUpdate: AEAjustesOptionView!
    var changeHomeLabel: UILabel!
    
    private let updateService: AEDeviceUpdateService? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = ColorManager.lightestDarkestColor
        
        navigationItem.largeTitleDisplayMode = .always
        
        self.setupTopView(parentView: self.view)
        self.setupWifiOption()
        self.setupHomeChanging()
        self.setupShareOption()
        self.setupFirmwareUpdateButton()
    }
    
    override func viewDidLayoutSubviews() {
        self.setupShadows(on: self.wifiOption.backgroundView)
        self.setupShadows(on: self.shareOption.backgroundView)
        self.setupShadows(on: self.homeOptions.backgroundView)
        self.setupShadows(on: self.firmwareUpdate.backgroundView)
    }
    
    func setupTopView(parentView: UIView) {
        self.view.addSubview(topView)
        topView.topAnchor.constraint(
            equalTo: view.topAnchor
        ).isActive = true
        topView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor
        ).isActive = true
        topView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor
        ).isActive = true
    }

    func setupShareOption() {
        let string = strings.AEAjustesOptionView.share
        let option = self.getMenuOption(string, "share-icon", option: .share)
        self.view.addSubview(option)
        option.backgroundColor = .clear
        option.backgroundView.backgroundColor = ColorManager.alternateBackgroundColor
        
        option.leadingAnchor.constraint(equalTo: self.homeOptions.leadingAnchor).isActive = true
        option.widthAnchor.constraint(equalTo: self.homeOptions.widthAnchor).isActive = true
        
        option.topAnchor.constraint(equalTo: self.homeOptions.bottomAnchor, constant: 30).isActive = true
         
        self.shareOption = option
    }
    
    
    func setupWifiOption() {
        let string = strings.AEAjustesOptionView.changeWifi
        let option = self.getMenuOption(string, "wifi-icon", option: .wifi)
        self.view.addSubview(option)
        option.backgroundView.backgroundColor = ColorManager.alternateBackgroundColor
        
        option.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        option.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        option.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 43).isActive = true
        
        self.wifiOption = option
    }
    
    func setupHomeChanging() {
        let titleLabel = UILabel()
        let view = AEAjustesOptionView(
            .changeHome,
            leading: nil,
            trailing: nil,
            axis: .vertical,
            margin: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        )
        
        titleLabel.textColor = ColorManager.backgroundColor
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        titleLabel.text = strings.AEAjustesOptionView.changeHome
        titleLabel.textColor = ColorManager.bodyTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.clipsToBounds = false
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(view)
        self.view.addSubview(titleLabel)
        
        view.leadingAnchor.constraint(equalTo: self.wifiOption.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.wifiOption.trailingAnchor).isActive = true
        
        HomeKitFacade.shared.getHomes().forEach
        { view.addArrangedSubview(self.getHomeOption(name: $0.name, needsSeparator: false, isSelected: $0.isPrimary)) }


        titleLabel.topAnchor.constraint(equalTo: self.wifiOption.bottomAnchor, constant: 30).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -10).isActive = true
        
        self.changeHomeLabel = titleLabel
        self.homeOptions = view
    }
    
    func setupFirmwareUpdateButton() {
        let toggle = UISwitch()
        let view = self.getMenuOption(
            strings.AEAjustesOptionView.update,
            toggle,
            option: .firmwareUpdate
        )
        
        toggle.onTintColor = ColorManager.highlightColor
        toggle.addTarget(self, action: #selector(onFirmwareUpdateChanged), for: .valueChanged)
        
        self.view.addSubview(view)
        view.backgroundView.backgroundColor = ColorManager.alternateBackgroundColor
        view.leadingAnchor.constraint(equalTo: self.homeOptions.leadingAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: self.homeOptions.widthAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.shareOption.bottomAnchor, constant: 30).isActive = true
        
        self.firmwareUpdate = view
    }
    
    func setupShadows(on view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(white: 0.4, alpha: 1).cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset =  CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 4
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
    }
    
    
    
    func getHomeOption(name: String, needsSeparator: Bool = true, isSelected: Bool = false) -> AEAjustesOptionView {
        
        let label = UILabel()
        let homeLabel = UILabel()
        let separator = UIView()
        let view = AEAjustesOptionView(
            .changeHome,
            leading: label,
            trailing: homeLabel,
            margin: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        )
        
        label.text = strings.Label.house
        homeLabel.text = name
        separator.backgroundColor =  needsSeparator ? ColorManager.bodyTextColor : .clear
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(separator)
        
        separator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        if isSelected {
            view.isSelected = isSelected
            label.textColor = ColorManager.neutralColor
            homeLabel.textColor = ColorManager.neutralColor
        } else {
            label.textColor = UIColor.darkText
            homeLabel.textColor = UIColor.darkText
        }
        self.addGesture(on: view)
        return view
    }
    
    func getMenuOption(_ text: String, _ imageName: String, option: AEAjusteOption) -> AEAjustesOptionView {
        let image = UIImageView(image: UIImage(named: imageName))
        image.tintColor = ColorManager.titleTextColor
        let view = self.getMenuOption(text, image, option: option)
        image.frame = CGRect(origin: .zero, size: CGSize(width: 24, height: 24))
        image.contentMode = .scaleAspectFit
        return view
    }
    
    func getMenuOption(_ text: String, _ trailing: UIView, option: AEAjusteOption) -> AEAjustesOptionView {
        let label = UILabel()
        let view = AEAjustesOptionView(option, leading: label, trailing: trailing)
        label.text = text
        label.textColor = ColorManager.titleTextColor
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addGesture(on: view)
        return view
    }
    
    func addGesture(on view: UIView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onOptionPicked(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    
    @objc func onOptionPicked(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view as? AEAjustesOptionView,
              let option = view.option
        else { return }
        switch option {
            case .wifi: self.onChangeWifi()
            case .share: self.onShareHouse()
            default: self.onChangeHome(view)
        }
    }
    
    @objc func onFirmwareUpdateChanged(_ toggle: UISwitch)
    { updateService?.setFirmwareUpdatePermission(to: toggle.isOn) }
    
    func onChangeWifi() {
        Interaction.instance.buttonPressed(withSound: false)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "wifiConfig") as! WifiConfigurationViewController
        vc.titleText = strings.AEAjustesOptionView.changeWifi
        vc.displaysBackButton = false
        self.present(vc, animated: true, completion: nil)
    }
    
    func onShareHouse()
    { Interaction.instance.errorHaptic() }
    
    func onChangeHome(_ view: AEAjustesOptionView) {
        Interaction.instance.buttonPressed(withSound: false)
        guard let viewIndex = self.homeOptions.arrangedSubviews.firstIndex(of: view) else { return }
        if view.isSelected { return }
        
        for currentHome in self.homeOptions.arrangedSubviews {
            guard let currentHome = currentHome as? AEAjustesOptionView, currentHome.isSelected else { continue }
            currentHome.deselect {}
            HomeKitFacade.shared.changeDefaultRoom(to: HomeKitFacade.shared.getHomes()[viewIndex].name)
            { view.select {} }
            return
        }
    }
}

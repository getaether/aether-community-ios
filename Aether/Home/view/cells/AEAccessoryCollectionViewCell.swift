//
//  HomeCollectionViewCell.swift
//  Aether
//
//  Created by Bruno Pastre on 30/07/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit
import Lottie

class AEAccessoryCollectionViewCell: AECollectionViewCell {
    
    private let offAnimation = "LOADED_OFF"
    private let onAnimation = "LOADED"
    private let bruteforceOn = "switchON"
    private let bruteforceOff = "switchOFF"
    private var containerMultiplier: CGFloat = 0.75
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var accessoryContainerView: UIView!
    @IBOutlet weak var accessoryNameLabel: UILabel!
    var accessory: HMAccessory?
    
    private var animatedView: AnimationView!
    private var isLoading: Bool = false
    private var isOn: Bool = false {
        willSet {
            if isOn == newValue { return }
            updateButton()
            updateText()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAnimateView()
        setupCardView()
        layer.masksToBounds = false
        clipsToBounds = false
        accessoryNameLabel.textColor = ColorManager.lighterColor
    }

    // MARK: - Setup methods
    private func setupAnimateView() {
        let switchAnimatedView = AnimationView()
        switchAnimatedView.translatesAutoresizingMaskIntoConstraints = false
        self.accessoryContainerView.addSubview(switchAnimatedView)
        switchAnimatedView.topAnchor.constraint(equalTo: self.accessoryContainerView.topAnchor).isActive = true
        switchAnimatedView.bottomAnchor.constraint(equalTo: self.accessoryContainerView.bottomAnchor).isActive = true
        switchAnimatedView.leftAnchor.constraint(equalTo: self.accessoryContainerView.leftAnchor).isActive = true
        switchAnimatedView.rightAnchor.constraint(equalTo: self.accessoryContainerView.rightAnchor).isActive = true
        switchAnimatedView.loopMode = .playOnce
        self.animatedView = switchAnimatedView
    }
    private func setupCardView() {
        
        guard let view = self.cardView
        else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.clipsToBounds = false
        view.layer.cornerRadius = 6
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.15)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset =  CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 5
        
        
        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7.5),
            view.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -15),
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
        ])
        
    }
    
    private func firstAnimationIfNeeded() {
        animatedView.animation = Animation.named(isOn ? bruteforceOff : bruteforceOn)
    }
    // MARK: - Helper methods
    func startLoading() {
        guard !isLoading else { return }
        isLoading = true
        animatedView.animation = Animation.named( isOn ? onAnimation : offAnimation )
        animatedView.play()
    }
    func configure() {
        guard let accessory = self.accessory,
              let characteristic = accessory.find(
                serviceType: HMServiceTypeLightbulb,
                characteristicType: HMCharacteristicMetadataFormatBool),
              let isOn = characteristic.value as? Bool,
              !didRecognizeLongPress
        else { return }
        
        self.isOn = isOn
        accessoryNameLabel.text = accessory.name
        stopLoading()
        firstAnimationIfNeeded()
    }
    
    func toggleIfNeeded(_ newValue: Bool) {
        self.isOn = newValue
    }
    
    private func stopLoading() {
        guard isLoading
        else { return }
        isLoading = false
        animatedView.stop()
        if isOn {
            animatedView.animation = Animation.named(bruteforceOn)
            animatedView.loopMode = .playOnce
            animatedView.play { _ in
                self.animatedView.loopMode = .loop
            }
        }
    }
    
    // MARK: - Update functions
    private func updateButton()
    {  }
    
    private func updateText() {
        self.accessoryNameLabel.textColor = !isOn ? ColorManager.highlightColor : ColorManager.lighterColor
    }
    
    // MARK: - AEPresenterView
    override func getPresentingView() -> UIView
    { self.cardView }
    
    
    override func getMenuObject() -> Any?
    { self.accessory }
}

extension HMAccessory {
    func isOn() -> Bool? {
        find(
            serviceType: HMServiceTypeLightbulb,
            characteristicType: HMCharacteristicMetadataFormatBool
        )?.value as? Bool
    }
}

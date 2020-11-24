//
//  AccessoryPickerTableViewCell.swift
//  Aether
//
//  Created by Bruno Pastre on 11/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

protocol AccessoryPickerTableViewCellDelegate: AnyObject {
    func onCheckmarkTapped(_ cell: AccessoryPickerTableViewCell)
    func onSwitchTapped(_ cell: AccessoryPickerTableViewCell)
}

class AccessoryPickerTableViewCell: UITableViewCell {
    
    // MARK: - Inner types
    struct Colors {
        static let selectedImage = UIColor.white
        static let selectedText = ColorManager.highlightColor
        static let selectedBorder = ColorManager.highlightColor
        static let selectedBackground = ColorManager.highlightColor
        
        static let deselectedImage = ColorManager.lighterColor
        static let deselectedBorder = ColorManager.lightestColor
        static let deselectedBackground = ColorManager.backgroundColor
    }
    
    // MARK: - Outlets
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var switchImageView: UIImageView!
    
    // MARK: - Constants
    private let SELECTED_IMAGE = UIImage(named: "onboarding3")
    private let DESELECTED_IMAGE = UIImage(named: "onboarding1")
    
    // MARK: - Properties
    private var areGesturesConfigured = false
    weak var delegate: AccessoryPickerTableViewCellDelegate?
    var accessory: HMAccessory?
    var isOn: Bool = true
    var checkmarkSelected: Bool = false
    
    // MARK: - UI Configuration
    func configure(accessory: HMAccessory, isSelected: Bool) {
        self.accessory = accessory
        self.checkmarkSelected = isSelected
        
        if !areGesturesConfigured {
            areGesturesConfigured = true
            configureGestures()
        }
        
        nameLabel.text = accessory.name
        
        imageContainerView.layer.cornerRadius = 6
        imageContainerView.layer.borderWidth = 1
    
        containerView.layer.cornerRadius = 6
        containerView.layer.borderWidth = 1
        configureSelection()
    }
    func toggleSelection() {
        checkmarkSelected.toggle()
        configureSelection()
    }
    private func configureSelection() {
        if checkmarkSelected { configureSelected() }
        else { configureDeselected()}
    }
    private func configureDeselected() {
        UIView.animate(withDuration: 0.2, animations: {
            self.imageContainerView.backgroundColor = Colors.deselectedBackground
            self.imageContainerView.layer.borderColor = Colors.deselectedBorder.cgColor
            self.checkImageView.image = nil
            self.containerView.layer.borderColor = Colors.deselectedBorder.cgColor
            self.containerView.backgroundColor = Colors.deselectedBackground
            self.nameLabel.textColor = Colors.deselectedImage
            self.switchImageView.isHidden = true
        }) { _ in
            self.updateSwitchImage()
        }
        
    }
    private func configureSelected() {
        UIView.animate(withDuration: 0.2, animations:  {
            self.imageContainerView.backgroundColor = Colors.selectedBackground
            self.imageContainerView.layer.borderColor = Colors.selectedBorder.cgColor
            self.checkImageView.image = UIImage(named: "check_shape")
            self.containerView.layer.borderColor = Colors.selectedBorder.cgColor
            self.nameLabel.layer.borderColor = Colors.selectedBorder.cgColor
            self.nameLabel.textColor = Colors.selectedText
            self.switchImageView.isHidden = false
        }) { _ in
            self.updateSwitchImage()
        }
    }
    
    private func updateSwitchImage() {
        let image = isOn ? SELECTED_IMAGE : DESELECTED_IMAGE
        
        UIView.animate(withDuration: 0.15, animations: {
            self.switchImageView.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.switchImageView.image = image
                self.switchImageView.alpha = 1
            }
        }
    }
    
    // MARK: - Gestures configuration
    private func configureGestures() {
        let enableTapGesture = UITapGestureRecognizer(target: self, action: #selector(onCheckmarkTapped))
        let switchTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSwitchTapped))
        
        imageContainerView.addGestureRecognizer(enableTapGesture)
        containerView.addGestureRecognizer(switchTapGesture)
    }
    
    // MARK: - Callbacks
    @objc private func onCheckmarkTapped() {
        toggleSelection()
        delegate?.onCheckmarkTapped(self)
    }
    
    @objc private func onSwitchTapped() {
        isOn.toggle()
        updateSwitchImage()
        delegate?.onSwitchTapped(self)
    }
}

//
//  RoomPickerOptionView.swift
//  Aether
//
//  Created by Bruno Pastre on 06/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

protocol RoomPickerOptionViewDelegate: AnyObject {
    func onViewTapped(_ view: RoomPickerOptionView)
}

class RoomPickerOptionView: UIStackView {
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
    
    struct Descriptor {
        enum Style {
            case title(String)
            case accessory(String)
        }
        enum OptionObject {
            case room(HMRoom)
            case accessory(HMAccessory)
        }
        let leading: UIImage?
        let trailing: Style
        let optionObject: OptionObject
    }
    
    // MARK: - Constants
    private let ON_IMAGE = UIImage(named: "onboarding1")
    private let OFF_IMAGE = UIImage(named: "onboarding3")
    // MARK: - UI Components
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(
            equalTo: view.heightAnchor
        ).isActive = true
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var imageViewContainer: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        view.backgroundColor = ColorManager.backgroundColor
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 1
        
        return view
    }()
    private lazy var trailingLabel: UILabel = {
        let label = UILabel()
        
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        
        return label
    }()
    private lazy var switchView: UIImageView = {
        let imageView = UIImageView(image: OFF_IMAGE)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // MARK: - Instance variables
    var isSelected: Bool = false
    var isTitle: Bool = true
    var optionObject: Descriptor.OptionObject
    private weak var delegate: RoomPickerOptionViewDelegate?
    
    // MARK: - Initialization
    init(descriptor: Descriptor, delegate: RoomPickerOptionViewDelegate?) {
        self.delegate = delegate
        optionObject = descriptor.optionObject
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureStackView()
        setupOption(using: descriptor)
        updateSelection()
    }
    
    // MARK: - UI Methods
    private func configureStackView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        
        axis = .horizontal
        spacing = 20
        alignment = .center
        distribution = .fill
        
        clipsToBounds = true
        layer.masksToBounds = true
        
        addGestureRecognizer(gesture)
    }
    
    private func setupOption(using descriptor: Descriptor) {
        
        imageView.image = descriptor.leading
        var shouldConfigureLeading: Bool = false
        switch descriptor.trailing {
            case .title(let title): configureTitleLabel(title)
            case .accessory(let name):
                configureOptionLabel(name)
                shouldConfigureLeading = true
        }
        
        addArrangedSubview(trailingLabel)
        
        if shouldConfigureLeading {
            insertArrangedSubview(imageViewContainer, at: 0)
            addArrangedSubview(switchView)
            constraintImageview()
            constraintSwitchView()
        }
        
        addArrangedSubview(.init())
    }
    
    private func configureTitleLabel(_ title: String) {
        trailingLabel.text = title
        trailingLabel.font = .boldSystemFont(ofSize: 14)
        trailingLabel.textColor = ColorManager.darkestColor
    }
    
    private func configureOptionLabel(_ name: String) {
        isTitle = false
        
        trailingLabel.text = "\u{2003}\(name)\u{2003}"
        trailingLabel.font = .systemFont(ofSize: 16)
        trailingLabel.textColor = ColorManager.lighterColor
        
        trailingLabel.layer.cornerRadius = 6
        trailingLabel.layer.borderWidth = 1
        trailingLabel.layer.borderColor = ColorManager.lightestColor.cgColor
    }
    private func constraintImageview() {
        
        trailingLabel.heightAnchor.constraint(
            equalTo: imageViewContainer.heightAnchor,
            multiplier: 1.3
        ).isActive = true
        
        imageViewContainer.heightAnchor.constraint(
            equalToConstant: isTitle ? 54 : 44
        ).isActive = true
        
        let containerSpacing: CGFloat = 15
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(
                equalTo: imageViewContainer.leadingAnchor,
                constant: containerSpacing
            ),
            
            imageView.trailingAnchor.constraint(
                equalTo: imageViewContainer.trailingAnchor,
                constant: -containerSpacing
            ),
        
            imageView.topAnchor.constraint(
                equalTo: imageViewContainer.topAnchor,
                constant: containerSpacing
            ),
        
            imageView.bottomAnchor.constraint(
                equalTo: imageViewContainer.bottomAnchor,
                constant: -containerSpacing
            ),
        ])
        
    }
    private func constraintSwitchView() {
        switchView.widthAnchor.constraint(equalTo: switchView.heightAnchor).isActive = true
        switchView.heightAnchor.constraint(equalTo: trailingLabel.heightAnchor).isActive = true
    }
    
    // MARK: - Selection methods
    private func setDeselected() {
        UIView.animate(withDuration: 0.2) {
            
            self.imageViewContainer.backgroundColor = Colors.deselectedBackground
            self.imageViewContainer.layer.borderColor = Colors.deselectedBorder.cgColor
            self.imageView.image = self.isTitle ? self.imageView.image : nil
            if let image = self.imageView.image {
                self.imageView.image = image.withColor(Colors.deselectedImage)
            }
            
            self.trailingLabel.layer.borderColor = Colors.deselectedBorder.cgColor
            guard !self.isTitle else { return}
            self.trailingLabel.backgroundColor = Colors.deselectedBackground
            self.trailingLabel.textColor = Colors.deselectedImage
        }
        
    }
    
    private func setSelected() {
        UIView.animate(withDuration: 0.2) {
            
            self.imageViewContainer.backgroundColor = Colors.selectedBackground
            self.imageViewContainer.layer.borderColor = Colors.selectedBorder.cgColor
            self.imageView.image = self.isTitle ? self.imageView.image : UIImage(named: "check_shape")
            if let image = self.imageView.image {
                self.imageView.image = image.withColor(Colors.selectedImage)
            }
            
            self.trailingLabel.layer.borderColor = Colors.selectedBorder.cgColor
            guard !self.isTitle else { return}
            self.trailingLabel.textColor = Colors.selectedText
        }
    }
    
    func updateSelection() {
        if isSelected { setSelected() }
        else { setDeselected() }
    }
    
    func getAccessory() -> HMAccessory? {
        if case let Descriptor.OptionObject.accessory(accessory) = self.optionObject {
            return accessory
        }
        return nil
    }
    
    // MARK: - Callbacks
    @objc private func didTap(_ gesture: UITapGestureRecognizer) {
        delegate?.onViewTapped(self)
    }
    
    // MARK: - Unused
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

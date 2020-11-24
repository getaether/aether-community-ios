//
//  SceneMetadataPickerView.swift
//  Aether
//
//  Created by Bruno Pastre on 13/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

protocol MetadataPickerViewDelegate: AnyObject {
    func didChangeName(to newName: String?)
    func didChangeIcon(to newIcon: CustomRoom)
}

class MetadataPickerView: UIStackView, AECarouselDelegate {
    weak var delegate: MetadataPickerViewDelegate? {
        didSet {
            didSelectItem(newItem: iconPicker.getCurrentItem())
        }
    }
    
    private lazy var nameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "   Nome do cômodo"
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorManager.lightestColor.cgColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 58).isActive = true
        view.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        view.addTarget(self, action: #selector(textDidChange), for: .editingDidEnd)
        return view
    }()
    private lazy var iconPicker: AECarousel = {
        let view = AECarousel(
            title: NSLocalizedString(
                "Ícone da cena",
                comment: ""
            ),
            items: getSceneIcons()
        )
        view.delegate = self
        return view
    }()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
        spacing = 20
        
        addSubviews()
    }
    
    // MARK: - UIView lifecycle
    func addSubviews() {
        addArrangedSubview(nameTextField)
        addArrangedSubview(iconPicker)
    }
    
    // MARK: - AECarouselDelegate methods
    func didSelectItem(newItem: CustomRoom) {
        delegate?.didChangeIcon(to: newItem)
    }
    
    @objc private func textDidChange() {
        delegate?.didChangeName(to: nameTextField.text == "" ? nil : nameTextField.text )
    }
    
    // MARK: - Helpers
    private func getSceneIcons() -> [CustomRoom] {
        return [
            .init(nome: "Desligado", image: "bedroom"),
            .init(nome: "Ligado", image: "bedroomIcon"),
            .init(nome: "Desligado", image: "onboarding1"),
            .init(nome: "Ligado", image: "onboarding3"),
            .init(nome: "Desligado", image: "onboarding1"),
        ]
    }
    
    // MARK: - Unused
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("This class should only be used programatically")
    }
}

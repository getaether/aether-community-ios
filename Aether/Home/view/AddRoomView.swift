//
//  AddRoomView.swift
//  Aether
//
//  Created by Bruno Pastre on 22/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class AddRoomView: UIView, AnimateableBottomView {
    
    typealias strings = AEStrings.AddRoomViewController
    
    // MARK: - UIComponents
    private lazy var carousel: AECarousel = {
        let carousel = AECarousel(
            title:  strings.Carousel.title,
            items: dependencies.carouselItems
        )
        carousel.translatesAutoresizingMaskIntoConstraints = false
        return carousel
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.titleTextColor
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.bodyTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var roomNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = strings.TextField.roomName
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 1
        textField.layer.borderColor = ColorManager.lightColor.cgColor
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(strings.Button.save, for: .normal)
        button.addTarget(self, action: #selector(saveInfo), for: .touchDown)
        button.backgroundColor = ColorManager.highlightColor
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Dependencies
    struct Dependencies {
        let carouselItems: [CustomRoom]
        let carouselDelegate: AECarouselDelegate
        let saveCallback: () -> Void
        let title: String
    }
    private let dependencies: Dependencies
    
    // MARK: - Initialization
    init(dependencies: Dependencies){
        self.dependencies = dependencies
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
        configureAdditionalSettings()
        
        carousel.delegate = dependencies.carouselDelegate
        titleLabel.text = dependencies.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(separatorView)
        addSubview(roomNameTextField)
        addSubview(saveButton)
        addSubview(carousel)
    }
    private func constraintSubviews() {
        constraintTitleLabel()
        constraintSeparatorView()
        constraintRoomNameTextField()
        constraintSaveButton()
        constraintCarousel()
    }
    func configureAdditionalSettings() {
        backgroundColor = ColorManager.backgroundColor
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        isUserInteractionEnabled = true
    }
    
    // MARK: - Public API
    public func scrollCarousel(to index: Int) {
        carousel.scrollCollection(to: index)
    }
    
    
    // MARK: - Constraints
    private func constraintTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.065),
        ])
    }
    private func constraintSeparatorView() {
        NSLayoutConstraint.activate([
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    private func constraintRoomNameTextField() {
        NSLayoutConstraint.activate([
            roomNameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            roomNameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
            roomNameTextField.heightAnchor.constraint(equalToConstant: 70),
            roomNameTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 25)
        ])
    }
    
    private func constraintSaveButton() {
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70)
        ])
    }
    private func constraintCarousel() {
        NSLayoutConstraint.activate([
            carousel.centerXAnchor.constraint(equalTo: centerXAnchor),
            carousel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.92),
            carousel.topAnchor.constraint(equalTo: roomNameTextField.bottomAnchor, constant: 10),
            carousel.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10)
        ])
    }
    
    @objc func saveInfo() {
        dependencies.saveCallback()
    }
}

//
//  EditSceneView.swift
//  Aether
//
//  Created by Bruno Pastre on 24/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

final class EditSceneView:  UIView, AnimateableBottomView {
    
    typealias strings = AEStrings.EditSceneViewController
    
    // MARK: - UIComponents
    private lazy var carousel: AECarousel = {
        let carousel = AECarousel(
            title: strings.Carousel.title,
            customItemSelector: dependencies.carouselManager
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
    
    lazy var sceneNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = strings.TextField.placeholder
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 1
        textField.layer.borderColor = ColorManager.lightColor.cgColor
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(strings.Button.title, for: .normal)
        button.addTarget(self, action: #selector(onDeleteButton), for: .touchDown)
        button.setTitleColor(ColorManager.errorColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Dependencies
    struct Dependencies {
        let carouselManager: AECarouselCollectionViewManager
        let carouselDelegate: AECarouselDelegate
        let deleteCallback: () -> Void
        let title: String
        let sceneId: String
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
        if let scene = self.getScene() {
            sceneNameTextField.text = scene.name
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(separatorView)
        addSubview(sceneNameTextField)
        addSubview(deleteButton)
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
            sceneNameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            sceneNameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
            sceneNameTextField.heightAnchor.constraint(equalToConstant: 70),
            sceneNameTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 25)
        ])
    }
    
    private func constraintSaveButton() {
        NSLayoutConstraint.activate([
            deleteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            deleteButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            deleteButton.heightAnchor.constraint(equalToConstant: 60),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70)
        ])
    }
    private func constraintCarousel() {
        NSLayoutConstraint.activate([
            carousel.centerXAnchor.constraint(equalTo: centerXAnchor),
            carousel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.92),
            carousel.topAnchor.constraint(equalTo: sceneNameTextField.bottomAnchor, constant: 10),
            carousel.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -10)
        ])
    }
    // MARK: - Helpers
    // TODO REMOVE THIS, IT SHOULD NOT BE HERE
    func getScene() -> HMActionSet? {
        HomeKitFacade.shared.getScene(by: dependencies.sceneId)
    }
    
    // MARK: - Callbacks
    @objc func onDeleteButton() {
        dependencies.deleteCallback()
    }
}

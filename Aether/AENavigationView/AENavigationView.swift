//
//  AENavigationView.swift
//  Aether
//
//  Created by Gabriel Gazal on 13/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class AENavigationView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .bottom
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .top
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = ColorManager.lighterColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var trailingButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onTrailingButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var action: ((UIButton?) -> Void)?
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        constrainSubviews()
        configureAdditionalSettings()
    }
    
    
    // MARK: - Lifecycle
    private func addSubviews() {
        addSubview(containerStackView)
    }
    
    private func constrainSubviews() {
        constrainContainerView()
    }
    
    private func configureAdditionalSettings() {
        configureLayer()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureLayer()
    }
    
    
    private func constrainContainerView() {
        containerStackView.widthAnchor.constraint(
            equalTo: widthAnchor,
            multiplier: 0.9
        ).isActive = true
        containerStackView.centerXAnchor.constraint(
            equalTo: centerXAnchor
        ).isActive = true
        containerStackView.topAnchor.constraint(
            equalTo: safeAreaLayoutGuide.topAnchor,
            constant: 40
        ).isActive = true
        containerStackView.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: -20
        ).isActive = true
    }
    
    
    // MARK: -
    func configureLayer() {
        backgroundColor = ColorManager.backgroundColor
        layer.cornerRadius = 20
        layer.shadowColor = ColorManager.titleTextColor?.cgColor //nao ta funcionando a troca de cor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.14
        layer.shadowRadius = 6.0
        layer.masksToBounds = false
    }
    
    // MARK: - Public API
    func configureTitle(_ title: String) {
        titleLabel.text = title
        configureTitleLabel()
    }
    
    func configureDescription(_ description: String) {
        descriptionLabel.text = description
        configureDescriptionLabel()
    }
    
    func configureButton(_ image: UIImage, action: ((UIButton?) -> Void)?) {
        self.action = action
        trailingButton.setImage(image, for: .normal)
        configureTrailingButton()
    }
    
    func configureArrengedView(_ view: UIView) {
        containerStackView.addArrangedSubview(view)
    }
    
    // MARK: - Component configuration
    private func configureTitleLabel() {
        containerStackView.addArrangedSubview(titleLabel)
    }
    private func configureDescriptionLabel() {
        containerStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func configureTrailingButton(){
        containerStackView.addSubview(trailingButton)
        trailingButton.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor,constant: 0).isActive = true
        trailingButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        trailingButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        trailingButton.heightAnchor.constraint(equalTo: trailingButton.widthAnchor).isActive = true
    }
    
    // MARK: - Callbacks
    @objc private func onTrailingButton(_ button: UIButton?) {
        action?(button)
    }
    
    // MARK: - Unused
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AENavigationViewBuilder {
    
    private var view: AENavigationView = .init()
    
    func withTitle(_ title: String) -> AENavigationViewBuilder {
        view.configureTitle(title)
        view.layoutIfNeeded()
        return self
    }
    
    func withDescription(_ description: String) -> AENavigationViewBuilder {
        view.configureDescription(description)
        view.layoutIfNeeded()
        return self
    }
    
    func withButton(_ image: UIImage, action: ((UIButton?) -> Void)?) -> AENavigationViewBuilder {
        view.configureButton(image, action: action)
        view.layoutIfNeeded()
        return self
    }
    
    func withArrengedView(_ view: UIView) -> AENavigationViewBuilder {
        self.view.configureArrengedView(view)
        view.layoutIfNeeded()
        return self
    }
    
    func build() -> AENavigationView { view }
}


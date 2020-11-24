//
//  AEAddActionMenu.swift
//  Aether
//
//  Created by Gabriel Gazal on 17/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class AEAddActionMenu: UIView {
    typealias strings = AEStrings.AddActionMenu
    
    //MARK: - UI Components
    private lazy var fadeView: UIView = {
        let view = UIView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissTap))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.05882352941, alpha: 0.5).withAlphaComponent(0)
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThinMaterialDark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.alpha = 0.8
        return view
    }()
    
    private lazy var contextView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 13
        return view
    }()
    
    private lazy var stackButton: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.backgroundColor = ColorManager.lighterColor
        stack.spacing = 1
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution  = UIStackView.Distribution.fillEqually
        return stack
    }()
    
    private lazy var viewSup: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var viewInf: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var accessoryIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named:"lampIcon")?.withTintColor(ColorManager.titleTextColor!)
        return view
    }()
    
    private lazy var roomIcon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named:"roomIcon")?.withTintColor(ColorManager.titleTextColor!)
        return view
    }()
    
    private lazy var newRoomButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorManager.backgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(handleAddRoomOptionTap),
            for: .touchDown
        )
        button.setTitle(
            strings.Label.newRoom,
            for: .normal
        )
        button.setTitleColor(ColorManager.titleTextColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var newAccessoryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorManager.backgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAddAccessoryOptionTap), for: .touchDown)
        button.setTitle(strings.Label.newLamp, for: .normal)
        button.setTitleColor(ColorManager.titleTextColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    //MARK: - Dependencies
    
    struct Actions {
        let dismiss: () -> Void
        let addRoom: () -> Void
        let addAccessory: () -> Void
    }
    
    private var actions: Actions?
    private var contextViewHeightConstrain: NSLayoutConstraint?
    private var contextViewZeroConstrain: NSLayoutConstraint?

    //MARK: - Initializion
    
    init(
        actions: Actions? = nil
    ) {
        self.actions = actions
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        constrainSubviews()
        configureAdditionalSettings()
    }
    
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public API
    public func configureContextView(on parentView: UIView) {
        constrainContextView(parentView: parentView)
        openContextMenu()
    }
    
    //MARK: - View Code Setup
    private func addSubviews() {
        addSubview(fadeView)
        fadeView.addSubview(blurEffectView)
        fadeView.addSubview(contextView)
        contextView.addSubview(stackButton)
        stackButton.addArrangedSubview(viewSup)
        stackButton.addArrangedSubview(viewInf)
        viewSup.addSubview(newAccessoryButton)
        viewSup.addSubview(accessoryIcon)
        viewInf.addSubview(newRoomButton)
        viewInf.addSubview(roomIcon)
    }
    private func constrainSubviews() {
        constrainFadeview()
        constrainStackButton()
        constrainStackSubviews()
        constrainAccessoryButton()
        constrainRoomButton()
        constrainAccessoryIcon()
        constrainRoomIcon()
    }
    private func configureAdditionalSettings() {
        contextViewHeightConstrain = contextView.heightAnchor.constraint(equalTo: fadeView.heightAnchor, multiplier: 0.135)
        contextViewZeroConstrain = contextView.heightAnchor.constraint(equalToConstant: 0.0)
    }
    func openContextMenu() {
        UIView.animate(withDuration: 0.2) {
            self.contextViewHeightConstrain?.isActive = true
            self.contextViewZeroConstrain?.isActive = false
            self.contextView.layoutIfNeeded()
        }
    }
    
    override func removeFromSuperview() {
        self.contextViewHeightConstrain?.isActive = false
        self.contextViewZeroConstrain?.isActive = true
        self.layoutIfNeeded()
        super.removeFromSuperview()
    }
    
    //MARK: - Constrains Setup
    private func constrainFadeview() {
        NSLayoutConstraint.activate([
            fadeView.topAnchor.constraint(equalTo: topAnchor),
            fadeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            fadeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fadeView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    private func constrainContextView(parentView: UIView) {
        contextView.widthAnchor.constraint(
            equalTo: fadeView.widthAnchor,
            multiplier: 0.6
        ).isActive = true
        contextView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        contextViewZeroConstrain?.isActive = true
        contextView.topAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 20).isActive = true
    }
    private func constrainStackButton() {
        stackButton.widthAnchor.constraint(equalTo: contextView.widthAnchor, multiplier: 1).isActive = true
        stackButton.heightAnchor.constraint(equalTo: contextView.heightAnchor, multiplier: 1).isActive = true
        stackButton.centerYAnchor.constraint(equalTo: contextView.centerYAnchor, constant: 0).isActive = true
        stackButton.centerXAnchor.constraint(equalTo: contextView.centerXAnchor, constant: 0).isActive = true
    }
    
    private func constrainStackSubviews() {
        viewSup.widthAnchor.constraint(equalTo: stackButton.widthAnchor, multiplier: 1).isActive = true
        viewSup.topAnchor.constraint(equalTo: stackButton.topAnchor).isActive = true
        viewInf.widthAnchor.constraint(equalTo: stackButton.widthAnchor, multiplier: 1).isActive = true
        viewInf.bottomAnchor.constraint(equalTo: stackButton.bottomAnchor).isActive = true
        viewSup.heightAnchor.constraint(equalTo: viewInf.heightAnchor).isActive = true
    }
    
    private func constrainAccessoryButton() {
        newAccessoryButton.widthAnchor.constraint(equalTo: viewSup.widthAnchor, multiplier: 1).isActive = true
        newAccessoryButton.heightAnchor.constraint(equalTo: viewSup.heightAnchor, multiplier: 1).isActive = true
        newAccessoryButton.centerYAnchor.constraint(equalTo: viewSup.centerYAnchor).isActive = true
        newAccessoryButton.centerXAnchor.constraint(equalTo: viewSup.centerXAnchor).isActive = true
    }
    
    private func constrainRoomButton() {
        newRoomButton.widthAnchor.constraint(equalTo: viewInf.widthAnchor, multiplier: 1).isActive = true
        newRoomButton.heightAnchor.constraint(equalTo: viewInf.heightAnchor, multiplier: 1).isActive = true
        newRoomButton.centerYAnchor.constraint(equalTo: viewInf.centerYAnchor).isActive = true
        newRoomButton.centerXAnchor.constraint(equalTo: viewInf.centerXAnchor).isActive = true
    }
    
    private func constrainAccessoryIcon() {
        accessoryIcon.heightAnchor.constraint(equalTo: viewSup.heightAnchor, multiplier: 0.45).isActive = true
        accessoryIcon.widthAnchor.constraint(equalTo: accessoryIcon.heightAnchor, multiplier: 1).isActive = true
        accessoryIcon.centerYAnchor.constraint(equalTo: viewSup.centerYAnchor).isActive = true
        accessoryIcon.rightAnchor.constraint(equalTo: viewSup.rightAnchor,constant: -20).isActive = true
    }
    
    private func constrainRoomIcon() {
        roomIcon.heightAnchor.constraint(equalTo: viewInf.heightAnchor, multiplier: 0.45).isActive = true
        roomIcon.widthAnchor.constraint(equalTo: roomIcon.heightAnchor, multiplier: 1).isActive = true
        roomIcon.centerYAnchor.constraint(equalTo: viewInf.centerYAnchor).isActive = true
        roomIcon.rightAnchor.constraint(equalTo: viewInf.rightAnchor,constant: -20).isActive = true
    }
    
    
    //MARK: - Actions
    
    @objc func handleDismissTap()
    { actions?.dismiss() }
    
    @objc func handleAddRoomOptionTap()
    { actions?.addRoom() }
    
    @objc func handleAddAccessoryOptionTap()
    { actions?.addAccessory() }
}

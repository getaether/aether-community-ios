//
//  EditAccessoryBottomView.swift
//  Aether
//
//  Created by Bruno Pastre on 21/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class EditAccessoryBottomView: UIView, AnimateableBottomView {
    typealias strings = AEStrings.EditAccessoryViewController
    
    // MARK: - UIComponents
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
        view.backgroundColor = ColorManager.darkColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.alternateBackgroundColor
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 1, height: 3)
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.backgroundColor = .clear
        nameTextField.font = UIFont.boldSystemFont(ofSize: 18)
        return nameTextField
    }()
    
    private lazy var editNameButton: UIButton = {
        let editButton = UIButton()
        editButton.setImage(
            UIImage(named: "edit"),
            for: .normal
        )
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(
            self,
            action: #selector(self.startEditing),
            for: .touchUpInside
        )
        return editButton
    }()
    private lazy var roomContainerView: UIView = {
        let viewSup = UIView()
        viewSup.backgroundColor = ColorManager.alternateBackgroundColor
        viewSup.clipsToBounds = true
        viewSup.layer.masksToBounds = false
        viewSup.layer.cornerRadius = 10
        viewSup.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewSup.layer.shadowRadius = 5
        viewSup.layer.shadowOffset = CGSize(width: 1, height: 3)
        viewSup.layer.shadowOpacity = 0.1
        viewSup.translatesAutoresizingMaskIntoConstraints = false
        return viewSup
    }()
    private lazy var roomLabel: UILabel = {
        let roomLabel = UILabel()
        roomLabel.text = strings.Label.room
        roomLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        roomLabel.translatesAutoresizingMaskIntoConstraints = false
        return roomLabel
    }()
    private lazy var comodoLabel: UILabel = {
        let comodoLabel = UILabel()
        comodoLabel.font = UIFont.systemFont(ofSize: 18.0)
        comodoLabel.textAlignment = .right
        comodoLabel.translatesAutoresizingMaskIntoConstraints = false
        return comodoLabel
    }()
    private lazy var roomPicker: UIPickerView = {
        let roomPicker = UIPickerView()
        roomPicker.translatesAutoresizingMaskIntoConstraints = false
        return roomPicker
    }()
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.backgroundColor = .clear
        deleteButton.setTitle(strings.Button.delete, for: .normal)
        deleteButton.setTitleColor(#colorLiteral(red: 0.9215686275, green: 0.3411764706, blue: 0.3411764706, alpha: 1), for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        deleteButton.addTarget(self, action: #selector(self.deleteAccessory), for: .touchDown)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        return deleteButton
    }()
    
    // MARK: - Dependencies
    private let dependencies: Dependencies
    struct Dependencies {
        let startEditing: () -> Void
        let deleteAccessory: () -> Void
        let accessoryName: String
        let pickerDataSource: UIPickerViewDataSource
        let pickerDelegate: UIPickerViewDelegate
    }
    
    // MARK: - Initialization
    init(using dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
        configureAdditionalSettings()
        titleLabel.text = dependencies.accessoryName
        nameTextField.text = dependencies.accessoryName
        roomPicker.delegate = dependencies.pickerDelegate
        roomPicker.dataSource = dependencies.pickerDataSource
    }
    
    // MARK: - UIView lifecycle
    private func addSubviews() {
        
        addSubview(titleLabel)
        addSubview(separatorView)
        addSubview(nameContainerView)
        nameContainerView.addSubview(nameTextField)
        nameContainerView.addSubview(editNameButton)
        addSubview(roomContainerView)
        roomContainerView.addSubview(roomLabel)
        roomContainerView.addSubview(comodoLabel)
        roomContainerView.addSubview(roomPicker)
        addSubview(deleteButton)
    }
    private func constraintSubviews() {

        constraintTitleLabel()
        constraintSeparatorView()
        constraintFieldView()
        constraintNameTextField()
        constraintEditNameButton()
        constraintRoomContainerView()
        constraintRoomLabel()
        constraintComodoLabel()
        constraintRoomPicker()
        constraintDeleteButton()
    }
    private func configureAdditionalSettings() {
        backgroundColor = ColorManager.backgroundColor
        layer.cornerRadius = 10
        isUserInteractionEnabled = true
    }
    
    // MARK: - Constraint subviews
    private func constraintTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
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
    private func constraintFieldView() {
        NSLayoutConstraint.activate([
            nameContainerView.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: 0.85
            ),
            nameContainerView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            nameContainerView.topAnchor.constraint(
                equalTo: separatorView.bottomAnchor,
                constant: 30
            ),
            nameContainerView.heightAnchor.constraint(
                equalTo: heightAnchor,
                multiplier: 0.15
            ),
        ])
    }
    private func constraintNameTextField() {
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(
                equalTo: nameContainerView.centerXAnchor
            ),
            nameTextField.centerYAnchor.constraint(
                equalTo: nameContainerView.centerYAnchor
            ),
            nameTextField.widthAnchor.constraint(
                equalTo: nameContainerView.widthAnchor,
                constant: -60
            ),
            nameTextField.heightAnchor.constraint(
                equalTo: nameContainerView.heightAnchor,
                multiplier: 1
            ),
        ])
    }
    private func constraintEditNameButton() {
        NSLayoutConstraint.activate([
            editNameButton.heightAnchor.constraint(
                equalTo: nameContainerView.heightAnchor
            ),
            editNameButton.widthAnchor.constraint(
                equalTo: editNameButton.heightAnchor
            ),
            editNameButton.centerYAnchor.constraint(
                equalTo: nameContainerView.centerYAnchor
            ),
            editNameButton.rightAnchor.constraint(
                equalTo: nameContainerView.rightAnchor
            ),
        ])
    }
    private func constraintRoomContainerView() {
        NSLayoutConstraint.activate([
            roomContainerView.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: 0.85
            ),
            roomContainerView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            roomContainerView.heightAnchor.constraint(
                equalTo: nameContainerView.heightAnchor
            ),
            roomContainerView.topAnchor.constraint(
                equalTo: nameContainerView.bottomAnchor,
                constant: 30
            ),
        ])
    }
    private func constraintRoomLabel() {
        NSLayoutConstraint.activate([
            roomLabel.centerYAnchor.constraint(
                equalTo: roomContainerView.centerYAnchor
            ),
            roomLabel.heightAnchor.constraint(
                equalTo: roomContainerView.heightAnchor,
                multiplier: 0.8
            ),
            roomLabel.leftAnchor.constraint(
                equalTo: roomContainerView.leftAnchor,
                constant: 30
            ),
            roomLabel.rightAnchor.constraint(
                equalTo: comodoLabel.leftAnchor,
                constant: 10
            ),
        ])
    }
    private func constraintComodoLabel() {
        NSLayoutConstraint.activate([
            comodoLabel.centerYAnchor.constraint(
                equalTo: roomContainerView.centerYAnchor
            ),
            comodoLabel.heightAnchor.constraint(
                equalTo: roomContainerView.heightAnchor,
                multiplier: 0.8
            ),
            comodoLabel.rightAnchor.constraint(
                equalTo: roomContainerView.rightAnchor,
                constant: -30
            ),
            comodoLabel.widthAnchor.constraint(
                equalTo: roomContainerView.widthAnchor,
                multiplier: 0.5
            ),
        ])
    }
    private func constraintRoomPicker() {
        NSLayoutConstraint.activate([
            roomPicker.centerYAnchor.constraint(
                equalTo: roomContainerView.centerYAnchor
            ),
            roomPicker.heightAnchor.constraint(
                equalTo: roomContainerView.heightAnchor,
                multiplier: 0.8
            ),
            roomPicker.rightAnchor.constraint(
                equalTo: roomContainerView.rightAnchor,
                constant: -30),
            roomPicker.widthAnchor.constraint(
                equalTo: roomContainerView.widthAnchor,
                multiplier: 0.5
            ),
        ])
    }
    private func constraintDeleteButton() {
        NSLayoutConstraint.activate([
            deleteButton.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            deleteButton.widthAnchor.constraint(
                equalTo: nameContainerView.widthAnchor
            ),
            deleteButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -40
            ),
            deleteButton.topAnchor.constraint(
                equalTo: roomContainerView.bottomAnchor,
                constant: 20
            )
        ])
    }
    
    // MARK: - Callbacks
    @objc private func startEditing()
    { dependencies.startEditing() }
    
    @objc private func deleteAccessory()
    { dependencies.deleteAccessory() }
    
    
    
    // MARK: - Unused
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  EditAccessoryViewController.swift
//  Aether
//
//  Created by Gabriel Gazal on 14/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

protocol OnDoneEditingAccessoryProtocol {
    func onDoneEditingAccessory()
}

class EditAccessoryViewController: DraggableModalViewController, UITextFieldDelegate, RoomPickerManagerDelegate {

    typealias strings = AEStrings.EditAccessoryViewController
    
    // MARK: - Properties
    private let homekitGroup: DispatchGroup = .init()
    private let queue = DispatchQueue.global(qos: .userInteractive)
    
    private lazy var roomPickerManager = RoomPickerManager(delegate: self)
    
    // MARK: - View
    private lazy var editAccessoryView: EditAccessoryBottomView = {
        let dependencies: EditAccessoryBottomView.Dependencies = .init(
            startEditing: startEditing,
            deleteAccessory: deleteAccessory,
            accessoryName: accessory.name,
            pickerDataSource: roomPickerManager,
            pickerDelegate: roomPickerManager
        )
        let view = EditAccessoryBottomView(using: dependencies)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var bottomView: AnimateableBottomView { editAccessoryView }
    
    // MARK: - Dependencies
    var accessory: HMAccessory!
    var selectedRoom: HMRoom?
    
    weak var delegate: SaveEditedDelegate?
    
    
    override func viewWillAppear(_ animated: Bool)
    { editAccessoryView.forceOut() }
    
    override func viewDidAppear(_ animated: Bool)
    { editAccessoryView.animateIn() }
    
    //MARK: Setup methods
    override func setupBottomView() {
        view.addSubview(editAccessoryView)
        NSLayoutConstraint.activate([
            editAccessoryView.centerXAnchor.constraint(
                equalTo: blurView.centerXAnchor
            ),
            editAccessoryView.widthAnchor.constraint(
                equalTo: blurView.widthAnchor
            ),
            editAccessoryView.bottomAnchor.constraint(
                equalTo: blurView.bottomAnchor,
                constant: 30
            ),
            editAccessoryView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.5
            ),
        ])
    }
    func setUpDeleteAlertController(accessory: HMAccessory){
        let name = accessory.name
        let alert = UIAlertController(
            title: "\(AEStrings.Alert.Delete.title) \(name)?",
            message: "\(AEStrings.Alert.Delete.message) \(name)",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: AEStrings.Alert.Action.yes,
                style: .destructive,
                handler: {action in
                    
            HomeKitFacade
                .shared
                .removeAccessory(accessory) { (error) in
                if let error = error {
                    return
                }
                self.dismissViewController()
            }
        }))
        alert.addAction(
            UIAlertAction(
                title: AEStrings.Alert.Action.no,
                style: .cancel,
                handler: nil
        ))
        
        self.present(alert, animated: true)
    }

    // MARK: - TextView delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - RoomPickerManagerDelegate
    func didSelectRoom(_ room: HMRoom?)
    { selectedRoom = room }

    
    // MARK: - Callbacks
    override func dismissViewController() {
        var errorToReturn: Error?
        if let name = editAccessoryView.nameTextField.text {
            queue.async(group: homekitGroup) {
                self.accessory.updateName(name) { (error) in
                    if let error = error{
                        errorToReturn = error
                    }
                }
            }
        }
        if let newRoom = selectedRoom {
            HomeKitFacade.shared.changeAccessoryRoom(
                accessory: self.accessory,
                newRoom: newRoom) {(error) in
                if let error = error {
                    errorToReturn = error
                }
            }
        }
        homekitGroup.notify(queue: .main) {
            self.delegate?.onDoneEditing(error: nil)
            super.dismissViewController()
        }
    }
    
    // MARK: - TextView Delegate
    @objc func startEditing(){
        print("edit")
        editAccessoryView.nameTextField.isUserInteractionEnabled = true
        editAccessoryView.nameTextField.becomeFirstResponder()
    }
    
    @objc func deleteAccessory(){
        print("apaga")
        setUpDeleteAlertController(accessory: accessory)
    }
}

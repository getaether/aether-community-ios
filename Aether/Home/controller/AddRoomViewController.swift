//
//  EditAccessoryViewController.swift
//  Aether
//
//  Created by Gabriel Gazal on 21/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit


protocol SaveEditedDelegate: AnyObject {
    func onDoneEditing(error: Error?)
}
class AddRoomViewController: DraggableModalViewController, AECarouselDelegate {
    
    // MARK: - Properties
    private var currentSelectedItem: CustomRoom?
    private let strings = AEStrings.AddRoomViewController.self
    private let availableIcons = AECustomIconManager.instance.availableIcons()
    weak var delegate: SaveEditedDelegate?
    
    // MARK: - UI Components
    private lazy var addRoomView: AddRoomView = .init(
        dependencies: .init(
            carouselItems: availableIcons,
            carouselDelegate: self,
            saveCallback: onSave,
            title: dependencies.title
        )
    )
    override var bottomView: AnimateableBottomView { addRoomView }
    
    // MARK: - Dependencies
    private let dependencies: Dependencies
    struct Dependencies {
        let title: String
        let room: HMRoom?
    }
    
    // MARK: - Initializing
    init(using dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup methods
    override func setupBottomView() {
        self.view.addSubview(addRoomView)
        NSLayoutConstraint.activate([
            addRoomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: 30),
            addRoomView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            addRoomView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addRoomView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let room = dependencies.room
        { configureEditMode(using: room) }
    }
    
    private func configureEditMode(using room: HMRoom) {
        let roomName = room.name
        addRoomView.roomNameTextField.text = roomName
        if let roomIcon = customIconManager.getIcon(for: room),
           let index = customIconManager.availableIcons().firstIndex(where: { $0.image == roomIcon.image })
        {
            addRoomView.scrollCarousel(to: index)
        }
    }
    
    // MARK: - CustomIconSelectorDelegate
    func didSelectItem(newItem: CustomRoom)
    { currentSelectedItem = newItem }
    
    // MARK: - Helpers
    private func onSave() {
        guard let item = currentSelectedItem,
              let name = addRoomView.roomNameTextField.text
        else { return }
        
        if let room = dependencies.room
        { updateRoomAndDismiss(
            room,
            name: name,
            item: item)
            
        } else { createNewRoomAndDismiss(
            name: name,
            item: item)
        }
    }
    
    private let customIconManager = AECustomIconManager.instance
    
    private func updateRoomAndDismiss(_ room: HMRoom, name: String, item: CustomRoom) {
        let completion: (Error?) -> Void = {
            self.delegate?.onDoneEditing(error: $0)
            self.dismissViewController()
        }
        if let cachedItem = customIconManager.getIcon(for: room),
           cachedItem.image != item.image {
            RoomImageBinder.remove(for: room.uniqueIdentifier.uuidString)
        }
        RoomImageBinder.bind(
            name: room.name,
            imageName: item.image,
            to: room.uniqueIdentifier.uuidString
        )
        
        
        if name != room.name {
            room.updateName(name)
                { error in completion(error) }
        }
        else { completion(nil) }
    }
    
    private func createNewRoomAndDismiss(name: String, item: CustomRoom) {
        HomeKitFacade.shared.addRoom(
            name: name) { (room, error) in
            guard let room = room
            else {
                self.delegate?.onDoneEditing(error: error)
                return
            }
            
            RoomImageBinder.bind(
                name: item.image,
                imageName: item.image,
                to: room.uniqueIdentifier.uuidString
            )
            self.delegate?.onDoneEditing(error: nil)
            super.dismissViewController()
        }
    }
}

//
//  HomeViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 30/07/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit
import HomeKit


class HomeViewController: AccessorySearchingViewController, HomeKitEventListener, AEFilterProvider, AEFilterDelegate, SaveEditedDelegate, CustomIconSelectorDelegate {
   
    typealias strings = AEStrings.HomeViewController
    
    // MARK: - Properties
    private let homekitFacade: HomeKitFacade = HomeKitFacade.shared
    private let roomSelector: CustomIconSelector = .init(itens: AECustomIconManager.instance.convertHomekitToCustomRoom())
    private lazy var accessoryManager: AccessoryCollectionViewManager = .init(filterProvider: self)
    private var currentFilter: AESegmentedOptions = .Todos
    
    // MARK: - UIComponents
    private lazy var addOptionView = AEAddActionMenu(
        actions: .init(
            dismiss: {
                self.hideAddView()
            },
            addRoom: {
                self.addRoom()
            },
            addAccessory: {
                self.addAccessory()
            }
        )
    )
    private lazy var homeView: HomeView = {
        let view = HomeView(
            onAddCallback: onAddButton,
            roomsManager: roomSelector,
            accessoryManager: accessoryManager
        )
        return view
    }()
    
    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
        roomSelector.delegate = self
    }
    
    //MARK: - UIViewController lifecycle
    override func loadView() { view = homeView }
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(
            true,
            animated: true
        )
        self.homekitFacade.registerListener(self)
        setupNotifications()
        self.updateFilters()
    }
    override func viewDidAppear(_ animated: Bool)
    { updateCollectionViews() }

    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: nil
        ) { _ in self.updateCollectionViews() }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onMenuTriggered(_:)),
            name: AECollectionViewCell.EDIT_NOTIFICATION,
            object: nil
        )
    }
    // MARK: - Setup methods
    func setUpDeleteAlertController(accessory: HMAccessory) {
        let name = accessory.name
        let alert = UIAlertController(
            title: "\(AEStrings.Alert.Delete.title) \(name)",
            message: "\(AEStrings.Alert.Delete.message) \(name) ?",
            preferredStyle: .alert
        )
        alert.addAction(  UIAlertAction(
            title: AEStrings.Alert.Action.yes,
            style: .destructive,
            handler: { action in
                self.homekitFacade.removeAccessory(accessory) { (error) in
                    if let error = error {
                        return
                    }
                    self.updateCollectionViews()
                    self.onDoneEditing(error: nil)
        }}))
        
        alert.addAction(
            UIAlertAction(
                title: AEStrings.Alert.Action.no,
                style: .cancel,
                handler: nil
        ))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Helpers
    func updateFilters() {
        UIView.animate(withDuration: 0.5) {
            self.updateCollectionViews()
            self.view.layoutIfNeeded()
        }
    }
    
    func updateCollectionViews() {
        homeView.reloadData()
        homeView.updateEmptyView()
    }
    
    // MARK: - Event listener
    func homeDidChange() {
        DispatchQueue.main.async {
            self.updateCollectionViews()
        }
    }
    func accessoryDidChange(_ notification: NSNotification) {
        guard
            let accessories = accessoryManager.getAccessories(),
            let payload = notification.userInfo,
            let accessory = payload["accessory"] as? HMAccessory,
            let index = accessories.firstIndex(of: accessory),
            let char = payload["characteristic"] as? HMCharacteristic,
            let newValue = char.value as? Bool
        else { return }
        let indexPath = IndexPath(item: index, section: 0)
        homeView.toggleCellIfNeeded(newValue, at: indexPath)
    }
    
    // MARK: - CustomIconSelectorDelegate
    func didSelectItem(newItem: CustomRoom) {
        updateCollectionViews()
        self.currentFilter = newItem.isHome() ? .Todos : .Cômodos
        if let room = newItem.hkroom { didChangeFilter(to: room) }
    }
    
    // MARK: - SaveEditedDelegate
    func onDoneEditing(error: Error?) {
        updateCollectionViews()
        if let error = error {
            presentAlertController(withError: error.localizedDescription)
        }
    }
    
    // MARK: - AccessorySearchingViewController
    override func onNewAccessory() { updateCollectionViews() }
    
    //MARK: - AEFilterDelegate
    func didChangeFilter(to room: HMRoom) {
        self.accessoryManager.room = room
        self.updateCollectionViews()
    }
    
    // MARK: - AEMenuViewPresenter
    @objc func onMenuTriggered(_ notification: NSNotification) {
        guard let view = notification.userInfo?["view"],
              let presenter = view as? AEMenuPresenter,
              let object = presenter.getMenuObject()
        else { return }
        if let accessory = object as? HMAccessory
        { presentEditAccessoryViewController(accessory: accessory) }
        
        if let room = object as? HMRoom
        { presentEditRoomViewController(room: room) }
    }
    
    // MARK: - Filter wrapper
    func getCurrentFilter() -> AESegmentedOptions { self.currentFilter }
    func isFilterOpened() -> Bool { self.currentFilter != .Cômodos }
    
    // MARK: - Helpers
    
    private func presentEditRoomViewController(room: HMRoom) {
        presentNewRoomModal(
            dependencies: .init(
                title: AEStrings.AddRoomViewController.Label.editRoom,
                room: room
            )
        )
    }
    
    func presentEditAccessoryViewController(accessory: HMAccessory) {
        let vc = EditAccessoryViewController()
        vc.accessory = accessory
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc,  animated: false, completion: nil)
    }
    
    func presentNewRoomModal(
        dependencies: AddRoomViewController.Dependencies = .init(
            title: AEStrings.AddRoomViewController.Label.newRoom,
            room: nil
        )) {
        let vc = AddRoomViewController(using: dependencies)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc,  animated: true, completion: nil)
    }
    
    private func presentAlertController(withError error: String) {
        let title = AEStrings.Alert.Scene.alertTitle
        let message  = error
        let alert = UIAlertController(
            title: title,
            message: error,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: AEStrings.Alert.Scene.confirmation, style: .cancel)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    // MARK: -  Add view managing
    
    private func presentAddView(_ button: UIButton) {
        guard addOptionView.superview == nil
        else { return }
        view.addSubview(addOptionView)
        NSLayoutConstraint.activate([
            addOptionView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            addOptionView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            addOptionView.widthAnchor.constraint(
                equalTo: view.widthAnchor
            ),
            addOptionView.heightAnchor.constraint(
                equalTo: view.heightAnchor
            ),
        ])
        addOptionView.configureContextView(on: button)
    }
    
    private func hideAddView() {
        addOptionView.removeFromSuperview()
    }
    
    // MARK: - Callbacks
    @objc func onAddButton(_ button: UIButton?) {
        guard let button = button
        else { return }
        presentAddView(button)
    }
    
    @objc func addAccessory() {
        hideAddView()
        super.presentLampOnboarding()
    }
    
    @objc func addRoom(){
        hideAddView()
        presentNewRoomModal()
    }
    
    // MARK: - Unused
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

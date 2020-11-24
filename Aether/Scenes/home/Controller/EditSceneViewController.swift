//
//  EditSceneViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 23/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

final class EditSceneViewController: DraggableModalViewController, AECarouselDelegate {
    
    // MARK: - Properties
    private var currentSelectedItem: CustomRoom?
    private let strings = AEStrings.AddRoomViewController.self
    private let availableIcons = SceneIconProvider.allIcons
    weak var delegate: SaveEditedDelegate?
    
    // MARK: - UI Components
    private lazy var editSceneView: EditSceneView = .init(
        dependencies: .init(
            carouselManager: SceneCarouselManager.init(itens: availableIcons),
            carouselDelegate: self,
            deleteCallback: onDelete,
            title: "Edit scene",
            sceneId: dependencies.sceneId
        )
    )
    override var bottomView: AnimateableBottomView { editSceneView }
    
    // MARK: - Dependencies
    private let dependencies: Dependencies
    struct Dependencies {
        let sceneId: String
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
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let sceneImage = SceneImageBinder.shared.getImage(for: dependencies.sceneId),
           let itemIndex = availableIcons.firstIndex(where: { $0.image == sceneImage.imageName }){
            editSceneView.scrollCarousel(to: itemIndex)
        }
    }
    
    //MARK: Setup methods
    override func setupBottomView() {
        self.view.addSubview(editSceneView)
        NSLayoutConstraint.activate([
            editSceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: 30),
            editSceneView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            editSceneView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            editSceneView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6)
        ])
    }
    
    // MARK: - CustomIconSelectorDelegate
    func didSelectItem(newItem: CustomRoom)
    { currentSelectedItem = newItem }
    
    override func dismissViewController() {
        save {
            self.delegate?.onDoneEditing(error: nil)
            super.dismissViewController()
        }
    }
    
    func save(completion: @escaping () -> Void) {
        guard let scene = editSceneView.getScene(),
              let item  = currentSelectedItem,
              let name  = editSceneView.sceneNameTextField.text
        else {
            completion()
            return
        }
        let binder = SceneImageBinder.shared
        binder.remove(sceneId: dependencies.sceneId)
        binder.bind(
            imageName: item.image,
            to: dependencies.sceneId
        )
        
        if name != scene.name {
            scene.updateName(name) { _ in  completion()  }
        }
        else { completion() }
    }
    
    // MARK: -  Helpers
    private func presentDeleteAlert() {
        guard let name = editSceneView.getScene()?.name
        else { return }
        let alert = UIAlertController(
            title: "\(AEStrings.Alert.Delete.title) \(name)",
            message: "\(AEStrings.Alert.Delete.message) \(name) ?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: AEStrings.Alert.Action.yes,
            style: .destructive,
            handler: { action in
                self.deleteAndDismiss()
        }))
        alert.addAction(
            UIAlertAction(
                title: AEStrings.Alert.Action.no,
                style: .cancel,
                handler: nil
        ))
        
        self.present(alert, animated: true)
    }
    
    private func deleteAndDismiss() {
        HomeKitFacade.shared.deleteScene(sceneId: dependencies.sceneId) {
            self.delegate?.onDoneEditing(error: $0)
            super.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Helperss
    private func onDelete() {
        presentDeleteAlert()
    }
}

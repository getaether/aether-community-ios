//
//  ScenesViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 18/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class ScenesViewController: UIViewController, ScenesCollectionViewManagerDelegate, SaveEditedDelegate {
    func onDoneEditing(error: Error?) {
        manager.updateScenes()
    }
    
    private let manager = ScenesCollectionViewManager()
    private lazy var scenesView = ScenesView(manager: manager,action: onAddTapped)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        manager.delegate = self
    }
    
    // MARK: - ViewController lifecycle
    override func loadView()
    { view = scenesView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onMenuTriggered(_:)),
            name: AECollectionViewCell.EDIT_NOTIFICATION,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager.updateScenes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.updateScenes()
    }
    // MARK: - ScenesCollectionViewManagerDelegate
    func reloadData()  {
        scenesView.reloadCollectionView()
    }
    
    // MARK: - Helpers
    
    private func presentEditSceneViewController(sceneId: String) {
        let viewController = EditSceneViewController(using: .init(sceneId: sceneId))
        viewController.delegate = self
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Callbacks
    private func onAddTapped(_ button: UIButton?) {
        let vc = UINavigationController(rootViewController: CreateSceneViewController())
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func onMenuTriggered(_ notification: NSNotification) {
        guard let view = notification.userInfo?["view"],
              let presenter = view as? AEMenuPresenter,
              let object = presenter.getMenuObject()
        else { return }
        if let sceneId = object as? String
        { presentEditSceneViewController(sceneId: sceneId) }
        
    }
    
    // MARK: - Unused
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

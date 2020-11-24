//
//  ScenesCollectionViewManager.swift
//  Aether
//
//  Created by Bruno Pastre on 19/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

struct SceneCollectionViewCellModel {
    let sceneName: String
    let sceneImageName: String
    let sceneId: String
    let isOn: Bool
}

protocol ScenesCollectionViewManagerDelegate: AnyObject {
    func reloadData()
    
}

class ScenesCollectionViewManager: NSObject, AECollectionViewManager, AESceneCollectionViewCellDelegate, HomeKitEventListener {
    func accessoryDidChange(_ notification: NSNotification) {
        updateScenes()
    }
    
    
    // MARK: - AESceneCollectionViewCellDelegate
    func onSwitchChange(_ cell: AESceneCollectionViewCell) {
        updateSceneInHomekit(
            sceneId: cell.sceneId,
            isOn: cell.isOn
        ) {
            self.updateScenes()
        }
    }
    
    static let CELL_ID = "ScenesCollectionViewManagerCellId"
    private let binder = SceneImageBinder.shared
    private let facade = HomeKitFacade.shared
    private var scenes: [SceneCollectionViewCellModel]?
    
    weak var delegate: ScenesCollectionViewManagerDelegate?
    
    override init() {
        super.init()
        updateScenes()
        facade.registerListener(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scenes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let scenes = scenes,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ScenesCollectionViewManager.CELL_ID,
                for: indexPath
              ) as? AESceneCollectionViewCell
        else { fatalError() }
        let model = scenes[indexPath.item]
        cell.configure(using: model)
        cell.delegate = self
        cell.setupLongPressIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width * 0.45, height: collectionView.bounds.width * 0.45 * 0.77)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AESceneCollectionViewCell,
              !cell.didRecognizeLongPress
        else { return }
        cell.animateSwitchToggle()
        onSwitchChange(cell)
    }
    
    // MARK: - HomeKitEventListener
    func homeDidChange() {
        updateScenes()
    }
    
    
    // MARK: - Helpers
    private func updateSceneInHomekit(sceneId: String, isOn: Bool, completion: @escaping () -> Void) {
        facade.updateScene(sceneId: sceneId, isOn: isOn, completion: completion)
    }
    func updateScenes() {
        scenes = facade.getScenes()?.map {
            let imageName = binder.getImage(for: $0.uniqueIdentifier.uuidString)?.imageName ?? ""
            return .init(
                sceneName: $0.name,
                sceneImageName: ($0.isOn() ? "" : "off_") + imageName,
                sceneId: $0.uniqueIdentifier.uuidString,
                isOn: $0.isOn()
            )
        }
        delegate?.reloadData()
    }
}

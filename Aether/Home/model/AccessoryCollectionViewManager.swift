//
//  AccessoryCollectionViewManager.swift
//  Aether
//
//  Created by Bruno Pastre on 03/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

protocol AEFilterProvider {
    func getCurrentFilter() -> AESegmentedOptions
}

typealias AECollectionViewManager = (UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout)


class AccessoryCollectionViewManager: NSObject, AECollectionViewManager {
    
    private let filterProvider: AEFilterProvider
    private let homekitFacade = HomeKitFacade.shared
    
    static let cellReuseId = "accessoryCell"
    
    public var room: HMRoom?
    
    init(filterProvider: AEFilterProvider) {
        self.filterProvider = filterProvider
        super.init()
    }
    
    func getAccessories() -> [HMAccessory]? { self.homekitFacade.getAccessories(self.filterProvider.getCurrentFilter(), room: self.room) }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int { self.getAccessories()?.count ?? 0 }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AccessoryCollectionViewManager.cellReuseId,
                for: indexPath) as? AEAccessoryCollectionViewCell,
              let accessories = self.getAccessories()
        else { return .init() }
        let accessory = accessories[indexPath.item]
        cell.accessory = accessory
        cell.configure()
        cell.setupLongPressIfNeeded()
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
        return cell
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let selectedLamp = self.getAccessories()?[indexPath.item],
              let cell = collectionView.cellForItem(at: indexPath) as? AEAccessoryCollectionViewCell,
              !cell.didRecognizeLongPress
        else { return }
        
        cell.startLoading()
        homekitFacade.toggleLight(selectedLamp) {
            Interaction.instance.buttonPressed(withSound: false)
            cell.configure()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.46
        let height = collectionView.frame.width * 140/178 * 0.6
        return CGSize(width: width, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat { 0 }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat { 45 }
    

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let width =  collectionView.frame.height * 0.3 * 140/178
        let cellSpace = width * 2
        let left = collectionView.frame.width - CGFloat(cellSpace +  30)
        return UIEdgeInsets.init(top: 20, left: 10, bottom: 45, right: 10)
    }
    
    func isEmpty() -> Bool { self.getAccessories()?.count == 0 }
    
}

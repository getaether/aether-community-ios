//
//  ComodoCollectionViewDataSource.swift
//  Aether
//
//  Created by Bruno Pastre on 03/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

protocol AEFilterDelegate {
    func didChangeFilter(to room: HMRoom)
}

private class RoomCollectionViewManager: NSObject, AECollectionViewManager {
    
    private let hkFacade = HomeKitFacade.shared
    static let CELL_ID = "ComodoCell"
    private var selectedRoom: Int = 0
    public var delegate: AEFilterDelegate?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int { self.hkFacade.getRooms()?.count ?? 0 }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                  withReuseIdentifier: RoomCollectionViewManager.CELL_ID,
                  for: indexPath
              ) as? RoomCollectionViewCell,
              let rooms = self.hkFacade.getRooms()
        else { return .init() }
        
        let room = rooms[indexPath.item]
        cell.nameLabel.text = room.name
        cell.room = room
        indexPath.item == self.selectedRoom ?
            cell.setSelected() : cell.setDeselected()
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        self.selectedRoom = indexPath.item
        Interaction.instance.buttonPressed(withSound: false)
        collectionView.reloadData()
        guard let room = self.getCurrentRoom()
        else { return }
        self.delegate?.didChangeFilter(to: room)
    }
    
    func getCurrentRoom() -> HMRoom? {
        if let rooms = self.hkFacade.getRooms(){
            return rooms[self.selectedRoom]
        }
        return nil
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let widht = UIScreen.main.bounds.width * 0.4
        return CGSize(width: widht, height: widht / 3)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        let spacing = (UIScreen.main.bounds.width - (2 * UIScreen.main.bounds.width * 0.4)) / 3
        return UIEdgeInsets(top: 4, left: spacing, bottom: 0, right: 0)
    }

    
    func resetSelection() {
        self.selectedRoom = 0
        guard let room = self.getCurrentRoom()
        else { return }
        self.delegate?.didChangeFilter(to: room)
    }
}


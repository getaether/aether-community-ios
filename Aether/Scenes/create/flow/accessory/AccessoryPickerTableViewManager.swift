//
//  File.swift
//  Aether
//
//  Created by Bruno Pastre on 11/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

class AccessoryPickerModel {
    internal init(accessory: HMAccessory, isOn: Bool) {
        self.accessory = accessory
        self.isOn = isOn
    }
    
    var accessory: HMAccessory
    var isOn: Bool
}

class AccessoryPickerTableViewManager: NSObject, UITableViewDelegate, UITableViewDataSource, AccessoryPickerTableViewCellDelegate {

    // MARK: - Properties
    private let facade = HomeKitFacade.shared
    private let CELL_IDENTIFIER = "AccessoryPickerTableViewCell"
    private var selectedAccessories: [AccessoryPickerModel] = []
    weak var delegate: AccessoryPickerViewDelegate?
    // MARK: - Utils
    func register(_ tableView: UITableView) {
        tableView.register(
            .init(nibName: "AccessoryPickerTableViewCell", bundle: nil),
            forCellReuseIdentifier: CELL_IDENTIFIER
        )
    }
    
    // MARK: - Tableview setup
    func numberOfSections(in tableView: UITableView) -> Int { getRooms()?.count ?? 0 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rooms = getRooms() else { return 0 }
        return rooms[section].accessories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let rooms = getRooms(),
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER) as? AccessoryPickerTableViewCell
        else { return .init() }
        
        let accessory = rooms[indexPath.section].accessories[indexPath.row]
        
        cell.configure(
            accessory: accessory,
            isSelected: selectedAccessories.map {$0.accessory} .contains(accessory)
        )
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let rooms = getRooms()
        else { return "" }
        return rooms[section].name
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let rooms = getRooms()
        else { return nil }
        
        let label = UILabel()
        
        label.text = rooms[section].name
        label.font = .systemFont(ofSize: 14, weight: .bold)
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 40 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 64 }
    
    func onCheckmarkTapped(_ cell: AccessoryPickerTableViewCell) {
        guard let accessory = cell.accessory else { return }
        if let toRemove = selectedAccessories.first(where: {$0.accessory == cell.accessory } ) {
            delegate?.removeAccessory(accessory: toRemove)
            selectedAccessories.removeAll(where:  { $0.accessory == accessory } )
        } else {
            let newAccessory = AccessoryPickerModel(accessory: accessory, isOn: cell.isOn)
            delegate?.addAccessory(accessory: newAccessory)
            selectedAccessories.append(newAccessory)
        }
    }
    
    func onSwitchTapped(_ cell: AccessoryPickerTableViewCell) {
        if let toUpdate = selectedAccessories.first(where: {$0.accessory == cell.accessory } )  {
            toUpdate.isOn = cell.isOn
            delegate?.updateAccessory(accessory: toUpdate)
        }
    }
    
    private func getRooms() -> [HMRoom]? {
        return facade.getRooms()?.filter { !$0.accessories.isEmpty }
    }
}

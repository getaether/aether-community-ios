//
//  RoomPickerView.swift
//  Aether
//
//  Created by Bruno Pastre on 06/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

protocol RoomPickerViewDelegate: AnyObject {
    func onRoomChanged(_ room: RoomPickerView)
}

class RoomPickerView: UIStackView, RoomPickerOptionViewDelegate {
    let room: HMRoom
    private weak var delegate: RoomPickerViewDelegate?
    
    // MARK: - Init
    init(
        room: HMRoom,
        delegate: RoomPickerViewDelegate
    ) {
        self.room = room
        self.delegate = delegate
        super.init(frame: .zero)
        configureStackView()
        buildRoom()
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func configureStackView() {
        axis = .vertical
        spacing = 10
        alignment = .fill
        distribution = .fillEqually
    }
    
    private func buildRoom() {
        let titleView = RoomPickerOptionView(
            descriptor: .init(
                leading: nil,
                trailing: .title(room.name),
                optionObject: .room(room)
            ),
            delegate: self
        )
        
        addArrangedSubview(titleView)
        room.accessories.forEach {
            let newView = RoomPickerOptionView(
                descriptor: .init(
                    leading: nil,
                    trailing: .accessory($0.name),
                    optionObject: .accessory($0)
                ),
                delegate: self
            )
            addArrangedSubview(newView)
        }
    }
    
    // MARK: - RoomPickerOptionViewDelegate methods
    func onViewTapped(_ view: RoomPickerOptionView) {
        view.isSelected.toggle()
        
        defer { delegate?.onRoomChanged(self) }
        
        if view.isTitle {
            
            optionViews().forEach {
                $0.isSelected = view.isSelected
            }
            
            optionViews().forEach {
                $0.updateSelection()
            }
            return
        }
        
        view.updateSelection()
        updateTitleIfNeeded()
    }
    
    private func updateTitleIfNeeded() {
        guard let view = optionViews().filter { $0.isTitle}.first
        else { return }
        
        view.isSelected = optionViews().filter { !$0.isTitle }.map { $0.isSelected }.allSatisfy { $0 }
        view.updateSelection()
        
    }
    
    
    // MARK: - Helpers
    
    func getEnabledAccessories() -> [HMAccessory] {
       arrangedSubviews.compactMap { $0 as? RoomPickerOptionView }.filter { $0.isSelected }.compactMap { $0.getAccessory() }
    }
    
    private func optionViews() -> [RoomPickerOptionView] {
        arrangedSubviews.compactMap { $0 as? RoomPickerOptionView }
    }
    
    // MARK: - Unused
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

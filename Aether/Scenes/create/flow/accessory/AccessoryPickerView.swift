//
//  AccessoryPickerView.swift
//  Aether
//
//  Created by Bruno Pastre on 06/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

protocol AccessoryPickerViewDelegate: AnyObject {
    func addAccessory(accessory: AccessoryPickerModel)
    func updateAccessory(accessory: AccessoryPickerModel)
    func removeAccessory(accessory: AccessoryPickerModel)
}

class AccessoryPickerView: UIView {
    weak var delegate: AccessoryPickerViewDelegate? {
        get { manager.delegate }
        set { manager.delegate = newValue }
    }
    
    private let manager: AccessoryPickerTableViewManager = .init()
    private lazy var tableView: UITableView = {
        let view = UITableView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        manager.register(view)
        view.delegate = manager
        view.dataSource = manager
        view.backgroundColor = .clear
        view.allowsSelection = false
        view.separatorStyle = .none
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
    }
    
    private func addSubviews() {
        addSubview(tableView)
    }
    
    private func constraintSubviews() {
        tableView.leadingAnchor.constraint(
            equalTo: leadingAnchor
        ).isActive = true
        tableView.trailingAnchor.constraint(
            equalTo: trailingAnchor
        ).isActive = true
        tableView.topAnchor.constraint(
            equalTo: topAnchor
        ).isActive = true
        tableView.bottomAnchor.constraint(
            equalTo: bottomAnchor
        ).isActive = true
        
        heightAnchor.constraint(
            equalToConstant: 600
        ).isActive = true
    }
    
    
    // MARK: - Unused
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIImage {
    func withColor(_ color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { (context) in
            color.setFill()
            draw(at: .zero)
            context.fill(.init(origin: .zero, size: size), blendMode: .sourceAtop)
        }
    }
}

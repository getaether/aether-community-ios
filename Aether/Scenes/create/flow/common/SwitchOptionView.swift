//
//  SwitchOptionView.swift
//  Aether
//
//  Created by Bruno Pastre on 28/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

protocol SwitchOptionViewDelegate: AnyObject {
    func onToggleChange(_ optionView: SwitchOptionView)
}

class SwitchOptionView: UIStackView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = ColorManager.lightColor
        label.font = label.font.withWeight(.regular).withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    lazy var trailingSwitch: UISwitch = {
        let toggle = UISwitch()

        toggle.onTintColor = ColorManager.highlightColor
        toggle.addTarget(self, action: #selector(toggleDidChange), for: .valueChanged)
        
        return toggle
    }()
    
    weak var delegate: SwitchOptionViewDelegate?
    
    init(title: String){
        super.init(frame: .zero)
        
        titleLabel.text = title
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(trailingSwitch)
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = ColorManager.lighterColor.cgColor
        
        layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        isLayoutMarginsRelativeArrangement = true
    }
    
    @objc private func toggleDidChange(_ toggle: UISwitch) {
        delegate?.onToggleChange(self)
    }
    
    func getTitle() -> String? { titleLabel.text }
    func isSwitchOn() -> Bool { self.trailingSwitch.isOn }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }
}

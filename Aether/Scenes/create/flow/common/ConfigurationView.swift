//
//  ConfigurationView.swift
//  Aether
//
//  Created by Bruno Pastre on 28/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class ConfigurationView: UIStackView {
    typealias Configuration = SceneAutomationFlowConfigurator.Configuration
    
    let optionView: UIView?
    let pickerView: UIView?
    let configuration: Configuration
    
    init(
        configuration: Configuration,
        optionView: UIView? = nil,
        pickerView: UIView? = nil,
        shouldHidePickerView: Bool = true
    ) {
        self.optionView = optionView
        self.pickerView = pickerView
        self.configuration = configuration
        super.init(frame: .zero)
        
        axis = .vertical
        alignment = .fill
        distribution = .equalSpacing
        spacing = 10
        
        if let view = optionView {
            addArrangedSubview(view)
        }
        
        if let view = pickerView {
            addArrangedSubview(view)
        }
        
        pickerView?.isHidden = shouldHidePickerView
    }
    
    private func togglePickerView() {
        pickerView?.isHidden.toggle()
    }
    
    func setPickerViewVisibility(to isHidden: Bool) {
        if isHidden {
            UIView.animate(withDuration: 3) {
                self.pickerView?.removeFromSuperview()
                self.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 3) {
                if let view = self.pickerView {
                    
                    self.addArrangedSubview(view)
                }
                self.layoutIfNeeded()
            }
        }
        
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

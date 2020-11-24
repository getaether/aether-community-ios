//
//  AetherSegmenterController.swift
//  Aether
//
//  Created by Bruno Pastre on 30/07/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

protocol AESegmentedDelegate {
    func onOptionChanged(to newOption: AESegmentedOptions)
}

enum AESegmentedOptions: String, CaseIterable {
    case Todos
    case Cômodos
    case Favoritos
}

class AESegmentedView: UIStackView {
    
    private var buttons = AESegmentedOptions.allCases
    private var currentSelectedOption: Int = 0
    private var animationDuration: TimeInterval = 0.2
    
    private var lineView: UIView!
    
    var delegate: AESegmentedDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupButtons()
        self.setupLine()
    }

    required init(coder: NSCoder) {
        super.init(coder:coder)
    }

    
    func onAppear() {
        
        self.moveLine(to: self.arrangedSubviews[self.currentSelectedOption] as! UIButton)
    }
    
    func setupButtons() {
        buttons.forEach { self.createButton($0.rawValue) }
        self.distribution = .equalSpacing
        self.updateButtonStates()
    }
    
    func setupLine() {
        
        self.lineView = UIView(frame: CGRect(x: self.frame.width / 2, y: 0, width: 10, height: 2))
        self.lineView.backgroundColor = ColorManager.titleTextColor
        lineView.layer.cornerRadius = 1
        
        self.addSubview(lineView)
        self.bringSubviewToFront(lineView)
        
        moveLine(to: self.arrangedSubviews[self.currentSelectedOption] as! UIButton)
    }
    
    func moveLine(to button: UIButton) {
        
        let y = button.titleLabel!.frame.maxY
        
        UIView.animate(withDuration: self.animationDuration) {
            self.lineView.frame = CGRect(x: button.frame.minX, y: y + 4, width: button.frame.width, height: 2)
        }
    }
    
    func createButton(_ name: String) {
        let button = UIButton()
        
        button.setTitle(name, for: .normal)
        button.addTarget(self, action: #selector(self.onOptionPicked), for: .touchDown)
        
        if let label = button.titleLabel {
            label.font = .systemFont(ofSize: 16, weight: .semibold)
        }
        
        self.addArrangedSubview(button)
    }
    
    func updateButtonStates() {
        self.arrangedSubviews.forEach { button in
            guard let button =  button as? UIButton else { return }
            if self.getButtonIndex(button) == self.currentSelectedOption {
                self.setButtonSelected(button)
            } else {
                self.setButtonDeselected(button)
            }
            
        }
    }
    
    func setButtonSelected(_ button: UIButton) {
        UIView.animate(withDuration: self.animationDuration) {
            
            button.setTitleColor(ColorManager.titleTextColor, for: .normal)
        }
    }
    
    func setButtonDeselected(_ button: UIButton) {
        UIView.animate(withDuration: self.animationDuration) {
            
            button.setTitleColor(UIColor(red: 0x99 / 255, green: 0x99 / 255, blue: 0x99 / 255, alpha: 1), for: .normal)
        }
    }
    
    @objc func onOptionPicked(_ button: UIButton){
        self.currentSelectedOption = getButtonIndex(button)
        self.updateButtonStates()
        
        self.moveLine(to: button)
        self.delegate?.onOptionChanged(to: self.buttons[self.getButtonIndex(button)])
    }
    
    func getButtonIndex(_ button: UIButton) -> Int {
        self.arrangedSubviews.firstIndex { (view) -> Bool in
            view == button
        }!
    }
}

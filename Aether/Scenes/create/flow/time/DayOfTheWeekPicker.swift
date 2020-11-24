//
//  DayOfTheWeekPicker.swift
//  Aether
//
//  Created by Bruno Pastre on 28/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

protocol DayOfTheWeekPickerDelegate: AnyObject {
    func onDaysChanged(to days: [String])
}
class DayOfTheWeekPicker: UIStackView {
    private let daysOfTheWeek = Calendar.current.shortWeekdaySymbols.map( { $0.uppercased() })
    private var selectedDays: [String] = []
    
    private let SELECTED_COLOR = ColorManager.highlightColor
    private let DESELECTED_COLOR = ColorManager.darkColor.withAlphaComponent(0.3)
    
    weak var delegate: DayOfTheWeekPickerDelegate?
    
    init() {
        super.init(frame: .zero)
        
        axis = .horizontal
        alignment = .fill
        distribution = .equalSpacing
//        spacing = 0
        
        translatesAutoresizingMaskIntoConstraints = false
        
        daysOfTheWeek.forEach {
            addArrangedSubview(getDOTW(named: $0))
        }
    }
    
    
    private func getDOTW(named: String) -> UIButton {
        let button = UIButton()
        
        button.setTitle(
            named.uppercased(),
            for: .normal
        )
        
        button.addTarget(
            self,
            action: #selector(onDaySelected),
            for: .touchUpInside
        )
        
        button.setTitleColor(
            DESELECTED_COLOR,
            for: .normal
        )
        
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        return button
    }
    
    @objc private func onDaySelected(_ button: UIButton) {
        guard
            let name = button.title(for: .normal)
        else { return }
        
        defer { delegate?.onDaysChanged(to: selectedDays) }
        
        if selectedDays.contains(name) {
            
            button.setTitleColor(
                self.DESELECTED_COLOR,
                for: .normal
            )

            selectedDays.removeAll(where: { $0 == name } )
            return
        }
        
        button.setTitleColor(
            SELECTED_COLOR,
            for: .normal
        )
        selectedDays.append(name)
        
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  TimePickerView.swift
//  Aether
//
//  Created by Bruno Pastre on 26/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

protocol TimePickerDelegate: AnyObject {
    func onTimeChanged(date: Date)
}
class TimePicker: UIStackView {
    typealias strings = AEStrings.TimePicker
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(20).withWeight(.semibold)
        label.text = strings.Label.time
        label.textColor = ColorManager.darkColor
        
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        picker.addTarget(self, action: #selector(pickerDidChange), for: .valueChanged)
        picker.datePickerMode = .time
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = UIDatePickerStyle.inline
        } else {
            picker.preferredDatePickerStyle = .compact
        }
        
        
        return picker
    }()
    
    weak var delegate: TimePickerDelegate?
    
    init() {
        super.init(frame: .zero)
        
        axis = .horizontal
        alignment = .fill
        distribution = .equalSpacing
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addArrangedSubview(timeLabel)
        addArrangedSubview(datePicker)
    }
    
    @objc private func pickerDidChange() {
        let date = datePicker.date
        delegate?.onTimeChanged(date: date)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }
}


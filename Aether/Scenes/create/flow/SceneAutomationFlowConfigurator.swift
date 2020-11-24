//
//  SceneAutomationFlowConfigurator.swift
//  Aether
//
//  Created by Bruno Pastre on 26/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import MapKit
import HomeKit

protocol SceneAutomationFlowConfiguratorDelegate: AnyObject {
    func userInputDidChange(_ view: SceneAutomationFlowConfigurator, to userInput: SceneUserInput)
    func presentLocationPickerView(_ delegate: LocationPickerDelegate)
    func presentationModeDidChange(_ view: SceneAutomationFlowConfigurator, to presentationMode: SceneAutomationFlowConfigurator.PresentationMode)
}


class SceneAutomationFlowConfigurator: UIView, TimePickerDelegate, SwitchOptionViewDelegate, DayOfTheWeekPickerDelegate, LocationPickerDelegate, AccessoryPickerViewDelegate, MetadataPickerViewDelegate {
    typealias strings = AEStrings.SceneAutomationFlowConfigurator
    struct Option {
        var trailingLabel: UILabel
        var option: Configuration
    }
    
    enum Configuration: CaseIterable {
        case location
        case time
        case accessory
        case metadata
    }
    
    enum PresentationMode {
        case folded
        case `default`
    }
    
    weak var delegate: SceneAutomationFlowConfiguratorDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = ColorManager.lighterColor
        label.font = label.font.withWeight(.bold).withSize(14)
        label.heightAnchor.constraint(equalToConstant: 58).isActive = true
        
        return label
    }()
    private let optionsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabelHiddenConstraint: NSLayoutConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 0)
    
    private var configurations: [Configuration]
    private var options: [Option] = []
    private var optionsViews: [UIView] = []
    var userInput: SceneUserInput = .init() {
        didSet {
            delegate?.userInputDidChange(self, to: userInput)
        }
    }
    var presentationMode: PresentationMode = .default {
        didSet {
            delegate?.presentationModeDidChange(self, to: presentationMode)
        }
    }
    
    init(_ configurations: [Configuration], title: String) {
        self.configurations = configurations
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if configurations.contains(.location) {
            buildLocationPicker()
        }

        if configurations.contains(.time) {
            buildTimePicker()
            buildWeekdayPicker()
        }

        if configurations.contains(.accessory) {
            buildAccessoryPicker()
        }

        if configurations.contains(.metadata) {
            buildMetadataPicker()
        }
        
        titleLabel.text = title
        
        addSubviews()
        setupDefaultState()
        addConstrains()
    }
    
    // MARK: - Layout
    private func addSubviews() {
        addSubview(optionsStackView)
        addSubview(titleLabel)
    }
    private func setupFoldedState() {
        var labels: [UILabel] = []
        func configureLabels() {
            labels.forEach { self.optionsStackView.addArrangedSubview($0) }
            self.optionsStackView.spacing = 5
            self.titleLabelHiddenConstraint.isActive = true
        }
        
        if configurations.contains(.accessory) {
            labels.append(buildResultLabel(
                title: strings.Label.accessories,
                triggerName: self.userInput.accessories.map { $0.accessory.name }.joined(separator: ", ")
            ))
            configureLabels()
            return
        }
        
        labels.append(buildResultLabel(
                        title: userInput.timeLabel().title,
                        triggerName: userInput.timeLabel().trigger
        ))
        
        labels.append(buildResultLabel(
                        title: userInput.daysLabel().title,
                        triggerName: userInput.daysLabel().trigger
        ))
        
        userInput.locationLabel { (description) in
            labels.insert(
                self.buildResultLabel(
                    title: description.title,
                    triggerName: description.trigger
                ),
                at: 0
            )
            configureLabels()
        }
    }
    
    private func setupDefaultState() {
        optionsStackView.spacing = 20
        optionsViews.forEach { optionsStackView.addArrangedSubview($0) }
        titleLabelHiddenConstraint.isActive = false
    }
    
    private func addConstrains() {
        optionsStackView.leadingAnchor.constraint(
            equalTo: leadingAnchor
        ).isActive = true
        
        optionsStackView.trailingAnchor.constraint(
            equalTo: trailingAnchor
        ).isActive = true
        
        optionsStackView.bottomAnchor.constraint(
            equalTo: bottomAnchor
        ).isActive = true
        
        titleLabel.topAnchor.constraint(
            equalTo: topAnchor
        ).isActive = true
        
        titleLabel.centerXAnchor.constraint(
            equalTo: centerXAnchor
        ).isActive = true
        
        titleLabel.widthAnchor.constraint(
            equalTo: widthAnchor,
            multiplier: 0.7
        ).isActive = true
        
        titleLabel.bottomAnchor.constraint(
            equalTo: optionsStackView.topAnchor,
            constant: -20
        ).isActive = true
    }
    
    private func buildTimePicker() {
        let optionView = SwitchOptionView(title: strings.SwitchOptionView.time)
        let pickerView = TimePicker()
        
        let configView = ConfigurationView(
            configuration: .time,
            optionView: optionView,
            pickerView: pickerView
        )
        
        pickerView.delegate = self
        optionView.delegate = self
        
        optionsViews.append(configView)
    }
    private func buildWeekdayPicker() {
        let optionView = SwitchOptionView(title: strings.SwitchOptionView.days)
        let pickerView = DayOfTheWeekPicker()
        
        let config = ConfigurationView(
            configuration: .time,
            optionView: optionView,
            pickerView: pickerView
        )
        
        pickerView.delegate = self
        optionView.delegate = self
        
        optionsViews.append(config)
    }
    private func buildLocationPicker() {
        let optionView = SwitchOptionView(title: strings.SwitchOptionView.location)

        let config = ConfigurationView(
            configuration: .location,
            optionView: optionView
        )

        optionView.delegate = self

        optionsViews.append(config)
    }
    
    private func buildAccessoryPicker() {
        
        let pickerView = AccessoryPickerView()
        
        let config = ConfigurationView(
            configuration: .accessory,
            pickerView: pickerView,
            shouldHidePickerView: false
        )

        pickerView.delegate = self
        optionsViews.append(config)
    }
    
    private func buildMetadataPicker() {
        let pickerView = MetadataPickerView()
        
        let config = ConfigurationView(
            configuration: .accessory,
            pickerView: pickerView,
            shouldHidePickerView: false
        )

        pickerView.delegate = self
        optionsViews.append(config)
    }
    
    private func buildResultLabel(title: String, triggerName: String) -> UILabel {
        let label: UILabel = .init()
        let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(didTapLabel))
        
        let leadingString = NSMutableAttributedString(
            string: title + ": ", attributes:[
                NSAttributedString.Key.foregroundColor : ColorManager.lighterColor,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)
            ]
        )
        let triggerString = NSMutableAttributedString(
            string: triggerName,
            attributes: [
                NSAttributedString.Key.foregroundColor : ColorManager.highlightColor,
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)
            ]
        )
        
        leadingString.append(triggerString)
        label.attributedText = leadingString
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        
        return label
    }
    
    // MARK: - TimePicker delegate
    func onTimeChanged(date: Date) {
        userInput.time = date
    }
    
    // MARK: - DayOfTheWeekPicker delegate
    func onDaysChanged(to days: [String]) {
        userInput.days = days
    }
    
    // MARK: - LocationPicker delegate
    func didChangeLocation(to coordinate: MKCoordinateRegion?) {
        userInput.location = coordinate
        updateCoordinate()
    }
    
    func onDismiss() {
        updateCoordinate()
    }
    
    // MARK: - AccessoryPickerViewDelegate
    func addAccessory(accessory: AccessoryPickerModel) {
        userInput.accessories.append(accessory)
    }
    
    func updateAccessory(accessory: AccessoryPickerModel) {
        removeAccessory(accessory: accessory)
        addAccessory(accessory: accessory)
    }
    
    func removeAccessory(accessory: AccessoryPickerModel) {
        userInput.accessories.removeAll(where:  { $0.accessory == accessory.accessory })
    }
    
    // MARK: - Metadata picker delegate methods
    func didChangeName(to newName: String?) {
        userInput.name = newName
    }
    
    func didChangeIcon(to newIcon: CustomRoom) {
        userInput.icon = newIcon
    }
    
    // MARK: - Helpers
    private func updateCoordinate() {
        guard
            let locationView = optionsStackView.arrangedSubviews.compactMap { $0 as? ConfigurationView }.filter({ $0.configuration == .location}).first,
            let optionView = locationView.optionView as? SwitchOptionView
        else { return }
        optionView.trailingSwitch.setOn(userInput.location != nil, animated: true)
    }
    
    // MARK: - SwitchOptionViewDelegate
    func onToggleChange(_ optionView: SwitchOptionView) {
        self.optionsStackView.arrangedSubviews.forEach {
            guard
                let view = $0 as? ConfigurationView,
                view.optionView == optionView
            else { return }
            
            let isDayOfTheWeek = view.pickerView is DayOfTheWeekPicker
            let isTimePicker =   view.pickerView is TimePicker
            let isLocationPicker = view.configuration == .location
            let isOn = optionView.isSwitchOn()
            
            if isLocationPicker {
                if isOn { delegate?.presentLocationPickerView(self) }
                userInput.locationEnabled = isOn
                return
            }
            
            view.pickerView?.isHidden = !isOn
            
            if isDayOfTheWeek {
                if !isOn { }
                userInput.daysEnabled = isOn
            }
            if isTimePicker { userInput.timeEnabled = isOn }
            
        }
    }
    
    // MARK: - Presentation mode modifiers
    func updatePresentationMode(to presentationMode: PresentationMode) {
        guard presentationMode != self.presentationMode else { return }
        
        self.presentationMode = presentationMode
        self.optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        switch presentationMode {
            case .folded: setupFoldedState()
            case .default: setupDefaultState()
        }
    }
    
    // MARK: - Callbacks
    @objc func didTapLabel() {
        updatePresentationMode(to: .default)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

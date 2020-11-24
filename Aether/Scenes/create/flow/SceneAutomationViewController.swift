//
//  SceneAutomationViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 20/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

class SceneAutomationViewController: UIViewController , SceneAutomationFlowConfiguratorDelegate {
    typealias strings = AEStrings.SceneAutomationViewController
    // MARK: - UI Components
    private let sceneAutomationView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private lazy var scrollableContentSize: CGSize = .init(width: view.frame.width, height: view.frame.height + 1000)
    
    private lazy var nextButton: UIButton = {
        let button = DesignableButton()
        
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(
            strings.Button.next,
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(onNext),
            for: .touchUpInside
        )
        button.setBackgroundColor(
            color: ColorManager.lightestColor,
            for: .disabled
        )
        
        return button
    }()
    private lazy var nextButtonContainerView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorManager.backgroundColor
        
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.frame = self.view.bounds
        view.contentSize = scrollableContentSize
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.frame.size = scrollableContentSize
        return view
    }()
    
    // MARK: - Dependencies
    private var condition: AutomationStartCondition
    
    // MARK: - Pickers
    private var triggerPickerView: SceneAutomationFlowConfigurator
    private var lampPickerView: SceneAutomationFlowConfigurator
    private var metadataPickerView: SceneAutomationFlowConfigurator

    // MARK: - Local variables
    private var timeLineViews: [TimeLineView] = []
    private var enabledLamps: [HMAccessory] = []
    private var dismissKeyboardGesture: UITapGestureRecognizer?
    
    // MARK: - Initializers
    init(condition: AutomationStartCondition) {
        triggerPickerView = .init(
            condition.configurator(),
            title: strings.SceneAutomationFlowConfigurator.triggerTitle
        )
        
        lampPickerView = .init(
            [.accessory],
            title: strings.SceneAutomationFlowConfigurator.lampPickerTitle
        )
        
        metadataPickerView = .init (
            [.metadata],
            title: strings.SceneAutomationFlowConfigurator.metadataPickerTitle
        )
        
        self.condition = condition
        super.init(nibName: nil, bundle: nil)
        
        triggerPickerView.delegate = self
        lampPickerView.delegate = self
        metadataPickerView.delegate = self
    }
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.backgroundColor = ColorManager.backgroundColor
        setupScrollView()
        addSubviews()
        setupAutomationStartView()
        addTimeLine(under: sceneAutomationView)
        setupConfiguratorView()
        setupNextButtonContainerView()
        setupNextButton()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisappear), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = ColorManager.backgroundColor
        navigationController?.navigationBar.backgroundColor = ColorManager.backgroundColor
        navigationController?.navigationBar.barTintColor = ColorManager.backgroundColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = .init()
        
        navigationItem.leftBarButtonItem = .init(customView: {
            let view = UIButton()
            
            view.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
            view.setImage(UIImage(named: "back_1")?.withColor(ColorManager.highlightColor), for: .normal)
            view.tintColor = ColorManager.highlightColor
            view.alpha = 0.5
            
            if let imageView = view.imageView {
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            }
            
            return view
        }())
        
    }
    
    // MARK: - View setup
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.addSubview(containerView)
    }
    private func addSubviews() {
        containerView.addSubview(sceneAutomationView)
        containerView.addSubview(triggerPickerView)
        view.addSubview(nextButtonContainerView)
        nextButtonContainerView.addSubview(nextButton)
    }
    private func setupAutomationStartView() {
        let imageView: UIImageView = {
            let view = UIImageView(image: UIImage(named: condition.imageName()))
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.contentMode = .scaleAspectFit
            
            return view
        }()
        let titleLabel: UILabel = {
            let label = UILabel()
            
            label.text = condition.title()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = ColorManager.highlightColor
            
            return label
        }()
        let descriptionLabel: UILabel = {
            let label = UILabel()
            
            label.text = condition.description()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = ColorManager.lightColor
            label.font = label.font.withSize(14)
            
            return label
        }()
        
        let view = containerView
        sceneAutomationView.addSubview(imageView)
        sceneAutomationView.addSubview(titleLabel)
        sceneAutomationView.addSubview(descriptionLabel)
        
        /// Constraints sceneAutomationView
        NSLayoutConstraint.activate([
            sceneAutomationView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            
            sceneAutomationView.widthAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.widthAnchor,
                multiplier: 0.6
            ),
        
            sceneAutomationView.heightAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.heightAnchor,
                multiplier: 0.08
            ),
            
            sceneAutomationView.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            ),
            
        ])

        /// Constraints imageView
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(
                equalTo: sceneAutomationView.leadingAnchor
            ),
            imageView.heightAnchor.constraint(
                equalTo: sceneAutomationView.heightAnchor
            ),
            imageView.centerYAnchor.constraint(
                equalTo: sceneAutomationView.centerYAnchor
            ),
            imageView.widthAnchor.constraint(
                equalTo: imageView.heightAnchor
            ),
        ])
        
        /// Constraints titleLabel
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: imageView.trailingAnchor,
                constant: 10
            ),
            
            titleLabel.bottomAnchor.constraint(
                equalTo: imageView.centerYAnchor,
                constant: 5
            ),
        ])
        
        /// Constraints titleLabel
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(
                equalTo: imageView.trailingAnchor,
                constant: 10
            ),
            
            descriptionLabel.topAnchor.constraint(
                equalTo: imageView.centerYAnchor,
                constant: 5
            ),
        ])
        
    }
    private func setupConfiguratorView() {
        guard let lastTimeLineView = timeLineViews.last
        else { return }
        
        triggerPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        triggerPickerView.topAnchor.constraint(equalTo: lastTimeLineView.bottomAnchor, constant: 20).isActive = true
        triggerPickerView.widthAnchor.constraint(
            equalTo: view.widthAnchor,
            multiplier: 0.85
        ).isActive = true
        
    }
    private func setupNextButtonContainerView() {
        NSLayoutConstraint.activate([
            nextButtonContainerView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            nextButtonContainerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            nextButtonContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            )
        ])
    }
    private func setupNextButton() {
        let container = nextButtonContainerView
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(
                equalTo: container.leadingAnchor,
                constant: 20
            ),
            nextButton.trailingAnchor.constraint(
                equalTo: container.trailingAnchor,
                constant: -20
            ),
            nextButton.topAnchor.constraint(
                equalTo: container.topAnchor,
                constant: 20
            ),
            nextButton.bottomAnchor.constraint(
                equalTo: container.bottomAnchor,
                constant: -20
            ),
            nextButton.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.07
            )
        ])
    }
    
    private func addTimeLine(under viewAbove: UIView) {
        let timeLineView: TimeLineView = {
            let view = TimeLineView()
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        containerView.addSubview(timeLineView)
        timeLineViews.append(timeLineView)
        
        NSLayoutConstraint.activate([
            
            timeLineView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            
            timeLineView.topAnchor.constraint(
                equalTo: viewAbove.bottomAnchor,
                constant: 20
            ),
            
            timeLineView.heightAnchor.constraint(
                equalToConstant: 44
            ),
        ])
        
    }
    
    // MARK: - Lamp picker manager methods
    private func presentLampPicker() {
        addTimeLine(under: self.triggerPickerView)
        containerView.addSubview(lampPickerView)
        
        guard let topView = timeLineViews.last
        else { return }
        
        NSLayoutConstraint.activate([
            lampPickerView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            
            lampPickerView.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.85
            ),
            lampPickerView.topAnchor.constraint(
                equalTo: topView.bottomAnchor,
                constant: 20
            )
        ])
        
        if lampPickerView.userInput.isValid() { presentMetadataPicker() }
    }
    private func hideLampPicker() {
        hideMetadataPicker()
        if lampPickerView.superview != nil {
            timeLineViews.popLast()?.removeFromSuperview()
            lampPickerView.removeFromSuperview()
        }
    }
    
    // MARK: - Metadata picker manager methods
    private func presentMetadataPicker() {
        addTimeLine(under: lampPickerView)
        containerView.addSubview(metadataPickerView)
        guard let topView = timeLineViews.last
        else { return }
        NSLayoutConstraint.activate([
            metadataPickerView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            metadataPickerView.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.85
            ),
            metadataPickerView.topAnchor.constraint(
                equalTo: topView.bottomAnchor,
                constant: 20
            )
        ])
    }
    private func hideMetadataPicker() {
        if metadataPickerView.superview != nil {
            timeLineViews.popLast()?.removeFromSuperview()
            metadataPickerView.removeFromSuperview()
        }
    }
    
    // MARK: - SceneAutomationFlowConfiguratorDelegate
    func presentLocationPickerView(_ delegate: LocationPickerDelegate) {
        let vc = LocationPickerViewController()
        let navigation = UINavigationController(rootViewController: vc)
        
        vc.delegate = delegate
        
        self.present(navigation, animated: true, completion: nil)
    }
    func userInputDidChange(_ view: SceneAutomationFlowConfigurator, to userInput: SceneUserInput) {
        nextButton.isEnabled = isButtonEnabled()
    }
    func presentationModeDidChange(_ view: SceneAutomationFlowConfigurator, to presentationMode: SceneAutomationFlowConfigurator.PresentationMode) {
        
        defer { nextButton.isEnabled = isButtonEnabled() }

        if view == triggerPickerView {
            switch presentationMode {
            case .default: hideLampPicker()
            case .folded:  presentLampPicker()
            }
        } else if view == lampPickerView {
            switch presentationMode {
            case .default: hideMetadataPicker()
            case .folded : presentMetadataPicker()
            }
        } else if view == metadataPickerView && presentationMode == .folded {
            print("ACABOU")
        }
         
    }
    
    // MARK: - Keyboard managing
    @objc private func keyboardWillAppear(_ notification: NSNotification) {
        guard
            let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        let height = value.cgRectValue.height
        configureKeyboardDismissGesture()
        UIView.animate(withDuration: 0.2) {
            self.nextButtonContainerView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -height)
        }
        scrollView.setContentOffset(.init(x: 0, y: height), animated: true)
    }
    @objc private func keyboardDidDisappear() {
        UIView.animate(withDuration: 0.2) {
            self.nextButtonContainerView.transform = .identity
        }
        scrollView.setContentOffset(.zero, animated: true)
        removeKeyboardDismissGesture()
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    private func configureKeyboardDismissGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
        dismissKeyboardGesture = gesture
    }
    private func removeKeyboardDismissGesture() {
        guard let gesture = dismissKeyboardGesture
        else { return }
        view.removeGestureRecognizer(gesture)
        dismissKeyboardGesture = nil
    }
    
    // MARK: - Create scene
    private func createScene() {
        AESceneBuilder.build(
            trigger: triggerPickerView.userInput,
            lamps: lampPickerView.userInput,
            metadata: metadataPickerView.userInput
        ) { (error) in
            if let error = error {
                self.onError(error.localizedDescription)
                return
            }
            self.onCompleted()
        }
    }
    
    // MARK: - Helpers
    private func isButtonEnabled() -> Bool {
        updateButtonName()
        if lampPickerView.presentationMode == .folded && triggerPickerView.presentationMode == .folded {
            return metadataPickerView.userInput.isValid()
        }
        if triggerPickerView.presentationMode == .folded {
            return lampPickerView.userInput.isValid()
        }
        return triggerPickerView.userInput.isValid()
    }
    
    private func updateButtonName() {
        if lampPickerView.presentationMode == .folded
            && triggerPickerView.presentationMode == .folded
            && metadataPickerView.userInput.isValid() {
            nextButton.setTitle(
                strings.Button.ready,
                for: .normal
            )
        } else {
            nextButton.setTitle(
                strings.Button.next,
                for: .normal
            )
        }
    }
    
    func onError(_ message: String) {
        presentAlertController(withError: message)
    }
    
    func onCompleted() {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    private func presentAlertController(withError error: String) {
        let title = AEStrings.Alert.Scene.alertTitle
        let message  = error
        let alert = UIAlertController(
            title: title,
            message: error,
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(title: AEStrings.Alert.Scene.confirmation, style: .cancel)
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    // MARK: - Callbacks
    @objc func onNext() {
        if nextButton.title(for: .normal) == strings.Button.ready {
            createScene()
        }
        
        if triggerPickerView.userInput.isValid() {
            triggerPickerView.updatePresentationMode(to: .folded)
        }
        
        if lampPickerView.userInput.isValid() {
            lampPickerView.updatePresentationMode(to: .folded)
        }
    }
    
    @objc func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    // MARK: - Unused
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension AutomationStartCondition {
    func configurator() -> [SceneAutomationFlowConfigurator.Configuration] {
        switch self {
        case .peopleArrive:
            return [
                .time,
                .location
            ]
        case .peopleLeave:
            return [
                .location,
                .time
            ]
        case .time:
            return [
                .time
            ]
        case .otherAccessory:
            return [
                .accessory
            ]
        }
    }
}

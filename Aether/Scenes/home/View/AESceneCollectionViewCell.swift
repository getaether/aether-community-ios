//
//  AESceneCollectionViewCell.swift
//  Aether
//
//  Created by Bruno Pastre on 19/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

protocol ActivationColor {
    static var active: UIColor { get }
    static var deactive: UIColor { get }
}

extension ActivationColor {
    static func get(isOn: Bool) -> UIColor {
        isOn ? active : deactive
    }
}

protocol AESceneCollectionViewCellDelegate: AnyObject {
    func onSwitchChange(_ cell: AESceneCollectionViewCell)
}

class AESceneCollectionViewCell: AECollectionViewCell {
    
    enum Colors {
        struct Switch: ActivationColor {
            static var active: UIColor { ColorManager.highlightColor }
            static var deactive: UIColor { ColorManager.lighterColor }
        }
        struct Background: ActivationColor {
            static var active: UIColor { ColorManager.highlightColor }
            static var deactive: UIColor { ColorManager.lightestColor }
            
        }
        struct Label: ActivationColor {
            static var active: UIColor  { UIColor.white }
            static var deactive: UIColor  { UIColor.white }
        }
    }
    
    @IBOutlet weak var sceneLabel: UILabel!
    @IBOutlet weak var sceneImageView: UIImageView!
    @IBOutlet weak var isOnSwitch: UISwitch!
    
    weak var delegate: AESceneCollectionViewCellDelegate?
    
    var isOn: Bool { isOnSwitch.isOn }
    var sceneId: String!
    private var configuredGestures = false
    
    func configure(using model: SceneCollectionViewCellModel) {
        configureGesturesIfPossible()
        sceneId = model.sceneId
        sceneLabel.text = model.sceneName
        sceneImageView.image = UIImage(named: model.sceneImageName)
        isOnSwitch.setOn(model.isOn, animated: true)
        configureLayout(isOn: model.isOn)
        configureAdditional()
    }
    
    func animateSwitchToggle() {
        let isOn = !isOnSwitch.isOn
        isOnSwitch.setOn(isOn, animated: true)
    }
    
    func toggle() {
        let isOn = isOnSwitch.isOn
        configureLayout(isOn: isOn)
    }
    
    private func configureAdditional() {
        isOnSwitch.subviews.first?.subviews.first?.backgroundColor = .white
        isOnSwitch.tintColor = .white
        isOnSwitch.onTintColor = .white
        sceneLabel.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private func configureGesturesIfPossible() {
        if !configuredGestures {
            isOnSwitch.addTarget(self, action: #selector(onSwitchChanged), for: .valueChanged)
            configuredGestures = true
        }
    }
    
    private func configureLayout(isOn: Bool) {
        isOnSwitch.thumbTintColor = Colors.Switch.get(isOn: isOn)
        sceneLabel.textColor = Colors.Label.get(isOn: isOn)
        
        contentView.backgroundColor = Colors.Background.get(isOn: isOn)
        contentView.layer.cornerRadius = 10
    }
    
    override func getMenuObject() -> Any? {
        self.sceneId
    }
    
    // MARK: - Callbacks
    
    @objc private func onSwitchChanged() {
        delegate?.onSwitchChange(self)
    }
}

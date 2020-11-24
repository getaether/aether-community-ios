//
//  IntroductionOnboardingViewController.swift
//  Aether
//
//  Created by Gabriel Gazal on 07/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

class IntroductionOnboardingViewController: UIViewController {
    
    private let strings = AEStrings.IntroductionOnboardingViewController.self
    
    @IBOutlet weak var dismissOnboarding: UIButton!
    @IBOutlet weak var startLabel: TitleLabel!
    @IBOutlet weak var descriptionLabel: BodyTextLabel!
    @IBOutlet weak var aetherButton: UIView!
    @IBOutlet weak var otherButton: UIView!
    @IBOutlet weak var stackViewBotoes: UIStackView!
    @IBOutlet weak var aetherLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    
    weak var delegate: ViewControllerDismissDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        startLabel.text = strings.Label.start
        descriptionLabel.attributedText = {
            
            let str = strings.Label.Description.start
            let componenets = str.components(separatedBy: "Aether")
            let attr = [
                NSAttributedString.Key.font : descriptionLabel.font.withWeight(.bold)
            ]
            let attributed = NSMutableAttributedString(string: componenets[0])
            
            attributed.append(NSAttributedString(string: "Aether", attributes: attr))
            attributed.append(NSMutableAttributedString(string:componenets[1]))
        
            return attributed
        }()
        
        aetherLabel.text = strings.Label.Description.aether
        otherLabel.text = strings.Label.Description.other
        
        setUpWhiteButton(button: aetherButton, selector: #selector(self.setupAether))
        setUpWhiteButton(button: otherButton, selector: #selector(self.otherLamp))
        
    }
    
    private final func setUpWhiteButton(button: UIView, selector: Selector) {
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorManager.grey4.cgColor
        button.layer.cornerRadius = 8
        
        let gesture = UITapGestureRecognizer(target: self, action: selector)
        
        button.addGestureRecognizer(gesture)
    }
    
    @objc func setupAether() {
        self.dismiss(should: true)
    }
    
    @objc func otherLamp() {
        self.performSegue(withIdentifier: "otherMaker", sender: self)
    }
    
    @IBAction func closeOnboarding(_ sender: Any) {
        self.dismiss(should: false)
    }
    
    func dismiss(should goOn: Bool) {
        self.dismiss(animated: true, completion: {
            self.delegate?.onDismiss(self, should: goOn)
        })
        
    }
    
}

extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let descriptor = fontDescriptor.addingAttributes([
            .traits : [
                UIFontDescriptor.TraitKey.weight : weight
            ]
        ])
        
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}

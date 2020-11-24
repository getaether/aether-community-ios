//
//  LampSetupInstructionViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 06/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class LampSetupInstructionViewController: UIViewController {

    private let titleLabel: TitleLabel = {
        let label = TitleLabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private let descriptionLabel: BodyTextLabel = {
       let label = BodyTextLabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private var contentView: UIView!
    
    
    init(title: String, description: String, contentView view: UIView) {
        super.init(nibName: nil, bundle: nil)
        
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        
        self.contentView = view
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stackView = UIStackView(arrangedSubviews: [
            self.contentView,
            self.titleLabel,
            self.descriptionLabel,
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
            
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)

        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.55).isActive = true
        
    }

}

class LampSetupImageInstructionViewController: LampSetupInstructionViewController {
    init(title: String, description: String, imageName: String) {
        let view = UIImageView(image: UIImage(named: imageName))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.contentMode = .scaleAspectFill
        super.init(title: title, description: description, contentView: view)
        
        view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

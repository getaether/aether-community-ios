//
//  CreateSceneViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 19/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

protocol CreateSceneDelegate: class {
    func didSelectCondition(_ condition: AutomationStartCondition)
}

class CreateSceneManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let automations: [AutomationStartCondition] = AutomationStartCondition.allCases
    static let CELL_ID = "Create scene cell"
    
    weak var delegate: CreateSceneDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { automations.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateSceneManager.CELL_ID) as! AutomationOptionCell
        let sceneCase = AutomationStartCondition.allCases[indexPath.item]
        
        cell.accessoryType = .disclosureIndicator
        
        cell.titleLabel.text = sceneCase.title()
        cell.descriptionLabel.text = sceneCase.description()
        cell.iconImageView.image = UIImage(named: sceneCase.imageName())
        
        cell.descriptionLabel.font = cell.descriptionLabel.font.withSize(14).withWeight(.regular)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height * 0.25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCondition = AutomationStartCondition.allCases[indexPath.item]
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.didSelectCondition(selectedCondition)
    }
    
}

class CreateSceneViewController: UIViewController, CreateSceneDelegate {
    private let strings = AEStrings.CreateSceneViewController.self
    private lazy var titleLabel: TitleLabel = {
        let label = TitleLabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = strings.Label.title
        
        return label
    }()
    
    private lazy var descriptionLabel: BodyTextLabel = {
        let label = BodyTextLabel()
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = strings.Label.description
        
        return label
    }()
    
    let optionsTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            .init(
                nibName: "CreateSceneCell",
                bundle: nil
            ),
            forCellReuseIdentifier: CreateSceneManager.CELL_ID
        )
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    let manager = CreateSceneManager()
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        view.backgroundColor = ColorManager.backgroundColor
        
        optionsTableView.dataSource = manager
        optionsTableView.delegate = manager
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(optionsTableView)
        
        self.setupTitleLabel()
        self.setupDescriptionLabel()
        self.setupOptionsTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Setup methods
    func setupTitleLabel() {
        
        titleLabel.leadingAnchor.constraint(
            equalTo: optionsTableView.leadingAnchor
        ).isActive = true
        
        titleLabel.bottomAnchor.constraint(
            equalTo: descriptionLabel.topAnchor,
            constant: -10
        ).isActive = true
    }
    
    func setupDescriptionLabel() {
        
        descriptionLabel.leadingAnchor.constraint(
            equalTo: optionsTableView.leadingAnchor
        ).isActive = true
        
        descriptionLabel.widthAnchor.constraint(
            equalTo: view.widthAnchor,
            multiplier: 0.5
        ).isActive = true
        
        descriptionLabel.bottomAnchor.constraint(
            equalTo: optionsTableView.topAnchor,
            constant: -20
        ).isActive = true
        
    }
    
    func setupOptionsTableView() {
    
        optionsTableView.centerYAnchor.constraint(
            equalTo: view.centerYAnchor
        ).isActive = true
        
        optionsTableView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 40
        ).isActive = true
        
        optionsTableView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -40
        ).isActive = true
        
        optionsTableView.heightAnchor.constraint(
            equalTo: view.heightAnchor,
            multiplier: 0.5
        ).isActive = true
    }
    
    // MARK: - CreateSceneDelegate
    func didSelectCondition(_ condition: AutomationStartCondition) {
        navigationController?.pushViewController(SceneAutomationViewController(condition: condition), animated: true)
    }
}

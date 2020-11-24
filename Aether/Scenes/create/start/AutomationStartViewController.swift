//
//  AutomationStartViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 19/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class AutomationStartViewController: UIViewController, AutomationOptionDelegate {
    typealias strings = AEStrings.AutomationStartViewController
    
    let titleLabel: TitleLabel = {
        let label = TitleLabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = strings.Label.title
        
        return label
    }()
    
    let descriptionLabel: BodyTextLabel = {
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
            forCellReuseIdentifier: AutomationStartManager.CELL_ID
        )
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        
        return tableView
    }()
    
    let manager = AutomationStartManager()
    
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
        let vc = SceneAutomationViewController(condition: condition)
        navigationController?.pushViewController(vc, animated: true)
    }
}


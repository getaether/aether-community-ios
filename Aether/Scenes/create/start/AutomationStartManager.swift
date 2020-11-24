//
//  AutomationStartManager.swift
//  Aether
//
//  Created by Bruno Pastre on 19/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class AutomationStartManager: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let automations: [AutomationStartCondition] = AutomationStartCondition.allCases
    static let CELL_ID = "Create scene cell"
    
    weak var delegate: AutomationOptionDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { automations.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AutomationStartManager.CELL_ID) as! AutomationOptionCell
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
        
        self.delegate?.didSelectCondition(selectedCondition)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

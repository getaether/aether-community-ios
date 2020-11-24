//
//  AutomationStartCondition.swift
//  Aether
//
//  Created by Bruno Pastre on 19/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation

enum AutomationStartCondition: String, CaseIterable {
    case peopleArrive
    case peopleLeave
    case time
    case otherAccessory
    
    func title() -> String {
        switch self {
        case .peopleArrive: return AEStrings.AutomationStartCondition.Title.peopleArrive
        case .peopleLeave: return AEStrings.AutomationStartCondition.Title.peopleLeave
        case .time: return AEStrings.AutomationStartCondition.Title.time
        case .otherAccessory: return AEStrings.AutomationStartCondition.Title.otherAccessory
        }
    }
    func description() -> String {
        switch self {
        case .peopleArrive: return AEStrings.AutomationStartCondition.Description.peopleArrive
        case .peopleLeave: return AEStrings.AutomationStartCondition.Description.peopleLeave
        case .time: return AEStrings.AutomationStartCondition.Description.time
        case .otherAccessory: return AEStrings.AutomationStartCondition.Description.otherAccessory
        }
    }
    func imageName() -> String { self.rawValue }
    
}

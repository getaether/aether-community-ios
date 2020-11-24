//
//  AutomationOptionDelegate.swift
//  Aether
//
//  Created by Bruno Pastre on 19/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation

protocol AutomationOptionDelegate: class {
    func didSelectCondition(_ condition: AutomationStartCondition)
}

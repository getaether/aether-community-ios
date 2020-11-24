//
//  MenuViewPresenter.swift
//  Aether
//
//  Created by Bruno Pastre on 05/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

@objc private protocol AEMenuViewPresenter {
    @objc func onMenuTriggered(_ view: NSNotification)
}
// THIS IS DEPRECATED, SINCE WE NO LONGER USE THE MENU
// Wraps notification center and adds long gesture to views which can show a context menu
private class MenuViewManager: NSObject {
    private let MENU_NOTIFICATION = "this will not be called"
    public static let shared = MenuViewManager()
    
    private var configuredViews: [UIView] = []
    
    private override init() { }
    
    public func configure(on view: UIView) {
        if self.configuredViews.contains(view)  { return }
        
        self.configuredViews.append(view)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.onLongPress(_:)))
        
        gesture.minimumPressDuration = 0.5
        
        view.isUserInteractionEnabled = true
        
        view.addGestureRecognizer(gesture)
    }
    public func listen(_ listener: AEMenuViewPresenter) {
        NotificationCenter.default.addObserver(listener, selector: #selector(listener.onMenuTriggered(_:)), name: NSNotification.Name(rawValue: MENU_NOTIFICATION), object: nil)
    }
    
    @objc private func onLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let view = gesture.view else {return}
        
        Interaction.instance.pulsate(view: view)
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: MENU_NOTIFICATION),
            object: nil,
            userInfo: ["view": view]
        )
        Interaction.instance.longPressed()
    }
    
    
    
}

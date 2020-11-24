//
//  AECollectionViewCell.swift
//  Aether
//
//  Created by Bruno Pastre on 05/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

protocol AEMenuPresenter: UICollectionViewCell {
    func getPresentingView() -> UIView
    func getMenuObject() -> Any?
}

class AECollectionViewCell: UICollectionViewCell, AEMenuPresenter {
    static let EDIT_NOTIFICATION = NSNotification.Name(rawValue: "EDIT_TRIGGERED")
    // MARK:- Flags
    private var canConfigureLongPress = true
    var shouldConfigureLongPress: Bool { true }
    var didRecognizeLongPress = false
    
    // MARK: - AEMenuPresenter
    func getMenuObject() -> Any? { nil }
    func getPresentingView() -> UIView
    { fatalError("\(self) should override this method") }
    
    // MARK: - Helpers
    func setupLongPressIfNeeded() {
        guard canConfigureLongPress,
              shouldConfigureLongPress
        else { return }
        canConfigureLongPress = false
        let gesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(self.onLongPress)
        )
        gesture.minimumPressDuration = 0.5
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(gesture)
    }
    
    // MARK: - Callbacks
    @objc private func onLongPress(_ gesture: UILongPressGestureRecognizer) {
        gesture.isEnabled = false
        didRecognizeLongPress = true
        Interaction.instance.pulsate(view: self) {
            NotificationCenter.default.post(
                name: AECollectionViewCell.EDIT_NOTIFICATION,
                object: nil,
                userInfo: ["view": self]
            )
            gesture.isEnabled = true
            self.didRecognizeLongPress = false
        }
        Interaction.instance.longPressed()
    }
}


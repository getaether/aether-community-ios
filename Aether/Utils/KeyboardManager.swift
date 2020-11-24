//
//  KeyboardManager.swift
//  Aether
//
//  Created by Bruno Pastre on 22/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

protocol KeyboardManagerDelegate: AnyObject {
    func keyboardWillAppear(size: CGRect?)
    func keyboardWillDisappear()
}
class KeyboardManager: NSObject {
    var isKeyboardHidden: Bool = true
    weak var delegate: KeyboardManagerDelegate?

    // MARK: - Initialization
    override init() {
        super.init()
        observe(
            event: UIResponder.keyboardWillShowNotification,
            selector: #selector(keyboardWillAppear)
        )
        observe(
            event: UIResponder.keyboardWillHideNotification,
            selector: #selector(keyboardWillDisappear)
        )
        observe(
            event: UIResponder.keyboardDidShowNotification,
            selector: #selector(keyboardDidShow)
        )
        observe(
            event: UIResponder.keyboardDidHideNotification,
            selector: #selector(keyboardDidHide)
        )
    }
    
    deinit
    { NotificationCenter.default.removeObserver(self) }
    
    // MARK: - Helpers
    private func observe(event: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(
            self,
            selector: selector,
            name: event,
            object: nil
        )
    }
    // MARK: - Callbacks
    
    @objc func keyboardDidShow()
    { isKeyboardHidden = false }
    
    @objc func keyboardDidHide()
    { isKeyboardHidden = true }
    
    @objc func keyboardWillDisappear()
    { delegate?.keyboardWillDisappear() }
    
    @objc func keyboardWillAppear(_ notification: NSNotification ) {
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardFrameInfo = notification.userInfo?[key],
              let keyboardFrame = keyboardFrameInfo as? NSValue
        else {
            delegate?.keyboardWillAppear(size: nil)
            return
        }
        delegate?.keyboardWillAppear(size: keyboardFrame.cgRectValue)
    }
}

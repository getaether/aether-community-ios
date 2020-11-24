//
//  DraggableModalViewController.swift
//  Aether
//
//  Created by Bruno Pastre on 22/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class DraggableModalViewController: UIViewController, DraggableViewPanGestureManagerDelegate, KeyboardManagerDelegate {
    // MARK: - Constants
    private let MAX_BLUR: CGFloat = 0.7

    // MARK: - Managers
    let keyboardManager: KeyboardManager = .init()
    private lazy var panManager: DraggableViewPanGestureManager = {
        DraggableViewPanGestureManager(
            using: bottomView,
            maxBlur: MAX_BLUR,
            backgroundView: blurView
        )
    }()
    
    open var bottomView: AnimateableBottomView { fatalError("\(self) did not override contentView") }
    
    // MARK: - UI Components
    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurredEffectView.alpha = self.MAX_BLUR

        return blurredEffectView
    }()
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = .init(
        target: self, action: #selector(onTap))
    
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        keyboardManager.delegate = self
        panManager.delegate = self
        super.viewDidLoad()
        setUpBackBlur()
        setupBottomView()
        view.addGestureRecognizer(tapGestureRecognizer)
        self.modalTransitionStyle = .crossDissolve
    }
    
    
    //MARK: Setup methods
    func setUpBackBlur() {
        let blurredEffectView = blurView
        self.view.addSubview(blurredEffectView)
        NSLayoutConstraint.activate([
            blurredEffectView.topAnchor.constraint(equalTo: self.view.topAnchor),
            blurredEffectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            blurredEffectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            blurredEffectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.blurView = blurredEffectView
    }
    
    func setupBottomView()
    { /* Blank functions for subclasses to override */ }
    
    func didTap(at position: CGPoint) {
        if !keyboardManager.isKeyboardHidden {
            dismissKeyboard()
            return
        }
        if !bottomView.frame.contains(position) {
            dismissViewController() }
    }
    
    // MARK: - DraggableViewPanGestureManagerDelegate
    func dragGestureShouldDismiss()
    { dismissViewController()  }
    func dragGestureShouldReset()
    { bottomView.animateIn(completion: nil) }
    func focus(on: UIView) {
        view.endEditing(true)
        view.bringSubviewToFront(bottomView)
    }
    
    // MARK: - Callbacks
    @objc private func onTap(_ gesture: UITapGestureRecognizer) {
        let position = gesture.location(in: view)
        self.didTap(at: position)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
        bottomView.transform = .identity
    }
    
    // MARK: - Keyboard managing
    func keyboardWillDisappear()
    { bottomView.transform = .identity }
    
    func keyboardWillAppear(size: CGRect?) {
        guard let size = size
        else { return }
        bottomView.transform = bottomView.transform
            .translatedBy(
            x: 0,
            y: -size.height
        )
    }
    
    func dismissViewController() {
        self.bottomView.animateOut(completion: nil)
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.alpha = 0
        }) { _ in
            
            self.modalTransitionStyle = .crossDissolve
            
            self.dismiss(animated: false, completion: nil)
        }
    }
}

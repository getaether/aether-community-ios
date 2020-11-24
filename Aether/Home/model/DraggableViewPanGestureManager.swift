//
//  DraggableViewPanGestureManager.swift
//  Aether
//
//  Created by Bruno Pastre on 21/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

protocol DraggableViewPanGestureManagerDelegate: AnyObject {
    func dragGestureShouldDismiss()
    func dragGestureShouldReset()
    func focus(on: UIView)
}
class DraggableViewPanGestureManager: NSObject {
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.draggedView)
        )
        return panGesture
    }()
    
    private var panDistance: CGFloat = 0
    private var currentY: CGFloat?
    private let MIN_BLUR: CGFloat = 0.1
    
    // MARK: - Dependencies
    private let MAX_BLUR: CGFloat
    private let controlledView: UIView
    private let backgroundView: UIView
    
    weak var delegate: DraggableViewPanGestureManagerDelegate?
    
    init(
        using controlledView: UIView,
        maxBlur: CGFloat,
        backgroundView: UIView
    ) {
        self.MAX_BLUR = maxBlur
        self.controlledView = controlledView
        self.backgroundView = backgroundView
        super.init()
        controlledView.addGestureRecognizer(panGesture)
    }
    
    
    // MARK: - Pan state
    func onPanChanged(_ gesture: UIPanGestureRecognizer) {
        let trans = gesture.translation(in: controlledView).y
        if let deltaY = self.currentY,
           deltaY > 0 {
            controlledView.transform = controlledView.transform.translatedBy(x: 0, y: trans - deltaY)
            backgroundView.alpha = min( max( MAX_BLUR * ( 1 - trans/controlledView.frame.height) , MIN_BLUR), MAX_BLUR)
        }
        currentY = trans
    }
    
    func onPanStarted(_ gesture: UIPanGestureRecognizer) {
        self.panDistance = 0
        self.currentY = nil
        
    }
    
    // MARK: - Pan helpers
    func getDismissThreshold() -> CGFloat
    { controlledView.frame.height * 0.4 }
    
    func onPanEnded(_ gesture: UIPanGestureRecognizer)
    { (currentY ?? 0) > getDismissThreshold() ?
        delegate?.dragGestureShouldDismiss() : delegate?.dragGestureShouldReset() }
    
    // MARK: - Callbacks
    @objc func draggedView(_ sender: UIPanGestureRecognizer){
        delegate?.focus(on: controlledView)
        switch sender.state {
        case .began: self.onPanStarted(sender)
        case .changed: self.onPanChanged(sender)
        default: self.onPanEnded(sender)
        }
        
    }
}

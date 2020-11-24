//
//  AEMenuView.swift
//  Aether
//
//  Created by Bruno Pastre on 05/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

private protocol AEMenuViewDelegate {
    func onDismiss(_ option: AEMenuViewOption?, presenter: AEMenuPresenter?)
}

private enum AEMenuViewOption: String, CaseIterable {
    case delete = "trash"
    case edit = "edit"
    case favorite = "star"
}

/// THIS IS DEPRECATED

private class AEMenuView: UIView {
    
    public var delegate: AEMenuViewDelegate?
    
    private var triggeredView: AEMenuPresenter!
    private var triggeredParentView: UIView!
    private var triggeredFrame: CGRect!
    private var drawFrame: CGRect!
    private var overlayView: UIView!
    
    private var isFavorite: Bool!
    private var menuViews: [UIView] = []
    
    init(on parentView: UIView, triggeredView: AEMenuPresenter, isFavorite: Bool) {
        self.isFavorite = isFavorite
        
        super.init(frame: parentView.frame)
        
        let overlay = self.getOverlayView(frame: parentView.frame)
        
        self.triggeredView = triggeredView
        self.overlayView = overlay

        self.addSubview(overlay)
        self.bringSubviewToFront(overlay)
        
        self.triggeredParentView = triggeredView.superview!
        self.triggeredFrame = triggeredView.frame
        
        let frame = triggeredView.superview!.convert(triggeredView.frame.origin, to: nil)
        
        let origin = self.triggeredView.getPresentingView().superview!.convert(self.triggeredView.getPresentingView().frame.origin, to: nil)
        
        self.drawFrame = CGRect(origin: origin, size: self.triggeredView.getPresentingView().frame.size)
                
        self.addSubview(triggeredView)
        triggeredView.frame.origin = frame
        
        self.presentMenu()
    }
    
    override func didMoveToSuperview() {
        
        let movePoints = self.menuViews.map { $0.frame.origin }
        
        self.menuViews.forEach {
            $0.frame.origin = self.drawFrame.origin
            
        }
        
        UIView.animate(withDuration: 0.3) {
            self.overlayView.alpha = 0.7
            
            for (i, button) in self.menuViews.enumerated() {
                button.frame.origin = movePoints[i]
                button.alpha = 1
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getOverlayView(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.alpha = 0
        view.addGestureRecognizer(dismissTap)
        
        return view
    }
    
    func presentMenu() {
        let buttons: [UIButton] = AEMenuViewOption.allCases.map { self.getButton($0.rawValue) }
        
        
        let needsXFlipping = drawFrame.origin.x < self.frame.size.width / 3
        
        let step: CGFloat = 3 * .pi / 8
        var currentPoint: CGFloat = .pi / 2
        
        if drawFrame.origin.y > self.frame.height * 0.5 {
            if needsXFlipping {
                currentPoint = 0
            } else {
                currentPoint = .pi
            }
        }
        
        for button in buttons {
            self.drawButton(button, theta: currentPoint, radius: 80, needsFlipping: needsXFlipping)
            
            if needsXFlipping {
                currentPoint -= step
            } else {
                currentPoint += step
            }
        }
        
    }
    
    func drawButton(_ button: UIButton, theta: CGFloat, radius: CGFloat, needsFlipping: Bool) {
        
        let x =  radius * cos(theta) + drawFrame.origin.x + ( needsFlipping ? 2 * drawFrame.width / 3 : 0)
        let y = radius * sin(theta) + drawFrame.origin.y - drawFrame.size.height / 2
        
        button.frame.origin = CGPoint(x: x , y: y)
        
        self.addSubview(button)
        self.menuViews.append(button)
        
        button.alpha = 0
    }
    
    
    func getButton(_ name: String) -> UIButton {
        let buttonSize: CGFloat = 60
        let button = UIButton(frame: .init(x: 0, y: 0, width: buttonSize, height: buttonSize))
        let edgeInsets: CGFloat = buttonSize / 3.5
        let isFavorite = self.isFavorite && name == "star"
        
        button.addTarget(self, action: #selector(self.onOptionPicked(_:)), for: .touchDown)
        
        button.backgroundColor = isFavorite ? UIColor(red: 0xF2/0xff, green: 0xC9/0xff, blue: 0x4C/0xff, alpha: 1) : .white
        
        
        button.imageEdgeInsets = UIEdgeInsets(top: edgeInsets, left: edgeInsets, bottom: edgeInsets, right: edgeInsets)
        
        button.setImage(isFavorite ? UIImage(named: name)?.withTintColor(.white) : UIImage(named: name) , for: .normal)
        button.contentMode = .scaleToFill
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        button.layer.cornerRadius = buttonSize / 2
        button.clipsToBounds = true
        
        button.layer.shadowOffset = .init(width: 0, height: 4)
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 2
        button.layer.masksToBounds = false
        
        return button
    }
    
    @objc func onOptionPicked(_ button: UIButton) {
        let option = AEMenuViewOption.allCases[self.menuViews.firstIndex(of: button)!]
        Interaction.instance.buttonPressed(withSound: false)

        
        self.doDismiss(option)
    }
    
    @objc func dismiss() {
        self.doDismiss(nil)
    }
    
    func doDismiss(_ option: AEMenuViewOption?) {
        
        UIView.animate(withDuration: 0.3, animations:  {
            self.overlayView.alpha = 0
            
            self.menuViews.forEach {
                $0.frame.origin = self.drawFrame.origin
                $0.alpha = 0
            }
            
        }) { _ in
            self.menuViews.forEach { $0.removeFromSuperview() }
            self.removeFromSuperview()
            self.triggeredView.removeFromSuperview()
            self.triggeredParentView.addSubview(self.triggeredView)
            self.triggeredView.frame = self.triggeredFrame
            
            self.delegate?.onDismiss(option, presenter: self.triggeredView)
        }
    }
}

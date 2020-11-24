//
//  AjustesView.swift
//  Aether
//
//  Created by Bruno Pastre on 12/08/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class AEAjustesOptionView: UIStackView {
    
    var leading, trailing: UIView?
    var backgroundView: UIView!
    var margin: UIEdgeInsets!
    var option: AEAjusteOption?

    var isSelected: Bool = false
    
    init(_ option: AEAjusteOption?, leading: UIView? = nil, trailing: UIView? = nil, axis: NSLayoutConstraint.Axis = .horizontal, margin: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)) {
        super.init(frame: .zero)
        
        self.option = option
        self.leading = leading
        self.trailing = trailing
        self.margin = margin
        
        self.axis = axis
        self.distribution = .equalSpacing
        
        if let leading = self.leading, let trailing = self.trailing {

            self.addArrangedSubview(leading)
            self.addArrangedSubview(trailing)
        }
    
        
    }
    
    func setupBackgroundView() {
        let bg = UIView(frame: self.bounds)
        
        bg.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
        bg.backgroundColor = isSelected ? ColorManager.highlightColor : .white
        
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = self.margin
        
        self.insertSubview(bg, at: 0)
        
        bg.clipsToBounds = false
        bg.layer.cornerRadius = 10
        self.backgroundView = bg
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.setupBackgroundView()
    }
    
    func deselect(completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.backgroundColor = .white
            if let leading = self.leading as? UILabel {
                leading.textColor = .black
            }
            
            if let trailing = self.trailing as? UILabel {
                trailing.textColor = .black
            }
            
        }) { (_) in
            self.isSelected = false
            completion()
        }
    }
    
    func select(completion: @escaping () -> () ) {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.backgroundColor = ColorManager.highlightColor
            if let leading = self.leading as? UILabel {
                leading.textColor = .white
            }
            
            if let trailing = self.trailing as? UILabel {
                trailing.textColor = .white
            }
            
            self.isSelected = true
        }) { (_) in
            completion()
        }
    }
    
}

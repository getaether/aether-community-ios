//
//  TimeLineView.swift
//  Aether
//
//  Created by Bruno Pastre on 26/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class TimeLineView: UIStackView {
    
    init() {
        super.init(frame: .zero)
        
        addArrangedSubview(getDot())
        addArrangedSubview(getDot())
        addArrangedSubview(getDot())
        addArrangedSubview(getDot())
        
        self.axis = .vertical
        self.alignment = .center
        
        self.distribution = .equalSpacing
        self.spacing = 8
        
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getDot(diameter: CGFloat = 5.0) -> UIView {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 0xA6/0xff, green: 0xA8/0xff, blue: 0xFD/0xff, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.widthAnchor.constraint(equalToConstant: diameter).isActive = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.layer.cornerRadius = diameter / 2
        
        
        return view
    }
}

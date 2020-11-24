//
//  EmptyAccessoriesView.swift
//  Aether
//
//  Created by Bruno Pastre on 20/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class EmptyAccessoriesView: UIView {
    typealias strings = AEStrings.HomeViewController
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.lighterColor
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = strings.Label.noDevices
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var imageView: UIImageView = {
        let image = UIImageView(image: .ghost)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(
            equalTo: image.heightAnchor
        ).isActive = true
        return image
    }()
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
    }
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(label)
    }
    
    private func constraintSubviews() {
        constraintImageView()
        constraintLabel()
    }
    
    private func constraintImageView() {
        horizontalAnchors(imageView)
        imageView.heightAnchor.constraint(
            equalTo: imageView.widthAnchor
        ).isActive = true
        imageView.topAnchor.constraint(
            equalTo: topAnchor
        ).isActive = true
    }
    
    private func constraintLabel(){
        label.centerXAnchor.constraint(
            equalTo: centerXAnchor
        ).isActive = true
        label.bottomAnchor.constraint(
            equalTo: bottomAnchor
        ).isActive = true
        label.topAnchor.constraint(
            equalTo: imageView.bottomAnchor,
            constant: 20
        ).isActive = true
    }
    
    private func horizontalAnchors(_ view: UIView) {
        view.leadingAnchor.constraint(
            equalTo: leadingAnchor
        ).isActive = true
        view.trailingAnchor.constraint(
            equalTo: trailingAnchor
        ).isActive = true
    }
        
    // MARK: - Unused
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

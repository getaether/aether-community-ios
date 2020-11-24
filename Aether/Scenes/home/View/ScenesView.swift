//
//  ScenesView.swift
//  Aether
//
//  Created by Bruno Pastre on 19/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class ScenesView: UIView {
    private let strings = AEStrings.ScenesView.self
    private let collectionViewManager: ScenesCollectionViewManager
    private lazy var navigationView:
        AENavigationView = AENavigationViewBuilder()
        .withTitle(strings.Navigation.title)
        .withDescription(strings.Navigation.description)
        .withButton(UIImage(named: "add")!, action: onAddTapped)
        .build()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(
            .init(nibName: "AESceneCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: ScenesCollectionViewManager.CELL_ID
        )
        view.delegate = collectionViewManager
        view.dataSource = collectionViewManager
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var onAddTapped: ((UIButton?) -> Void)?
    
    init(
        manager: ScenesCollectionViewManager,
        action: ((UIButton?) -> Void)? = nil
    ) {
        collectionViewManager = manager
        self.onAddTapped = action
        super.init(frame: .zero)
        backgroundColor = ColorManager.backgroundColor
        addSubviews()
        constraintSubviews()
    }
    
    private func addSubviews() {
        addSubview(navigationView)
        addSubview(collectionView)
    }
    
    private func constraintSubviews() {
        constraintNavigationView()
        constraintCollectionView()
    }
    
    
    // MARK: - Constraints
    private func constraintNavigationView() {
        navigationView.topAnchor.constraint(
            equalTo: topAnchor
        ).isActive = true
        navigationView.leadingAnchor.constraint(
            equalTo: leadingAnchor
        ).isActive = true
        navigationView.trailingAnchor.constraint(
            equalTo: trailingAnchor
        ).isActive = true
    }
    
    private func constraintCollectionView() {
        collectionView.topAnchor.constraint(
            equalTo: navigationView.bottomAnchor,
            constant: 20
        ).isActive = true
        collectionView.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor,
            constant: -20
        ).isActive = true
        collectionView.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: 20
        ).isActive = true
        collectionView.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -20
        ).isActive = true
    }
    
    // MARK: - Public API
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    // MARK: - Unused
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

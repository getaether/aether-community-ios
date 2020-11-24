//
//  HomeView.swift
//  Aether
//
//  Created by Bruno Pastre on 20/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class HomeView: UIView {
    typealias strings = AEStrings.HomeViewController
    
    // MARK: - UI Components
    private lazy var emptyAccessoriesView: EmptyAccessoriesView = {
        let view = EmptyAccessoriesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var roomsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        layout.scrollDirection = .horizontal
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = roomsManager
        collectionView.dataSource = roomsManager
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(
            UINib(
                nibName: "AECustomIconSelectorCell",
                bundle: nil),
            forCellWithReuseIdentifier: CustomIconSelector.cellId
        )
        
        return collectionView
    }()
    private lazy var accessoryCollectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionLayout.scrollDirection = .vertical
        collectionView.backgroundColor = .clear
        collectionView.register(
            UINib(
                nibName: "AEAccessoryCollectionViewCell",
                bundle: nil),
            forCellWithReuseIdentifier: AccessoryCollectionViewManager.cellReuseId
        )
        collectionView.delegate = self.accessoryManager
        collectionView.dataSource = self.accessoryManager
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private lazy var navigationView: AENavigationView = AENavigationViewBuilder()
        .withTitle(strings.Label.title)
        .withDescription(strings.Label.subtitle)
        .withButton(.add, action: onAddCallback)
        .withArrengedView(roomsCollectionView)
        .build()
    
    // MARK: - Dependencies
    private let onAddCallback: ((UIButton?) -> Void)?
    private let roomsManager: CustomIconSelector
    private let accessoryManager: AccessoryCollectionViewManager
    
    // MARK: - Initialization
    init(
        onAddCallback: ((UIButton?) -> Void)?,
        roomsManager: CustomIconSelector,
        accessoryManager: AccessoryCollectionViewManager
    ) {
        self.onAddCallback = onAddCallback
        self.roomsManager = roomsManager
        self.accessoryManager = accessoryManager
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
        backgroundColor = ColorManager.backgroundColor
    }
    
    // MARK: - UIView lifecycle
    private func addSubviews() {
        addSubview(navigationView)
        addSubview(accessoryCollectionView)
        addSubview(emptyAccessoriesView)
    }
    
    private func constraintSubviews() {
        constraintNavigationView()
        constraintRoomsCollectionView()
        constraintAccessoriesCollectionView()
        constraintEmptyAccessoriesView()
    }
    
    private func constraintNavigationView() {
        navigationView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        navigationView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        navigationView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    private func constraintRoomsCollectionView() {
        roomsCollectionView.heightAnchor.constraint(
            equalToConstant: 54
        ).isActive = true
    }
    private func constraintAccessoriesCollectionView() {
        accessoryCollectionView.topAnchor.constraint(
            equalTo: navigationView.bottomAnchor,
            constant: 40
        ).isActive = true
        accessoryCollectionView.leadingAnchor.constraint(
            equalTo: leadingAnchor
        ).isActive = true
        accessoryCollectionView.trailingAnchor.constraint(
            equalTo: trailingAnchor
        ).isActive = true
        accessoryCollectionView.bottomAnchor.constraint(
            equalTo: bottomAnchor
        ).isActive = true
    }
    private func constraintEmptyAccessoriesView() {
        emptyAccessoriesView.centerXAnchor.constraint(
            equalTo: centerXAnchor
        ).isActive = true
        emptyAccessoriesView.centerYAnchor.constraint(
            equalTo: centerYAnchor
        ).isActive = true
        emptyAccessoriesView.widthAnchor.constraint(
            equalTo: widthAnchor,
            multiplier: 0.3
        ).isActive = true
    }
    
    // MARK: - Public API
    
    func updateEmptyView() {
        self.emptyAccessoriesView.isHidden = !self.accessoryManager.isEmpty()
    }
    
    func reloadData() {
        roomsManager.array = AECustomIconManager.instance.convertHomekitToCustomRoom()
        roomsCollectionView.reloadData()
        accessoryCollectionView.reloadData()
    }
    
    func toggleCellIfNeeded(_ value: Bool, at indexPath: IndexPath) {
        guard let cell = self.accessoryCollectionView.cellForItem(at: indexPath) as? AEAccessoryCollectionViewCell
        else { return }
        cell.toggleIfNeeded(value)
    }
    
    // MARK: - Unused
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

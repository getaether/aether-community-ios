//
//  AECarrousel.swift
//  Aether
//
//  Created by Bruno Pastre on 12/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

protocol AECarouselDelegate: AnyObject {
    func didSelectItem(newItem: CustomRoom)
}

class SceneCarouselManager: AECarouselCollectionViewManager {
    override func getImage(_ room: CustomRoom, for indexPath: IndexPath) -> UIImage? {
        let imageName = indexPath.item == currentSelectedIndex ?
            room.image : "off_" + room.image
        return UIImage(named: imageName)
    }
}

class AECarousel: UIView, CustomIconSelectorDelegate {
    
    // MARK: - Properties
    weak var delegate: AECarouselDelegate?
    
    // MARK: - UIComponents
    private let cellId = "AECArouselCell"
    private let customItemSelector: AECarouselCollectionViewManager
    private lazy var iconsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        view.register(UINib.init(nibName: "AECustomIconSelectorCell", bundle: nil), forCellWithReuseIdentifier: CustomIconSelector.cellId)
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()
    private lazy var controlContainerStackView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var prevButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "Prev")?.withTintColor(ColorManager.titleTextColor!), for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        view.imageView?.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(onPreviousTapped), for: .touchUpInside)
        return view
    }()
    private lazy var nextButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "Next")?.withTintColor(ColorManager.titleTextColor!), for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        view.imageView?.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(onNextTapped), for: .touchUpInside)
        return view
    }()
    private lazy var subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.font = UIFont.boldSystemFont(ofSize: 15)
        subtitle.textAlignment = .center
        subtitle.textColor = ColorManager.titleTextColor
        subtitle.backgroundColor = .clear
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        return subtitle
    }()
    private lazy var pickerDescription: UILabel = {
        let pickerDescription = UILabel()
        pickerDescription.backgroundColor = .clear
        pickerDescription.textColor = ColorManager.bodyTextColor
        pickerDescription.textAlignment = .center
        pickerDescription.translatesAutoresizingMaskIntoConstraints = false
        return pickerDescription
    }()
    
    // MARK: - Initialization
    init(
        title: String,
        customItemSelector: AECarouselCollectionViewManager
    ) {
    
        self.customItemSelector = customItemSelector
        super.init(frame: .zero)
        iconsCollectionView.delegate = customItemSelector
        iconsCollectionView.dataSource = customItemSelector
        addSubviews()
        constraintSubviews()
        
        subtitle.text = title
        
        customItemSelector.delegate = self
    }
    
    convenience init(
        title: String,
        items: [CustomRoom]
    ) {
        let manager = AECarouselCollectionViewManager(itens: items)
        self.init(title: title, customItemSelector: manager)
    }
    
    // MARK: - UIView lifecycle
    
    override func didMoveToSuperview() {
        let currentItem = customItemSelector.getCurrentItem()
        pickerDescription.text = currentItem.nome
    }
    
    private func addSubviews() {
        addSubview(subtitle)
        addSubview(iconsCollectionView)
        addSubview(controlContainerStackView)
        controlContainerStackView.addSubview(prevButton)
        controlContainerStackView.addSubview(pickerDescription)
        controlContainerStackView.addSubview(nextButton)
    }
    
    private func constraintSubviews() {
        constraintSubtitle()
        constraintControlContainerStackView()
        constraintPrevButton()
        constraintNextButton()
        constraintDescriptionLabel()
        constraintIconsCollectionView()
    }
    
    // MARK: - Constraints
    private func constraintSubtitle() {
        NSLayoutConstraint.activate([
            subtitle.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            subtitle.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: 0.5
            ),
            subtitle.topAnchor.constraint(
                equalTo: topAnchor
            ),
            subtitle.heightAnchor.constraint(
                equalToConstant: 20
            ),
        ])
    }
    private func constraintControlContainerStackView() {
        NSLayoutConstraint.activate([
            controlContainerStackView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            controlContainerStackView.widthAnchor.constraint(
                equalTo: widthAnchor
            ),
            controlContainerStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            controlContainerStackView.heightAnchor.constraint(
                equalTo: subtitle.heightAnchor,
                multiplier: 1.5
            ),
        ])
    }
    private func constraintPrevButton() {
        NSLayoutConstraint.activate([
            prevButton.heightAnchor.constraint(
                equalTo: controlContainerStackView.heightAnchor,
                multiplier: 2
            ),
            prevButton.widthAnchor.constraint(
                equalTo: prevButton.heightAnchor
            ),
            prevButton.centerYAnchor.constraint(
                equalTo: controlContainerStackView.centerYAnchor
            ),
            prevButton.leadingAnchor.constraint(
                equalTo: controlContainerStackView.leadingAnchor
            ),
        ])
    }
    private func constraintNextButton() {
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(
                equalTo: prevButton.heightAnchor
            ),
            nextButton.widthAnchor.constraint(
                equalTo: nextButton.widthAnchor
            ),
            nextButton.trailingAnchor.constraint(
                equalTo: controlContainerStackView.trailingAnchor
            ),
            nextButton.centerYAnchor.constraint(
                equalTo: controlContainerStackView.centerYAnchor
            ),
        ])
    }
    private func constraintDescriptionLabel() {
        NSLayoutConstraint.activate([
            pickerDescription.heightAnchor.constraint(
                equalTo: controlContainerStackView.heightAnchor
            ),
            pickerDescription.centerYAnchor.constraint(
                equalTo: controlContainerStackView.centerYAnchor
            ),
            pickerDescription.centerXAnchor.constraint(
                equalTo: controlContainerStackView.centerXAnchor
            )
        ])
    }
    private func constraintIconsCollectionView() {
        NSLayoutConstraint.activate([
            iconsCollectionView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            iconsCollectionView.widthAnchor.constraint(
                equalTo: widthAnchor
            ),
            iconsCollectionView.topAnchor.constraint(
                equalTo: subtitle.bottomAnchor,
                constant: 10
            ),
            iconsCollectionView.bottomAnchor.constraint(
                equalTo: controlContainerStackView.topAnchor,
                constant: -10
            )
        ])
    }
    
    public func getCurrentItem() -> CustomRoom {
        customItemSelector.getCurrentItem()
    }
    
    // MARK: - CustomIconSelectorDelegate
    func didSelectItem(newItem: CustomRoom) {
        pickerDescription.text = newItem.nome
        delegate?.didSelectItem(newItem: newItem)
    }
    
    // MARK: - Callbacks
    @objc func onPreviousTapped() {
        guard let previousItem = customItemSelector.getPreviousItem()
        else { return }
        scrollCollection(to: previousItem)
    }
    @objc func onNextTapped() {
        guard let nextItem = customItemSelector.getNextItem()
        else { return }
        scrollCollection(to: nextItem)
    }
    
    // MARK: - Helpers
    func scrollCollection(to itemIndex: Int) {
        customItemSelector.collectionView(
            iconsCollectionView,
            didSelectItemAt: IndexPath(
                item: itemIndex,
                section: 0
            )
        )
    }
    
    // MARK: - Unused
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


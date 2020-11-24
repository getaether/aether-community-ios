//
//  CustomIconSelector.swift
//  Aether
//
//  Created by Gabriel Gazal on 15/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

protocol CustomIconSelectorDelegate: class {
    func didSelectItem(newItem: CustomRoom)
}

class CustomIconSelector: NSObject, AECollectionViewManager {
    
    public var array: [CustomRoom]
    public static var cellId = "customSelectorCell"
    weak var delegate: CustomIconSelectorDelegate?
    var currentSelectedIndex = 0
    
    private let iconManager = AECustomIconManager.instance
    
    init(itens: [CustomRoom]) {
        self.array = itens
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: CustomIconSelector.cellId,
                    for: indexPath
                ) as? AECustomIconSelectorCell
        else { return .init() }
        let isSelected = indexPath.item == currentSelectedIndex
        
        let customRoom = array[indexPath.row]
        cell.background.layer.cornerRadius = 8
        cell.background.clipsToBounds = false
        cell.background.layer.masksToBounds = false
        cell.background.layer.borderColor = ColorManager.borderColor.cgColor
        cell.iconView.contentMode = .scaleAspectFit
        cell.iconView.image = getImage(customRoom, for: indexPath)
       
        cell.background.backgroundColor = isSelected ?
            ColorManager.highlightColor : ColorManager.neutralColor
        cell.background.layer.borderWidth = isSelected ?
            0 : 1
        
        configureGesture(on: cell)
        cell.room = customRoom.hkroom
        
        return cell
    }
    
    func getImage(_ room: CustomRoom, for indexPath: IndexPath) -> UIImage? {
        indexPath.item == currentSelectedIndex ?
            UIImage(named: room.image)?.withTintColor(.white) :
            UIImage(named: room.image)?
            .withTintColor(ColorManager.lighterColor)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 20 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widht = collectionView.bounds.height
        return CGSize(width: widht, height: widht)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didSelectItem(newItem: array[currentSelectedIndex])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AECustomIconSelectorCell,
              !cell.didRecognizeLongPress
        else { return }
        
        self.currentSelectedIndex = indexPath.item
        self.delegate?.didSelectItem(newItem: self.array[currentSelectedIndex])
        collectionView.reloadData()
    }
    
    func configureGesture(on cell: AECollectionViewCell)
    { cell.setupLongPressIfNeeded() }
}



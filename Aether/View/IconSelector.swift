//
//  IconSelector.swift
//  Aether
//
//  Created by Gabriel Gazal on 24/09/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class CustomIconSelector: NSObject, AECustomIconSelector {
    
    private let cellReuseId = "iconCell"
    private var icones: [IconItem] = []
    private var selectedIcon = 0
    
    init(_ collectionView: UICollectionView) {
        super.init()
        collectionView.register(UINib(nibName: "AECustomIconCell", bundle: nil), forCellWithReuseIdentifier: self.cellReuseId)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icones.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseId, for: indexPath) as! AECustomIconPickerCell
        let icon = self.icones[indexPath.item]
        cell.iconImageView.image = icon.iconImage
        if indexPath.item == selectedIcon{
            cell.iconView.backgroundColor = ColorManager.backgroundColor
            cell.activateShadow(view: cell.iconView)
        }else{
            cell.iconView.backgroundColor = ColorManager.titleTextColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIcon = indexPath.item
        collectionView.reloadItems(at: [indexPath])
    }
    
}

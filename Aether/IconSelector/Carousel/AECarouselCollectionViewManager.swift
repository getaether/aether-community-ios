//
//  AECarouselCollectionViewManager.swift
//  Aether
//
//  Created by Bruno Pastre on 12/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit

class AECarouselCollectionViewManager: CustomIconSelector {
    // MARK: - Public API
    func getNextItem() -> Int? {
        guard currentSelectedIndex < array.count - 1
        else { return nil }
        return currentSelectedIndex + 1
    }
    func getCurrentItem() -> CustomRoom {
        return array[currentSelectedIndex]
    }
    func getPreviousItem() -> Int? {
        guard currentSelectedIndex > 0
        else { return nil }
        return currentSelectedIndex - 1
    }
    
    // MARK: - Datasource
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let baseCell = super.collectionView(collectionView, cellForItemAt: indexPath) as? AECustomIconSelectorCell
        else { return .init() }
        
        baseCell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        baseCell.layer.shadowOffset = CGSize(width: 0, height: 4)
        baseCell.layer.shadowOpacity = 0.5
        baseCell.layer.shadowRadius = 4.0
        baseCell.background.layer.borderWidth = 0
        baseCell.layer.masksToBounds = false
        
        return baseCell
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let multiplier: CGFloat = indexPath.item == currentSelectedIndex ? 0.8 : 0.5
        return CGSize(
            width: collectionView.frame.height * multiplier,
            height: collectionView.frame.height * multiplier
        )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let smallCellWidht = collectionView.frame.height * 0.5
        let bigCellWidht = collectionView.frame.height * 0.8
        let totalCellWidth = (CGFloat((collectionView.visibleCells.count - 1 )) * smallCellWidht) + bigCellWidht
        let totalSpacing = 20 * (collectionView.visibleCells.count - 1)
        
        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacing))) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    // MARK: - Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, didSelectItemAt: indexPath)
        currentSelectedIndex = indexPath.item
        self.delegate?.didSelectItem(newItem: self.array[currentSelectedIndex])
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func configureGesture(on cell: AECollectionViewCell)
    { /* THIS IS BLANK TO PREVENT STUFF*/ }
}

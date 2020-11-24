//
//  RoomPickerManager.swift
//  Aether
//
//  Created by Bruno Pastre on 21/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import UIKit
import HomeKit

protocol RoomPickerManagerDelegate: AnyObject {
    func didSelectRoom(_ room: HMRoom?)
}


class RoomPickerManager: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    private let pickerData = AECustomIconManager.instance.convertHomekitToCustomRoom()
    private weak var delegate: RoomPickerManagerDelegate?
    init(delegate: RoomPickerManagerDelegate) {
        self.delegate = delegate
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    { pickerData.count  }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {  return pickerData[row].nome }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    { delegate?.didSelectRoom(pickerData[row].hkroom) }
}

//
//  TriggerUserInput.swift
//  Aether
//
//  Created by Bruno Pastre on 05/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import MapKit
import CoreLocation
import HomeKit

struct SceneUserInput {
    typealias strings = AEStrings.SceneUserInput
    typealias LabelDescription = (title: String, trigger: String)
    var location: MKCoordinateRegion?
    var days: [String] = []
    var time: Date?
    var accessories: [AccessoryPickerModel] = []
    var name: String?
    var icon: CustomRoom?
    
    var locationEnabled = false
    var daysEnabled = false
    var timeEnabled = false
    var accessoriesEnabled = false
    
    func isValid() -> Bool {
           (locationEnabled && location != nil)
        || (daysEnabled && !days.isEmpty)
        || (!accessories.isEmpty)
        || (timeEnabled && time != nil)
        || (name != nil && icon != nil)
    }
    
    func locationLabel(completion: @escaping (LabelDescription) -> Void) {
        
        self.locationToString { (location) in
            let triggerString = !locationEnabled ? strings.any : location ?? strings.any
            
            completion((
                title: strings.location,
                trigger: NSLocalizedString(triggerString, comment: "")
            ))
        }
        
    }
    
    func timeLabel() -> LabelDescription {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        
        let triggerString = time == nil || !timeEnabled ? strings.any : formatter.string(from: time!)
        
        return (
            title: strings.time,
            trigger: NSLocalizedString(triggerString, comment: "")
        )
    }
    
    func daysLabel() -> LabelDescription {
        let triggerString = days.isEmpty || !daysEnabled ? strings.any : days.joined(separator: " ")
        
        return (
            title: strings.days,
            trigger: NSLocalizedString(triggerString, comment: "")
        )
    }
    
    private func locationToString(completion: @escaping (String?) -> Void) {
        guard let location = self.location
        else {
            completion(nil)
            return
        }
        
        let geocoder = CLGeocoder()
            
        geocoder.reverseGeocodeLocation(
            .init(
                latitude: location.center.latitude,
                longitude: location.center.longitude)
        ) { (placemark, error) in
            if let mark = placemark?.first {
                
                completion(mark.name)
                return
            }
            
            completion(nil)
        }

    }
}

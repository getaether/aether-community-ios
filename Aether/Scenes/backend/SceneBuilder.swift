//
//  SceneBuilder.swift
//  Aether
//
//  Created by Bruno Pastre on 17/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import HomeKit
import MapKit
import CoreLocation

class AESceneBuilder {
    
    private let queue = DispatchQueue.global(qos: .userInteractive)
    private let group = DispatchGroup()
    private let calendar = Calendar.current
    
    func getTriggers() -> [HMTrigger]? {
        guard let home = HomeKitFacade.shared.getDefaultHome()
        else { return nil }
        return home.triggers
    }
    
    static func build(trigger: SceneUserInput, lamps: SceneUserInput, metadata: SceneUserInput, completion: @escaping (Error?) -> Void ) {
        guard let home = HomeKitFacade.shared.getDefaultHome()
        else { return }
        
        let name = metadata.name ?? AEStrings.SceneBuilder.defaultSceneName
        let builder = AESceneBuilder()
        builder.buildActionSet(in: home, with: lamps, named: name) { (actionSet, error) in
            guard let actionSet = actionSet
            else {
                completion(error)
                return
            }
            
            builder.buildTrigger(in: home, using: actionSet, with: metadata, from: trigger, completion: completion)
        }
    }
    
    // Creates scene
    private func buildActionSet(in home: HMHome, with userInput: SceneUserInput, named name: String, completion: @escaping (HMActionSet?, Error?) -> Void) {

        home.addActionSet(withName: name) { (actionSet, error) in
            guard let actionSet = actionSet
            else {
                completion(nil, error)
                return
            }
            var latestError: Error? = error
            for accessoryModel in userInput.accessories {
                guard let characteristic = accessoryModel.accessory.find(
                        serviceType: HMServiceTypeLightbulb,
                        characteristicType: HMCharacteristicMetadataFormatBool
                    )
                else { return }
                let targetValue = NSNumber(value: accessoryModel.isOn)
                
                let action = HMCharacteristicWriteAction(
                    characteristic: characteristic,
                    targetValue: targetValue
                )
                self.group.enter()
                self.queue.async {
                    actionSet.addAction(action) { (error) in
                        latestError = error
                        self.group.leave()
                    }
                }
            }
        
            self.group.notify(queue: .main) {
                completion(actionSet, latestError)
            }
        }
    }
    
    private func buildTrigger(
        in home: HMHome,
        using actionSet: HMActionSet,
        with metadata: SceneUserInput,
        from userInput: SceneUserInput,
        completion: @escaping (Error?) -> Void
    ) {
        var events: [HMEvent] = []
        
        if let location = userInput.location { events.append(getLocationEvent(for: location)) }
        let userInputDays: [Int] = userInput.days.compactMap { calendar.weekdaySymbols.map { $0.uppercased() }.firstIndex(of: $0) }.map { $0 + 1 }
        let daysToRepeat = (userInputDays.isEmpty ? [1, 2, 3, 4, 5, 6, 7] : userInputDays)
        
        if let time = userInput.time {
            events.append(getTimeEvent(time: time))
        }
        
        let trigger = HMEventTrigger(name: UUID().uuidString, events: events, predicate: nil)
        
        home.addTrigger(trigger) { (error) in
            if let error = error {
                self.cancelAction(home: home, action: actionSet) { _ in completion(error) }
                return
            }
            trigger.addActionSet(actionSet) { (error) in
                if let error = error {
                    self.cancelAction(home: home, action: actionSet) { _ in completion(error) }
                    return
                }
                if let icon = metadata.icon {
                    SceneImageBinder.shared.bind(
                        imageName: icon.image,
                        to: actionSet.uniqueIdentifier.uuidString
                    )
                }
                trigger.updateRecurrences(daysToRepeat.map { DateComponents(weekday: $0) }) { (error) in
                    if let error = error {
                        self.cancelAction(home: home, action: actionSet) { _ in completion(error) }
                        return
                    }
                    trigger.enable(true, completionHandler: completion)
                }
            }
        }
    }
    
    private func cancelAction(home: HMHome,action: HMActionSet, _ completion: @escaping (Error?) -> Void) {
        home.removeActionSet(action, completionHandler: completion)
    }
    
    
    private func getLocationEvent(for location: MKCoordinateRegion) -> HMEvent {
        let region = CLCircularRegion(
            center: location.center,
            radius: 100,
            identifier: UUID().uuidString
        )
        return HMLocationEvent(region: region)
    }
    
    private func getTimeEvent(time: Date) -> HMEvent {
        let calendar = Calendar.current
        let dateComponents = DateComponents(
            hour: calendar.component(.hour, from: time),
            minute: calendar.component(.minute, from: time)
        )
        
        return HMCalendarEvent(fire: dateComponents)
    }
}

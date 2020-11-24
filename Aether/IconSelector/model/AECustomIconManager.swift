//
//  AECustomIconManage.swift
//  Aether
//
//  Created by Gabriel Gazal on 29/10/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit
import HomeKit

struct AEIcon {
    enum Priority: Int {
        case low
        case normal
        case high
    }
    
    let possibleNames: [String]
    let priority: Priority
    let associatedImage: String
    let name: String
    
    init(
        name: String,
        associatedImage: String,
        priority: Priority = .normal,
        possibleNames: [String]
    ) {
        self.name = name
        self.possibleNames = possibleNames
        self.priority = priority
        self.associatedImage = associatedImage
    }
}

class AECustomIconManager {
    typealias strings = AEStrings.AEIcon.Name
    static let instance = AECustomIconManager()
    
    private let facade = HomeKitFacade.shared
    typealias binder = RoomImageBinder
    
    private let allIcons: [AEIcon] = [
        .init(
            name: strings.home,
            associatedImage:  "home-icon",
            possibleNames: [
                "home",
                "house",
                "casa",
                "lar",
        ]),
        .init(
            name: strings.bathroom,
            associatedImage:  "toiletIcon",
            possibleNames: [
                "toilete",
                "toalete",
                "banheiro",
                "banho",
                "bathroom",
        ]),
        .init(
            name: strings.kitchen,
            associatedImage:  "kitchenIcon",
            possibleNames: [
                "cozinha",
                "copa",
                "kitchen",
        ]),
        .init(
            name: strings.bedroom,
            associatedImage:  "bedroomIcon",
            possibleNames: [
                "quarto",
                "bedroom",
        ]),
        .init(
            name: strings.garage,
            associatedImage:  "carIcon",
            possibleNames: [
                "garage",
                "garagem"
        ]),
        .init(
            name: strings.garden,
            associatedImage:  "gardenIcon",
            possibleNames: [
                "jardim",
                "garden"
        ]),
        .init(
            name: strings.laundry,
            associatedImage:  "laundryIcon",
            possibleNames: [
                "laundry",
                "lavanderia"
        ]),
        .init(
            name: strings.office,
            associatedImage:  "officeIcon",
            possibleNames: [
                "study",
                "office",
                "escritório",
                "estudo"
        ]),
        .init(
            name: strings.lamp,
            associatedImage:  "ideaIcon",
            possibleNames: []
        ),
        .init(
            name: strings.wardrobe,
            associatedImage:  "wardrobeIcon",
            possibleNames: [
                "wardrobe",
                "closet",
                "roupa"
        ]),
        .init(
            name: strings.living,
            associatedImage:  "sofaIcon",
            priority: .low,
            possibleNames: [
                "estar",
                "sala"
        ]),
        
    ]
    private init(){}
    
    // MARK: - Public API
    func availableIcons() -> [CustomRoom] {
        allIcons.map { CustomRoom(
            nome: $0.name,
            image: $0.associatedImage
        )}
    }
    func convertHomekitToCustomRoom() -> [CustomRoom] {
        guard let defaultRoom = facade.getDefaultHome()?.roomForEntireHome(),
              let rooms = facade.getRooms()
        else { return  [] }
        
        var missing = rooms
        missing.removeAll(where: { $0.uniqueIdentifier.uuidString == defaultRoom.uniqueIdentifier.uuidString })
        
        let serialized = getSerialized(rooms)
        missing.removeAll { serialized.map { $0.roomId }.contains($0.uniqueIdentifier.uuidString) }
       
        let guessed = getGuessed(missing)
        missing.removeAll { guessed.map{ $0.roomId }.contains($0.uniqueIdentifier.uuidString) }
        let unkown = missing.map { defautImage(for: $0) }
        
        var ret: [RoomWithImage] = []
        ret.append(
            RoomWithImage(
                roomId: defaultRoom.uniqueIdentifier.uuidString,
                imageName: "home-icon",
                name: strings.home
            )
        )
        
        ret.append(contentsOf: serialized)
        ret.append(contentsOf: guessed)
        ret.append(contentsOf: unkown)
        
        return ret.compactMap { roomWithIcon in
            guard let room = rooms.first( where:{ $0.uniqueIdentifier.uuidString == roomWithIcon.roomId } )
            else { return nil }
            
            return CustomRoom(
                nome: roomWithIcon.name,
                image: roomWithIcon.imageName,
                hkroom: room
            )
        }
    }
    
    func getIcon(for room: HMRoom) -> CustomRoom?
    { convertHomekitToCustomRoom()
        .first(where: { $0.hkroom == room }) }
    
    public func updateRoomIcon(_ room: HMRoom, to icon: CustomRoom) {
        let roomId = room.uniqueIdentifier.uuidString
        binder.remove(for: roomId)
        bindRoom(room, to: icon)
    }
    
    public func bindRoom(_ room: HMRoom, to icon: CustomRoom) {
        binder.bind(
            name: icon.image,
            imageName: icon.image,
            to: room.name
        )
    }
    
    func defaultIcon(for roomName: String) -> UIImage? {
        guard let initial = roomName.first
        else { return nil }
        
        let str = String(initial) as NSString
        let size = str.size(withAttributes: nil)
        return UIGraphicsImageRenderer(size: size).image {_ in
            str.draw(in: .init(origin: .zero, size: size), withAttributes: nil)
        }
    }
    
    // MARK: - Helpers
    
    private func convertNameToIcon(roomId: String) -> String {
        guard let rooms = facade.getRooms()
        else { return "add"}
        
        if let room = getSerialized(rooms).first(where: { $0.roomId == roomId })
        { return room.imageName }
        
        if let room = getGuessed(rooms).first(where: { $0.roomId == roomId })
        { return room.imageName }
        
        return "add"
    }
    
    private func getSerialized(_ rooms: [HMRoom]) -> [RoomWithImage]
    { rooms.compactMap { binder.getImage(for: $0.uniqueIdentifier.uuidString) } }
    
    private func getGuessed(_ rooms: [HMRoom]) -> [RoomWithImage]
    { rooms.compactMap { guessImage(by: $0) } }
    
    private func guessImage(by room: HMRoom) -> RoomWithImage? {
        for icon in allIcons {
            for possibleName in icon.possibleNames {
                if possibleName.normalized().contains(room.name.normalized()) {
                    return RoomWithImage(
                        roomId: room.uniqueIdentifier.uuidString,
                        imageName: icon.associatedImage,
                        name: possibleName
                    )
                    
                }
            }
        }
        return nil
    }
    
    private func defautImage(for room: HMRoom) -> RoomWithImage {
        RoomWithImage(
            roomId: room.uniqueIdentifier.uuidString,
            imageName: "add",
            name: "Default"
        )
    }
    
    private func normalize(_ string: String) -> String {
        string.lowercased()
    }
}

extension String {
    func normalized() -> String {
        return self.lowercased()
    }
}

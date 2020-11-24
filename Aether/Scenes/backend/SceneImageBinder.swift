//
//  SceneImageBinder.swift
//  Aether
//
//  Created by Bruno Pastre on 19/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation

struct SceneWithImage: Codable {
    let sceneID: String
    let imageName: String
}
struct SceneImageGuess {
    let associatedImageName: String
    let possibilities: [String]
}
class SceneImageBinder {
    private let storage = StorageFacade()
    private init() {}
    private let guesses: [SceneImageGuess] = [
        .init(
            associatedImageName: "goodMorningIcon",
            possibilities: [
                "Morning",
                "Day",
                "Dia",
                "Bom",
            ]
        ),
        .init(
            associatedImageName: "sleepIcon",
            possibilities: [
                "Sleep",
                "Sleeping",
                "Night",
                "Moon",
                "Dormir",
                "Dormindo",
                "Dormi",
                "Noite",
                "Sono",
                "Lua",
            ]
        ),
        .init(
            associatedImageName: "leaveHomeIcon",
            possibilities: [
                "Leave",
                "Leaving",
                "Sair",
                "Saindo",
            ]
        ),
        .init(
            associatedImageName: "arriveHomeIcon",
            possibilities: [
                "Arrive",
                "Arriving",
                "Chegar",
                "Chegando",
            ]
        ),
        
    ]
    
    static let shared = SceneImageBinder()
    
    func bind(imageName: String, to sceneId: String) {
        let newElement: SceneWithImage = .init(sceneID: sceneId, imageName: imageName)
        var array = getEverything()
        array.append(newElement)
        storage.updateScenesWithImage(to: array)
    }
    
    func getImage(for sceneId: String) -> SceneWithImage? {
        if let guessed = getEverything().first(where: { $0.sceneID == sceneId })
        { return guessed }
        return guessImageIfPossble(for: sceneId)
    }
    
    func remove(sceneId: String) {
        var arr = getEverything()
        arr.removeAll(where: { $0.sceneID == sceneId })
        storage.updateScenesWithImage(to: arr)
    }
    
    private func guessImageIfPossble(for sceneId: String) -> SceneWithImage? {
        guard let scene = HomeKitFacade.shared.getScene(by: sceneId)
        else { return nil }
        
        for guess in guesses {
            guard scene.name.components(separatedBy: " ").map { guess.possibilities.map{ $0.normalized() }.contains( $0.normalized() ) }.contains(true)
            else { continue }
            return .init(sceneID: sceneId, imageName: guess.associatedImageName)
        }
        return nil
    }
    private func getEverything() -> [SceneWithImage] {
        storage.getScenesWithImage() ?? []
    }
}

struct RoomWithImage: Codable {
    let roomId: String
    let imageName: String
    let name: String
}
class RoomImageBinder {
    private static let storage = StorageFacade()
    
    public static func bind(name: String, imageName: String, to roomId: String) {
        let newElement: RoomWithImage = .init(
            roomId: roomId,
            imageName: imageName,
            name: name
        )
        
        var new = getAllShit()
        new.append(newElement)
        storage.updateRoomsWithImage(to: new )
    }
    
    public static func getImage(for roomId: String) -> RoomWithImage? {
        getAllShit().first(where: { $0.roomId == roomId })
    }
    
    public static func remove(for roomId: String) {
        var new = getAllShit()
        new.removeAll(where: { $0.roomId == roomId })
        storage.updateRoomsWithImage(to: new)
    }
    
    private static func getAllShit() -> [RoomWithImage] { RoomImageBinder.storage.getRoomsWithImage() ?? [] }
}

//
//  SceneIconProvider.swift
//  Aether
//
//  Created by Bruno Pastre on 23/11/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation

class SceneIconProvider {
    typealias strings = AEStrings.SceneIconProvider
    static var allIcons: [CustomRoom] {[
        .init(nome: strings.gameIcon, image: "gameIcon"),
        .init(nome: strings.goodMorning, image: "goodMorningIcon"),
        .init(nome: strings.gym, image: "gymIcon"),
        .init(nome: strings.party, image: "partyIcon"),
        .init(nome: strings.sleep, image: "sleepIcon"),
        .init(nome: strings.study, image: "studyIcon"),
        .init(nome: strings.work, image: "workIcon"),
        .init(nome: strings.arriveHome, image: "arriveHomeIcon"),
        .init(nome: strings.leaveHome, image: "leaveHomeIcon"),
    ]}
}

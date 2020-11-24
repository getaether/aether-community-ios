//
//  LibraryAudio.swift
//  Aether
//
//  Created by Gabriel Gazal on 30/07/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import AVFoundation

enum SongLibrary : String, CaseIterable {
    case timer = "Contagem-Regressiva-2.mp3"
    case jail = "Large-steel-door-closing.mp3"
    case inocente = "Acusado-Inocente-_Dramático_.mp3"
    case culpado = "Acusado-Culpado-_menos-épico_.mp3"
    
    //case night = "night-at-the-club.mp3"
}


enum SoundEffectLibrary : String, CaseIterable {
    case button = "click.mp3"
    case timer = "Contagem-Regressiva-2.mp3"
    case jail = "Large-steel-door-closing.mp3"
    case inocente = "Acusado-Inocente-_Dramático_.mp3"
    case culpado = "Acusado-Culpado-_menos-épico_.mp3"
}

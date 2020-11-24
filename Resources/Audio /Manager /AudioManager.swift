//
//  ManagerAudio.swift
//  Aether
//
//  Created by Gabriel Gazal on 30/07/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager{
    static let shared = AudioManager()
    
    private var soundEffects = [SoundEffectLibrary : SoundEffect]()
    private var songs = [SongLibrary : Song]()

    private init() {
        SoundEffectLibrary.allCases.forEach( { soundEffects[$0] = SoundEffect(fileName: $0.rawValue) } )
        SongLibrary.allCases.forEach( { songs[$0] = Song(fileName: $0.rawValue) } )
    }
    
    func play(soundEffect: SoundEffectLibrary) {
        soundEffects[soundEffect]?.play()
        
    }
    
    func play(song: SongLibrary) {
        stopSongs()
        songs[song]?.play()
        
    }

    
    func stopCurrentSong() {
        stopSongs()
    }
    
    private func stopSongs() {
        songs.forEach( { $0.value.stop() } )
    }
    
    
}

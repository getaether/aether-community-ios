//
//  Song.swift
//  Aether
//
//  Created by Gabriel Gazal on 30/07/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import AVFoundation

class Song : NSObject {
    
    private var player : AVAudioPlayer!
    
    init(fileName: String) {
        super.init()
        self.player = load(fileName: fileName)
    }
    
    internal func load(fileName: String) -> AVAudioPlayer{
        let path = Bundle.main.path(forResource: fileName, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.prepareToPlay()
            return player
        } catch {
            fatalError("Fatal Error - Song/Intro-Loop Player")
        }
    }
    
    func play() {
        if player.isPlaying {
            return
        }
        player.play()
        
    }
    
    func stop() {
        player.stop()
        player.currentTime = 0
    }
}

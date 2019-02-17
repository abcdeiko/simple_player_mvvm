//
//  StreamPlayer.swift
//  player
//
//  Created by Yuriy on 17/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation
import AVFoundation

class StreamPlayer {
    private lazy var players: [AVPlayer] = []
    
    func playFrom(streamURL: String) {
        guard let url = URL(string: streamURL) else {
            return
        }
        
        let newPlayer = AVPlayer(url: url)
        self.players.append(newPlayer)
        newPlayer.play()
    }
}

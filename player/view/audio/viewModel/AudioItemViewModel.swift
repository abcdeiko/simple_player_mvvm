//
//  AudioItemViewModel.swift
//  player
//
//  Created by Yuriy on 24/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation

class AudioItemViewModel {
    var title: String
    let url: String
    var playing: Bool
    
    init(title: String, url: String, playing: Bool) {
        self.title = title
        self.url = url
        self.playing = playing
    }
}

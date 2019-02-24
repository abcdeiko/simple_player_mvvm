//
//  AudioItemViewModel.swift
//  player
//
//  Created by Yuriy on 24/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation

class AudioItemViewModel {
    let title: String
    let url: String
    
    init(title: String, url: String) {
        self.title = title
        self.url = url
    }
}

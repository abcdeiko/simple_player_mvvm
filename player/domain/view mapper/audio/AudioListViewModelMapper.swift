//
//  AudioListViewModelMapper.swift
//  player
//
//  Created by Yuriy on 24/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation

class AudioListViewModelMapper: AudioListViewModelMapperProtocol {
    func map(_ items: [RadioStreamModel]) -> [AudioItemViewModel] {
        return items.map { AudioItemViewModel(title: $0.title, url: $0.url, playing: false) }
    }
}

//
//  YoutubeDataProvider.swift
//  player
//
//  Created by Yuriy on 23/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation

class YoutubeDataProvider {
    
    private let networkSource: YoutubeApiProtocol
    private let mapper: YoutubeNetworkMapperProtocol
    
    init(networkSource: YoutubeApiProtocol, mapper: YoutubeNetworkMapperProtocol) {
        self.networkSource = networkSource
        self.mapper = mapper
    }
    
    func getPlaylistVideos(callback: @escaping ([ModelYoutubeVideoInfo]?, Error?) -> Void) {
        self.networkSource.getPlaylist { (networkModels, error) in
            callback(self.mapper.map(networkModels), error)
        }
    }
}

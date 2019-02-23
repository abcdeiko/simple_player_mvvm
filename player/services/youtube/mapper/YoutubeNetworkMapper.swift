//
//  YoutubeNetworkMapper.swift
//  player
//
//  Created by Yuriy on 23/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation

class YoutubeNetworkMapper {
    func map(_ list: JSONYoutubeVideoList?) -> [ModelYoutubeVideoInfo]? {
        return list?.items.map { ModelYoutubeVideoInfo(title: $0.title, thumbnailUrl: $0.thumbnailUrl, videoId: $0.videoId) }
    }
}

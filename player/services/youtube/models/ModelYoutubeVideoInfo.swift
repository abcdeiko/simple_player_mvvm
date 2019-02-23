//
//  ModelYoutubeVideoInfo.swift
//  player
//
//  Created by Yuriy on 19/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import UIKit

class ModelYoutubeVideoInfo {
    let thumbnailUrl: String?
    let title: String?
    let videoId: String
    
    init(title: String?, thumbnailUrl: String?, videoId: String) {
        self.thumbnailUrl = thumbnailUrl
        self.title = title
        self.videoId = videoId
    }
}

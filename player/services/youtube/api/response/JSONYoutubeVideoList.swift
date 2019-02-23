//
//  JSONYoutubeVideoList.swift
//  player
//
//  Created by Yuriy on 22/02/2019.
//  Copyright © 2019 kbshko. All rights reserved.
//

import Foundation

struct JSONYoutubeVideoList: Codable {
    let items: [JSONYoutubeVideoItem]
    
    enum CodingKeys: String, CodingKey {
        case items
    }    
}
